module Bitcoin module OTC
  ##
  # Error class for `#bitcoin-otc` operations.
  class Error < StandardError
    ##
    # @param  [String] message
    # @param  [Net::HTTP::Response] response
    def initialize(message, response = nil)
      super(message)
      @response = response
    end

    # @return [Net::HTTP::Response]
    attr_reader :response
  end # Error
end end # Bitcoin::OTC
