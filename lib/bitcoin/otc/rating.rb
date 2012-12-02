module Bitcoin module OTC
  ##
  # Represents a `#bitcoin-otc` rating entry.
  class Rating
    ##
    # @param  [Integer, #to_i] id
    def initialize(id)
      @id = id.to_i
    end

    # @return [Integer]
    attr_reader :id

    # @return [String]
    attr_reader :rater_nick

    # @return [String]
    attr_reader :rated_nick

    # @return [Date]
    attr_reader :created_at

    # @return [Integer]
    attr_reader :rating

    # @return [String]
    attr_reader :notes

    ##
    # @return [Account]
    def rater
      Account.new(self.rater_nick)
    end

    ##
    # @return [Account]
    def rated
      Account.new(self.rater_nick)
    end

    ##
    # Returns the integer representation of this rating.
    #
    # @return [Integer]
    def to_i
      self.rating
    end

    ##
    # Returns the JSON string representation of this rating.
    #
    # @return [String]
    def to_json
      self.to_hash.to_json
    end

    ##
    # Returns the hash representation of this rating.
    #
    # @return [Hash]
    def to_hash
      %w(id rater_nick rated_nick created_at rating notes).inject({}) do |hash, attr|
        hash[attr.to_sym] = self.instance_variable_get("@#{attr}")
        hash
      end
    end
  end # Rating
end end # Bitcoin::OTC
