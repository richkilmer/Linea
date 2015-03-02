class LineaTestController < UIViewController

  include CocoaMotion::ViewControllerBehaviors
  
  DEBUG = true
  
  def viewDidLoad
    super
    view.backgroundColor = color(:button)
    nav title:"Linea Test"
    @bible = Bible[:niv]
  end
  
  attr_reader :rocker, :label, :bible

  def viewWillAppear(animated)
    super
    nav.apply!
    debug "Application Launched"
    
    margin = UIView.alloc.initWithFrame([[20, 200], [UIScreen.mainScreen.bounds.size.width-40, 50]])
    margin.backgroundColor = color(:white)
    margin.clipsToBounds = true
    view.addSubview margin
    
    @label = UILabel.alloc.init
    label.text = bible.verse("Esther", 8, 9).text
    label.font = font(:base, 24)
    
    label.frame = [[0,0], [0,0]]
    label.size = label.sizeThatFits(CGSizeMake(10000, 40))
    label.origin = CGPointMake(0, (margin.size.height - label.size.height)/2)
    margin.addSubview label

    @rocker = UIView.alloc.initWithFrame([[20, UIScreen.mainScreen.bounds.size.height - 150], [200, 50]])
    rocker.backgroundColor = color(:black)
    view.addSubview rocker
    
    panGesture = UIPanGestureRecognizer.alloc.initWithTarget(self, action: "pan:")
    rocker.addGestureRecognizer panGesture
  end
  
  def beginAnimatingLabel
    @labelTimer = EM.add_periodic_timer 0.005 do
      x = label.frame.origin.x + labelSpeed
      label.origin = CGPointMake(x, label.frame.origin.y) 
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