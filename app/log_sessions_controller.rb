class LogSessionsController < UITableViewController

  include CocoaMotion::ViewControllerBehaviors

  def viewDidLoad
    super
    nav title: "Session History"
  end

  def viewWillAppear(animated)
    super
    navigationItem.rightBarButtonItem = editButtonItem
    nav.apply!
  end
  
  def log_sessions
    @log_sessions ||= LogSession.list
  end

  def log_controller
    @log_controller ||= LogController.new
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    if editingStyle == UITableViewCellEditingStyleDelete
      session = log_sessions[indexPath.row]
      log_sessions.delete session
      session.remove
      view.deleteRowsAtIndexPaths [indexPath], withRowAnimation:UITableViewRowAnimationFade
    end
  end

  def tableView(tableView, numberOfRowsInSection: section)
    log_sessions.length
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "LOG_SESSION_CELL"
    
    cell = view.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    if cell.nil?
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:@reuseIdentifier)
    end

    session = log_sessions[indexPath.row]
    
    cell.textLabel.text = session.name
    
    count = session.events_count
    cell.detailTextLabel.text = if count == 0
      "No Verses Referenced"
    elsif count == 1
      "1 Verse Referenced"
    else
      "#{count} Verses Referenced"
    end
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    view.deselectRowAtIndexPath(indexPath, animated: false)
    log_controller.session = log_sessions[indexPath.row]
    nav.push log_controller
  end

end