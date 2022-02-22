# frozen_string_literal: true

class Starship
  attr_reader :x, :y, :angle

  def initialize(game)
    @game = game
    create
  end

  def create
    @x = 640
    @y = 512
    @previous_shot_second = 0
    @vel_x = @vel_y = @angle = 0.0
    @spaceship_img = Gosu::Image.new('img/spaceship.png')
    @bullet_img = Gosu::Image.new('img/bullet.png')
  end

  def restart
    @x = 640
    @y = 512
    @vel_x = @vel_y = @angle = 0.0
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
    @game.objects.push(Bullet.new(@game))
  end

  def update
    turn_left if Gosu.button_down? Gosu::KB_LEFT
    turn_right if Gosu.button_down? Gosu::KB_RIGHT
    accelerate if Gosu.button_down? Gosu::KB_UP
    if Gosu.button_down?(Gosu::KB_SPACE)
      @shot_second = @game.seconds
      if @shot_second - @previous_shot_second > 0.2
        shoot
        @previous_shot_second = @shot_second
      end
    end
    move
  end

  def draw
    @spaceship_img.draw_rot(@x, @y, 1, @angle)
  end
end
