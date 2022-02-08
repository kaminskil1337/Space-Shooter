require 'gosu'
require_relative 'starShip'
require_relative 'meteorite'

module ZOrder
  BACKGROUND, METEORITE, STARSHIP, UI = *0..3
end

class Game < Gosu::Window
  def initialize
    super 1280, 1024
    self.caption = "Space Shooter"

    @hp = 5
    @score = 0
    @starShip = StarShip.new
    @starShip.warp(640,512)
    @meteorites = Array.new

    @font = Gosu::Font.new(24)
    @background_img = Gosu::Image.new("img/background.png", :tileable => true)
  end

  def update
    if Gosu.button_down? Gosu::KB_LEFT
      @starShip.turn_left
    end
    if Gosu.button_down? Gosu::KB_RIGHT
      @starShip.turn_right
    end
    if Gosu.button_down? Gosu::KB_UP
      @starShip.accelerate
    end
    if Gosu.button_down? Gosu::KB_SPACE
      if @starShip.trigger == false
        @starShip.shoot
      end
    end

    @starShip.move
    @starShip.shootMove
    @meteorites.each { |meteorite| meteorite.move(@starShip.x,@starShip.y) }

    if rand(100) < 1 and @meteorites.size < 5
      @meteorites.push(Meteorite.new())
    end

    @meteorites.each do |meteorite|
      if meteorite.check(@starShip.x, @starShip.y) == true
        @hp -= 1
        if @hp <= 0
          puts "pprzegrales"
          @lost = true
        end
      end
      if @starShip.bulletCheck(meteorite.x, meteorite.y) == true
        meteorite.create
        @score += 1
        puts @score
      end
    end


  end

  def draw
    @font.draw_text("Score: #{@score}",20,20,3,1.0,1.0,Gosu::Color::YELLOW)
    @font.draw_text("HP: #{@hp}",1200, 20,3,1.0,1.0,Gosu::Color::RED)
    @starShip.draw
    @background_img.draw(0,0,ZOrder::BACKGROUND)
    @meteorites.each { |meteorite| meteorite.draw }
    @starShip.bulletDraw
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