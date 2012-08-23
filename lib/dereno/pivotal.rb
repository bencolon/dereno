#@cap.dereno_options[:pivotal_tracker][:token] -*- encoding: utf-8 -*-

require 'pivotal-tracker'

module Dereno
  module Pivotal

    def self.config
      Dereno.cap.try(:dereno_options) && Dereno.cap.dereno_options[:pivotal_tracker]
    end

    def self.token
      config && config[:token]
    end

    def self.project_id
      config && config[:project_id]
    end

    def self.enabled?
      token.present?
    end

    # Return the stories included in the commits list
    def self.stories(commits)
      init_project and pivotal_stories(commits)
    end

  private

    def self.line(story, id)
      "[#{story.story_type.upcase}] #{story.name}, https://www.pivotaltracker.com/story/show/#{id}\n" if story
    end

    def self.init_project
      PivotalTracker::Client.token = token
      @project = PivotalTracker::Project.find(project_id)
    end

    def self.story(id)
      @project.stories.find(id)
    end

    def self.pivotal_stories(commits)
      extract_stories(commits).uniq.compact.join("\n")
    end

    def self.extract_stories(commits)
      commits.scan(/\d{8}/).map {|id| line(story(id), id)}
    end

  end
end
