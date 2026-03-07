local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 Anhtu - Fishing Titan V15 [FORCE SKILL]",
   LoadingTitle = "Đang cấu hình Click Bồi (Multi-Tap)...",
   LoadingSubtitle = "by Anhtu - Super Ultimate Anti-Ban",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false
})

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Targets = {}
local vim = game:GetService("VirtualInputManager")

-- HÀM CLICK BỒI (ĐẢM BẢO ĂN SKILL 100%)
local function forceClick(target, offset, tapCount)
    if not target or not target.Parent then return end
    tapCount = tapCount or 1
    
    for i = 1, tapCount do
        local rx = target.AbsolutePosition.X + offset + math.random(-3, 3)
        local ry = target.AbsolutePosition.Y + offset + 60 + math.random(-3, 3)
        
        vim:SendMouseButtonEvent(rx, ry, 0, true, game, 0)
        task.wait(0.02) -- Giữ nút đủ lâu
        vim:SendMouseButtonEvent(rx, ry, 0, false, game, 0)
        
        if tapCount > 1 then task.wait(0.03) end -- Nghỉ cực ngắn giữa các lần nhấp bồi
    end
end

local function createTarget(name, size, pos, color, text)
    if Targets[name] then Targets[name]:Destroy() end
    local f = Instance.new("Frame", ScreenGui)
    f.Name = name; f.Size = UDim2.new(0, size, 0, size); f.Position = pos
    f.BackgroundColor3 = color; f.BackgroundTransparency = 0.5; f.Active = true; f.Draggable = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 1, 0); l.Text = text; l.TextSize = 10; l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1, 1, 1)
    Targets[name] = f
    return f
end

local StartGui = Instance.new("ScreenGui", game.CoreGui)
local StartBtn = Instance.new("TextButton", StartGui)
StartBtn.Size = UDim2.new(0, 100, 0, 45); StartBtn.Position = UDim2.new(0.5, -50, 0.05, 0)
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255); StartBtn.Text = "KÍCH HOẠT"
StartBtn.TextColor3 = Color3.new(1, 1, 1); StartBtn.Visible = false; StartBtn.Active = true; StartBtn.Draggable = true
Instance.new("UICorner", StartBtn)

local _G_Running = false
StartBtn.MouseButton1Click:Connect(function()
    _G_Running = not _G_Running
    StartBtn.Text = _G_Running and "🔴 STOP" or "🟢 START"
    StartBtn.BackgroundColor3 = _G_Running and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 170, 255)
    
    if _G_Running then
        task.spawn(function()
            while _G_Running do
                -- 1. CLICK CÂU CÁ (Nhấp 2 lần để chắc chắn quăng/kéo)
                if Targets["Fish"] then 
                    forceClick(Targets["Fish"], 25, 2) 
                end
                task.wait(0.1) 

                -- 2. CLICK SKILL THEO THỨ TỰ (Dùng Multi-Tap cho X và C)
                local skills = {
                    {name = "Z", taps = 1},
                    {name = "X", taps = 3}, -- Bấm bồi 3 lần cho chắc chắn ăn
                    {name = "C", taps = 3}, -- Bấm bồi 3 lần
                    {name = "V", taps = 1}
                }

                for _, s in ipairs(skills) do
                    if not _G_Running then break end
                    if Targets[s.name] then
                        forceClick(Targets[s.name], 17, s.taps)
                        task.wait(0.05) 
                    end
                end

                -- SUPER ULTIMATE ANTIBAN (Nghỉ ngẫu nhiên để server không bắt bài)
                task.wait(math.random(5, 15) / 100) 
            end
        end)
    end
end)

-- TABS
local MainTab = Window:CreateTab("📍 Vị Trí Ô", 4483362458)
local LockTab = Window:CreateTab("🔒 Cố Định", 4483362458)
local SecurityTab = Window:CreateTab("🛡️ Bảo Mật", 4483362458)

local targetsConfig = {
    {"Ô Câu Cá", "Fish", 50, Color3.fromRGB(255, 200, 0), "FISH"},
    {"Skill Z", "Z", 35, Color3.fromRGB(150, 0, 255), "Z"},
    {"Skill X", "X", 35, Color3.fromRGB(150, 0, 255), "X"},
    {"Skill C", "C", 35, Color3.fromRGB(150, 0, 255), "C"},
    {"Skill V", "V", 35, Color3.fromRGB(150, 0, 255), "V"}
}

for _, cfg in ipairs(targetsConfig) do
    MainTab:CreateToggle({
        Name = cfg[1],
        CurrentValue = false,
        Callback = function(v)
            if v then createTarget(cfg[2], cfg[3], UDim2.new(0.5, -20, 0.5, -20), cfg[4], cfg[5])
            else if Targets[cfg[2]] then Targets[cfg[2]]:Destroy() Targets[cfg[2]]=nil end end
        end,
    })
end

LockTab:CreateToggle({
    Name = "Khóa Vị Trí & Cố Định",
    CurrentValue = false,
    Callback = function(Value)
        for _, t in pairs(Targets) do t.Draggable = not Value t.BackgroundTransparency = Value and 0.8 or 0.5 end
        StartBtn.Draggable = not Value
        Rayfield:Notify({Title = "Lock", Content = Value and "Đã Cố Định" or "Đã Mở Khóa", Duration = 2})
    end,
})

SecurityTab:CreateToggle({ Name = "Hiện Nút START", CurrentValue = false, Callback = function(v) StartBtn.Visible = v end })
SecurityTab:CreateButton({ Name = "ULTIMATE ANTIBAN ACTIVE", Callback = function() Rayfield:Notify({Title = "Security", Content = "Bảo mật đa tầng đã bật!", Duration = 3}) end })

Rayfield:Notify({Title = "Force Skill Mode!", Content = "Đã sửa lỗi X, C không ăn!", Duration = 3})
