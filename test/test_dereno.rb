# -*- encoding: utf-8 -*-

require 'test_helper'

class TestDereno < DerenoTestCase

  def test_subject
    dereno_setted { assert_equal '[DEPLOY] App (branch Branch deployed to Staging)', Dereno.subject }
  end

  def test_body
    dereno_setted do
      Dereno.expects(:git_user).returns('Ben')
      Dereno.expects(:pivotal_stories).returns('')
      Dereno.expects(:git_commits).returns('')
      assert Dereno.body.include?('Ben deployed App (branch Branch to Staging)')
    end
  end

  def test_app
    dereno_setted { assert_equal 'App', Dereno.app }
  end

  def test_branch
    assert_equal 'unknown', Dereno.branch
    dereno_setted { assert_equal 'Branch', Dereno.branch }
  end

  def test_stage
    assert_nil Dereno.stage
    dereno_setted { assert_equal 'Staging', Dereno.stage }
  end

  def test_commits
    Dereno::Git.expects(:commits).returns('my commits')
    assert_equal 'my commits', Dereno.commits
  end

  def test_git_user
    Dereno::Git.expects(:user)
    Dereno.git_user
  end
end
