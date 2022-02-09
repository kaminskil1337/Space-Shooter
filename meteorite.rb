# frozen_string_literal: true

class Meteorite
  attr_reader :x, :y

  def initialize
    @meteorite_img = Gosu::Image.new('img/meteorite.png')
    create
  end

  def create
    @startx = [rand(-100..-50), rand(1280..1330), rand(100..1100), rand(100..1100)]
    @starty = [rand(0..900), rand(0..900), rand(-100..-50), rand(1024..1074)]
    @random = rand(0..3)
    @x = @startx[@random]
    @y = @starty[@random]
    @angle = 0.0
    @vel_x = @vel_y = 0.0
  end

  def draw
    @meteorite_img.draw_rot(@x, @y, 1, @angle)
  end

  def move(starship_x, starship_y)
    @angle = Gosu.angle(@x, @y, starship_x, starship_y)
    @vel_x = Gosu.offset_x(@angle, 1)
    @vel_y = Gosu.offset_y(@angle, 1)
    @x += @vel_x
    @y += @vel_y
  end

  def check_if_hit(starship_x, starship_y)
    if ((@x - starship_x).abs < 30) && ((@y - starship_y).abs < 30)
      create
      create while ((@x - starship_x).abs < 150) && ((@y - starship_y).abs < 150)
      true
    end
  end
end
