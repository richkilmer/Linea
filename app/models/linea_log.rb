class LineaLog

  def self.instance
    @instance ||= LineaLog.new
  end

  def initialize
    @sessions = []
  end

  attr_reader :sessions

  def currentSession
    @sessions.last || createSession("New Session")
  end

  def createSession(name)
    s = Session.new(name)
    @sessions << s
    s
  end

end
