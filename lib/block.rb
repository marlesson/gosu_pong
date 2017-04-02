
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
    #(self.x + BLOCK_SIZE)
    block.x >= self.x - BLOCK_SIZE and 
    block.x <= self.x + BLOCK_SIZE and
    block.y >= self.y - BLOCK_SIZE and 
    block.y <= self.y + BLOCK_SIZE 
  end
end