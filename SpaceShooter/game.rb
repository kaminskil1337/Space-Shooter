# frozen_string_literal: true

require 'gosu'
require_relative 'starship'
require_relative 'meteorite'
require_relative 'bullet'
require_relative 'score_manager'
require_relative 'name_getter'

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
    self.caption = 'SpaceShooter'
    initialize_assets
    set_start_parameters
    @starship = Starship.new(self)
    @name_getter = NameGetter.new
    @objects.push(@starship)
    @game_state = GameState::START
  end

  def set_start_parameters
    @score_manager = ScoreManager.new
    # initialize_high_score
    @objects = []
    @hp = 5
    @meteorites = @score = @seconds = 0
  end

  def initialize_assets
    @font_s = Gosu::Font.new(32, name: 'fonts/ice_pixel-7.ttf')
    @font_m = Gosu::Font.new(64, name: 'fonts/ice_pixel-7.ttf')
    @font_l = Gosu::Font.new(100, name: 'fonts/ice_pixel-7.ttf')
    @background_img = Gosu::Image.new('./img/background.png')
  end

  def take_damage
    @hp -= 1
    @game_state = GameState::LOST if @hp <= 0
  end

  def add_score
    @score += 1
  end

  def restart
    @player_name = @name_getter.output_name
    @score_manager.send_score(@score, @player_name)
    @player_name = ''
    @score = 0
    @hp = 5
    @objects.each(&:restart)
    @game_state = GameState::PLAY
  end

  def update
    case @game_state
    when GameState::PLAY
      @objects.each(&:update)
      if (rand(100) < 1) && (@meteorites < 5)
        @objects.push(Meteorite.new(self))
        @meteorites += 1
      end
    when GameState::START
      @game_state = GameState::PLAY if Gosu.button_down? Gosu::KB_RETURN
    else
      @name_getter.update
      restart if Gosu.button_down? Gosu::KB_RETURN
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
    @font_m.draw_text("SCORE: #{@score}", 20, 20, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font_m.draw_text("HP: #{@hp}", 1140, 20, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
  end

  def draw_high_score
    @font_m.draw_text('LEADERBOARD: ', 490, 620, 1, 1.0, 1.0, Gosu::Color::RED)
    (0..2).each do |a|
      @font_m.draw_text("#{a + 1}. #{@score_manager.high_scores[a]['name']} - #{@score_manager.high_scores[a]['score']}", 465, 720 + (a * 60), 1, 1.0, 1.0,
                        Gosu::Color::RED)
    end
  end

  def draw_lost
    @font_m.draw_text('YOU LOST, PRESS ENTER TO RESTART', 225, 500, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
    @font_m.draw_text("YOUR SCORE: #{@score}", 475, 600, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @name_getter.draw
  end

  def draw_start
    @font_l.draw_text('SPACE SHOOTER', 385, 180, ZOrder::UI, 1.0, 1.0, Gosu::Color::FUCHSIA)
    @font_m.draw_text('PRESS ENTER TO START', 380, 400, 3, 1.0, 1.0, Gosu::Color::YELLOW)
    @font_m.draw_text('USE ARROW KEYS TO MOVE', 350, 460, 3, 1.0, 1.0, Gosu::Color::YELLOW)
    @font_m.draw_text('USE SPACEBAR TO SHOOT', 370, 520, 3, 1.0, 1.0, Gosu::Color::YELLOW)
    draw_high_score
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
