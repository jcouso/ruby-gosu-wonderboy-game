require 'gosu'

class MyGame < Gosu::Window
  def initialize
    super 700, 500
    self.caption = "My Little Game"

    @background_image = Gosu::Image.new("media/background.jpg", tileable: true)
    @hero = Hero.new
    @hero.wrap(100, 350)
    @apples = []
    5.times {
      x = rand(300..400)
      y = rand(200..350)
      @apples << Apple.new(x,y)
    }
  end

  def update
    @hero.update
    #puts @apples[0]
    @apples.each do |apple|
      if @hero.got_apple?(apple)
        @apples.delete(apple)
      end
    end
  end

  def draw
    @apples.each { |apple| apple.draw }
    @hero.draw
    @background_image.draw(0, 0, 0, 0.7, 0.7)
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
end


class Apple
  attr_reader :x, :y, :width
  def initialize(x, y)
    @x = x
    @y = y
    @apple = Gosu::Image.new("media/apple.png")
  end

  def draw
    @apple.draw(@x, @y, 1, 0.1, 0.1)
  end

  def width
    @apple.width * 0.08
  end

  def height
    @apple.height * 0.08
  end
end


class Hero
  GRAVITY = 1
  FLOOR = 330
  def initialize
    @image = Gosu::Image.new("media/hero.png")
    @x = @y = @vel_y = 0.0
    @right = true
  end


  def update
    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
      @right = false
      move_left
    end

    if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
      move_right
      @right = true
    end

    if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
      if @jump == false
        @vel_y = -15
        @jump = true
      end
    end

    @y += @vel_y
    @vel_y += GRAVITY if @y != FLOOR

    if @y > FLOOR
      @vel_y = 0
      @y = FLOOR
      @jump = false
    end

  end

  def wrap(x, y)
    @x, @y = x, y
  end

  def move_left
    @x -= 6

  end

  def move_right
    @x += 6
  end

  def width
    @image.width * 0.25
  end

  def height
    @image.height * 0.25
  end

  def got_apple?(apple)
    puts "apple X: #{ apple.x }"
    puts "apple Y: #{ apple.y }"
    puts "hero X: #{ @x }"
    puts "hero Y: #{ @y }"
    puts apple.width
    (@x + width) > apple.x && @x < (apple.x + apple.width) &&
    (@y + height) > apple.y && @y < (apple.y + apple.height)
  end

  def draw
    if @right
      @image.draw(@x, @y, 2, 0.3, 0.3)
    else
      @image.draw(@x + 100, @y, 2, -0.3, 0.3)
    end
  end
end

MyGame.new.show
