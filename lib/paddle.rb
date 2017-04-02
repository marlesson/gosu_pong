
class Paddle
  MOVE = 10

  def initialize()
    @blocks = []

    @blocks << Block.new(Block::BLOCK_SIZE, GameWindow::HEIGHT/2 + (0 * Block::BLOCK_SIZE))
    @blocks << Block.new(Block::BLOCK_SIZE, GameWindow::HEIGHT/2 + (1 * Block::BLOCK_SIZE))
    @blocks << Block.new(Block::BLOCK_SIZE, GameWindow::HEIGHT/2 + (2 * Block::BLOCK_SIZE))
    @blocks << Block.new(Block::BLOCK_SIZE, GameWindow::HEIGHT/2 + (3 * Block::BLOCK_SIZE))
    @blocks << Block.new(Block::BLOCK_SIZE, GameWindow::HEIGHT/2 + (4 * Block::BLOCK_SIZE))

  end

  def draw
    @blocks.each(&:draw)
  end
  
  def up
    return if @blocks.first.y <= GameWindow.limit_top
    
    @blocks.map{|b| b.y -= MOVE }
  end

  def down
    return if @blocks.last.y >= GameWindow.limit_botton

    @blocks.map{|b| b.y += MOVE }
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