class LineaTestController < UIViewController

  include CocoaMotion::ViewControllerBehaviors
  
  DEBUG = true

  attr_reader :verseSpeed, :verseTimer, :verseViews, :panningViewPosition
  
  def viewDidLoad
    super
    view.backgroundColor = color(:button)
    nav title:"Linea Test"
    @bible = Bible[:esv]
    @verseViews = []
    @panningViewPosition = -1

    build :button, :add_verse,
          title: "New",
          target: self,
          action: "addVersePressed:",
          layout:{bottom:15, width:60, right:15, height:40}
  end
  
  attr_reader :rocker, :bible

  def viewWillAppear(animated)
    super
    nav.apply!
    addRocker
  end
  
  def addRocker
    @rocker = UIView.alloc.initWithFrame([[20, UIScreen.mainScreen.bounds.size.height - 150], [200, 50]])
    rocker.backgroundColor = color(:black)
    view.addSubview rocker
    panGesture = UIPanGestureRecognizer.alloc.initWithTarget(self, action: "pan:")
    rocker.addGestureRecognizer panGesture
  end
  
  def addVersePressed(button)
    verseViews << VerseView.alloc.initWithVerse(bible.verse("John", 3, 16), position: verseViews.length)
    verseViews.last.delegate = self
    view.addSubview(verseViews.last)
    verseViewSelected(verseViews.last)
  end
  
  def verseViewSelected(verseView)
    if panningViewPosition > -1
      verseViews[panningViewPosition].deselect
    end
    @panningViewPosition = verseView.position
    verseViews[panningViewPosition].select
  end
  
  def beginAnimatingLabel
    @verseTimer = EM.add_periodic_timer 0.005 do
      if panningViewPosition > -1
        verseViews[panningViewPosition].pan(verseSpeed)
      end
    end
  end
  
  def stopAnimatingLabel
    EM.cancel_timer verseTimer
  end
  
  def pan(recognizer)
    translation = recognizer.translationInView rocker
    case recognizer.state
    when UIGestureRecognizerStateBegan
      @verseSpeed = 0
      beginAnimatingLabel
    when UIGestureRecognizerStateEnded
      @verseSpeed = 0
      stopAnimatingLabel
    else
      max = @rocker.frame.size.width / 2
      speed = translation.x
      if speed < -max
        speed = -max
      elsif speed > max
        speed = max
      end
      speed = speed / 10.0
      @verseSpeed = speed
    end
  end

end