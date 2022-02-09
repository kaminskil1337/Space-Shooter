# frozen_string_literal: true

require 'gosu'
require_relative 'starship'
require_relative 'meteorite'

module ZOrder
  BACKGROUND, METEORITE, STARSHIP, UI = *0..3
end

class Game < Gosu::Window
  def initialize
    super 1280, 1024
    self.caption = 'Space Shooter'

    @hp = 5
    @score = 0
    @starship = StarShip.new
    @starship.warp(640, 512)
    @meteorites = []
    @game_state = 0 # 0 - game start, 1 - game, 2 - lost
    @font = Gosu::Font.new(36)
    @background_img = Gosu::Image.new('img/background.png', tileable: true)
  end

  def update
    if @game_state == 1
      @starship.turn_left if Gosu.button_down? Gosu::KB_LEFT
      @starship.turn_right if Gosu.button_down? Gosu::KB_RIGHT
      @starship.accelerate if Gosu.button_down? Gosu::KB_UP
      @starship.shoot if Gosu.button_down?(Gosu::KB_SPACE) && (@starship.trigger == false)

      @starship.move
      @starship.shot_move
      @meteorites.each { |meteorite| meteorite.move(@starship.x, @starship.y, @score) }

      @meteorites.push(Meteorite.new) if (rand(100) < 1) && (@meteorites.size < 5)

      @meteorites.each do |meteorite|
        if meteorite.check_if_hit(@starship.x, @starship.y) == true
          @hp -= 1
          @game_state = 2 if @hp <= 0
        end
        next unless @starship.bullet_check(meteorite.x, meteorite.y) == true

        meteorite.create
        @score += 1
      end
    elsif Gosu.button_down? Gosu::KB_SPACE
      @meteorites.each { |meteorite| meteorite.create }
      @starship.restart
      @score = 0
      @hp = 5
      @game_state = 1
    end
  end

  def draw
    @background_img.draw(0, 0, ZOrder::BACKGROUND)
    if @game_state == 1
      @font.draw_text("Score: #{@score}", 20, 20, 3, 1.0, 1.0, Gosu::Color::YELLOW)
      @font.draw_text("HP: #{@hp}", 1160, 20, 3, 1.0, 1.0, Gosu::Color::RED)
      @starship.draw
      @meteorites.each(&:draw)
      @starship.bullet_draw
    elsif @game_state == 2
      @font.draw_text('YOU LOST, PRESS SPACEBAR TO RESTART', 360, 500, 3, 1.0, 1.0, Gosu::Color::RED)
      @font.draw_text("YOUR SCORE: #{@score}", 500, 560, 3, 1.0, 1.0, Gosu::Color::YELLOW)
    else
      @font.draw_text('PRESS SPACEBAR TO START', 410, 500, 3, 1.0, 1.0, Gosu::Color::RED)
      @font.draw_text('USE < ^ > TO MOVE, AND SPACEBAR TO SHOOT', 290, 560, 3, 1.0, 1.0, Gosu::Color::YELLOW)
    end
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
end

Game.new.show
