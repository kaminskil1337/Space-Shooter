# frozen_string_literal: true

require 'gosu'
require_relative 'starship'
require_relative 'meteorite'
require_relative 'bullet'

module ZOrder
  BACKGROUND, STARSHIP, METEORITE, UI = *0..3
end

module GameState
  START, PLAY, LOST = *0..2
end

class Game < Gosu::Window
  attr_reader :objects, :starship, :score, :seconds

  def initialize
    super 1280, 1024
    self.caption = 'Space Shooter'

    @hp = 5
    @meteorites = @score = @seconds = 0
    @starship = Starship.new(self)
    @objects = []
    @objects.push(@starship)
    @game_state = GameState::START
    @font = Gosu::Font.new(36)
    @background_img = Gosu::Image.new('img/background.png', tileable: true)
    @banner_img = Gosu::Image.new('img/banner.png')
    @start_img = Gosu::Image.new('img/start.png')
  end

  def take_damage
    @hp -= 1
    @game_state = GameState::LOST if @hp <= 0
  end

  def add_score
    @score += 1
  end

  def restart
    @score = 0
    @hp = 5
    @objects.each(&:restart)
    @game_state = GameState::PLAY
  end

  def update
    if @game_state == GameState::PLAY
      @objects.each(&:update)

      if (rand(100) < 1) && (@meteorites < 5)
        @objects.push(Meteorite.new(self))
        @meteorites += 1
      end

    elsif Gosu.button_down? Gosu::KB_RETURN
      restart
    end
    @seconds += 1.0 / 60
  end

  def draw
    @background_img.draw(0, 0, ZOrder::BACKGROUND)
    case @game_state
    when GameState::PLAY
      draw_play
    when GameState::LOST
      draw_lost
    else
      draw_start
    end
  end

  def draw_play
    @objects.each(&:draw)
    @font.draw_text("Score: #{@score}", 20, 20, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw_text("HP: #{@hp}", 1160, 20, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
  end

  def draw_lost
    @font.draw_text('YOU LOST, PRESS ENTER TO RESTART', 360, 500, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
    @font.draw_text("YOUR SCORE: #{@score}", 500, 560, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
  end

  def draw_start
    @banner_img.draw(320, 180, ZOrder::UI)
    @start_img.draw(320, 450, ZOrder::UI)
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
