namespace :gemsy do
  desc 'Upload Gemfile.lock'
  task upload: :environment do
    Gemsy::Uploader.new.upload_gemlock
    puts 'Gemfile.lock has been successfully uploaded.'
  end

  task :environment do
    require File.expand_path('../../gemsy', __FILE__)
  end
end
