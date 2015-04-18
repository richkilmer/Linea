class BibleWebViewController < UIViewController

  include CocoaMotion::ViewControllerBehaviors
  
  def viewDidLoad
    super
    view.backgroundColor = color(:white)
    nav title:"Biblia.com Bible Reader", 
      left_button:{title:"Close", action:->{nav.dismiss}}
  end

  def loadView
    self.view = UIWebView.alloc.init
    view.delegate = self
  end
  
  def viewWillAppear(animated)
    super
    nav.apply!
  end
  
  def webView(webView, shouldStartLoadWithRequest:request, navigationType:navType)
    true
  end
  
  def showVerse(verse)
    view.loadHTMLString bible_html(verse), baseURL: NSURL.alloc.initWithString("http://biblia.com")
  end
  
  def bible_html(verse)
   %[
    <html>
    <body>
    <!-- Embedded Bible. https://biblia.com/plugins/embeddedbible -->
    <biblia:bible 
       layout="minimal" 
       resource="esv" 
       width="100%" 
       height="100%" 
       historyButtons="false" 
       navigationBox="false" 
       resourcePicker="false" 
       shareButton="false" 
       textSizeButton="false" 
       startingReference="#{verse.book_biblia_abbreviation}#{verse.chapter}.#{verse.verse}">
       </biblia:bible>
    <!-- If you’re including multiple Biblia widgets, you only need this script tag once -->
    <script src="//biblia.com/api/logos.biblia.js"></script>
    <script>logos.biblia.init();</script>
    </html>
    ]
  end
  
end