require 'gosu'
require 'forwardable'

require './lib/block'
require './lib/ball'
require './lib/paddle'

class GameWindow < Gosu::Window

  WIDTH   = 800
  HEIGHT  = 600

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = 'Pong!'

    
    @font         = Gosu::Font.new(self, Gosu::default_font_name, 50)
    @font_score   = Gosu::Font.new(self, Gosu::default_font_name, 20)

    Block.sprite  = Gosu::Image.new(self, "images/pixel.png", true)

    @score        = 0 
    @paddle       = Paddle.new
    @ball         = Ball.new
  end

  def update

    if button_down? Gosu::KbEnter or button_down?Gosu::KbReturn or button_down? Gosu::GpButton9
      self.reset_play
    end  

    return if game_over?

    if button_down? Gosu::KbUp
      @paddle.up
    elsif button_down? Gosu::KbDown
      @paddle.down
    end

    @ball.move(@paddle)

    if @ball.pong?
      @score += 1
    end
  end

  def draw
    if game_over?
      @font.draw_rel("GAME OVER!", 400, 300, 5, 0.5, 0.5)
    else
      @ball.draw
      @paddle.draw
    end

    @font_score.draw_rel("SCORE: #{@score}", 40, 15, 5, 0.5, 0.5)
  end

  def game_over?
    @ball.x <= 0
  end

  def reset_play
    @score   = 0 
    @paddle  = Paddle.new
    @ball    = Ball.new    
  end

  #Limits

  def self.limit_left 
    0 
  end

  def self.limit_top  
    0 
  end 

  def self.limit_botton 
    GameWindow::HEIGHT - Block::BLOCK_SIZE 
  end

  def self.limit_right 
    GameWindow::WIDTH - Block::BLOCK_SIZE 
  end
end