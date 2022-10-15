-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

SAUVEGARDE = {}

local lst_buttons = {}

myJSON = require("json")

Game = require("game")

gameState = "menu"

local function createButtons(pX,pY,pText,pID)
  local v = {}
  
  v.x = pX
  v.y = pY
  v.l = 200
  v.h = 50
  v.text = pText
  v.ID = pID
  
  table.insert(lst_buttons,v)
end

function love.load()
  
  largeur_ecran = love.graphics.getWidth()
  hauteur_ecran = love.graphics.getHeight()
  
  createButtons(15, 100, "New Partie", "NP")
  createButtons(15, 200, "Load Partie", "LP")
  
  Game.load()
  
end

local function Menu_update(dt)
  
end

function love.update(dt)
  if gameState == "menu" then
    Menu_update(dt)
  elseif gameState == "game" then
    Game.update(dt)
  end
end

local function Menu_draw()
  local title = "sav case color"
  love.graphics.print(title, (largeur_ecran/2)-50, 10)
  
  for k,v in ipairs(lst_buttons) do 
    love.graphics.rectangle("line", v.x, v.y, v.l, v.h)
    love.graphics.print(v.text, v.x, v.y)
  end
end

function love.draw()
  if gameState == "menu" then
    Menu_draw()
  elseif gameState == "game" then
    Game.draw()
  end
end

function love.keypressed(key)
  
  print(key)
  
  if gameState == "game" then
    Game.keypressed(key)
  end
  
end

function love.mousepressed(px, py, pbutton)
  if gameState == "menu" then
    for k,v in ipairs(lst_buttons) do
      if pbutton == 1 and px >= v.x and px <= v.x+v.l and py >= v.y and py <= v.y+v.h then
        if v.ID == "NP" then
          print("je lance une nouvelle partie")
          gameState = "game"
        end
        if v.ID == "LP" then
          print("je lance une partie déjà chargé")
          local file = love.filesystem.newFile("game.json")
          if love.filesystem.getInfo("game.json") ~= nil then
            file:open("r")
            SAUVEGARDE = myJSON.decode(file:read())
            gameState = "game"
          end
        end
      end
    end
  end
end