class Session
  class Event

    attr_reader :action, :uuid

    def initialize(action, uuid, verse)
      @action = action
      @uuid = uuid
      @translation = verse.bible.translation.to_s
      @book = verse.book
      @chapter_number = verse.chapter
      @verse_number = verse.verse
      @occurred_at = Time.now
    end

    def verse
      Bible[@translation.to_sym].verse(@book, @chapter_number, @verse_number)
    end

    def to_s
      "#{uuid}: #{action} #{verse.to_s}"
    end

  end

  attr_reader :starts_at, :events, :name

  def initialize(name)
    @starts_at = Time.now
    @events = []
    @name = name
  end

  def event!(action, uuid, verse)
    events << Event.new(action, uuid, verse)
  end

end
