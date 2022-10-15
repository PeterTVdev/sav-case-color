local Game = {}

lst_ennemy = {}

SAUVEGARDE.score = 0
SAUVEGARDE.life = 3 
SAUVEGARDE.directionColor = "red"

local hero = {}
hero.img = nil
hero.x = nil
hero.y = nil
hero.dim = nil

local function createEnnemy(pX,pY,pColor)
  local e = {}
  
  e.x = pX
  e.y = pY
  e.dim = 25
  e.color = pColor
  
  table.insert(lst_ennemy, e)
end

function Game.load()
  hero.x = largeur_ecran/2
  hero.y = hauteur_ecran/2
  hero.dim = 25
  
  
  createEnnemy(200,200,"green")
end

function Game.update(dt)
  --verifie si ça collide
  for k,v in ipairs(lst_ennemy) do
    if CheckCollision(hero.x,hero.y,25,25, v.x,v.y,25,25) then
      if SAUVEGARDE.directionColor ~= v.color then
        SAUVEGARDE.life = SAUVEGARDE.life - dt
      else
        SAUVEGARDE.life = SAUVEGARDE.life + dt
        SAUVEGARDE.score = SAUVEGARDE.score + dt
      end
    end
  end
  
  if love.keyboard.isDown("right") then
    SAUVEGARDE.directionColor = "red" 
    hero.x = hero.x + 150*dt
  elseif love.keyboard.isDown("down") then
    SAUVEGARDE.directionColor = "blue"
    hero.y = hero.y + 150*dt
  elseif love.keyboard.isDown("left") then
    SAUVEGARDE.directionColor = "yellow"
    hero.x = hero.x - 150*dt
  elseif love.keyboard.isDown("up") then
    SAUVEGARDE.directionColor = "green"
    hero.y = hero.y - 150*dt
  end
end

function Game.draw()
  --gui
  love.graphics.print("score : "..SAUVEGARDE.score)
  love.graphics.print("life : "..SAUVEGARDE.life, 0, 15)
  love.graphics.print("pour save appuie sur S", 0, 30)
  
  --gameplay
  hero.img = love.graphics.rectangle("fill", hero.x, hero.y, hero.dim, hero.dim)
  
  for k,v in ipairs(lst_ennemy) do
    love.graphics.rectangle("line", v.x, v.y, v.dim, v.dim)
  end
end

function Game.keypressed(key)
  if key == "s" then
    mJSON = myJSON.encode(SAUVEGARDE)
    local file = love.filesystem.newFile("game.json")
    file:open("w")
    file:write(mJSON)
    file:close()
  end
end

return Game