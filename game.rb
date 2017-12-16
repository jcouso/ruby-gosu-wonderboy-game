require 'gosu'

class MyGame < Gosu::Window
  def initialize
    super 700, 500
    self.caption = "My Little Game"
    @background = [Background.new, Background.new(890)]
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
    @apples.each do |apple|
      if @hero.got_apple?(apple)
        @apples.delete(apple)
      end
    end
  end

  def draw
    @apples.each { |apple| apple.draw }
    @hero.draw
    puts @background[0].width
    if @hero.end?
      @background[0].x -= 6
      @background[1].x -= 6
    end
      @background[0].draw
      @background[1].draw
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
end

class Background
  attr_accessor :x
  def initialize(x=0)
    @y = 0
    @x = x
    @img = Gosu::Image.new("media/background.jpg", tileable: true)
  end

  def draw
    @img.draw(@x, 0, 0, 0.7, 0.7)
  end

  def width
    @img.width
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
  attr_reader :x, :y
  GRAVITY = 1
  FLOOR = 330
  def initialize
    @hero_walking = Gosu::Image.load_tiles("media/hero-animation.png", 110, 120)
    @hero_stading = Gosu::Image.new("media/hero_standing.png")
    #@image = Gosu::Image.new("media/hero.png")
    @x = @y = @vel_y = 0.0
    @walking = false
    @right = true
  end


  def update
    #puts @x
    @walking = false
    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
      @right = false
      @walking = true
      move_left
    end

    if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
      @walking = true
      @right = true
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
    if @x > 0
      @x -= 6
    end
  end

  def move_right
    if @x < 310
      @x += 6
    end
  end

  def end?
    @x == 310 && @walking
  end

  def width
    100
  end

  def height
    210
  end

  def got_apple?(apple)
    (@x + width) > apple.x && @x < (apple.x + apple.width) &&
    (@y + height) > apple.y && @y < (apple.y + apple.height)
  end

  def draw

    if !@walking
      if @right
        @hero_stading.draw(@x, @y, 2, 0.45, 0.45)
      else
        @hero_stading.draw(@x + 100 , @y, 2, -0.45, 0.45)
      end
    else
      img = @hero_walking[Gosu.milliseconds / 100 % @hero_walking.size]
      if @right
        #@image.draw(@x, @y, 2, 0.3, 0.3)
        img.draw(@x, @y, 2, 0.9, 0.9)
      else
        img.draw(@x + 100, @y, 2, -0.9, 0.9)
      end
    end
  end
end

MyGame.new.show
