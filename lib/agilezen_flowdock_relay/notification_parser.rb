class AgilezenFlowdockRelay::NotificationParser

  include Patterns

  def self.parse(xhtml)
    PATTERNS.each_pair do |name, pattern|
      m = pattern.match(xhtml) and return HashWithIndifferentAccess[ m.names.zip( m.captures ) ].merge(event: name)
    end
    return nil # if nothing matched
  end

end