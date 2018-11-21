# GCSStreamUpload

A simple wrapper on top of `google_cloud_storage` allowing for streaming uploads. It uses the underlying resumable uploads provided in the json api.

Unfortunately the `UPLOAD_CONTENT_LENGTH` header is hardcoded to be set in `google-api-client` and the following monkey patch is necessary and is included:

```ruby
if upload_io.respond_to?(:size)
  request_header[UPLOAD_CONTENT_LENGTH] = upload_io.size.to_s
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gcs_stream_upload'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gcs_stream_upload

## Usage

```ruby
require 'gcs_stream_upload'

storage = Google::Cloud::Storage.new(timeout: 5 * 60)
bucket = storage.bucket('bucket')
gcs_stream_upload = GCSStreamUpload.new(bucket)

gcs_stream_upload.upload('object') do |io|
  IO.copy_stream(IO.popen('yes | head -n 10'), io)
end
# => Written "y\n" * 10


gcs_stream_upload.upload('object') do |io|
  io << 'data'
  io << 'dat2'
end
# => Written "datadat2"

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Fonsan/gcs_stream_upload. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the GcsStreamUpload project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Fonsan/gcs_stream_upload/blob/master/CODE_OF_CONDUCT.md).
