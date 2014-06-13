require 'time'
require 'mime/headers/internet'

module MIME

  #
  # Construct RFC 2822 Internet messages.
  #
  class Mail

    include Headers::Internet

    attr_reader :headers, :body

    #
    # Initialize a Mail object with body set to +content+.
    #
    def initialize content = nil
      @headers = Header.new
      self.body = content
      self.date = Time.now
    end

    #
    # Format the Mail object as an Internet message.
    #
    def to_s
      self.message_id   ||= ID.generate_gid(domain)
      body.mime_version ||= "1.0 (Ruby MIME v#{VERSION})"

      #--
      # In an RFC 2822 message, the header and body sections must be separated
      # by two line breaks (i.e., 2*CRLF). One line break is deliberately
      # omitted here to allowing the body supplier to append headers to the
      # top-level message header section.
      #++
      "#{headers}\r\n#{body}"
    end

    def body= content
      @body = content.is_a?(Media) ? content : Text.new(content.to_s)
    end

    private

    def domain
      headers.get('from').match(/@([[:alnum:].-]+)/)[1] rescue nil
    end

  end
end
