require 'gosu'
require 'forwardable'

class Ball
  extend Forwardable

  def_delegators :@block, :x, :y

  def initialize
    @block = Block.new(Block::BLOCK_SIZE, Block::BLOCK_SIZE)
    @direction_x = 10
    @direction_y = 2
    @pong = false
  end

  def draw
    @block.draw
  end

  def move(paddle)
    @block.x += @direction_x
    @block.y += @direction_y

    if @block.x >= GameWindow.limit_right
      @direction_x = @direction_x * -1
    elsif paddle.collision?(self)
      @direction_x = @direction_x * -1
      @direction_y += paddle.collision_rate(self)
    elsif @block.y <= GameWindow.limit_top
      @direction_y = @direction_y * -1
    elsif @block.y >= GameWindow.limit_botton
      @direction_y = @direction_y * -1
    end
  end

  def pong?
    @block.x >= GameWindow.limit_right
  end
end

class Block
  BLOCK_SIZE = 16

  attr_accessor :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end

  def self.sprite=(sprite)
    @@sprite = sprite
  end

  def draw
    @@sprite.draw(x,y,0)
  end

  def collision?(block)
    block.x >= self.x and 
    block.x <= self.x + BLOCK_SIZE and
    block.y >= self.y and 
    block.y <= self.y + BLOCK_SIZE 
  end
end


class Paddle

  def initialize()
    @blocks = []

    @blocks << Block.new(Block::BLOCK_SIZE, GameWindow::HEIGHT/2 + (0 * Block::BLOCK_SIZE))
    @blocks << Block.new(Block::BLOCK_SIZE, GameWindow::HEIGHT/2 + (1 * Block::BLOCK_SIZE))
    @blocks << Block.new(Block::BLOCK_SIZE, GameWindow::HEIGHT/2 + (2 * Block::BLOCK_SIZE))
    @blocks << Block.new(Block::BLOCK_SIZE, GameWindow::HEIGHT/2 + (3 * Block::BLOCK_SIZE))
    @blocks << Block.new(Block::BLOCK_SIZE, GameWindow::HEIGHT/2 + (4 * Block::BLOCK_SIZE))

  end

  def up
    return if @blocks.first.y <= GameWindow.limit_top
    
    @blocks.map{|b| b.y -= Block::BLOCK_SIZE }
  end

  def down
    return if @blocks.last.y >= GameWindow.limit_botton

    @blocks.map{|b| b.y += Block::BLOCK_SIZE }
  end

  def draw
    @blocks.each(&:draw)
  end

  def collision?(ball)
    @blocks.any?{|b| b.collision? ball}
  end

  def collision_rate(ball)
    rates = [ -2, -1, 0, 1, 2 ]

    index = @blocks.index{|b| b.collision? ball}
    
    rates[index] unless index.nil?
  end
end

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

gwindow = GameWindow.new
gwindow.show
