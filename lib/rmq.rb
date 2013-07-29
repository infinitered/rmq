unless defined?(Motion::Project::App)
  raise "This must be required from within a RubyMotion Rakefile"
end

Motion::Project::App.setup do |app|
  parent = File.join(File.dirname(__FILE__), '..')
  app.files.unshift(Dir.glob(File.join(parent, "motion/**/*.rb")))
end
