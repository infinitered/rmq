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
    def rmq_live_stylesheets(interval = 1.0, debug=false)
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
      return unless root_path = RubyMotionQuery::RMQ.project_path

      # Get list of stylesheet files
      path_query = "#{root_path}/app/stylesheets/*.rb"
      stylesheet_file_paths = Dir.glob(path_query)

      stylesheets = stylesheet_file_paths.inject({}) do |out, stylesheet_path_file|
        klass_name = File.basename(stylesheet_path_file, '.rb')
        klass_name = klass_name.gsub("_", " ").gsub(/\b(?<!['’`])[a-z]/){ $&.capitalize }.gsub(/\s/, "")
        out[klass_name] = {
          class_name: klass_name,
          path: stylesheet_path_file,
          modified: File.mtime(stylesheet_path_file)
          # TODO, for each stylehsheet find every view_controller that uses it and sub stylesheets
        }
        out
      end

      if @live_reload_debug
        puts "path_query: #{path_query}\n"
        puts stylesheet_file_paths
        #puts stylesheets.to_s
      end

      # Check if any stylesheets have been modified
      @live_reload_timer = RubyMotionQuery::App.every(interval) do
        style_changed = false
        stylesheets.each do |key, stylesheet|

          modified_at = File.mtime(stylesheet[:path])
          if modified_at > stylesheet[:modified]
            code = File.read(stylesheet[:path])
            puts "Reloaded #{stylesheet[:class_name]}" if @live_reload_debug
            eval(code)
            stylesheet[:modified] = modified_at
            style_changed = true
          end

        end

        if style_changed
          rmq_live_current_view_controllers.each do |vc|
            vc.rmq.all.and_self.reapply_styles
          end
        end
      end

      "Live reloading of RMQ stylesheets is now on."
    end

    def rmq_live_current_view_controllers(vc = nil)
      vc = rmq.window.rootViewController unless vc
      vcs = []

      if vc.rmq.stylesheet
        vcs << vc
      end

      if children_vcs = vc.childViewControllers
        children_vcs.each do |child_vc|
          vcs << rmq_live_current_view_controllers(child_vc)
        end
      end

      vcs.flatten
    end
  end

  module RubyMotionQuery
    module Stylers
      class UIViewStyler
        def method_missing method, *args
          puts "Sorry, #{method} is not implemented on #{self.class}. This will produce a crash when not in debug mode."
        end
      end
    end
  end
end
