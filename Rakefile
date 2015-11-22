require "open3"

task "create-orphans" do
  syscall("git checkout --quiet --orphan gh-pages") do |status, ret, err|
    exists_regex = /already exists/ 
    unless (ret && ret.empty?) ||  err =~ exists_regex
      setup_orphan("gh-pages")
    end
  end

  syscall("git checkout --quiet --orphan content") do |status, ret, err|
    exists_regex = /already exists/ 
    unless (ret && ret.empty?) ||  err =~ exists_regex
      setup_orphan("content")
    end
  end
end

def setup_orphan(name)
  status, ret, err = syscall("git rm -rf .")
  puts "21"
  raise err unless status.success?
  puts "22"
  `touch README.md`
  `echo "# #{name}" > README.md`
  
  status, ret, err = syscall("git add -A")
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
