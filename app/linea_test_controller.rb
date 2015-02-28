class LineaTestController < UIViewController

  include CocoaMotion::ViewControllerBehaviors
  
  DEBUG = true
  
  VERSE = "The king's scribes were summoned at that time, in the third month, which is the month of Sivan, on the twenty-third day. And an edict was written, according to all that Mordecai commanded concerning the Jews, to the satraps and the governors and the officials of the provinces from India to Ethiopia, 127 provinces, to each province in its own script and to each people in its own language, and also to the Jews in their script and their language."
  
  def viewDidLoad
    super
    view.backgroundColor = color(:white)
    nav title:"Linea Test"

    

  end

  def viewWillAppear(animated)
    super
    nav.apply!
    debug "Application Launched"
    
    margin = UIView.alloc.initWithFrame([[20, 200], [UIScreen.mainScreen.bounds.size.width-40, 50]])
    margin.backgroundColor = color(:white)
    margin.clipsToBounds = true
    view.backgroundColor = color(:button)
    view.addSubview margin
    
    label = UILabel.alloc.init
    label.text = VERSE
    label.font = font(:base, 24)
    
    label.frame = [[0,0], [0,0]]
    label.size = label.sizeThatFits(CGSizeMake(10000, 40))
    label.origin = CGPointMake(0, (margin.size.height - label.size.height)/2)
    margin.addSubview label
    EM.add_periodic_timer 0.005 do
      label.origin = CGPointMake(label.frame.origin.x - 1, label.frame.origin.y)
    end
  end

end