# -*- encoding: utf-8 -*-

require 'test_helper'

class TestCampfire < DerenoTestCase

  def setup_campfire
    @campfire = Tinder::Campfire.new('domain', :token => 'mytoken')
  end

  def test_config
    assert_nil Dereno::Campfire.config
    dereno_setted { assert_equal Dereno.cap.dereno_options[:campfire], Dereno::Campfire.config }
  end

  def test_subdomain
    assert_nil Dereno::Campfire.subdomain
    dereno_setted { assert_equal 'domain', Dereno::Campfire.subdomain }
  end

  def test_token
    assert_nil Dereno::Campfire.token
    dereno_setted { assert_equal 'mytoken', Dereno::Campfire.token }
  end

  def test_enabled?
    assert !Dereno::Campfire.enabled?
    dereno_setted { assert Dereno::Campfire.enabled? }
  end

  def test_campfire
    dereno_setted do
      setup_campfire
      Dereno::Campfire.expects(:campfire).returns(@campfire)
      assert_equal @campfire, Dereno::Campfire.campfire
    end
  end

  def test_room
    dereno_setted do
      setup_campfire
      Dereno::Campfire.expects(:campfire).returns(@campfire)
      @campfire.expects(:find_room_by_name).returns('First Room')
      assert_equal 'First Room', Dereno::Campfire.room
    end
  end
end
