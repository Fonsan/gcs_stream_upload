
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gcs_stream_upload/version"

Gem::Specification.new do |spec|
  spec.name          = "gcs_stream_upload"
  spec.version       = GcsStreamUpload::VERSION
  spec.authors       = ["Fonsan"]
  spec.email         = ["fonsan@gmail.com"]

  spec.summary       = %q{Google Cloud Storage streaming uploader}
  spec.description   = %q{Google Cloud Storage streaming uploader}

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "google-cloud-storage", "= 1.15.0"
  spec.add_dependency 'google-api-client', '= 0.25.0'
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
