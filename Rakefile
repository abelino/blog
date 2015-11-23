require "open3"

task "foo" do
  if has_uncommitted_changes?
    puts "has unccommitted changes"
  else
    puts "notthing to commit"
  end

  puts get_content_branches()
end

task "deploy" do
  content = get_content_branches()
  return if content.empty?

  status, ret, err = syscall("git checkout content")
  raise err if status.success?

  content.each do | branch_name |

  end
end

task "setup-orphans" do
  syscall("git checkout --quiet --orphan gh-pages") do |status, ret, err|
    exists_regex = /already exists/
    unless  err =~ exists_regex
      setup_orphan("gh-pages")
    end
  end

  syscall("git checkout --quiet --orphan content") do |status, ret, err|
    exists_regex = /already exists/
    unless  err =~ exists_regex
      setup_orphan("content")
    end
  end
end

def get_content_branches()
  status, ret, err = syscall("git branch")
  raise err unless status.success?

  ret.split("\n")
    .map { |line| line.strip.sub(/^\*\s+/, "") }
    .select { |item| item =~ /^post\// && item !=~ /^post\/wip\// }
end

def has_uncommitted_changes?
  status, ret, err = syscall("git diff --exit-code --quiet")
  !status.success?
end

def setup_orphan(name)
  status, ret, err = syscall("git rm -rf .")
  raise err unless status.success?
  `touch README.md`
  `echo "# #{name}" > README.md`

  status, ret, err = syscall("git add README.md")
  raise err unless status.success?

  msg = "Initial commit on #{name} branch"
  status, ret, err = syscall("git commit -m \"#{msg}\"")
  raise err unless status.success?

  status, ret, err = syscall("git push origin #{name}")
  raise err unless status.success?
end

def syscall(cmd)
  begin
    stdout, stderr, status = Open3.capture3(cmd)
    ret = stdout.slice!(0..-(1 + $/.size)).strip if status.success?

    if block_given?
      yield status, ret, stderr
    else
      return status, ret, stderr
    end
  rescue StandardError => error
    if block_given?
      yield nil, nil, error
    else
      return nil, nil, error
    end
  end
end
