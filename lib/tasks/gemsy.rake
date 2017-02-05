namespace :gemsy do
  desc 'Upload Gemfile.lock'
  task :upload do
    require File.expand_path('../../gemsy/uploader', __FILE__)

    Gemsy::Uploader.new.upload_gemlock
    puts 'Gemfile.lock has been successfully uploaded.'
  end

  # task :environment do
  #   require File.expand_path('../../gemsy', __FILE__)
  # end
end
