class LogSession < NanoStore::Model

  NEW_SESSION_DELAY = 7200 #seconds
  
  attribute :starts_at
  attribute :name
  attribute :event_uuids
  
  def self.current
    last_session = LogSession.all.last
    unless last_session 
      last_session = LogSession.create name: Time.now.strftime("%A %B %d, %Y - %l:%M%P"), starts_at: Time.now 
      last_session.save
    else
      if Time.now - last_session.last_updated_at > NEW_SESSION_DELAY
        last_session = LogSession.create name: Time.now.strftime("%A %B %d, %Y - %l:%M%P"), starts_at: Time.now 
        last_session.save
      end
    end
    last_session
  end

  def last_updated_at
    starts_at
  end
  
  def create_event(uuid, verse)
    self.event_uuids = event_uuids ? "#{event_uuids},#{uuid}" : uuid
    save
    LogEvent.create! uuid, verse
  end
  
  def events
    event_uuids.split(",").collect {|uuid| LogEvent.with_uuid(uuid)}
  end
  
  def close!
    @events.each do |event|
      event.close! unless event.closed?
    end
  end
end
