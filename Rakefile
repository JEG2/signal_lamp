require "bundler/gem_tasks"
require "rdoc/task"
require "rspec/core/rake_task"

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "doc"
  rdoc.main     = "README.md"
  rdoc.rdoc_files.include(
    "README.md",
    `git ls-files -z`.split("\x0").grep(%r{\Alib/})
  )
end

RSpec::Core::RakeTask.new(:spec)
task default: :spec
