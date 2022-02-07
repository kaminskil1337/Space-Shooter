require 'gosu'

class Game < Gosu::Window
  def initialize
    super 1280, 1024
    self.caption = "Space Shooter"

    @background_img = Gosu::Image.new("img/background.png", :tileable => true)
  end

  def update
    # ...
  end

  def draw
    @background_img.draw(0,0,0)
  end

end

Game.new.show