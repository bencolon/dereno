# -*- encoding : utf-8 -*-

require 'test/unit'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dereno'

class DerenoTestCase < Test::Unit::TestCase
  class Cap
    attr_accessor :application, :branch, :stage, :dereno_options

    def initialize(options)
      @application    = options[:application]
      @branch         = options[:branch]
      @stage          = options[:stage]
      @dereno_options = options[:dereno_options]
    end

  end

  def dereno_setted
    Dereno.cap = Cap.new({
      application: 'app',
      branch: 'Branch',
      stage: 'Staging',
      git_user: 'Ben',
      dereno_options: {
        campfire: { subdomain: 'domain', token: 'mytoken' , room: 'room' },
        pivotal_tracker: { token: '1234567890', project_id: 'r2d2' }
      }
    })
    yield
    Dereno.cap = nil
  end

end

