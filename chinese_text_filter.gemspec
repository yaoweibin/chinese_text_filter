Gem::Specification.new do |s|
  s.name = %q{chinese_text_filter}
  s.version = "0.1.0"

  s.authors = %q{Webin Yao}
  s.description = <<EOF
process chinese text, segmentation, conversion, etc
EOF
  s.email = %q{yaoweibin@gmail.com}
  s.files = ["README", 
            "Manifest.txt",
            "lib/chinese_text_filter.rb",  
            "lib/zh_conversion.rb",
            "test/test.rb"]
  s.homepage = %q{http://yaoweibin.cn}
  s.require_paths = ["lib"]
  s.summary = %q{process chinese text}

  # Ruby version
  s.required_ruby_version = ::Gem::Requirement.new("< 1.9.0")

  # dependencies
  # RubyGems has runtime dependencies (add_dependency) and
  # development dependencies (add_development_dependency)
  s.add_dependency "rmmseg-cpp", "=0.2.7"

  # RubyForge
  s.rubyforge_project = "chinese_text_filter"
  s.license = "BSD"
end
