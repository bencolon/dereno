# -*- encoding: utf-8 -*-

require 'dereno'

class Capistrano::ReleaseNotes
  def self.load_into(config)
    config.load do

      namespace :release_notes do

        # rake release_notes:show
        desc 'Show deployment release notes'
        task :show, roles: :dereno do
          Dereno.cap = config
          puts Dereno.release_notes(true)
        end

        # rake release_notes:notify
        desc 'Deployment release notes notification via email (campfire alert in option).'
        task :notify, roles: :dereno do
          Dereno.cap = config
          path = Dereno.build_release_notes(false)
          Dereno::Campfire.ping if Dereno::Campfire.enabled?

          upload(path, release_path, :via => :scp)
          run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake send_email['#{Pathname.new(path).basename.to_s}']"
          File.delete(path) if File.exists?(path)
        end

      end

      #after 'deploy:restart', 'release_notes:notify'
    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::ReleaseNotes.load_into(Capistrano::Configuration.instance)
end
