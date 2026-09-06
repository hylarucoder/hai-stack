#!/usr/bin/env ruby

require "yaml"
require "json"

ROOT = File.expand_path("..", __dir__)
SKILLS_ROOT = File.join(ROOT, "skills")
MAX_DESCRIPTION_CHARS = 700
MAX_SKILL_LINES = 200

errors = []
warnings = []
skill_files = Dir[File.join(SKILLS_ROOT, "*", "SKILL.md")].sort

skill_files.each do |file|
  relative = file.delete_prefix("#{ROOT}/")
  directory_name = File.basename(File.dirname(file))
  content = File.read(file)
  frontmatter = content[/\A---\n(.*?)\n---\n/m, 1]

  unless frontmatter
    errors << "#{relative}: missing YAML frontmatter"
    next
  end

  begin
    metadata = YAML.safe_load(frontmatter)
  rescue Psych::SyntaxError => e
    errors << "#{relative}: invalid YAML (#{e.message.lines.first.strip})"
    next
  end

  errors << "#{relative}: name must equal directory #{directory_name.inspect}" unless metadata["name"] == directory_name

  description = metadata["description"].to_s.strip
  errors << "#{relative}: description is missing" if description.empty?
  if description.length > MAX_DESCRIPTION_CHARS
    errors << "#{relative}: description is #{description.length} chars (max #{MAX_DESCRIPTION_CHARS})"
  end

  line_count = content.lines.length
  if line_count > MAX_SKILL_LINES
    errors << "#{relative}: #{line_count} lines; move optional detail to references (max #{MAX_SKILL_LINES})"
  end

  if directory_name.start_with?("hai-")
    chinese = File.join(File.dirname(file), "SKILL.zh_CN.md")
    errors << "#{relative}: missing required SKILL.zh_CN.md" unless File.file?(chinese)
  end

  openai_yaml = File.join(File.dirname(file), "agents", "openai.yaml")
  if File.file?(openai_yaml)
    begin
      agent_metadata = YAML.safe_load(File.read(openai_yaml))
      interface = agent_metadata.fetch("interface", {})
      %w[display_name short_description default_prompt].each do |field|
        errors << "#{openai_yaml.delete_prefix("#{ROOT}/")}: missing interface.#{field}" if interface[field].to_s.strip.empty?
      end
    rescue Psych::SyntaxError => e
      errors << "#{openai_yaml.delete_prefix("#{ROOT}/")}: invalid YAML (#{e.message.lines.first.strip})"
    end
  end
end


Dir[File.join(SKILLS_ROOT, "**", "*.md")].sort.each do |file|
  content = File.read(file)
  fence_count = content.scan(/^```/).length
  relative = file.delete_prefix("#{ROOT}/")
  errors << "#{relative}: unbalanced fenced code blocks" if fence_count.odd?

  relative_parts = relative.split(File::SEPARATOR)
  skill_root = File.join(ROOT, relative_parts[0], relative_parts[1])
  content.scan(%r{(?:references|assets|scripts)/[A-Za-z0-9._/-]+}).uniq.each do |resource|
    resource = resource.sub(/[.,;:]\z/, "")
    errors << "#{relative}: missing referenced resource #{resource}" unless File.file?(File.join(skill_root, resource))
  end
end

readme = File.read(File.join(ROOT, "README.md"))
badge_count = readme[/skills-(\d+)-/, 1]&.to_i
if badge_count != skill_files.length
  errors << "README.md: badge says #{badge_count.inspect} skills, found #{skill_files.length}"
end

listed = readme.scan(/`([a-z0-9][a-z0-9-]+)`/).flatten.uniq
skill_names = skill_files.map { |file| File.basename(File.dirname(file)) }
retired = JSON.parse(File.read(File.join(ROOT, "scripts", "retired-skills.json")))
retired.each do |old_name, replacement|
  errors << "retired skill #{old_name} still has an active entry" if skill_names.include?(old_name)
  errors << "retired skill #{old_name} points to missing #{replacement}" unless skill_names.include?(replacement)
end
Dir[File.join(SKILLS_ROOT, "**", "*.{md,yaml}")].each do |file|
  retired.each_key do |old_name|
    if File.read(file).match?(/(?<![a-z0-9-])#{Regexp.escape(old_name)}(?![a-z0-9-])/)
      errors << "#{file.delete_prefix("#{ROOT}/")}: routes to retired skill #{old_name}"
    end
  end
end
missing_from_readme = skill_names - listed
warnings << "README.md: skills not named in documentation: #{missing_from_readme.join(', ')}" unless missing_from_readme.empty?

trigger_file = File.join(ROOT, "evals", "trigger-cases.json")
begin
  trigger_cases = JSON.parse(File.read(trigger_file))
  ids = trigger_cases.map { |item| item["id"] }
  errors << "evals/trigger-cases.json: duplicate ids" unless ids.uniq.length == ids.length

  trigger_cases.each do |item|
    expected = Array(item["expected_skills"])
    excluded = Array(item["excluded_skills"])
    unknown = (expected + excluded).uniq - skill_names
    errors << "evals/trigger-cases.json: #{item['id']} names unknown skills: #{unknown.join(', ')}" unless unknown.empty?
    overlap = expected & excluded
    errors << "evals/trigger-cases.json: #{item['id']} both expects and excludes: #{overlap.join(', ')}" unless overlap.empty?
    errors << "evals/trigger-cases.json: #{item['id']} has an empty prompt" if item["prompt"].to_s.strip.empty?
    if item["expected_mode"] && !%w[internal implementation combined global bounded compact full].include?(item["expected_mode"])
      errors << "evals/trigger-cases.json: #{item['id']} has an unknown mode"
    end
  end

  uncovered = skill_names - trigger_cases.flat_map { |item| Array(item["expected_skills"]) }.uniq
  errors << "evals/trigger-cases.json: no positive case for #{uncovered.join(', ')}" unless uncovered.empty?
rescue Errno::ENOENT
  errors << "evals/trigger-cases.json: missing trigger regression set"
rescue JSON::ParserError => e
  errors << "evals/trigger-cases.json: invalid JSON (#{e.message})"
end

begin
  workflow = JSON.parse(File.read(File.join(ROOT, "evals", "workflow-cases.json")))
  ids = workflow.fetch("evals").map { |item| item.fetch("id") }
  errors << "evals/workflow-cases.json: duplicate ids" unless ids.uniq.length == ids.length
  workflow.fetch("evals").each do |item|
    %w[prompt expected_output].each do |field|
      errors << "workflow #{item['id']}: empty #{field}" if item[field].to_s.strip.empty?
    end
    errors << "workflow #{item['id']}: no expectations" if Array(item["expectations"]).empty?
    Array(item["files"]).each do |path|
      errors << "workflow #{item['id']}: missing fixture #{path}" unless File.exist?(File.join(ROOT, path))
    end
  end
rescue Errno::ENOENT, JSON::ParserError, KeyError => e
  errors << "evals/workflow-cases.json: #{e.message}"
end

if errors.empty?
  puts "OK: validated #{skill_files.length} skills"
  warnings.each { |warning| warn "WARN: #{warning}" }
  exit 0
end

errors.each { |error| warn "ERROR: #{error}" }
warnings.each { |warning| warn "WARN: #{warning}" }
warn "FAILED: #{errors.length} error(s) across #{skill_files.length} skills"
exit 1
