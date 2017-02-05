namespace :gemsy do
  desc 'Upload Gemfile.lock'
  task :upload, [:name, :file] do |_, args|
    require File.expand_path('../../gemsy/uploader', __FILE__)

    Gemsy::Uploader.new(args).upload_gemlock
    puts 'Gemfile.lock has been successfully uploaded.'
  end

  desc 'List web hooks'
  task :web_hooks do
    require 'gems'

    puts Gems.web_hooks
  end

  desc 'Add web hook'
  task :add_web_hooks, [:gem] do |_, args|
    require 'gems'

    puts Gems.add_web_hook(args[:gem], 'https://gemns.herokuapp.com/hook')
  end

  desc 'Test web hook'
  task :test_web_hook, [:gem] do |_, args|
    require 'gems'

    puts Gems.fire_web_hook(args[:gem], 'https://gemns.herokuapp.com/hook')
  end

  # task :environment do
  #   require File.expand_path('../../gemsy', __FILE__)
  # end
end
