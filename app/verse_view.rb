class VerseView < UIView

  attr_reader :verse, :label, :position
  attr_accessor :delegate
  
  VerticalOffset = 100

  def initWithVerse(verse, position: position)
    @verse = verse
    @position = position
    initWithFrame([[20, position*80 + VerticalOffset], [UIScreen.mainScreen.bounds.size.width-40, 50]])
    self.backgroundColor = color(:white)
    self.clipsToBounds = true
    
    @label = UILabel.alloc.init
    label.text = verse.text
    label.font = font(:base, 24)
    label.frame = [[0,0], [0,0]]
    label.size = label.sizeThatFits(CGSizeMake(10000, 40))
    label.origin = CGPointMake(0, (self.size.height - label.size.height)/2)
    addSubview label
    clickButton = UIButton.buttonWithType(UIButtonTypeCustom)
    clickButton.addTarget self, action:"press:", forControlEvents:UIControlEventTouchUpInside
    clickButton.frame = [[0,0], [frame.size.width, frame.size.height]]
    addSubview clickButton
    self
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
    x = label.frame.origin.x + distance
    label.origin = CGPointMake(x, label.frame.origin.y) 
  end
  
  def nextVerse
  end
  
  def previousVerse
  end
  
  private

  def color(name)
    CocoaMotion::Theme.color(name)
  end

  def font(name, size=nil)
    CocoaMotion::Theme.font(name, size)
  end

end