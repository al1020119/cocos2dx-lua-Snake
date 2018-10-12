
--- @class TitleScene
local TitleScene = class("TitleScene",cc.load("mvc").ViewBase)

---onEnter
function TitleScene:onEnter()
	print("onEnter")
end

---createStaticButton 通用创建按钮方法
---@param node table
---@param imageName table
---@param x table
---@param y table
---@param callBack table
local function createStaticButton(node, imageName, x, y, callBack)
    local btn = ccui.Button:create(imageName, imageName)
    btn:move(x, y)
    btn:addClickEventListener(callBack)
    btn:addTo(node)
end

---onCreate
function TitleScene:onCreate()

    -- 初始化背景
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

	-- 初始化按钮
    createStaticButton(self, "button_start.png", display.cx, display.cy-150, function ()
        self:getApp():enterScene("MainScene")
    end)
    createStaticButton(self, "图形-04.png", display.cx-200, display.cy-250, function ()
        print("图形-04")
    end)
    createStaticButton(self, "图形-05.png", display.cx, display.cy-250, function ()
        print("图形-05")
    end)
    createStaticButton(self, "图形-06.png", display.cx+200, display.cy-250, function ()
        print("图形-06")
    end)

end

return TitleScene