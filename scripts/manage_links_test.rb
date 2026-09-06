require "minitest/autorun"
require "tmpdir"
require "stringio"
require_relative "manage_links"

class SkillLinksTest < Minitest::Test
  def setup
    @tmp = Dir.mktmpdir("hai-stack-links-")
    @root = File.join(@tmp, "repo", "skills")
    @target = File.join(@tmp, "agents")
    @legacy = File.join(@tmp, "codex")
    FileUtils.mkdir_p([File.join(@root, "new"), @target, @legacy])
    File.write(File.join(@root, "new", "SKILL.md"), "fixture")
    @manager = SkillLinks.new(skill_root: @root, targets: [@target], legacy_targets: [@legacy],
                              retired: {"old" => "new"}, output: StringIO.new)
  end

  def teardown
    FileUtils.remove_entry(@tmp)
  end

  def test_upgrade_retires_only_owned_links_including_legacy
    File.symlink(File.join(@root, "old"), File.join(@target, "old"))
    File.symlink(File.join(@root, "old"), File.join(@legacy, "old"))
    @manager.run("link")
    refute File.symlink?(File.join(@target, "old"))
    refute File.symlink?(File.join(@legacy, "old"))
    assert_equal File.join(@root, "new"), File.readlink(File.join(@target, "new"))
    refute File.exist?(File.join(@legacy, "new"))
    @manager.run("link") # idempotent
    assert File.symlink?(File.join(@target, "new"))
  end

  def test_foreign_and_real_installations_survive_link_and_unlink
    File.symlink(File.join(@tmp, "foreign-missing"), File.join(@target, "new"))
    FileUtils.mkdir_p(File.join(@target, "old"))
    %w[link unlink].each { |action| @manager.run(action) }
    assert_equal File.join(@tmp, "foreign-missing"), File.readlink(File.join(@target, "new"))
    assert File.directory?(File.join(@target, "old"))
  end

  def test_status_is_read_only_and_unlink_recognizes_relative_owned_links
    File.symlink("../repo/skills/new", File.join(@target, "new"))
    File.symlink(File.join(@root, "old"), File.join(@legacy, "old"))
    @manager.run("status")
    assert File.symlink?(File.join(@legacy, "old"))
    assert File.symlink?(File.join(@target, "new"))
    @manager.run("unlink")
    refute File.symlink?(File.join(@target, "new"))
    refute File.symlink?(File.join(@legacy, "old"))
    assert File.file?(File.join(@root, "new", "SKILL.md"))
  end
end
