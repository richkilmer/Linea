class LineaTestController < UIViewController

  include CocoaMotion::ViewControllerBehaviors
  
  DEBUG = true
  
  def viewDidLoad
    super
    view.backgroundColor = color(:button)
    nav title:"Linea Test"
    @bible = Bible[:niv]
  end
  
  attr_reader :rocker, :bible

  def viewWillAppear(animated)
    super
    nav.apply!
    debug "Application Launched"
    
    @verseView = VerseView.alloc.initWithVerse(bible.verse("Genesis", 1, 1))
    view.addSubview(@verseView)
    @rocker = UIView.alloc.initWithFrame([[20, UIScreen.mainScreen.bounds.size.height - 150], [200, 50]])
    rocker.backgroundColor = color(:black)
    view.addSubview rocker
    
    panGesture = UIPanGestureRecognizer.alloc.initWithTarget(self, action: "pan:")
    rocker.addGestureRecognizer panGesture
  end
  
  def beginAnimatingLabel
    @labelTimer = EM.add_periodic_timer 0.005 do
      @verseView.pan(labelSpeed)
    end
  end
  
  attr_reader :labelSpeed, :labelTimer
  
  def stopAnimatingLabel
    EM.cancel_timer labelTimer
  end
  
  def pan(recognizer)
    translation = recognizer.translationInView rocker
    case recognizer.state
    when UIGestureRecognizerStateBegan
      @labelSpeed = 0
      beginAnimatingLabel
    when UIGestureRecognizerStateEnded
      @labelSpeed = 0
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
      @labelSpeed = speed
    end
  end

end