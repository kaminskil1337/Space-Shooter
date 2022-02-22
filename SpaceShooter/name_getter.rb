# frozen_string_literal: true

require 'gosu'

class NameGetter < Gosu::Window
  attr_reader :output_name

  def initialize
    super 1280, 1024
    @letters = %w[- a b c d e f g h i j k l m n o p q r s t u
                  v w x y z]
    @value = [0, 0, 0, 0, 0, 0]
    @name = [@letters[@value[0]], @letters[@value[1]], @letters[@value[2]], @letters[@value[3]], @letters[@value[4]],
             @letters[@value[5]]]
    @indicator = 0
    @seconds = @second_pressed = 0
    @output_name = ''
    @font_m = Gosu::Font.new(64, name: 'SpaceShooter/fonts/ice_pixel-7.ttf')
  end

  def indicator_left
    @second_pressed = @seconds
    @indicator -= 1
    @indicator %= 6
  end

  def indicator_right
    @second_pressed = @seconds
    @indicator += 1
    @indicator %= 6
  end

  def letter_up
    @second_pressed = @seconds
    @value[@indicator] += 1
    @value[@indicator] %= 27
    @name[@indicator] = @letters[@value[@indicator]]
  end

  def letter_down
    @second_pressed = @seconds
    @value[@indicator] -= 1
    @value[@indicator] %= 27
    @name[@indicator] = @letters[@value[@indicator]]
  end

  def print
    @second_pressed = @seconds
  end

  def update
    @seconds += 1.0 / 60
    @output_name = @name[0] + @name[1] + @name[2] + @name[3] + @name[4] + @name[5]
    if @seconds - @second_pressed > 0.2
      indicator_left if Gosu.button_down? Gosu::KB_LEFT
      indicator_right if Gosu.button_down? Gosu::KB_RIGHT
      letter_up if Gosu.button_down? Gosu::KB_UP
      letter_down if Gosu.button_down? Gosu::KB_DOWN
      print if Gosu.button_down? Gosu::KB_RETURN

    end
  end

  def draw
    @font_m.draw_text("YOUR NAME: #{@output_name}", 415, 700, 1, 1.0, 1.0, Gosu::Color::YELLOW)
    @font_m.draw_text('^', 700 + (@indicator * 29), 740, 1, 1.0, 1.0, Gosu::Color::RED)
  end
end
