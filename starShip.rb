require 'gosu'

class StarShip
  attr_reader :x, :y, :trigger
  def initialize

    @x = 0
    @y = 0
    @vel_x = @vel_y = @angle = 0.0
    @spaceship_img = Gosu::Image.new("img/spaceship.png")
    @bullet_img = Gosu::Image.new("img/bullet.png")

    @trigger = false
    @bulletx = -10
    @bullety = -10
    @bulletvelx = @bulletvely = 0.0
    @bulletangle = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @vel_x += Gosu.offset_x(@angle, 0.5)
    @vel_y += Gosu.offset_y(@angle, 0.5)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 1280
    @y %= 1024

    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def shoot
    @bulletx = @x
    @bullety = @y
    @bulletangle = @angle
    @trigger = true
    self.shootMove
  end

  def shootMove
    if @trigger == true
      @bulletvelx = Gosu.offset_x(@bulletangle, 20)
      @bulletvely = Gosu.offset_y(@bulletangle, 20)
      @bulletx += @bulletvelx
      @bullety += @bulletvely
      if @bulletx < -10 or @bulletx > 1300 or @bullety < -10 or @bullety > 1050
        @trigger = false

      end
    end
  end

  def bulletCheck(meteoriteX, meteoriteY)
    if (@bulletx - meteoriteX).abs < 30 and (@bullety - meteoriteY).abs < 30
      return true
    end

  end

  def bulletDraw
    @bullet_img.draw_rot(@bulletx, @bullety, 1, @bulletangle)
  end

  def draw
    @spaceship_img.draw_rot(@x, @y, 1, @angle)
  end
end
