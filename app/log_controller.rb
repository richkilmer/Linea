class LogController < UIViewController

  include CocoaMotion::ViewControllerBehaviors
  
  attr_accessor :session
  
  def viewDidLoad
    super
    view.backgroundColor = color(:white)
    nav title:"Session"
  end

  def loadView
    self.view = UIWebView.alloc.init
    view.delegate = self
  end
  
  def viewWillAppear(animated)
    super
    nav.title = session.name
    nav.apply!
    updateLog!
  end
  
  def webView(webView, shouldStartLoadWithRequest:request, navigationType:navType)
    true
  end
  
  def updateLog!
    view.loadHTMLString log_html, baseURL: NSBundle.mainBundle.bundleURL
  end
  
  def log_event_html(event)
    book = nil
    chapter = nil
    event_html = []
    event.verses.each do |verse|
      if verse.book != book
        event_html << "<span class='book'>#{verse.book}</span>"
        book = verse.book
      end
      if verse.chapter != chapter
        event_html << "<span class='chapter-break'><span>"
        event_html << "<span class='chapter'>#{verse.chapter}</span>"
        chapter = verse.chapter
      end
      event_html << "<span class='verse'><sup>#{verse.verse}</sup>#{verse.text}</span>"
    end
    event_html.join
  end
  
  def log_html
    log_entries = []
    session.events.each do |event|
      log_entries << %[
        <div class="log-entry">
          #{log_event_html(event)}
        </div>
      ]
    end
   %[
    <html>
    <head>
    <style>
      body {
        font-family: "Avenir Light"
      }
      sup {
        font-weight: bold;
        font-size: 10px;
        padding-right: 2px;
      }
      span.verse {
        margin-right: 10px;
      }
      span.book {
        clear: right;
        display: block;
        font-size: 20px;
        color: #3498db;
        font-weight: bold;
        padding-top: 10px;
        margin-bottom: 10px;
        font-style: italic;
      }
      span.chapter-break {
        display: block;
      }
      span.chapter {
        float: left; 
        color: #2980b9; 
        font-size: 50px; 
        line-height: 40px; 
        padding-top: 4px; 
        padding-right: 8px; 
        padding-left: 3px; 
      }
      div.log-entry {
        clear: left;
        padding-bottom: 10px;
      }
    </style>
    </head>
    <body style="margin:10px;">
      #{log_entries.join("\n")}
    </html>
    ]
  end
  
end