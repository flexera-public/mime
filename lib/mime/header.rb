module MIME

  #
  # Header section for Internet and MIME messages.
  #
  class Header

    def initialize
      @headers = Hash.new
    end

    #
    # Convert all headers to their string equivalents and join them using the
    # RFC 2822 CRLF line separator.
    #--
    # TODO fold lines to 78 chars.
    # word.scan(/(.,?){1,78}/) OR word.split
    #
    def to_s
      # For our purposes the Content-Type header must come first
      ct = @headers.find {|k,v| k.downcase == "content-type"}
      h = @headers.reject{|k,v| k.downcase == "content-type"}.
                   to_a.map {|kv| kv.join(": ")}.join("\r\n")
      ct ? ct.join(": ") + "\r\n" + h : h
    end

    #
    # Get header value associated with +name+.
    #
    def get name
      _, value = @headers.find {|k,v| name.downcase == k.downcase }
      value
    end

    #
    # Set header +name+ to +value+. If a header of the same name exists it will
    # be overwritten. Header names are _case-insensitive_.
    #
    def set name, value
      delete(name)
      @headers.store(name, value)
    end

    #
    # Delete header associated with +name+.
    #
    def delete name
      @headers.delete_if {|k,v| name.downcase == k.downcase }
    end

  end
end
