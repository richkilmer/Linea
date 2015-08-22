class LineaLog

  def self.instance
    @instance ||= LineaLog.new
  end

  def initialize
  end
  
  def current_session
    LogSession.current
  end

  def each_event(&block)
    current_session.events.each(&block)
  end
  
  def self.each_event(&block)
    instance.each_event(&block)
  end
  
  def self.event!(action, uuid, verse)
    instance.event!(action, uuid, verse)
  end
  
  # def self.note!(event_uuid, verse, body)
  #   instance.note!(event_uuid, verse, body)
  # end

  def event!(action, uuid, verse)
    case action
    when :open
      current_session.create_event(uuid, verse)
    when :close
      LogEvent.with_uuid(uuid).close!(verse)
    end
  end
  
  # def note!(event_uuid, verse, body)
  #   current_session.notes << Note.new(event_uuid, verse, body)
  # end
  # 
  # class Note
  #   def initialize(event_uuid, verse, body)
  #     @event_uuid = event_uuid
  #     @translation = verse.bible.translation.to_s
  #     @opened_at = Time.now
  #     @book = verse.book
  #     @chapter_number = verse.chapter
  #     @verse_number = verse.verse
  #     @body = body
  #   end
  # end

end
