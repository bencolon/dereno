# -*- encoding: utf-8 -*-

require 'test_helper'

class TestPivotal < DerenoTestCase

  def test_config
    assert_nil Dereno::Pivotal.config
    dereno_setted { assert_equal Dereno.cap.dereno_options[:pivotal_tracker], Dereno::Pivotal.config }
  end

  def test_token
    assert_nil Dereno::Pivotal.token
    dereno_setted { assert_equal '1234567890', Dereno::Pivotal.token }
  end

  def test_project_id
    assert_nil Dereno::Pivotal.project_id
    dereno_setted { assert_equal 'r2d2', Dereno::Pivotal.project_id }
  end

  def test_enabled?
    assert !Dereno::Pivotal.enabled?
    dereno_setted { assert Dereno::Pivotal.enabled? }
  end

  def test_stories_when_no_project
    commits = ['12345678','12345678','87654321']
    Dereno::Pivotal.expects(:init_project).returns(nil)
    Dereno::Pivotal.expects(:pivotal_stories).never
    Dereno::Pivotal.stories(commits)
  end

  def test_stories_when_project
    commits = ['12345678','12345678','87654321']
    Dereno::Pivotal.expects(:init_project).returns(PivotalTracker::Project.new)
    Dereno::Pivotal.expects(:pivotal_stories).with(commits)
    Dereno::Pivotal.stories(commits)
  end

  def test_line
    story = PivotalTracker::Story.new(id:12345678, story_type: 'CHORE', name:'Story name')
    Dereno::Pivotal.line(story, '12345678')
    assert_equal "[CHORE] Story name, https://www.pivotaltracker.com/story/show/12345678\n", Dereno::Pivotal.line(story, '12345678')
  end

  def test_init_project
    dereno_setted do
      PivotalTracker::Project.expects(:find).with(Dereno::Pivotal.project_id).returns(true)
      Dereno::Pivotal.init_project
    end
  end

  def test_story
    Dereno::Pivotal.instance_variable_set(:@project, PivotalTracker::Project.new).expects(:stories).returns([])
    Dereno::Pivotal.story('12345678')
  end

  def test_pivotal_stories
    Dereno::Pivotal.stubs(:extract_stories).returns(['12345678','12345678','87654321'])
    assert_equal "12345678\n87654321", Dereno::Pivotal.pivotal_stories('')
  end

  def test_extract_stories
    commits = "[Story #12345678] First commit\n[Story #12345678] Second commit\n[Story #87654321] Last commit"
    Dereno::Pivotal.stubs(:story).returns(true)
    Dereno::Pivotal.stubs(:line).returns('story_id')
    assert_equal ['story_id','story_id','story_id'], Dereno::Pivotal.extract_stories(commits)
  end
end
