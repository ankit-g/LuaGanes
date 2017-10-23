local yellow = {255, 255, 0, 255}
local one = {255, 0, 255, 255}
local two = {0, 255, 255, 255}
local red = {255, 0, 0, 255}
local green = {0, 255, 0, 255}
local blue  = {0, 0, 255, 255}
local white = {255, 255, 255, 255}
--not adding white (looks ugly)
local colors = {red, yellow, blue, green, one, two}
local tbl_clr = {}

function love.load(arg)
  for i = 1, 300 do
    tbl_clr[i] = math.random(1, #colors)
  end
end

local function draw_circle_line(x,y, line_number)
    local radius = 20
    local strokes = 100
    for i = 1, 20 do
        love.graphics.setColor(unpack(colors[tbl_clr[i*line_number]]))
        love.graphics.circle('fill', x, y, radius, strokes)
        x = x + 40
    end
end

function love.draw()
  local x, y, radius, strokes = 20, 20, 20, 100
  for i = 1, 15 do
    draw_circle_line(x, y, i)
    y = y + 40
  end
end
