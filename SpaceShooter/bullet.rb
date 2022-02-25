# frozen_string_literal: true

class Bullet
  def initialize(game)
    @game = game
    @x = @y = 100
    @vel_x = @vel_y = @angle = 0.0
    @bullet_img = Gosu::Image.new('img/bullet.png')
    shoot
  end

  def restart
    @x = @y = -20
    @vel_x = @vel_y = @angle = 0.0
  end

  def shoot
    @x = @game.starship.x
    @y = @game.starship.y
    @angle = @game.starship.angle
  end

  def update
    move
    check_if_hit
    @game.objects.delete(self) if marked_for_delete
  end

  def check_if_hit
    @meteorites = @game.objects.select { |c| c.is_a?(Meteorite) }
    @meteorites.each do |meteorite|
      if ((@x - meteorite.x).abs < 30) && ((@y - meteorite.y).abs < 30)
        meteorite.create
        @game.add_score
      end
    end
  end

  def marked_for_delete
    true if (@x < -200) || (@x > 1500) || (@y < -200) || (@y > 1250)
  end

  def move
    @vel_x = Gosu.offset_x(@angle, 20)
    @vel_y = Gosu.offset_y(@angle, 20)
    @x += @vel_x
    @y += @vel_y
  end

  def draw
    @bullet_img.draw_rot(@x, @y, 1, @angle)
  end
end
