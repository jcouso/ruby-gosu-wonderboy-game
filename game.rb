require 'gosu'

class MyGame < Gosu::Window
  def initialize
    super 700, 500
    self.caption = "My Little Game"

    @background_image = Gosu::Image.new("media/background.jpg", tileable: true)
    @hero = Hero.new
    @hero.wrap(250, 250)
  end

  def update
    @hero.update
  end

  def draw
    @hero.draw
    @background_image.draw(0, 0, 0, width = 0.7, heigth = 0.7)
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
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
        @vel_y = -20
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

  def move_up
    @y += 1
  end

  def draw
    @image.draw(@x, @y, 1, scale_y = 0.3, scale_x = 0.3)
  end
end

MyGame.new.show
