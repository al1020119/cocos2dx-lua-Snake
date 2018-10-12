
---- 引入
local Snake = require "app.Snake.Snake"
local Apple = require "app.Object.Apple"
local Fence = require "app.Object.Fence"

local Common = require "app.Tools.Common"

---- @class MainScene
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
--local MainScene = class("MainScene", function() return display.newScene("MainScene") end)

---- 常量
local cMoveSpeed = 0.3
local cBound = 7

---onCreate
function MainScene:onCreate()

    -- 初始化墙壁
    self.fence = Fence.new(cBound, self)

    -- 重置游戏
    self:ResetScene()

    -- 初始化用户输入
    self:ProcessInput()

    -- 定时执行更新
    local tick = function()

        -- 死亡的时候，不在继续执行定时器
        if self.status == "dead" then
            return
        end

        -- 更新蛇
        self.snake:update()

        -- 头部位置
        local headX, headY = self.snake:GetHeadGrid()

        -- 吃苹果：如果蛇头碰到了苹果，就让苹果重生蛇长长
        if self.apple:CheckAppleCollide(headX, headY) then
        
            self.apple:Generate()
            self.snake:Grow(false)
        
        end

        -- 碰撞自己或者碰撞到墙壁
        if self.snake:CheckSelfCollide() or self.fence:CheckFenceCollide(headX, headY) then
        
            self.status = "dead"
            self.snake:Blink(function()
                self:ResetScene()
            end)
        
        end
    end

    --定时器
    cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, cMoveSpeed, false)

end

---ResetScene 重置
function MainScene:ResetScene()

    -- 杀蛇
    if self.snake ~= nil then

        self.snake:Kill()

    end

    -- 重置苹果
    if self.apple ~= nil then

        self.apple:ResetApple()

    end

    -- 初始化蛇，和苹果
    self.snake = Snake.new(self)
    self.apple = Apple.new(cBound, self)

    -- 当前状态
    self.status = "running"

end

---vector2Dir 二维位置转换为移动方向
---@param x table
---@param y table
function vector2Dir(x, y)
        
    if math.abs(x) > math.abs(y) then
        if x < 0 then
            return L_D
        else
            return R_D
        end
    else
        if y < 0 then
            return U_D
        else
            return D_D
        end
    end

end

---ProcessInput 处理用户输入
function MainScene:ProcessInput()
    
    local function onTouchBegan(touch, event)

        local location = touch:getLocation()
        local visiableSize = cc.Director:getInstance():getVisibleSize()
        local origin = cc.Director:getInstance():getVisibleOrigin()

        local finalX = location.x - (origin.x + visiableSize.width/2)
        local finalY = location.y - (origin.y + visiableSize.height/2)
        
        local dir = vector2Dir(finalX, finalY)

        self.snake:setDir(dir)

    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDiapatcher = self:getEventDispatcher()
    eventDiapatcher:addEventListenerWithSceneGraphPriority(listener, self)

end

return MainScene
