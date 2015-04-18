class VerseChooserController < UIViewController

  include CocoaMotion::ViewControllerBehaviors
  
  DEBUG = true
  
  attr_reader :bible, :bookText, :chapterText, :verseText

  def viewDidLoad
    super
    view.backgroundColor = color(:white)
    nav title:"Verse Selector", 
      left_button:{title:"Cancel", action:->{nav.dismiss}},
      right_button:{title:"Sort by Name", target: self, action: "sort:"}
    @bible = Bible[:esv]

    index = 0

    build :label, :book,
          text: "Book: ", 
          align: :center,
          font: font(:base, 40),
          layout:{left:0, top:10, height:50, right:0}
    
    11.times do |row|
      6.times do |column|
        build :button, "book_#{row*6+column}",
              title: Bible::BookAbbreviations[row*6 + column],
              font: font((row*6+column) < 39 ? :button : :button_bold),
              target: self,
              action: "bookPressed:",
              layout: {top: row*50+65, width:100, left:59+column*110, height:40}
      end
    end
    
    keys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "<", "0", "x"]

    4.times do |row|
      3.times do |column|
        build :button, "chapter_#{row*3+column}",
              title: keys[row*3+column],
              target: self,
              action: "chapterKeyPressed:",
              layout: {top: row*50+670, width:80, left:59+column*90, height:40}
      end
    end

    build :label, :chapter,
          text: "Chapter: ", 
          align: :center,
          font: font(:base, 40),
          layout:{left:59, top:670 - 50, height:40, width:270}

    4.times do |row|
      3.times do |column|
        build :button, "verse_#{row*3+column}",
              title: keys[row*3+column],
              target: self,
              action: "verseKeyPressed:",
              layout: {top: row*50+670, width:80, left:59+(column+3)*90+120, height:40}
      end
    end

    build :label, :verse,
          text: "Verse: ", 
          align: :center,
          font: font(:base, 40),
          layout:{left:59 + 120 + 3*90, top:670 - 50, height:40, width:270}

    build :button, "select",
          title: "Choose",
          target: self,
          action: "chooseButtonPressed:",
          layout: {bottom: 20, width:200, height:60, left: 284}

  end
  
  def viewWillAppear(animated)
    super
    @chapterText = ""
    @chapter_label.text = "Chapter"
    @verseText = ""
    @verse_label.text = "Verse"
    @bookText = ""
    @book_label.text = "Choose Book"
    nav.apply!
  end
  
  def chosen(&listener)
    @listener = listener
  end
  
  def chooseButtonPressed(button)
    if valid?
      nav.dismiss
      @listener.call
    end
  end
  
  def valid?
    if @bookText != ""
      @chapterText = '1' if @chapterText == ""
      @verseText = '1' if @verseText == "" 
      true
    else
      false
    end
  end
  
  def bookPressed(button)
    text = button.titleLabel.text
    @bookText = Bible::Books[Bible::BookAbbreviations.index(text)]
    @book_label.text = @bookText
    @chapterText = ""
    @verseText = ""
    @chapter_label.text = "#{Bible[:esv].chapter_count(@bookText)} Chapters"
    @verse_label.text = "Verse"
  end
  
  def sort(button)
    if @book_0_button.titleLabel.text == "Gen"
      button.title = "Sort by Order"
      sortByName
    else
      button.title = "Sort by Name"
      sortByOrder
    end
  end
  
  def sortByOrder
    66.times do |i|
      button = instance_variable_get("@book_#{i}_button")
      button.update! title: Bible::BookAbbreviations[i]
      button.font = font(i < 39 ? :button : :button_bold)
    end
  end
  
  def sortByName
    books = Bible::BookAbbreviations.sort {|a, b| a.split(" ").reverse.join(" ") <=> b.split(" ").reverse.join(" ")}
    66.times do |i|
      button = instance_variable_get("@book_#{i}_button")
      button.update! title: books[i]
      button.font = font(:button)
    end
  end
  
  def chapterKeyPressed(button)
    if @bookText == ""
      return
    end
    text = button.titleLabel.text
    if text == "<"
      @chapterText = @chapterText[0..-2]
    elsif text == "x"
      @chapterText = ""
    else
      i = (@chapterText + text).to_i
      if i > 0 && @bookText != "" && i <= Bible[:esv].chapter_count(@bookText)
        @chapterText += text
      end
    end
    if @chapterText == ""
      @chapter_label.text = "#{Bible[:esv].chapter_count(@bookText)} Chapters"
      @verse_label.text = "Verse"
    else
      @chapter_label.text = "Chapter: #{@chapterText}"
      @verseText = ""
      @verse_label.text = "#{Bible[:esv].verse_count(@bookText, @chapterText.to_i)} Verses"
    end
  end
  
  def verseKeyPressed(button)
    if @chapterText == ""
      return
    end
    text = button.titleLabel.text
    if text == "<"
      @verseText = @verseText[0..-2]
    elsif text == "x"
      @verseText = ""
    else
      i = (@verseText + text).to_i
      if i > 0 && @bookText != "" && @chapterText != "" && i <= Bible[:esv].verse_count(@bookText, @chapterText.to_i)
        @verseText += text
      end
    end
    if @verseText == ""
      @verse_label.text = "#{Bible[:esv].verse_count(@bookText, @chapterText.to_i)} Verses"
    else
      @verse_label.text = "Verse: #{@verseText}"
    end
  end
  

end