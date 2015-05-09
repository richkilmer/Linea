class LineaController < UIViewController

  include CocoaMotion::ViewControllerBehaviors

  DEBUG = true

  attr_reader :verseSpeed, :verseTimer, :verseViews, :panningViewPosition

  def viewDidLoad
    super
    view.backgroundColor = color(:white)
    nav title:"Linea Bible Reader",
      right_button:{title:"Add Verse", target: self, action: "addVersePressed:"}

    @bible = Bible[:esv]
    @verseViews = []
    @panningViewPosition = -1

    build :button, :close,
          title: "Close",
          target: self,
          font: font(:button, 20),
          action: "closeVersePressed:",
          layout:{bottom:15, width:80, right:20, height:40}

    build :button, :expand,
          title: "Biblia",
          target: self,
          font: font(:button, 20),
          action: "expandVersePressed:",
          layout:{bottom:15, width:80, right:120, height:40}

    build :label, :verse,
          text: "VERSE",
          align: :center,
          font: font(:base, 12),
          layout:{right:255, bottom:60, height:15, width:90}

    build :button, :previous_verse,
          title: "<",
          target: self,
          action: "previousVersePressed:",
          layout:{bottom:15, width:40, right:300, height:40}

    build :button, :next_verse,
          title: ">",
          target: self,
          action: "nextVersePressed:",
          layout:{bottom:15, width:40, right:255, height:40}


    build :label, :chapter,
          text: "CHAPTER",
          align: :center,
          font: font(:base, 12),
          layout:{right:360, bottom:60, height:15, width:90}

    build :button, :previous_chapter,
          title: "<",
          target: self,
          action: "previousChapterPressed:",
          layout:{bottom:15, width:40, right:405, height:40}

    build :button, :next_chapter,
          title: ">",
          target: self,
          action: "nextChapterPressed:",
          layout:{bottom:15, width:40, right:360, height:40}

    build :label, :speed,
          text: "READ SPEED",
          align: :center,
          font: font(:base, 12),
          layout:{left:230, bottom:60, height:15, width:85}

    build :button, :slower,
          title: "-",
          target: self,
          action: "slowerPressed:",
          layout:{bottom:15, width:40, left:230, height:40}

    build :button, :faster,
          title: "+",
          target: self,
          action: "fasterPressed:",
          layout:{bottom:15, width:40, left:275, height:40}

   addRocker

    build :view, :disabled,
          background_color: color(:disabled_view),
          layout:{bottom:0, left: 0, right: 0, height: 100}

  end

  attr_reader :rocker, :bible

  def viewWillAppear(animated)
    super
    nav.apply!
    @verseSpeed = 0
  end

  def addRocker
    @rocker = UIView.alloc.initWithFrame([[20, UIScreen.mainScreen.bounds.size.height - 120], [200, 40]])
    rocker.backgroundColor = color(:button)
    view.addSubview rocker
    innerView = UIView.alloc.initWithFrame([[1,1],[198,38]])
    innerView.backgroundColor = color(:white)
    @rocker.addSubview innerView
    @rockerButton = UIView.alloc.initWithFrame([[97,10],[6,20]])
    @rockerButton.backgroundColor = color(:button)
    @rocker.addSubview @rockerButton
    panGesture = UIPanGestureRecognizer.alloc.initWithTarget(self, action: "pan:")
    rocker.addGestureRecognizer panGesture
  end

  def previousVersePressed(button)
    currentVerseView.previousVerse
  end

  def nextVersePressed(button)
    currentVerseView.nextVerse
  end

  def previousChapterPressed(button)
    currentVerseView.previousChapter
  end

  def nextChapterPressed(button)
    currentVerseView.nextChapter
  end

  def closeVersePressed(button)

    LineaLog.instance.currentSession.event!(:close, currentVerseView.uuid, currentVerseView.verse)
    currentVerseView.removeFromSuperview
    verseViews.delete(currentVerseView)
    if verseViews.length == 0
      stopAnimatingLabel
      @disabled_view.hidden = false
      @panningViewPosition = -1
    else
      verseViews[@panningViewPosition..-1].each do |verseView|
        verseView.slidePosition
      end
      @panningViewPosition -= 1 unless @panningViewPosition == 0
      currentVerseView.select
    end
  end

  def addVersePressed(button)
    if verseViews.size == 10
      alert title:"Maximum Verses Reached", message:"You can only view ten verses at a time.  Please close an existing verse to add a new verse.", buttons:{okay:"Okay"} do |button|
      end
    else
      nav.modal verse_chooser
    end
  end

  def fasterPressed(button)
    beginAnimatingLabel unless @verseTimer
    @verseSpeed -= 0.2
  end

  def slowerPressed(button)
    beginAnimatingLabel unless @verseTimer
    @verseSpeed += 0.2
  end

  def expandVersePressed(button)
    nav.modal bible_web_view_controller
    bible_web_view_controller.showVerse(currentVerseView.verse)
  end

  def bible_web_view_controller
    @bible_web_view_controller ||= BibleWebViewController.new
  end

  def verse_chooser
    @verse_chooser ||= begin
      chooser = VerseChooserController.new
      chooser.chosen do
        verseViews << VerseView.alloc.initWithVerse(bible.verse(chooser.bookText, chooser.chapterText.to_i, chooser.verseText.to_i), position: verseViews.length)
        verseViews.last.delegate = self
        view.addSubview(verseViews.last)
        verseViewSelected(verseViews.last)
      end
      chooser
    end
  end

  def currentVerseView
    panningViewPosition > -1 ? verseViews[panningViewPosition] : nil
  end

  def verseViewSelected(verseView)
    currentVerseView.deselect if currentVerseView
    @panningViewPosition = verseView.position
    currentVerseView.select
    @disabled_view.hidden = true
  end

  def beginAnimatingLabel
    @verseTimer = EM.add_periodic_timer 0.005 do
      currentVerseView.pan(verseSpeed)
    end
  end

  def stopAnimatingLabel
    EM.cancel_timer verseTimer if verseTimer
    @verseTimer = nil
  end

  def pan(recognizer)
    translation = recognizer.translationInView rocker
    case recognizer.state
    when UIGestureRecognizerStateBegan
      @verseSpeed = 0
      stopAnimatingLabel
      beginAnimatingLabel
    when UIGestureRecognizerStateEnded
      @verseSpeed = 0
      UIView.animateWithDuration(0.2,
          animations: lambda { @rockerButton.origin = CGPointMake(97, @rockerButton.origin.y) },
          completion:lambda {|finished| }
      )
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
      x = translation.x + max - 3
      if x < 0
        x = 0
      elsif x > 194
        x = 194
      end
      @rockerButton.origin = CGPointMake(x, @rockerButton.origin.y)
      @verseSpeed = speed
    end
  end

end
