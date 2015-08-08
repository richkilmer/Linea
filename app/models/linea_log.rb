class LineaLog

  def self.instance
    @instance ||= LineaLog.new
  end

  def initialize
    @events ||= []
  end
  
  def dump
    @events.each do |event|
      puts event.to_s
    end
    nil
  end
  
  def self.event!(action, uuid, verse)
    instance.event!(action, uuid, verse)
  end
  
  def self.note!(uuid, verse, body)
  end

  def event!(action, uuid, verse)
    case action
    when :open
      @events << Event.new(uuid, verse)
    when :close
      event = @events.detect {|event| event.uuid == uuid}
      event.close!(verse)
    end
  end
  
  def note!(uuid, verse, body)
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
    
    def close!(verse)
      @closed_at = Time.now
      @closing_book = verse.book
      @closing_chapter_number = verse.chapter
      @closing_verse_number = verse.verse
    end

    def opening_verse
      Bible[@translation.to_sym].verse(@opening_book, @opening_chapter_number, @opening_verse_number)
    end

    def closing_verse
      Bible[@translation.to_sym].verse(@closing_book, @closing_chapter_number, @closing_verse_number)
    end

    def to_s
      "#{opened_at}: #{opening_verse.to_s} - #{closing_verse.to_s}"
    end

  end

end
