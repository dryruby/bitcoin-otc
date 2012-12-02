require 'date'

module Bitcoin module OTC
  ##
  # Represents a `#bitcoin-otc` user account.
  #
  # @example Checking whether a nick exists
  #   Bitcoin::OTC::Account.exists?('jhacker')  #=> false
  #
  # @example Enumerating all accounts
  #   Bitcoin::OTC::Account.each { |account| p account }
  #
  # @example Obtaining information about an account
  #   account = Bitcoin::OTC::Account['bendiken']
  #   account.nick            #=> "bendiken"
  #   account.id              #=> 5174
  #   account.keyid           #=> "74D266C6748B3546"
  #   account.fingerprint     #=> "FE0A49F7154638A73DBF0EFD74D266C6748B3546"
  #   account.bitcoinaddress  #=> "1Es4dCurqKxNSqK5W8Adb8WKTbrvKrDdQZ"
  #   account.registered_at   #=> #<DateTime: 2012-10-08T02:43:34+00:00>
  #   account.rating          #=> 7
  #
  # @example Enumerating ratings for an account
  #   account = Bitcoin::OTC::Account['bendiken']
  #   account.ratings.each { |rating| p rating }
  #
  class Account
    ##
    # Returns account information for the given `nick`.
    #
    # @return [Account]
    def self.[](nick)
      self.new(nick)
    end

    ##
    # Returns `true` if the given `nick` is registered.
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

    ##
    # The account identifier.
    #
    # @return [Integer]
    attr_reader :id

    ##
    # The account nick.
    #
    # @return [String]
    attr_reader :nick

    ##
    # The account's registration date.
    #
    # @return [DateTime]
    attr_reader :registered_at

    ##
    # The account's verified OpenPGP key identifier.
    #
    # @return [String]
    attr_reader :keyid

    ##
    # The account's verified OpenPGP key fingerprint.
    #
    # @return [String]
    attr_reader :fingerprint

    ##
    # The account's verified Bitcoin wallet address.
    #
    # @return [String]
    attr_reader :bitcoinaddress

    ##
    # Returns the rating for this account.
    #
    # @return [Integer]
    def rating
      self.ratings.inject(0) { |sum, rating| sum += rating.to_i }
    end

    ##
    # Returns the rating entries for this account.
    #
    # @return [Array<Rating>]
    def ratings
      entries = Client.load('viewratingdetail.php', :nick => self.nick)
      entries.map { |entry| Rating.new(entry) }
    end
  end # Account
end end # Bitcoin::OTC
