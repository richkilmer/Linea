CocoaMotion::Theme.define do

  CargoSenseColors.apply!

  # The Fonts
  # -------------------------------------------------------------------
  
  font  :base, 'Avenir-Light', (ipad? ? 18 : 12)
  font  :book, 'Avenir-Book', (ipad? ? 18 : 12)
  font  :italic, 'Avenir-LightOblique', (ipad? ? 18 : 12)
  font  :bold, 'Avenir-Heavy', (ipad? ? 18 : 12)
  font  :black, 'Avenir-Black', (ipad? ? 18 : 12)
  
  font  :button, :base, (ipad? ? 24 : 20)
  font  :button_bold, :bold, (ipad? ? 24 : 20)
  font  :button_black, :black, (ipad? ? 24 : 20)
  
  # Buttons
  # -------------------------------------------------------------------
  
  color :button, :turquoise
  color :button_disabled, :gray
  color :button_header, '23272B'
  
  color :activity_background, opacify(:black, 0.4)

  style :button, 
        title_color: color(:white),
        font: font(:button),
        background_color: color(:button),
        corner_radius:4,
        tint_color: color(:white)
        
  style :danger_button,
        background_color: color(:red)
        
  style :home_button,
        font: font(:button, ipad? ? 34 : 20),
        multiline:true

  # Other controls
  # -------------------------------------------------------------------
  
  style :label,
        font: font(:base),
        color: color(:white)
        
  style :text_field,
        text_color: color(:gray_darkest),
        clear_button: :while_editing,
        padding: 10,
        return_key: :done,
        background_color: color(:white),
        border_style: :none,
        ipad:{
          font: font(:base, 30),
          corner_radius: 4
        },
        iphone:{
          font: font(:base, 17)
        }
        
  style :navigation_controller,
        bar_tint_color: color(:black), 
        bar_text_tint_color: color(:white)
        
  style :activity_indicator,
        style: :large,
        hides_when_stopped: true

  style :scroll_view,
      shows_horizontal_scroll_indicator:false,
      shows_vertical_scroll_indicator:true,
      user_interaction_enabled:true,
      exclusive_touch:true
  
end