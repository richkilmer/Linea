CocoaMotion::Theme.define do

  CargoSenseColors.apply!
  
  color :turquoise, '1abc9c'
  color :emerald, '16a085'
  color :peter_river, '3498db'
  color :belize_hole, '2980b9'

  # The Fonts
  # -------------------------------------------------------------------
  
  font  :base, 'Avenir-Light', (ipad? ? 18 : 12)
  font  :book, 'Avenir-Book', (ipad? ? 18 : 12)
  font  :italic, 'Avenir-LightOblique', (ipad? ? 18 : 12)
  font  :bold, 'Avenir-Heavy', (ipad? ? 18 : 12)
  font  :black, 'Avenir-Black', (ipad? ? 18 : 12)
  
  font  :verse_reference, :base, 14
  
  font  :button, :base, (ipad? ? 24 : 20)
  font  :button_bold, :bold, (ipad? ? 24 : 20)
  font  :button_black, :black, (ipad? ? 24 : 20)
  
  # Buttons
  # -------------------------------------------------------------------
  
  color :button, :peter_river
  color :button_disabled, :gray
  color :button_header, '23272B'
  
  color :verse_reference, :belize_hole
  
  color :activity_background, opacify(:black, 0.4)
  
  color :disabled_view, opacify(:white, 0.6)

  style :button, 
        title_color: color(:belize_hole),
        font: font(:button),
        tint_color: color(:white)
        
  # Other controls
  # -------------------------------------------------------------------
  
  style :label,
        font: font(:base),
        color: color(:gray_darkest)
        
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
        bar_tint_color: color(:white), 
        bar_text_tint_color: color(:black)
        
  style :activity_indicator,
        style: :large,
        hides_when_stopped: true

  style :scroll_view,
      shows_horizontal_scroll_indicator:false,
      shows_vertical_scroll_indicator:true,
      user_interaction_enabled:true,
      exclusive_touch:true
  
end