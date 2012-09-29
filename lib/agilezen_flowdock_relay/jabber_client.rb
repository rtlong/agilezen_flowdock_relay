require 'blather/client/dsl'

class AgilezenFlowdockRelay::JabberClient
  include Blather::DSL

  def run; client.run; end

  def initialize(opts)
    opts.stringify_keys!
    setup *opts.values_at(*%w[jid password host port])

    when_ready do
      puts "[debug] Connected ! configure AgileZen notifications to be sent to #{jid.stripped}." if CONFIG[:debug]
      say CONFIG[:jabber][:alert_friend], "I'm up and running... ready to go!" if CONFIG[:jabber][:alert_friend]
    end

    # Auto approve subscription requests (when someone adds this JID to their contact list)
    subscription :request? do |s|
      write_to_stream s.approve!
    end

    if CONFIG[:debug]
      message do |m|
        puts "[debug] " << m.inspect
        puts "---"
      end
    end

  end



end