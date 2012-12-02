require 'cgi'
require 'json'
require 'net/http'
require 'uri'

module Bitcoin module OTC
  ##
  # HTTP client for fetching `#bitcoin-otc` data.
  class Client
    BASE_URL = 'http://bitcoin-otc.com/'

    ##
    # Returns the `#bitcoin-otc` base URL.
    #
    # @return [URI]
    def self.base_url
      @base_url ||= URI.parse(BASE_URL)
    end

    def self.load(*args)
      self.new.load(*args)
    end

    def initialize
      @headers = {}
    end

    ##
    # Returns the server's host name.
    #
    # @return [String]
    def host
      self.class.base_url.host
    end

    ##
    # Returns the server's port number.
    #
    # @return [Integer]
    def port
      self.class.base_url.port
    end

    ##
    # @param  [String] op
    # @param  [Hash] options
    # @return [Hash]
    def path_for(op, options = {})
      options[:outformat] ||= :json
      '/' + op + '?' + options.map { |k, v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }.join('&')
    end

    ##
    # @param  [String] op
    # @param  [Hash] options
    # @return [Hash]
    def load(op, options = {})
      self.get(self.path_for(op, options)) do |response|
        case response
          when Net::HTTPSuccess
            JSON.parse(response.body)
          else
            raise Error.new("Failed to retrive #bitcoin-otc data", response)
        end
      end
    end

    ##
    # Performs an HTTP GET request for the given path.
    #
    # @param  [String, #to_s]          path
    # @param  [Hash{String => String}] headers
    # @yield  [response]
    # @yieldparam [Net::HTTPResponse] response
    # @return [Net::HTTPResponse]
    def get(path, headers = {}, &block)
      Net::HTTP.start(self.host, self.port) do |http|
        response = http.get(path.to_s, @headers.merge(headers))
        if block_given?
          block.call(response)
        else
          response
        end
      end
    end
  end # Client
end end # Bitcoin::OTC
