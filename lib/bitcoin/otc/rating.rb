require 'date'

module Bitcoin module OTC
  ##
  # Represents a `#bitcoin-otc` rating entry.
  class Rating
    ##
    # @param  [Integer, #to_i] id
    def initialize(id_or_data)
      case id_or_data
        when Hash
          id_or_data.each do |attr, value|
            case attr.to_sym
              when :id, :rating
                value = value.to_i
              when :created_at
                value = DateTime.strptime(value, '%s') unless value.is_a?(DateTime)
            end
            self.instance_variable_set("@#{attr}", value)
          end
        else @id = id_or_data.to_i
      end
    end

    # @return [Integer]
    attr_reader :id

    # @return [String]
    attr_reader :rater_nick

    # @return [String]
    attr_reader :rated_nick

    # @return [DateTime]
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
      hash = self.to_hash
      hash.each do |attr, value|
        case attr
          when :id, :rating
            hash[attr] = value.to_s
          when :created_at
            hash[attr] = value.strftime('%s')
        end
      end
      hash.to_json
    end

    ##
    # Returns the hash representation of this rating.
    #
    # @return [Hash]
    def to_hash
      %w(id rater_nick rated_nick created_at rating notes).map(&:to_sym).inject({}) do |hash, attr|
        hash[attr] = self.instance_variable_get("@#{attr}")
        hash
      end
    end
  end # Rating
end end # Bitcoin::OTC
