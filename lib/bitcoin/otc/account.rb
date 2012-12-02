require 'date'

module Bitcoin module OTC
  ##
  # Represents a `#bitcoin-otc` user account.
  class Account
    ##
    # Returns `true` if the given `#bitcoin-otc` nick is registered.
    #
    # @return [Boolean]
    def self.exists?(nick)
      !(Client.load('viewgpg.php', :nick => nick).empty?)
    end

    ##
    # Enumerates every `#bitcoin-otc` user account.
    #
    # @yield  [account] each account
    # @yieldparam  [Account] account
    # @yieldreturn [void] ignored
    # @return [Enumerator]
    def self.each(&block)
      if block_given?
        entries = Client.load('viewgpg.php')
        entries.each do |entry|
          block.call(self.new(entry))
        end
      end
      to_enum
    end

    ##
    # @overload initialize(nick)
    #   @param  [String] nick
    # @overload initialize(data)
    #   @param  [Hash] data
    def initialize(nick_or_data)
      case nick_or_data
        when Hash # pass through
        when String
          @nick = nick_or_data.to_s
          entries = Client.load('viewgpg.php', :nick => @nick)
          raise ArgumentError, "unknown #bitcoin-otc nick '#{@nick}'" if entries.empty?
          nick_or_data = entries.first
        else
          raise TypeError, "expected a String or Hash, but got #{nick_or_data.inspect}"
      end

      nick_or_data.each do |attr, value|
        case attr.to_sym
          when :id
            value = value.to_i
          when :registered_at
            value = DateTime.strptime(value, '%s') unless value.is_a?(DateTime)
        end
        self.instance_variable_set("@#{attr}", value)
      end
    end

    # @return [Integer]
    attr_reader :id

    # @return [String]
    attr_reader :nick

    # @return [DateTime]
    attr_reader :registered_at

    # @return [String]
    attr_reader :keyid

    # @return [String]
    attr_reader :fingerprint

    # @return [String]
    attr_reader :bitcoinaddress

    ##
    # Returns the ratings for this account.
    #
    # @return [Array<Rating>]
    def ratings
      entries = Client.load('viewratingdetail.php', :nick => self.nick)
      entries.map { |entry| Rating.new(entry) }
    end
  end # Account
end end # Bitcoin::OTC
