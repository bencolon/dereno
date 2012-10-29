# -*- encoding: utf-8 -*-

[
 'tmpdir',
 'active_support/core_ext/object/try',
 'capistrano', 'capistrano/release_notes',
 'dereno/version', 'dereno/git', 'dereno/pivotal', 'dereno/campfire'
].each { |f| require f }

module Dereno

  require 'dereno/railtie' if defined?(Rails)

  class << self
    attr_accessor :cap, :local
  end

  # Build config email file and return the path
  def self.build_release_notes(local)
    self.local, path = local, File.join(Dir.tmpdir,'deployment.txt')
    write_config_file(path)
    path
  end

  # Return current deployment release notes
  def self.release_notes(local)
    self.local = local
    body
  end

private

  def self.subject
    @cap.dereno_options[:subject] || "[DEPLOY] #{app} (branch #{branch} deployed to #{stage})"
  end

  def self.body
<<-eos
#{git_user} deployed #{app} (branch #{branch} to #{stage}), on #{Time.now.strftime("%m/%d/%Y")} at #{Time.now.strftime("%I:%M %p %Z")}

#{pivotal_stories}
#{git_commits}
eos
  end

  def self.app
    @cap.application.capitalize
  end

  def self.branch
    @cap.try(:branch) || 'unknown'
  end

  def self.stage
    @cap.try(:stage)
  end

  def self.commits
    @commits ||= Dereno::Git.commits
  end

  def self.pivotal_stories
    if Dereno::Pivotal.enabled?
<<-eos
*** Pivotal Tracker Stories ***

#{Dereno::Pivotal.stories(commits)}
eos
    end
  end

  def self.git_commits
<<-eos
*** Git Commits ***

#{commits}
eos
  end

  def self.git_user
    Dereno::Git.user
  end

  def self.write_config_file(path)
    File.open(path, 'w') do |f|
      f.puts @cap.dereno_options[:from]
      f.puts @cap.dereno_options[:to]
      f.puts subject
      f.puts body
    end
  end
end
