#!/usr/bin/env ruby
require "fileutils"
require "json"

class SkillLinks
  def initialize(skill_root:, targets:, legacy_targets:, retired:, output: $stdout)
    @skill_root = File.expand_path(skill_root)
    @targets = targets.map { |path| File.expand_path(path) }.uniq
    @legacy_targets = legacy_targets.map { |path| File.expand_path(path) }.uniq
    @retired = retired
    @output = output
  end

  def run(action)
    raise ArgumentError, "expected link, unlink, or status" unless %w[link unlink status].include?(action)

    skills = Dir.children(@skill_root).select do |name|
      File.file?(File.join(@skill_root, name, "SKILL.md"))
    end.sort
    (@targets + @legacy_targets).uniq.each do |target|
      @retired.each do |old_name, replacement|
        path = File.join(target, old_name)
        next unless owned_link?(path, old_name)
        if action == "status"
          @output.puts "retired #{path} -> use #{replacement}"
        else
          File.unlink(path)
          @output.puts "removed retired link #{path} -> use #{replacement} (source preserved in Git)"
        end
      end
    end
    # Unlink also handles this repository's historical Codex installations.
    targets = action == "link" ? @targets : (@targets + @legacy_targets).uniq
    targets.each do |target|
      skills.each do |name|
        path = File.join(target, name)
        if owned_link?(path, name)
          if action == "unlink"
            File.unlink(path)
            @output.puts "unlinked #{path}"
          else
            @output.puts "linked #{path}"
          end
        elsif File.exist?(path) || File.symlink?(path)
          @output.puts "CONFLICT preserved #{path} (not owned by this repository)"
        elsif action == "link"
          FileUtils.mkdir_p(target)
          File.symlink(File.join(@skill_root, name), path)
          @output.puts "linked #{path}"
        elsif action == "status"
          @output.puts "missing #{path}"
        end
      end
    end
  end

  private

  def owned_link?(path, name)
    File.symlink?(path) &&
      File.expand_path(File.readlink(path), File.dirname(path)) == File.join(@skill_root, name)
  end
end

if $PROGRAM_NAME == __FILE__
  action, agents, claude, legacy = ARGV
  abort "usage: manage_links.rb <link|unlink|status> <agents-dir> <claude-dir> <legacy-codex-dir>" unless ARGV.length == 4
  root = File.expand_path("../skills", __dir__)
  retired = JSON.parse(File.read(File.join(__dir__, "retired-skills.json")))
  SkillLinks.new(skill_root: root, targets: [agents, claude], legacy_targets: [legacy], retired: retired).run(action)
end
