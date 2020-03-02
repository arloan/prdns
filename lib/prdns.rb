require 'async/dns'
require "prdns/version"

module Prdns
  class AppError < StandardError; end
  class UsageError < AppError; end

  class PurifiedServer < Async::DNS::Server
    LOG = Async.logger
    # LOG.debug!

    def setup(polluted: nil, authentic: nil)
      @polluted_ns = Async::DNS::Resolver.new(polluted || [[:udp, '114.114.114.114', 53]])
      @authentic_ns = Async::DNS::Resolver.new(authentic || [[:udp, '208.67.220.220', 5353]])
      @polluted_domains = {}
      @virgin_domains = {}
    end

    def polluted?(domain)
      @polluted_domains.has_key?(domain)
    end
    def virgin?(domain)
      @virgin_domains.has_key?(domain)
    end
    def add_polluted(domain)
      @polluted_domains[domain] = true
    end
    def add_virgin(domain)
      @virgin_domains[domain] = Time.now
    end

    def process(name, resource_class, transaction)
      split = name.chomp('.').split('.')

      # unless split[-1] == 'local'
      #     LOG.debug 'name: %s' % name
      #     LOG.debug 'resource class: %s' % resource_class
      # end

      return transaction.passthrough!(@polluted_ns) if
          resource_class != Resolv::DNS::Resource::IN::A or split.length < 2

      top_domain = split[-2, 2].join('.').downcase
      return transaction.passthrough!(@authentic_ns) if polluted?(top_domain)
      return transaction.passthrough!(@polluted_ns) if virgin?(top_domain)

      polluted = false
      Async do
        message = @polluted_ns.query('ne-%d.%s' % [Time.now.to_i, top_domain],
                                     Resolv::DNS::Resource::IN::ANY)

        # LOG.debug message.inspect
        records = message&.answer
        if records and records.length == 1 and records.first[2].is_a?(Resolv::DNS::Resource::IN::A)
          LOG.warn 'Domain: %s is polluted, delegate to authentic server from now on!' % top_domain
          polluted = true
          add_polluted(top_domain)
        else
          add_virgin(top_domain) if records
        end
      end
      polluted ?
          transaction.passthrough!(@authentic_ns) :
          transaction.passthrough!(@polluted_ns)
    end
  end
end
