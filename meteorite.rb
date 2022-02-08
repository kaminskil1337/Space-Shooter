class Meteorite
  attr_reader :x, :y

  def initialize
    @meteorite_img = Gosu::Image.new("img/meteorite.png")
    self.create
  end

  def create
    @startx = [rand(0..100), rand(1100..1200), rand(100..1100), rand(100..1100)]
    @starty = [rand(0..900),rand(0..900), rand(0..100), rand(900..1000)]
    @random = rand(0..3)
    @x = @startx[@random]
    @y = @starty[@random]
    @angle = 0.0
    @vel_x = @vel_y = 0.0
  end

  def draw
    @meteorite_img.draw_rot(@x, @y, 1, @angle)
  end

  def move(starShipX, starShipY)
    @angle = Gosu.angle(@x, @y, starShipX, starShipY)
    @vel_x = Gosu.offset_x(@angle, 1)
    @vel_y = Gosu.offset_y(@angle, 1)
    @x += @vel_x
    @y += @vel_y
  end

  def check(starShipX, starShipY)
    if (@x - starShipX).abs < 30 and (@y - starShipY).abs < 30
      self.create
      return true
      while  (@x - starShipX).abs < 150 and (@y - starShipY).abs < 150
        self.create
      end
    end
  end
end