module Bitcoin module OTC
  ##
  # Represents a `#bitcoin-otc` user account.
  class Account
    ##
    # @param  [String, #to_s] nick
    def initialize(nick)
      @nick = nick.to_s
    end

    # @return [Integer]
    attr_reader :id

    # @return [String]
    attr_reader :nick

    # @return [Date]
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
      data = Client.load('viewratingdetail.php', :nick => self.nick)
      [] # TODO
    end
  end # Account
end end # Bitcoin::OTC
