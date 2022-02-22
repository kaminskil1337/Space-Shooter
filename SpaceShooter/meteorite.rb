# frozen_string_literal: true

class Meteorite
  attr_reader :x, :y

  def initialize(game)
    @game = game
    @meteorite_img = Gosu::Image.new('SpaceShooter/img/meteorite.png')
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

  def restart
    create
  end

  def move(starship_x, starship_y, score)
    @angle = Gosu.angle(@x, @y, starship_x, starship_y)
    @vel_x = Gosu.offset_x(@angle, 1.0 + score.to_f / 20)
    @vel_y = Gosu.offset_y(@angle, 1.0 + score.to_f / 20)
    @x += @vel_x
    @y += @vel_y
  end

  def check_if_hit(starship_x, starship_y)
    if ((@x - starship_x).abs < 30) && ((@y - starship_y).abs < 30)
      create
      create while ((@x - starship_x).abs < 150) && ((@y - starship_y).abs < 150)
      @game.take_damage
    end
  end

  def update
    move(@game.starship.x, @game.starship.y, @game.score)
    check_if_hit(@game.starship.x, @game.starship.y)
  end

  def draw
    @meteorite_img.draw_rot(@x, @y, 3, @angle)
  end
end
