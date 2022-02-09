# frozen_string_literal: true

require 'gosu'

class StarShip
  attr_reader :x, :y, :trigger

  def initialize
    @x = 0
    @y = 0
    @vel_x = @vel_y = @angle = 0.0
    @spaceship_img = Gosu::Image.new('img/spaceship.png')
    @bullet_img = Gosu::Image.new('img/bullet.png')

    @trigger = false
    @bulletx = -10
    @bullety = -10
    @bulletvelx = @bulletvely = 0.0
    @bulletangle = 0
  end

  def restart
    warp(640, 512)
    @vel_x = @vel_y = @angle = 0.0
  end

  def warp(x, y)
    @x = x
    @y = y
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
    shot_move
  end

  def shot_move
    if @trigger == true
      @bulletvelx = Gosu.offset_x(@bulletangle, 40)
      @bulletvely = Gosu.offset_y(@bulletangle, 40)
      @bulletx += @bulletvelx
      @bullety += @bulletvely
      @trigger = false if (@bulletx < -10) || (@bulletx > 1300) || (@bullety < -10) || (@bullety > 1050)
    end
  end

  def bullet_check(meteorite_x, meteorite_y)
    return true if ((@bulletx - meteorite_x).abs < 30) && ((@bullety - meteorite_y).abs < 30)
  end

  def bullet_draw
    @bullet_img.draw_rot(@bulletx, @bullety, 1, @bulletangle)
  end

  def draw
    @spaceship_img.draw_rot(@x, @y, 1, @angle)
  end
end
