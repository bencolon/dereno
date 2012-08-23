# -*- encoding: utf-8 -*-

require 'tinder'

module Dereno
  module Campfire

    def self.config
      Dereno.cap.try(:dereno_options) && Dereno.cap.dereno_options[:campfire]
    end

    def self.subdomain
      config && config[:subdomain]
    end

    def self.token
      config && config[:token]
    end

    def self.enabled?
      token.present?
    end

    # Deployment release notes notification in a Campfire room
    def self.ping
      room.speak Dereno.release_notes(false)
    end

  private

    def self.campfire
      Tinder::Campfire.new(subdomain, token: token)
    end

    def self.room
      campfire.find_room_by_name(config[:room])
    end

  end
end
