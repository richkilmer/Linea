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
    event.verses.collect do |verse|
      "<span class='verse'><sup>#{verse.verse}</sup>#{verse.text}</span>"
    end
  end
  
  def log_html
    log_entries = []
    session.events.each do |event|
      log_entries << %[
        <div class="log-entry">
          <p>#{event.opened_at}</p>
          <hr>
          <p>#{log_event_html(event).join}</p>
        </div>
      ]
    end
   %[
    <html>
    <head>
    <basefont face="Avenir-Light">
    <style>
      sup {
        font-weight: bold;
      }
      span.verse {
        margin-right: 10px;
      }
      div.log-entry {
        margin: 10px;
      }
    </style>
    </head>
    <body style="margin:0px;">
      #{log_entries.join("\n")}
    </html>
    ]
  end
  
end