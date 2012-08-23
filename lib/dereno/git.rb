# -*- encoding: utf-8 -*-

module Dereno
  module Git

    def self.config
      Dereno.cap
    end

    # Return all commits since the last deployment
    def self.commits
      git_log
    end

    # Return the user name of the deployer
    def self.user
      `git config --get user.name`.strip
    end

  private

    def self.git_previous_revision
      if Dereno.local
        config.current_revision[0,7] if config.try(:current_revision)
      else
        config.previous_revision[0,7] if config.try(:previous_revision)
      end
    end

    def self.git_current_revision
      if Dereno.local
        `git log --pretty=format:'%h' -n 1`
      else
        config.current_revision[0,7] if config.try(:current_revision)
      end
    end

    def self.git_log
      `git log #{git_range} --no-merges --format=format:"%h %s (%an)"` if git_range
    end

    def self.git_range
      "#{git_previous_revision}..#{git_current_revision}" if git_previous_revision && git_current_revision
    end

  end
end
