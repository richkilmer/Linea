class VerseView < UIView

  attr_reader :verse, :label

  def initWithVerse(verse)
    @verse = verse
    initWithFrame([[20, 200], [UIScreen.mainScreen.bounds.size.width-40, 50]])
    self.backgroundColor = color(:white)
    self.clipsToBounds = true
    
    @label = UILabel.alloc.init
    label.text = verse.text
    label.font = font(:base, 24)
    label.frame = [[0,0], [0,0]]
    label.size = label.sizeThatFits(CGSizeMake(10000, 40))
    label.origin = CGPointMake(0, (self.size.height - label.size.height)/2)
    addSubview label
    self
  end
  
  def pan(distance)
    x = label.frame.origin.x + distance
    label.origin = CGPointMake(x, label.frame.origin.y) 
  end
  
  private

  def color(name)
    CocoaMotion::Theme.color(name)
  end

  def font(name, size=nil)
    CocoaMotion::Theme.font(name, size)
  end

end