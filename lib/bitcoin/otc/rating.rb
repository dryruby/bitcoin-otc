require 'date'
require 'json'

module Bitcoin module OTC
  ##
  # Represents a `#bitcoin-otc` rating entry.
  class Rating
    ##
    # @overload initialize(id)
    #   @param  [Integer] id
    # @overload initialize(data)
    #   @param  [Hash] data
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
        when Integer, String
          @id = id_or_data.to_i
        else
          raise TypeError, "expected an Integer or Hash, but got #{id_or_data.inspect}"
      end
    end

    ##
    # The rating identifier.
    #
    # @return [Integer]
    attr_reader :id

    ##
    # The nick of the user who created this rating.
    #
    # @return [String]
    attr_reader :rater_nick

    ##
    # The nick of the user being rated.
    #
    # @return [String]
    attr_reader :rated_nick

    ##
    # The rating's creation date.
    #
    # @return [DateTime]
    attr_reader :created_at

    ##
    # The rating's numerical value.
    #
    # @return [Integer]
    attr_reader :rating

    ##
    # The rating's informational content.
    #
    # @return [String]
    attr_reader :notes

    ##
    # Returns the account of the user who created this rating.
    #
    # @return [Account]
    def rater
      Account[self.rater_nick]
    end

    ##
    # Returns the account of the user being rated.
    #
    # @return [Account]
    def rated
      Account[self.rater_nick]
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
