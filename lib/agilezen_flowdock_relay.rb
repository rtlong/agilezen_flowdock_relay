class AgilezenFlowdockRelay

  %w[ jabber_client patterns notification_parser ].each { |l| require "agilezen_flowdock_relay/" << l }

  def initialize(*args)
    # rebuild the hash based on project ID to make mapping project id to the flow easy
    @relays = {}
    CONFIG[:relays].each_pair do |label, r|
      @relays[r[:agilezen_id]] = {flow_token: r[:flow_token], name: label} if args.include?(label.to_sym)
    end

  end

  def run
    puts "Starting..."
    puts 'Will be relaying the following:'
    @relays.each_pair do |agilezen_id,r|
      az_name = agile_zen.project(agilezen_id).name
      puts "  - [#{r[:name]}] Project '#{az_name}' to the '#{r[:flow_token]}' flow"
      r[:flow] = flowdock_api(r[:flow_token])
    end


    # define the Blather stream handlers for the client
    # Any message from AgileZen, process and relay to Flowdock
    jabber.message :chat?, :body, :from => /notifications@jabber.agilezen.com/ do |m|

      if notification = NotificationParser.parse(m.xhtml.strip)
        p notification if CONFIG[:debug]
      else
        puts "[Error] Unhandled notification:"
        p m
      end

    end

    # Finally, start EventMachine and the Jabber client
    trap(:INT) { EM.stop }
    trap(:TERM) { EM.stop }
    EM.run do
      jabber.run
    end
  end

  private

  def jabber
    @jabber ||= JabberClient.new CONFIG[:jabber]
  end

  def agile_zen
    @agile_zen ||= AgileZen::Client.new api_key: CONFIG[:agilezen][:api_token]
  end

  def flowdock_api(flow_token)
    Flowdock::Flow.new CONFIG[:flowdock].merge(api_token: flow_token)
  end
end