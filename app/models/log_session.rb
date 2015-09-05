class LogSession < NanoStore::Model

  NEW_SESSION_DELAY = 7200 #seconds
  
  attribute :starts_at
  attribute :name
  attribute :event_uuids
  
  def self.list
    LogSession.all.sort {|a, b| b.starts_at <=> a.starts_at }
  end
  
  def self.current
    most_recent_session = list.first
    unless most_recent_session 
      most_recent_session = LogSession.create name: Time.now.strftime("%A, %B %d, %Y - %l:%M%P"), starts_at: Time.now 
      most_recent_session.save
    else
      puts Time.now - most_recent_session.last_updated_at
      if Time.now - most_recent_session.last_updated_at > NEW_SESSION_DELAY
        most_recent_session = LogSession.create name: Time.now.strftime("%A, %B %d, %Y - %l:%M%P"), starts_at: Time.now 
        most_recent_session.save
      end
    end
    most_recent_session
  end

  def last_updated_at
    starts_at
  end
  
  def remove
    events_to_delete = events
    events_to_delete.each do |event| 
      event.delete
    end
    delete
  end
  
  def create_event(uuid, verse)
    self.event_uuids = event_uuids ? "#{event_uuids},#{uuid}" : uuid
    save
    LogEvent.create! uuid, verse
  end
  
  def events_count
    event_uuids ? (event_uuids.scan(/,/).count + 1) : 0
  end
  
  def events
    event_uuids ? event_uuids.split(",").collect {|uuid| LogEvent.with_uuid(uuid)} : []
  end
  
  def close!
    @events.each do |event|
      event.close! unless event.closed?
    end
  end
end
