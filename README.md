`#bitcoin-otc` Client for Ruby
==============================

This is a Ruby library for fetching ratings data from the `#bitcoin-otc`
trading database.

Features
--------

* Supports checking whether a particular nick is registered.
* Supports enumerating all registered accounts and their ratings.
* Supports fetching ratings entries for individual accounts.
* Compatible with Ruby 1.8.7+, Ruby 1.9.x, and JRuby.

Examples
--------

    require 'rubygems'
    require 'bitcoin/otc'

### Checking whether a nick exists

    Bitcoin::OTC::Account.exists?('bendiken')  #=> true
    Bitcoin::OTC::Account.exists?('jhacker')   #=> false

### Enumerating all accounts

    Bitcoin::OTC::Account.each { |account| p account }

### Obtaining information about an account

    account = Bitcoin::OTC::Account['bendiken']
    account.nick            #=> "bendiken"
    account.id              #=> 5174
    account.keyid           #=> "74D266C6748B3546"
    account.fingerprint     #=> "FE0A49F7154638A73DBF0EFD74D266C6748B3546"
    account.bitcoinaddress  #=> "1Es4dCurqKxNSqK5W8Adb8WKTbrvKrDdQZ"
    account.registered_at   #=> #<DateTime: 2012-10-08T02:43:34+00:00>
    account.rating          #=> 7

### Enumerating ratings for an account

    account = Bitcoin::OTC::Account['bendiken']
    account.ratings.each { |rating| p rating }

Dependencies
------------

* [Ruby](http://ruby-lang.org/) (>= 1.8.7) or (>= 1.8.1 with [Backports][])

Author
------

* [Arto Bendiken](mailto:arto@bendiken.net) - <https://github.com/bendiken>

License
-------

This is free and unencumbered public domain software. For more information,
see <http://unlicense.org/> or the accompanying UNLICENSE file.

[Backports]: http://rubygems.org/gems/backports
