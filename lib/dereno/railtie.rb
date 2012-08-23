# -*- encoding: utf-8 -*-

require 'dereno'
require 'rails'
require 'pony'

require 'rake/dsl_definition'
include Rake::DSL

module Dereno
  def self.email_params(path)
    params = {}

    File.open(path, 'r') do |f|
      params[:from]    = f.readline.chomp
      params[:to]      = f.readline.chomp
      params[:subject] = f.readline.chomp
      params[:body]    = f.readlines.join
    end

    params
  end

  class Railtie < Rails::Railtie
    railtie_name :dereno

    rake_tasks do

      # rake send_email['path/to/config_file']
      desc 'Send an email with params details'
      task :send_email, :path do |t, args|
        Pony.mail(Dereno.email_params(args[:path]))
      end

    end
  end
end
