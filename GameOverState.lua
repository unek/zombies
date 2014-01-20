gameover = {}

function gameover:draw()
    local text = "You died"
    local font = game.assets:getFont("Roboto-Black")[44]
    local w, h = love.graphics.getDimensions()
    local x, y = (w - font:getWidth(text)) / 2, (h - font:getHeight()) / 2

    love.graphics.setFont(font)
    love.graphics.setColor(255, 101, 30)
    love.graphics.print(text, x, y)
end
