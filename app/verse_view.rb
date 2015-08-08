class VerseView < UIView

  attr_reader :verse, :labels, :position, :verseLabels, :verseReferenceLabel, :verseScroller
  attr_reader :uuid, :selectorView, :clickButton
  attr_accessor :delegate

  VerticalOffset = 50

  def slidePosition
    @position = position - 1
    UIView.animateWithDuration(0.5,
        animations: lambda {
           self.frame = [[20, position*80 + VerticalOffset], [UIScreen.mainScreen.bounds.size.width-40, 50]]
        },
        completion:lambda {|finished|

        }
      )
  end

  def initWithVerse(verse, position: position)

    @uuid = CFUUIDCreateString(nil, CFUUIDCreate(nil))
    LineaLog.event!(:open, uuid, verse)

    @verse = verse
    @position = position
    initWithFrame([[5, position*80 + VerticalOffset], [UIScreen.mainScreen.bounds.size.width-5, 50]])
    self.backgroundColor = color(:white)
    self.clipsToBounds = true

    @labels = []
    @verseLabels = []

    @selectorView = UIView.alloc.init
    @selectorView.backgroundColor = color(:white)
    @selectorView.frame = [[0,0],[5,frame.size.height]]
    @selectorView.clipsToBounds = true
    addSubview selectorView

    @verseScroller = UIView.alloc.init
    @verseScroller.backgroundColor = color(:white)
    @verseScroller.frame = [[10,0],[frame.size.width-10,frame.size.height]]
    @verseScroller.clipsToBounds = true
    addSubview verseScroller

    @verseReferenceLabel = UILabel.alloc.init
    verseReferenceLabel.frame = [[0,0], [0,0]]
    verseReferenceLabel.font = font(:verse_reference)
    verseReferenceLabel.color = color(:verse_reference)
    verseScroller.addSubview verseReferenceLabel

    createLabels
    updateVerseReference

    @clickButton = UIButton.buttonWithType(UIButtonTypeCustom)
    clickButton.addTarget self, action:"press:", forControlEvents:UIControlEventTouchUpInside
    clickButton.frame = [[0,0], [frame.size.width, frame.size.height]]
    addSubview clickButton

    panGesture = UIPanGestureRecognizer.alloc.initWithTarget(self, action: "panGestureReceived:")
    clickButton.addGestureRecognizer panGesture

    self
  end

  def panGestureReceived(recognizer)
    translation = recognizer.translationInView clickButton
    case recognizer.state
    when UIGestureRecognizerStateBegan
      @amountPanned = 0
    when UIGestureRecognizerStateEnded
    else
      pan(translation.x - @amountPanned)
      @amountPanned += (translation.x - @amountPanned)
    end
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

  def updateVerseReference
    verseReferenceLabel.text = verse.to_s.upcase
    verseReferenceLabel.size = verseReferenceLabel.sizeThatFits(CGSizeMake(10000, 40))
    verseReferenceLabel.origin = CGPointMake(2, self.size.height - verseReferenceLabel.size.height + 2)
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
      verseScroller.addSubview label
      labels << label

      verseLabel = UILabel.alloc.init
      verseLabel.text = v.verse.to_s
      verseLabel.font = font(:bold, 13)
      verseLabel.color = color(:verse_reference)
      verseLabel.frame = [[0,0], [0,0]]
      verseLabel.size = verseLabel.sizeThatFits(CGSizeMake(10000, 40))
      verseScroller.addSubview verseLabel
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
      (self.size.height - label.size.height)/2 - 7
    end
  end

  def select
    selectorView.backgroundColor = color(:black)
  end

  def deselect
    selectorView.backgroundColor = color(:white)
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
    if (labels[2].origin.x + PADDING) > verseScroller.size.width
      offset = labels[1].origin.x - PADDING
      previousVerse
      pan(offset)
    elsif labels[3].origin.x <= 0
      offset = labels[3].origin.x - PADDING
      nextVerse
      pan(offset)
    end
    updateVerseReference
  end

  def nextVerse
    @verse = @verse.next
    removeLabels
    createLabels
    updateVerseReference
  end

  def previousVerse
    @verse = @verse.previous
    removeLabels
    createLabels
    updateVerseReference
  end

  def nextChapter
    @verse = @verse.next_chapter
    removeLabels
    createLabels
    updateVerseReference
  end

  def previousChapter
    @verse = @verse.previous_chapter
    removeLabels
    createLabels
    updateVerseReference
  end

  private

  def color(name)
    CocoaMotion::Theme.color(name)
  end

  def font(name, size=nil)
    CocoaMotion::Theme.font(name, size)
  end

end
