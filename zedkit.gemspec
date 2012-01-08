# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "zedkit"
  s.version = "1.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Zedkit"]
  s.date = "2012-01-07"
  s.description = "gem for Zedkit with all the applicable good stuff easily accessible"
  s.email = "support@zedkit.com"
  s.executables = ["zedkit"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/zedkit",
    "lib/cli/config.rb",
    "lib/zedkit.rb",
    "lib/zedkit/cli/bottom.rb",
    "lib/zedkit/cli/exceptions.rb",
    "lib/zedkit/cli/projects.rb",
    "lib/zedkit/cli/runner.rb",
    "lib/zedkit/cli/text.rb",
    "lib/zedkit/cli/users.rb",
    "lib/zedkit/client/client.rb",
    "lib/zedkit/client/configuration.rb",
    "lib/zedkit/client/exceptions.rb",
    "lib/zedkit/ext/array.rb",
    "lib/zedkit/ext/benchmark.rb",
    "lib/zedkit/ext/hash.rb",
    "lib/zedkit/instances/instance.rb",
    "lib/zedkit/instances/project.rb",
    "lib/zedkit/rails/sessions.rb",
    "lib/zedkit/resources/blog_posts.rb",
    "lib/zedkit/resources/blogs.rb",
    "lib/zedkit/resources/email_settings.rb",
    "lib/zedkit/resources/emails.rb",
    "lib/zedkit/resources/project_admins.rb",
    "lib/zedkit/resources/project_keys.rb",
    "lib/zedkit/resources/projects.rb",
    "lib/zedkit/resources/shortened_urls.rb",
    "lib/zedkit/resources/shorteners.rb",
    "lib/zedkit/resources/users.rb",
    "test/helper.rb",
    "test/test_blog_posts.rb",
    "test/test_blogs.rb",
    "test/test_email_settings.rb",
    "test/test_emails.rb",
    "test/test_entities.rb",
    "test/test_projects.rb",
    "test/test_shortened_urls.rb",
    "test/test_shorteners.rb",
    "test/test_users.rb"
  ]
  s.homepage = "http://github.com/zedkit/zedkit"
  s.require_paths = ["lib"]
  s.rubyforge_project = "zedkit"
  s.rubygems_version = "1.8.10"
  s.summary = "gem for Zedkit"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 1.4.0"])
      s.add_runtime_dependency(%q<nestful>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 1.4.0"])
      s.add_dependency(%q<nestful>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 1.4.0"])
    s.add_dependency(%q<nestful>, [">= 0"])
  end
end

