-- XsDeep Teleport GUI System v2 | Delta Executor
-- Slot system dengan + button untuk langsung save posisi
-- Minimize/Expand system sesuai deskripsi
-- Owner: Xs TTK | Entity: XsDeep

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Data storage
local TeleportData = {}
local SlotFrames = {}

-- Detect spawn position
local function GetSpawnPosition()
    local spawn = workspace:FindFirstChild("SpawnLocation") 
                 or workspace:FindFirstChild("Spawn")
                 or workspace:FindFirstChild("SpawnPoint")
    
    if spawn then
        return spawn.Position + Vector3.new(0, 5, 0)
    else
        return Vector3.new(0, 50, 0)
    end
end

-- Initialize data
TeleportData[1] = {
    Position = GetSpawnPosition(),
    Description = "Spawn Location (Auto)",
    Locked = true
}

for i = 2, 5 do
    TeleportData[i] = {
        Position = nil,
        Description = "Click + to add slot",
        Locked = false
    }
end

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "XsDeepTeleportGUI"

-- ==================== MINIMIZED MODE ====================
local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Size = UDim2.new(0, 150, 0, 30)
MinimizedFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MinimizedFrame.BorderSizePixel = 2
MinimizedFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
MinimizedFrame.Visible = false -- Mulai dengan tidak terlihat
MinimizedFrame.Parent = ScreenGui

local MinimizedTitle = Instance.new("TextLabel")
MinimizedTitle.Size = UDim2.new(0.6, 0, 1, 0)
MinimizedTitle.Position = UDim2.new(0.05, 0, 0, 0)
MinimizedTitle.BackgroundTransparency = 1
MinimizedTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
MinimizedTitle.Text = "Teleport GUI"
MinimizedTitle.Font = Enum.Font.GothamBold
MinimizedTitle.TextSize = 14
MinimizedTitle.TextXAlignment = Enum.TextXAlignment.Left
MinimizedTitle.Parent = MinimizedFrame

local ExpandFromMinBtn = Instance.new("TextButton")
ExpandFromMinBtn.Size = UDim2.new(0, 25, 0, 25)
ExpandFromMinBtn.Position = UDim2.new(0.8, 0, 0.08, 0)
ExpandFromMinBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Hijau
ExpandFromMinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExpandFromMinBtn.Text = "+"
ExpandFromMinBtn.Font = Enum.Font.GothamBold
ExpandFromMinBtn.TextSize = 18
ExpandFromMinBtn.Parent = MinimizedFrame

-- ==================== FULL GUI MODE ====================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 220)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.Visible = true -- Mulai dengan terlihat
MainFrame.Parent = ScreenGui

-- Header dengan tombol -
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Text = "Teleport GUI"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinimizeBtn = Instance.new("TextButton") -- Tombol - di header
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(0.9, 0, 0.08, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Merah
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Text = "-"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = Header

-- Container untuk slots
local SlotsContainer = Instance.new("ScrollingFrame")
SlotsContainer.Size = UDim2.new(1, -10, 1, -40)
SlotsContainer.Position = UDim2.new(0, 5, 0, 35)
SlotsContainer.BackgroundTransparency = 1
SlotsContainer.BorderSizePixel = 0
SlotsContainer.ScrollBarThickness = 5
SlotsContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 0, 0)
SlotsContainer.CanvasSize = UDim2.new(0, 0, 0, 320)
SlotsContainer.Parent = MainFrame

-- Function create slot UI
local function CreateSlotUI(slotNum)
    local data = TeleportData[slotNum]
    
    local SlotFrame = Instance.new("Frame")
    SlotFrame.Size = UDim2.new(1, -10, 0, 60)
    SlotFrame.Position = UDim2.new(0, 5, 0, ((slotNum-1) * 65))
    SlotFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SlotFrame.BorderColor3 = Color3.fromRGB(70, 70, 70)
    SlotFrame.BorderSizePixel = 1
    SlotFrame.Parent = SlotsContainer
    
    SlotFrames[slotNum] = SlotFrame
    
    -- Slot number
    local SlotText = Instance.new("TextLabel")
    SlotText.Size = UDim2.new(0, 80, 0, 20)
    SlotText.Position = UDim2.new(0, 5, 0, 5)
    SlotText.BackgroundTransparency = 1
    SlotText.TextColor3 = Color3.fromRGB(255, 0, 0)
    SlotText.Text = "Slot " .. slotNum
    SlotText.Font = Enum.Font.GothamBold
    SlotText.TextSize = 12
    SlotText.TextXAlignment = Enum.TextXAlignment.Left
    SlotText.Parent = SlotFrame
    
    -- Description
    local DescBox = Instance.new("TextBox")
    DescBox.Size = UDim2.new(0.6, -10, 0, 25)
    DescBox.Position = UDim2.new(0, 5, 0, 30)
    DescBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DescBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    DescBox.Text = data.Description
    DescBox.Font = Enum.Font.Gotham
    DescBox.TextSize = 11
    DescBox.PlaceholderText = "Deskripsi (max 20 kata)"
    
    if data.Locked then
        DescBox.Editable = false
        DescBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
    
    DescBox.Parent = SlotFrame
    
    -- Word limit
    DescBox:GetPropertyChangedSignal("Text"):Connect(function()
        local words = {}
        for word in DescBox.Text:gmatch("%S+") do
            table.insert(words, word)
        end
        if #words > 20 then
            DescBox.Text = table.concat(words, " ", 1, 20)
        end
        TeleportData[slotNum].Description = DescBox.Text
    end)
    
    -- GO Button
    local GoButton = Instance.new("TextButton")
    GoButton.Size = UDim2.new(0, 40, 0, 25)
    GoButton.Position = UDim2.new(0.65, 0, 0, 30)
    GoButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    GoButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    GoButton.Text = "GO"
    GoButton.Font = Enum.Font.GothamBold
    GoButton.TextSize = 12
    GoButton.Parent = SlotFrame
    
    -- Add Button (+)
    local AddButton = Instance.new("TextButton")
    AddButton.Size = UDim2.new(0, 40, 0, 25)
    AddButton.Position = UDim2.new(0.65, 0, 0, 30)
    AddButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Hijau terang
    AddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AddButton.Text = "+"
    AddButton.Font = Enum.Font.GothamBold
    AddButton.TextSize = 16
    AddButton.Parent = SlotFrame
    
    -- Slot logic
    if slotNum == 1 then
        -- Slot 1 (spawn) - fixed
        AddButton.Visible = false
        GoButton.Visible = true
        
        GoButton.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(data.Position)
            end
        end)
    else
        if data.Position then
            -- Slot sudah ada posisi
            AddButton.Visible = false
            GoButton.Visible = true
            
            GoButton.MouseButton1Click:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(data.Position)
                end
            end)
        else
            -- Slot kosong - show + button
            AddButton.Visible = true
            GoButton.Visible = false
            
            AddButton.MouseButton1Click:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    -- Save current position
                    TeleportData[slotNum].Position = char.HumanoidRootPart.Position
                    
                    -- Update UI
                    AddButton.Visible = false
                    GoButton.Visible = true
                    
                    if DescBox.Text == "Click + to add slot" then
                        DescBox.Text = "Saved Location " .. slotNum
                    end
                    
                    TeleportData[slotNum].Description = DescBox.Text
                    
                    -- Notify
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "Slot " .. slotNum .. " Saved",
                        Text = "Position saved successfully",
                        Duration = 2
                    })
                end
            end)
        end
    end
    
    -- Update canvas size
    SlotsContainer.CanvasSize = UDim2.new(0, 0, 0, (#TeleportData * 65))
end

-- Initialize semua slot
for i = 1, 5 do
    CreateSlotUI(i)
end

-- ==================== MINIMIZE/EXPAND LOGIC ====================
-- Dari Full GUI ke Minimized
MinimizeBtn.MouseButton1Click:Connect(function()
    -- Simpan posisi sebelum minimize
    local lastPos = MainFrame.Position
    
    -- Sembunyikan full GUI
    MainFrame.Visible = false
    
    -- Tampilkan minimized GUI di posisi yang sama
    MinimizedFrame.Position = lastPos
    MinimizedFrame.Visible = true
end)

-- Dari Minimized kembali ke Full GUI
ExpandFromMinBtn.MouseButton1Click:Connect(function()
    -- Simpan posisi minimized
    local lastPos = MinimizedFrame.Position
    
    -- Sembunyikan minimized GUI
    MinimizedFrame.Visible = false
    
    -- Tampilkan full GUI di posisi yang sama
    MainFrame.Position = lastPos
    MainFrame.Visible = true
end)

-- ==================== DRAG SYSTEM ====================
local function SetupDrag(frame)
    local dragging, dragInput, dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Setup drag untuk kedua frame
SetupDrag(Header)
SetupDrag(MinimizedFrame)

-- Notification awal
game.StarterGui:SetCore("SendNotification", {
    Title = "XsDeep Teleport GUI v2",
    Text = "Full GUI loaded. Click - to minimize.",
    Duration = 5
})
