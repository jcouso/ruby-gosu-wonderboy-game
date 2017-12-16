require 'gosu'

class MyGame < Gosu::Window
  def initialize
    super 700, 500
    self.caption = "My Little Game"

    @background_image = Gosu::Image.new("media/background.jpg", tileable: true)
    @hero = Hero.new
    @hero.wrap(100, 250)
    @apples = []
    5.times {
      x = rand(100..500)
      y = rand(100..350)
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
  attr_reader :x, :y
  def initialize(x, y)
    @x = x
    @y = y
    @apple = Gosu::Image.new("media/apple.png")
  end

  def draw
    @apple.draw(@x, @y, 1, 0.1, 0.1)
  end
end


class Hero
  GRAVITY = 1
  FLOOR = 300
  def initialize
    @image = Gosu::Image.new("media/hero.png")
    @x = @y = @vel_y = 0.0
  end


  def update
    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
      move_left
    end

    if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
      move_right
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

  def got_apple?(apple)
    (apple.x > @x) && (apple.y > @y)
  end

  def draw
    @image.draw(@x, @y, 2, scale_y = 0.3, scale_x = 0.3)
  end
end

MyGame.new.show
