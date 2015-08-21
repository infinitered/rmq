module RubyMotionQuery
  class RMQ

    # Animate
    #
    # @return [RMQ]
    def animate(opts = {}, &block)

      animations_callback = (block || opts[:animations] || opts[:changes])
      before_callback = opts[:before]
      after_callback = (opts[:completion] || opts[:after])
      return self unless animations_callback

      working_selected = self.selected
      self_rmq = self

      working_selected.each do |view|
        view_rmq = self_rmq.wrap(view)

        return_var = nil

        if before_callback
          return_var = before_callback.call(view_rmq)
        end

        animations_lambda = -> do
          case animations_callback.arity
          when 0
            animations_callback.call
          when 1
            animations_callback.call(view_rmq)
          when 2
            animations_callback.call(view_rmq, return_var)
          end
        end

        after_lambda = if after_callback
          ->(did_finish) {
            # TODO, check arity and allow just view_rmq or no params. Also
            # this is backwards, should be view_rmq, did_finish
            after_callback.call(did_finish, view_rmq)
          }
        else
          nil
        end

        if accessibility.voiceover_running?
          after_lambda.call(true)
        else
          UIView.animateWithDuration(
            opts[:duration] || 0.3,
            delay: opts[:delay] || 0.0,
            options: opts[:options] || UIViewAnimationOptionCurveEaseInOut,
            animations: animations_lambda,
            completion: after_lambda
          )
        end
      end

      self
    end

    # @return [Animations]
    def animations
      @_animations ||= Animations.new(self)
    end
  end

  class Animations
    def initialize(rmq)
      @rmq = rmq
    end

    # @return [RMQ]
    def fade_in(opts = {})
      @rmq.each do |view|
        view.layer.opacity = 0.0
        view.hidden = false
      end

      opts[:animations] = lambda do |rmq|
        rmq.get.layer.opacity = 1.0
      end

      @rmq.animate(opts)
    end

    # @return [RMQ]
    def fade_out(opts = {})
      opts[:animations] = lambda do |rmq|
        rmq.get.layer.opacity = 0.0
      end

      @completion_block = opts[:completion] || opts[:after]

      opts[:completion] = lambda do |did_finish, rmq|
        rmq.each do |view|
          view.hidden = true
          view.layer.opacity = 1.0
        end

        @completion_block.call(did_finish, rmq) if @completion_block
      end

      @rmq.animate(opts)
    end

    # @return [RMQ]
    def throb(opts = {})
      opts = {
        duration: 0.4,
        animations: ->(cq) {
          cq.style {|st| st.scale = 1.0}
        }
      }.merge(opts)

      out = @rmq.animate(
        duration: opts[:duration_out] || 0.1,
        animations: ->(q) {
          q.style {|st| st.scale = 1.1}
        },
        completion: ->(did_finish, completion_rmq) {
          if did_finish
            completion_rmq.animate(opts)
          end
        }
      )
      out
    end

    # @return [RMQ]
    def sink_and_throb(opts = {})
      opts = {
        duration: 0.3,
        animations: ->(cq) {
         cq.animations.throb(duration: 0.6)
        }
      }.merge(opts)

      out = @rmq.animate(
        duration: opts[:duration_out] || 0.1,
        animations: ->(q) {
          q.style {|st| st.scale = 0.9}
        },
        completion: ->(did_finish, completion_rmq) {
          if did_finish
            completion_rmq.animate(opts)
          end
        }
      )
      out
    end

    # @return [RMQ]
    def land_and_sink_and_throb(opts = {})
      @rmq.hide.style do |st|
        st.opacity = 0.1
        st.scale = 8.0
        st.hidden = false
      end

      opts = {
        duration: 0.5,
        animations: ->(cq) {
          cq.style do |st|
            st.opacity = 1.0
            st.scale = 0.8
          end
        },
        completion: ->(did_finish, last_completion_rmq) {
          if did_finish
            last_completion_rmq.animations.throb
          end
        }
      }.merge(opts)

      @rmq.animate(opts)
    end

    # @return [RMQ]
    def drop_and_spin(opts = {})
      remove_view = opts[:remove_view]
      opts = {
        duration: 0.4 + (rand(8) / 10),
        options: UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionBeginFromCurrentState,
        animations: ->(cq) {
          cq.style do |st|
            st.frame = {t: @rmq.device.height + st.frame.height}
            st.rotation = 180 + rand(50)
          end
        },
        completion: ->(did_finish, q) {
          if did_finish
            q.style do |st|
              st.rotation = 0
            end

            if remove_view
              q.remove
            else
              q.hide.move(t:0)
            end
          end
        }
      }.merge(opts)

      @rmq.animate(opts)
    end

    # @return [RMQ]
    def blink
      self.fade_out(duration: 0.2, after: lambda {|did_finish, rmq| rmq.animations.fade_in(duration: 0.2)})
    end

    # @return [RMQ]
    def slide_in(opts = {})
      from_direction = opts[:from_direction] || :right

      opts = {
        duration: 0.5,
        options: UIViewAnimationOptionCurveEaseIn,
        before: ->(bq) {
          bq.hide
          start_frame = bq.get.frame.dup

          case from_direction
          when :right
            bq.move(l: rmq.device.width)
          when :left
            bq.move(l: -rmq.device.width)
          when :top
            bq.move(t: -rmq.device.height)
          else :bottom
            bq.move(t: rmq.device.height)
          end
          bq.show
          start_frame
        },
        animations: ->(aq, return_var) {
          aq.frame = return_var
        }
      }.merge(opts)

      @rmq.animate(opts)
    end

    # @return [RMQ]
    def slide_out(opts = {})
      remove_view = opts[:remove_view]
      to_direction = opts[:to_direction] || :left

      opts = {
        duration: 0.5,
        options: UIViewAnimationOptionCurveEaseIn,
        before: ->(bq) {
          start_frame = bq.get.frame
          start_frame
        },
        animations: ->(aq, return_var) {
          case to_direction
          when :right
            aq.move(l: rmq.device.screen_width)
          when :left
            aq.move(l: -rmq.device.screen_width)
          when :top
            aq.move(t: -rmq.device.screen_height)
          else :bottom
            aq.move(t: rmq.device.screen_height)
          end
        },
        completion: ->(did_finish, q) {
          if did_finish
            if remove_view
              q.remove
            else
              q.hide
            end
          end
        }
      }.merge(opts)

      @rmq.animate(opts)
    end

    # @return [RMQ]
    def start_spinner(style = UIActivityIndicatorViewStyleGray, opts = {})
      spinner = Animations.window_spinner({ style: style }.merge(opts))
      spinner.startAnimating
      @rmq.create_rmq_in_context(spinner)
    end

    # @return [RMQ]
    def stop_spinner
      spinner = Animations.window_spinner
      spinner.stopAnimating
      @rmq.create_rmq_in_context(spinner)
    end

    protected

    def self.window_spinner(opts={})
      @_window_spinner ||= begin
        parent = opts.fetch(:parent, RMQ.app.window)
        UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(opts.fetch(:style, UIActivityIndicatorViewStyleGray)).tap do |o|
          o.hidesWhenStopped = true
          o.center = opts.fetch(:center, RMQ.app.window.center)
          o.layer.zPosition = NSIntegerMax
          parent.addSubview(o)
        end
      end
    end
  end
end
