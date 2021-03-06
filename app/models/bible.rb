class Bible
  Books = [
    "Genesis",
    "Exodus",
    "Leviticus",
    "Numbers",
    "Deuteronomy",
    "Joshua",
    "Judges",
    "Ruth",
    "1 Samuel",
    "2 Samuel",
    "1 Kings",
    "2 Kings",
    "1 Chronicles",
    "2 Chronicles",
    "Ezra",
    "Nehemiah",
    "Esther",
    "Job",
    "Psalms",
    "Proverbs",
    "Ecclesiastes",
    "Song of Solomon",
    "Isaiah",
    "Jeremiah",
    "Lamentations",
    "Ezekiel",
    "Daniel",
    "Hosea",
    "Joel",
    "Amos",
    "Obadiah",
    "Jonah",
    "Micah",
    "Nahum",
    "Habakkuk",
    "Zephaniah",
    "Haggai",
    "Zechariah",
    "Malachi",
    "Matthew",
    "Mark",
    "Luke",
    "John",
    "Acts",
    "Romans",
    "1 Corinthians",
    "2 Corinthians",
    "Galatians",
    "Ephesians",
    "Philippians",
    "Colossians",
    "1 Thessalonians",
    "2 Thessalonians",
    "1 Timothy",
    "2 Timothy",
    "Titus",
    "Philemon",
    "Hebrews",
    "James",
    "1 Peter",
    "2 Peter",
    "1 John",
    "2 John",
    "3 John",
    "Jude",
    "Revelation"
  ]

  BookAbbreviations = [
    "Gen",
    "Exod",
    "Lev",
    "Num",
    "Deut",
    "Josh",
    "Judg",
    "Ruth",
    "1 Sam",
    "2 Sam",
    "1 Kgs",
    "2 Kgs",
    "1 Chr",
    "2 Chr",
    "Ezra",
    "Neh",
    "Esth",
    "Job",
    "Ps",
    "Prov",
    "Eccl",
    "Song",
    "Isa",
    "Jer",
    "Lam",
    "Ezek",
    "Dan",
    "Hos",
    "Joel",
    "Amos",
    "Obad",
    "Jonah",
    "Micah",
    "Nahum",
    "Hab",
    "Zeph",
    "Hag",
    "Zech",
    "Mal",
    "Matt",
    "Mark",
    "Luke",
    "John",
    "Acts",
    "Rom",
    "1 Cor",
    "2 Cor",
    "Gal",
    "Eph",
    "Phil",
    "Col",
    "1 Ths",
    "2 Ths",
    "1 Tim",
    "2 Tim",
    "Titus",
    "Phlm",
    "Heb",
    "James",
    "1 Pet",
    "2 Pet",
    "1 Jn",
    "2 Jn",
    "3 Jn",
    "Jude",
    "Rev"
  ]

  BibliaAbbreviations = [
    "Ge",
    "Ex",
    "Le",
    "Nu",
    "De",
    "Jos",
    "Jdg",
    "Ru",
    "1Sa",
    "2Sa",
    "1Ki",
    "2Ki",
    "1Ch",
    "2Ch",
    "Ezr",
    "Ne",
    "Es",
    "Job",
    "Ps",
    "Pr",
    "Ec",
    "So",
    "Is",
    "Je",
    "La",
    "Eze",
    "Da",
    "Ho",
    "Joe",
    "Am",
    "Ob",
    "Jon",
    "Mic",
    "Na",
    "Hab",
    "Zep",
    "Hag",
    "Zec",
    "Mal",
    "Mt",
    "Mk",
    "Lk",
    "Jn",
    "Ac",
    "Ro",
    "1Co",
    "2Co",
    "Ga",
    "Eph",
    "Php",
    "Col",
    "1Th",
    "2Th",
    "1Ti",
    "2Ti",
    "Tt",
    "Phm",
    "Heb",
    "Jas",
    "1Pe",
    "2Pe",
    "1Jn",
    "2Jn",
    "3Jn",
    "Jud",
    "Re"
  ]

  class Verse
    attr_reader :bible, :book, :chapter, :verse, :text
    def initialize(bible, book, chapter, verse, text)
      @bible = bible
      @book = book
      @chapter = chapter
      @verse = verse
      @text = text
    end

    def to_s
      "#{book} #{chapter}:#{verse}"
    end
    
    def book_abbreviation
      Bible::BookAbbreviations[Bible::Books.index(book)]
    end
    
    def book_biblia_abbreviation
      Bible::BibliaAbbreviations[Bible::Books.index(book)]
    end
    
    def ==(verse)
      unless verse.kind_of?(Verse)
        raise "Verse is #{verse}"
      end
      @bible == verse.bible &&
      @book == verse.book &&
      @chapter == verse.chapter &&
      @verse == verse.verse
    end

    def next
      verse_count = bible.verse_count(book, chapter)
      if verse_count == verse
        chapter_count = bible.chapter_count(book)
        if chapter_count == chapter
          index = Books.index(book) + 1
          index = 0 if index == 66
          next_verse = bible.verse(Books[index], 1, 1)
        else
          next_verse = bible.verse(book, chapter + 1, 1)
        end
      else
        next_verse = bible.verse(book, chapter, verse + 1)
      end
      next_verse
    end

    def previous
      if verse == 1
        if chapter == 1
          index = Books.index(book)
          previous_book = Books[index == 0 ? 65 : index - 1]
          previous_chapter = bible.chapter_count(previous_book)
          previous_verse = bible.verse_count(previous_book, previous_chapter)
          prev_verse = bible.verse(previous_book, previous_chapter, previous_verse)
        else
          prev_verse = bible.verse(book, chapter - 1, bible.verse_count(book, chapter - 1))
        end
      else
        prev_verse = bible.verse(book, chapter, verse - 1)
      end
      prev_verse
    end

    def next_chapter
      bible.verse(book, chapter, bible.verse_count(book, chapter)).next
    end

    def previous_chapter
      p = bible.verse(book, chapter, 1).previous
      bible.verse(p.book, p.chapter, 1)
    end
  end

  def self.[](translation)
    @bibles ||= {}
    unless @bibles[translation]
      path = NSBundle.mainBundle.pathForResource(translation.to_s, ofType: "json")
      data = NSData.dataWithContentsOfFile(path)
      error = Pointer.new(:id)
      opts =  NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
      obj = NSJSONSerialization.JSONObjectWithData data, options: opts, error: error
      raise ParserError, error[0].description if error[0]
      @bibles[translation] = new(translation, obj)
    end
    @bibles[translation]
  end

  attr_reader :translation

  def initialize(translation, data)
    @translation = translation
    @data = data
  end

  def verse(book, chapter, verse)
    raise "Unknown bible book: #{book}" unless Books.include?(book)
    text = @data[book][chapter.to_s][verse.to_s]
    Verse.new(self, book, chapter.to_i, verse.to_i, text)
  end

  def chapter_count(book)
    raise "Unknown book #{book}" unless @data[book]
    @data[book].keys.map {|chapter| chapter.to_i}.sort.last
  end

  def verse_count(book, chapter)
    raise "Unknown book #{book}" unless @data[book]
    raise "#{book} does not have chapter #{chapter}" unless @data[book][chapter.to_s]
    @data[book][chapter.to_s].keys.map {|verses| verses.to_i}.sort.last
  end

  def inspect
    "Bible[:#{translation}]"
  end

  def [](book)
    @data[book]
  end

end
