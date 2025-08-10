---------------------------
-- GUI (estilo hub moderno com sidebar)
---------------------------
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VoxSeasHub"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local function mkCorner(i,r)local c=Instance.new("UICorner")c.CornerRadius=UDim.new(0,r or 12)c.Parent=i end
local function mkStroke(i,t,tr,c)local s=Instance.new("UIStroke")s.Thickness=t or 1 s.Transparency=tr or 0.85 s.Color=c or Color3.fromRGB(200,200,200) s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border s.Parent=i end

-- root
local root = Instance.new("Frame")
root.Size = UDim2.new(0,620,0,380)
root.Position = UDim2.fromScale(0.5,0.5)
root.AnchorPoint = Vector2.new(0.5,0.5)
root.BackgroundColor3 = Color3.fromRGB(19,19,23)
root.Parent = screenGui
mkCorner(root,14); mkStroke(root,1,0.85)

-- header
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,38)
header.BackgroundColor3 = Color3.fromRGB(24,24,28)
header.Parent = root
mkCorner(header,14)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,12,0,0)
title.Font = Enum.Font.GothamBold
title.Text = "VOXSEAS HUB"
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(240,240,255)
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-36,0.5,-14)
closeBtn.Text = "—"
closeBtn.BackgroundColor3 = Color3.fromRGB(36,36,42)
closeBtn.TextColor3 = Color3.fromRGB(230,230,230)
closeBtn.Parent = header
mkCorner(closeBtn,8)

-- body
local body = Instance.new("Frame")
body.Size = UDim2.new(1,-12,1,-50)
body.Position = UDim2.new(0,6,0,44)
body.BackgroundTransparency = 1
body.Parent = root

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,170,1,0)
sidebar.BackgroundColor3 = Color3.fromRGB(25,25,30)
sidebar.Parent = body
mkCorner(sidebar,10); mkStroke(sidebar,1,0.9)

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0,6)
sideLayout.Parent = sidebar

local content = Instance.new("Frame")
content.Size = UDim2.new(1,-180,1,0)
content.Position = UDim2.new(0,180,0,0)
content.BackgroundColor3 = Color3.fromRGB(22,22,27)
content.Parent = body
mkCorner(content,10); mkStroke(content,1,0.9)

-- helpers
local sections, currentSection = {}, nil
local function addSection(name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-12,0,38)
    b.Text = "  "..name
    b.Font = Enum.Font.Gotham
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.TextSize = 16
    b.BackgroundColor3 = Color3.fromRGB(32,32,38)
    b.TextColor3 = Color3.fromRGB(230,230,240)
    b.Parent = sidebar
    mkCorner(b,8); mkStroke(b,1,0.92)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1,-16,1,-16)
    page.Position = UDim2.new(0,8,0,8)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 6
    page.Parent = content

    local pad = Instance.new("UIPadding")
    pad.PaddingTop, pad.PaddingLeft, pad.PaddingRight = UDim.new(0,8), UDim.new(0,6), UDim.new(0,6)
    pad.Parent = page

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0,8)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = page

    table.insert(sections,{btn=b,page=page})
    b.MouseButton1Click:Connect(function()
        for _,s in ipairs(sections) do
            s.page.Visible = (s.btn==b)
            s.btn.BackgroundColor3 = s.btn==b and Color3.fromRGB(45,45,54) or Color3.fromRGB(32,32,38)
        end
    end)

    if not currentSection then
        currentSection = {btn=b,page=page}; b:Activate()
        for _,s in ipairs(sections) do s.page.Visible = (s==currentSection) end
    else page.Visible=false end
    return page
end

local function addSwitch(parent,label,initial,cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-4,0,44)
    f.BackgroundColor3 = Color3.fromRGB(30,30,36)
    f.Parent = parent
    mkCorner(f,8); mkStroke(f,1,0.92)

    local txt = Instance.new("TextLabel")
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.new(1,-70,1,0)
    txt.Position = UDim2.new(0,10,0,0)
    txt.Font = Enum.Font.Gotham
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.TextSize = 15
    txt.Text = label
    txt.TextColor3 = Color3.fromRGB(235,235,240)
    txt.Parent = f

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,56,0,26)
    btn.Position = UDim2.new(1,-64,0.5,-13)
    btn.Text = initial and "ON" or "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = initial and Color3.fromRGB(50,120,60) or Color3.fromRGB(70,70,74)
    btn.Parent = f
    mkCorner(btn,12); mkStroke(btn,1,0.9)

    local state = initial
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(50,120,60) or Color3.fromRGB(70,70,74)
        if cb then cb(state) end
    end)
end

local function addButton(parent,label,cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-4,0,42)
    b.Text = label; b.Font = Enum.Font.Gotham; b.TextSize = 15
    b.TextColor3 = Color3.fromRGB(235,235,240)
    b.BackgroundColor3 = Color3.fromRGB(30,30,36)
    b.Parent = parent
    mkCorner(b,8); mkStroke(b,1,0.92)
    b.MouseButton1Click:Connect(function() if cb then cb() end end)
end

-- Seções
local pageGeneral = addSection("General")
local pageTeleport = addSection("Teleport")

-- ligações às variáveis que você já tem no script
addSwitch(pageGeneral,"Auto Farm (Auto Quest)",false,function(v) autoQuest=v end)
addSwitch(pageGeneral,"Auto por Level/NextQuest",true,function(v) autoByLevel=v end)
addSwitch(pageGeneral,"Auto Chest",false,function(v) autoChest=v end)
addSwitch(pageGeneral,"Auto Fruit",false,function(v) autoFruit=v end)

-- Teleports
local function repopulateTP()
    for _,c in ipairs(pageTeleport:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
    end
    if spawnPointsRoot then
        for _,d in ipairs(spawnPointsRoot:GetDescendants()) do
            local part = d:IsA("BasePart") and d or d:FindFirstChildWhichIsA("BasePart")
            if part then
                addButton(pageTeleport,"TP: "..d.Name,function() teleportToCFrame(part.CFrame) end)
            end
        end
    else
        addButton(pageTeleport,"SpawnPoints não encontrados",function() end)
    end
end
repopulateTP()
addButton(pageGeneral,"Atualizar Spawns",function() refreshRoots(); repopulateTP() end)

-- drag + minimiza
do
    local dragging=false; local dragStart; local startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=root.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local d=input.Position-dragStart
            root.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
end

closeBtn.MouseButton1Click:Connect(function() root.Visible = not root.Visible end)
