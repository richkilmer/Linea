class VerseView < UIView

  attr_reader :verse, :labels, :position, :verseLabels
  attr_accessor :delegate
  
  VerticalOffset = 100

  def initWithVerse(verse, position: position)
    @verse = verse
    @position = position
    initWithFrame([[20, position*80 + VerticalOffset], [UIScreen.mainScreen.bounds.size.width-40, 50]])
    self.backgroundColor = color(:white)
    self.clipsToBounds = true
    
    @labels = []
    @verseLabels = []
    
    createLabels
    
    clickButton = UIButton.buttonWithType(UIButtonTypeCustom)
    clickButton.addTarget self, action:"press:", forControlEvents:UIControlEventTouchUpInside
    clickButton.frame = [[0,0], [frame.size.width, frame.size.height]]
    addSubview clickButton
    self
  end
  
  PADDING = 20
  
  def removeLabels
    labels.each do |label|
      label.removeFromSuperview
    end
    verseLabels.each do |verseLabel|
      verseLabel.removeFromSuperview
    end
    @labels = []
    @verseLabels = []
  end
  
  def createLabels
    v = verse.previous.previous
    5.times do
      
      label = UILabel.alloc.init
      label.text = v.text
      label.font = font(:base, 24)
      label.frame = [[0,0], [0,0]]
      label.size = label.sizeThatFits(CGSizeMake(10000, 40))
      label.origin = CGPointMake(0, labelY)
      addSubview label
      labels << label
      
      verseLabel = UILabel.alloc.init
      verseLabel.text = v.verse.to_s
      verseLabel.font = font(:bold, 13)
      verseLabel.frame = [[0,0], [0,0]]
      verseLabel.size = verseLabel.sizeThatFits(CGSizeMake(10000, 40))
      addSubview verseLabel
      verseLabels << verseLabel
      
      v = v.next
    end
    labels[0].origin = CGPointMake(-labels[0].size.width - labels[1].size.width - PADDING, labelY)
    labels[1].origin = CGPointMake(-labels[1].size.width, labelY)
    labels[2].origin = CGPointMake(PADDING, labelY)
    labels[3].origin = CGPointMake(labels[2].size.width + PADDING*2, labelY)
    labels[4].origin = CGPointMake(labels[2].size.width + labels[3].size.width + PADDING*3, labelY)
    alignVerseLabels
  end
  
  def alignVerseLabels
    @verseLabels.each_with_index do |verseLabel, index|
      verseLabel.origin = CGPointMake(labels[index].origin.x - verseLabel.size.width - 1, labelY+2)
    end
  end
  
  def labelY
    @labelY ||= begin
      label = UILabel.alloc.init
      label.text = "Testy"
      label.font = font(:base, 24)
      label.frame = [[0,0], [0,0]]
      label.size = label.sizeThatFits(CGSizeMake(10000, 40))
      (self.size.height - label.size.height)/2
    end
  end
  
  def select
    self.backgroundColor = color(:yellow)  
  end
  
  def deselect
    self.backgroundColor = color(:white)
  end
  
  def press(button)
    delegate.verseViewSelected(self) if delegate
  end
  
  def pan(distance)
    labels.each do |label|
      x = label.frame.origin.x + distance
      label.origin = CGPointMake(x, labelY) 
    end
    alignVerseLabels
    if labels[2].origin.x > size.width
      offset = (labels[2].origin.x - size.width)
      previousVerse
      pan(offset)
    elsif labels[3].origin.x <= 0
      offset = labels[3].origin.x
      nextVerse
      pan(offset)
    end
  end
  
  def nextVerse
    @verse = @verse.next
    removeLabels
    createLabels
  end
  
  def previousVerse
    @verse = @verse.previous
    removeLabels
    createLabels
  end
  
  private

  def color(name)
    CocoaMotion::Theme.color(name)
  end

  def font(name, size=nil)
    CocoaMotion::Theme.font(name, size)
  end

end