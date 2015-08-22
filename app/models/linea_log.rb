class LineaLog

  class Session
    
    NEW_SESSION_DELAY = 7200 #seconds

    attr_reader :starts_at, :events, :name

    def initialize(name = Time.now.strftime("%A %B %d, %Y - %l:%M%P"))
      @starts_at = Time.now
      @events ||= {}
      @notes ||= []
      @name = name
    end
    
    def last_updated_at
      @events.empty? ? starts_at : events.values.last.opened_at
    end
    
    def close!
      @events.each do |event|
        event.close! unless event.closed?
      end
    end

  end

  def self.instance
    @instance ||= LineaLog.new
  end

  def initialize
    @sessions = []
    @current_session = Session.new()
  end
  
  def current_session
    @sessions << Session.new if @sessions.empty?
    if Time.now - @sessions.last.last_updated_at > Session::NEW_SESSION_DELAY
      @sessions.last.close!
      @sessions << Session.new
    end
    @sessions.last
  end

  def each_event(&block)
    current_session.events.values.each(&block)
  end
  
  def dump
    current_session.events.each do |uuid, event|
      puts event.to_s
    end
    nil
  end
  
  def self.each_event(&block)
    instance.each_event(&block)
  end
  
  def self.event!(action, uuid, verse)
    instance.event!(action, uuid, verse)
  end
  
  def self.note!(event_uuid, verse, body)
    instance.note!(event_uuid, verse, body)
  end

  def event!(action, uuid, verse)
    case action
    when :open
      current_session.events[uuid] = Event.new(uuid, verse)
    when :close
      event = current_session.events[uuid]
      if event
        event.close!(verse)
      else
        if @sessions[-2]
          event = current_session.events[uuid]
          if event
            event.close!(verse)
          end
        end
      end
    end
  end
  
  def note!(event_uuid, verse, body)
    current_session.notes << Note.new(event_uuid, verse, body)
  end
  
  class Note
    def initialize(event_uuid, verse, body)
      @event_uuid = event_uuid
      @translation = verse.bible.translation.to_s
      @opened_at = Time.now
      @book = verse.book
      @chapter_number = verse.chapter
      @verse_number = verse.verse
      @body = body
    end
  end

  class Event
    attr_reader :uuid, :translation
    attr_reader :opened_at, :opening_book, :opening_chapter_number, :opening_verse_number
    attr_reader :closed_at, :closing_book, :closing_chapter_number, :closing_verse_number

    def initialize(uuid, verse)
      @uuid = uuid
      @translation = verse.bible.translation.to_s
      @opened_at = Time.now
      @opening_book = verse.book
      @opening_chapter_number = verse.chapter
      @opening_verse_number = verse.verse
    end
    
    def close!(verse=nil)
      @closed_at = Time.now
      if verse
        @closing_book = verse.book
        @closing_chapter_number = verse.chapter
        @closing_verse_number = verse.verse
      else
        @closing_book = @opening_book
        @closing_chapter_number = @closing_chapter_number
        @closing_verse_number = @closing_verse_number
      end
    end

    def opening_verse
      @opening_verse ||= Bible[@translation.to_sym].verse(@opening_book, @opening_chapter_number, @opening_verse_number)
    end

    def closing_verse
      @closing_verse ||= Bible[@translation.to_sym].verse(@closing_book, @closing_chapter_number, @closing_verse_number)
    end
    
    def closed?
      !!@closed_at
    end
    
    def verses
      return [opening_verse] unless closed?
      result = [opening_verse]
      while result.last != closing_verse
        result << result.last.next
      end
      result
    end

    def to_s
      "#{opened_at}: #{opening_verse.to_s} - #{closing_verse.to_s}"
    end

  end

end
