class LogEvent < NanoStore::Model
  
  attribute :uuid
  attribute :translation
  attribute :opened_at
  attribute :opening_book
  attribute :opening_chapter_number
  attribute :opening_verse_number
  attribute :closed_at
  attribute :closing_book
  attribute :closing_chapter_number
  attribute :closing_verse_number
  
  def self.create!(uuid, verse)
    event = create uuid: uuid, 
      translation: verse.bible.translation.to_s,
      opened_at: Time.now, 
      opening_book: verse.book,
      opening_chapter_number: verse.chapter,
      opening_verse_number: verse.verse
    event.save
    event
  end
  
  def self.with_uuid(uuid)
    #we need to optimize this in the future
    LogEvent.all.detect {|event| event.uuid == uuid}
  end
  
  # instance methods

  def close!(verse=nil)
    self.closed_at = Time.now
    if verse
      self.closing_book = verse.book
      self.closing_chapter_number = verse.chapter
      self.closing_verse_number = verse.verse
    else
      self.closing_book = opening_book
      self.closing_chapter_number = closing_chapter_number
      self.closing_verse_number = closing_verse_number
    end
    save
  end

  def opening_verse
    @opening_verse ||= Bible[translation.to_sym].verse(opening_book, opening_chapter_number, opening_verse_number)
  end

  def closing_verse
    @closing_verse ||= Bible[translation.to_sym].verse(closing_book, closing_chapter_number, closing_verse_number)
  end
  
  def closed?
    !!closed_at
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
