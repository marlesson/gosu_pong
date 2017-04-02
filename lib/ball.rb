require 'forwardable'

class Ball
  extend Forwardable

  def_delegators :@block, :x, :y

  def initialize
    @block        = Block.new(Block::BLOCK_SIZE, Block::BLOCK_SIZE)
    @direction_x  = 10
    @direction_y  = 2
    @pong         = false
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