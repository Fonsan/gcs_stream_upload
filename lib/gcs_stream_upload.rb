require "gcs_stream_upload/version"
require "google/cloud/storage"
require "delegate"

class ::Google::Apis::Core::ResumableUploadCommand
  def send_start_command(client)
    logger.debug { sprintf('Sending upload start command to %s', url) }

    request_header = header.dup
    apply_request_options(request_header)
    request_header[UPLOAD_PROTOCOL_HEADER] = RESUMABLE
    request_header[UPLOAD_COMMAND_HEADER] = START_COMMAND
    if upload_io.respond_to?(:size)
      request_header[UPLOAD_CONTENT_LENGTH] = upload_io.size.to_s
    end
    request_header[UPLOAD_CONTENT_TYPE_HEADER] = upload_content_type

    client.request(method.to_s.upcase,
                   url.to_s, query: nil,
                   body: body,
                   header: request_header,
                   follow_redirect: true)
  rescue => e
    raise Google::Apis::ServerError, e.message
  end
end

class GCSStreamUpload
  def initialize(bucket)
    @bucket = bucket
  end

  def upload(*args)
    read_pipe, write_pipe = IO.pipe
    def read_pipe.pos
      0
    end
    def read_pipe.pos=(value)
    end
    thread = Thread.start do
      yield(write_pipe)
    rescue StandardError => e
      e
    ensure
      write_pipe.close_write
    end
    @bucket.create_file(read_pipe, *args)
    result = thread.value
    raise result if result.is_a?(StandardError)
  end
end
