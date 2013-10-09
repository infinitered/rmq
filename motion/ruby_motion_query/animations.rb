module RubyMotionQuery
  class RMQ

    # @return [RMQ]
    def animate(opts = {})
      working_selected = self.selected
      @_rmq = self # @ for rm bug

      animations_lambda = if (animations_callback = (opts.delete(:animations) || opts.delete(:changes)))
        -> do
          working_selected.each do |view|
            animations_callback.call(@_rmq.create_rmq_in_context(view))
          end
        end
      else
        nil
      end

      return self unless animations_lambda

      after_lambda = if (after_callback = (opts.delete(:completion) || opts.delete(:after)))
        -> (did_finish) {
          after_callback.call(did_finish, @_rmq)
        }
      else
        nil
      end

      UIView.animateWithDuration(
        opts.delete(:duration) || 0.3,
        delay: opts.delete(:delay) || 0,
        options: (opts.delete(:options) || UIViewAnimationOptionCurveEaseInOut),
        animations: animations_lambda,
        completion: after_lambda
      )

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
      opts.merge!({
        duration: 0.4,
        animations: -> (cq) {
          cq.style {|st| st.scale = 1.0}
        }
      })

      @rmq.animate(
        duration: 0.1,
        animations: -> (q) {
          q.style {|st| st.scale = 1.1}
        },
        completion: -> (did_finish, q) {
          q.animate(opts)
        }
      )
    end

    def drop_and_spin(opts = {})
      remove_view = opts[:remove_view]
      opts.merge!({
        duration: 0.4 + (rand(8) / 10),
        options: UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionBeginFromCurrentState,
        animations: -> (cq) {
          cq.style do |st| 
            st.top = @rmq.device.height + st.height
            st.rotation = 180 + rand(50) 
          end
        },
        completion: -> (did_finish, q) {
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
      })

      @rmq.animate(opts)
    end

    # @return [RMQ]
    def blink
      self.fade_out(duration: 0.2, after: lambda {|did_finish, rmq| rmq.animations.fade_in(duration: 0.2)})
    end

    # @return [RMQ]
    def start_spinner(style = UIActivityIndicatorViewStyleGray)
      spinner = Animations.window_spinner(style)
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

    def self.window_spinner(style = UIActivityIndicatorViewStyleGray)
      @_window_spinner ||= begin
        window = RMQ.app.window
        UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(style).tap do |o|
          o.center = window.center
          o.hidesWhenStopped = true
          o.layer.zPosition = NSIntegerMax
          window.addSubview(o)
        end
      end
    end
  end
end
