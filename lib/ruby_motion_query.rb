unless defined?(Motion::Project::App)
  raise "This must be required from within a RubyMotion Rakefile"
end

Motion::Project::App.setup do |app|
  parent = File.join(File.dirname(__FILE__), '..')
  files = [File.join(parent, 'motion/ruby_motion_query/stylesheet.rb')]
  files << [File.join(parent, 'motion/ruby_motion_query/validation_event.rb')]
  files << [File.join(parent, 'motion/ruby_motion_query/stylers/ui_view_styler.rb')]
  files << File.join(parent, 'motion/ruby_motion_query/stylers/ui_control_styler.rb')
  files << Dir.glob(File.join(parent, "motion/**/*.rb"))
  files.flatten!.uniq!
  app.files.unshift files
end
