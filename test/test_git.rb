# -*- encoding: utf-8 -*-

require "test_helper"

class TestGit < DerenoTestCase

  def test_config
    assert_nil Dereno::Git.config
    dereno_setted { assert_equal Dereno.cap, Dereno::Git.config }
  end

  def test_commits
    Dereno::Git.expects(:git_log)
    Dereno::Git.commits
  end

end
