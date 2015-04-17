class Object
  def rmq(*working_selectors)
    if (app = RubyMotionQuery::RMQ.app) && (window = app.window) && (cvc = app.current_view_controller)
      cvc.rmq(working_selectors)
    else
      RubyMotionQuery::RMQ.create_with_array_and_selectors([], working_selectors, self)
    end
  end
end

class UIView
  def rmq_data
    @_rmq_data ||= RubyMotionQuery::ViewData.new
  end

  def rmq_created
  end

  # Override this to build your view and view's subviews
  def rmq_build
  end

  def rmq_appended
  end

  def rmq_style_applied
  end

  # Technically my_view.rmq is the same as rmq(my_view), so it may seem enticing to use,
  # but the really nice thing about rmq is its consistent API, and doing this
  # for one view: my_view.rmq and this for two views: rmq(my_view, my_other_view) sucks
  def rmq(*working_selectors)
    RubyMotionQuery::RMQ.create_with_selectors(working_selectors, self).tap do |o|
      if vc = self.rmq_data.view_controller
        o.weak_view_controller = vc
      end
    end
  end
end

class UIViewController
  def rmq(*working_selectors)
    crmq = (rmq_data.cached_rmq ||= RubyMotionQuery::RMQ.create_with_selectors([], self))

    if working_selectors.length == 0
      crmq
    else
      RubyMotionQuery::RMQ.create_with_selectors(working_selectors, self, crmq)
    end
  end

  def rmq_data
    @_rmq_data ||= RubyMotionQuery::ControllerData.new
  end
end

if RUBYMOTION_ENV == "development"
  module Kernel
    def rmq_live_stylesheets(interval = 0.5, debug=false)
      @live_reload_debug = debug
      if interval == false
        @live_reload_timer.invalidate if @live_reload_timer
        @live_reload_timer = nil
        "Live reloading of RMQ stylesheets is now off."
      else
        enable_rmq_live_stylesheets(interval)
      end
    end

    private

    def enable_rmq_live_stylesheets(interval)
      # Get list of stylesheet files
      return unless root_path = RubyMotionQuery::RMQ.project_path

      path_query = "#{root_path}/app/stylesheets/*.rb"
      puts path_query if @live_reload_debug
      stylesheet_file_paths = Dir.glob(path_query)
      stylesheet_file_paths.delete_if{|stylesheet| stylesheet =~ /application_stylesheet\.rb$/}
      puts stylesheet_file_paths if @live_reload_debug

      stylesheets = stylesheet_file_paths.inject({}) do |out, stylesheet_path_file|
        out[stylesheet_path_file] = RubyMotionQuery::RMQ.build_time
        out
      end

      @live_reload_timer = RubyMotionQuery::App.every(interval) do
        style_changed = false
        stylesheets.each do |stylesheet, modified_date|
          if File.mtime(stylesheet) > modified_date
            code = File.read(stylesheet)
            puts "Reloaded #{stylesheet}." if @live_reload_debug
            eval(code)
            stylesheets[stylesheet] = File.mtime(stylesheet)
            style_changed = true
          end
        end
        if style_changed
          vc_rmq = rmq.view_controller.rmq
          vc_rmq.all.and_self.reapply_styles
        end
      end

      "Live reloading of RMQ stylesheets is now on."
    end
  end
end
