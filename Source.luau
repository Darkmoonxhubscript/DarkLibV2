local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Tabs = {}

local function SetProps(Instance, Props)
    if Props then
        for prop, value in pairs(Props) do
            Instance[prop] = value
        end
    end
    return Instance
end

local function Create(...)
    local args = {...}
    local new = Instance.new(args[1])
    local parent = args[2]
    local props = args[3]
    
    if parent then
        new.Parent = parent
    end
    if props then
        SetProps(new, props)
    end
    return new
end

local function Corner(parent, radius)
    return Create("UICorner", parent, {
        CornerRadius = radius or UDim.new(0, 5)
    })
end

local function Stroke(parent, Colorstk, Thickness)
    local new = Create("UIStroke", parent, {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Colorstk or Color3.fromRGB(120, 120, 120),
        Thickness = Thickness or 0.1
    })
    return new
end

local ViewportSize = workspace.CurrentCamera.ViewportSize
local UIScale = ViewportSize.Y / 660

local function MakeDrag(Instance)
    local Dragging, DragInput, DragStart, StartPosition

    local function Update(input)
        local Delta = input.Position - DragStart
        Instance.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end

    Instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = Instance.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    Instance.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

function MakeWindow(WindowConfig)
local Title = WindowConfig[1] or WindowConfig.Title or "DarkLib V1"
  
local ScreenGui = Create("ScreenGui", CoreGui, {
    Name = "DarkLibraryV1",
    ResetOnSpawn = false
})
  Create("UIScale", ScreenGui, {
    Scale = UIScale
})

local MainFrame = Create("Frame", ScreenGui, {
    Name = "MainFrame",
    BackgroundColor3 = Color3.fromRGB(10, 10, 10),
    Size = UDim2.new(0.5, 0, 0.6, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Active = true,
    BackgroundTransparency = 0
})
Corner(MainFrame, UDim.new(0.05, 0))
MakeDrag(MainFrame)

local TopBar = Create("Frame", MainFrame, {
    Name = "TopBar",
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    Size = UDim2.new(1, 0, 0.1, 0),
    Position = UDim2.new(0, 0, 0, 0)
})
Corner(TopBar, UDim.new(0.2, 0))

local HubTitle = Create("TextLabel", TopBar, {
    Name = "Title",
    Text = Title,
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.FredokaOne,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
    Size = UDim2.new(0.8, 0, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    TextWrapped = false,
    BackgroundTransparency = 1
})

local CloseButton = Create("TextButton", TopBar, {
    Name = "Close",
    Text = "X",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.FredokaOne,
    TextSize = 20,
    BackgroundTransparency = 1,
    Size = UDim2.new(0.1, 0, 1, 0),
    Position = UDim2.new(1, -50, 0, 0)
})
CloseButton.MouseButton1Click:Connect(function()
  local tween = TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 0)})
  tween:Play()
  tween.Completed:Wait()
  ScreenGui:Destroy()
end)

local LeftBar = Create("Frame", MainFrame, {
    Name = "TabsBar",
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    Size = UDim2.new(0.2, 0, 0.9, 0),
    Position = UDim2.new(0, 0, 0.1, 0)
})
Corner(LeftBar, UDim.new(0.05, 0))

local LeftScrollFrame = Create("ScrollingFrame", LeftBar, {
    Name = "TabsScrollFrame",
    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 1, 0),
    ScrollBarThickness = 0,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(),
    ElasticBehavior = Enum.ElasticBehavior.Never
})
Create("UIListLayout", LeftScrollFrame, {
  Padding = UDim.new(0, 8),
})

local RightScrollFrame = Create("Frame", MainFrame, {
    Name = "Containers",
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    BorderSizePixel = 0,
    Size = UDim2.new(0.8, 0, 0.9, 0),
    Position = UDim2.new(0.2, 0, 0.1, 0)
})
Corner(RightScrollFrame)

local Padding = Create("UIPadding", RightScrollFrame, {
        PaddingLeft = UDim.new(0, 7),
        PaddingRight = UDim.new(0, 7),
        PaddingTop = UDim.new(0, 7),
        PaddingBottom = UDim.new(0, 7)
    })


local SelectedTab = "" 
local FirstTab = nil 

function NewTab(Configs)
    local TabName = Configs.Name or Configs.Text or "Tab Name"
    local TabIcon = Configs.Icon or "0123456789"
    local TabButton
    local TabFrame
     
     if not TabIcon:find("rbxassetid://") then
       TabIcon = "rbxassetid://" .. TabIcon
       end
     
    if not FirstTab then
        FirstTab = TabName
        SelectedTab = TabName  
    end
 
    TabButton = Create("TextButton", LeftScrollFrame, {
        Name = "TabButton",
        Text = "",
        TextColor3 = Color3.fromRGB(240, 240, 240),
        Font = Enum.Font.FredokaOne,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        Size = UDim2.new(1, -10, 0, 30),
        TextWrapped = false,
        ClipsDescendants = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTruncate = "AtEnd",
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(0, 0, 0, 0)  
    })
    Corner(TabButton, UDim.new(0.3, 0))  
    
    local TabNameLabel = Create("TextLabel", TabButton,{
      Text = TabName,
      BackgroundTransparency = 1,
      TextColor3 = Color3.fromRGB(240, 240, 240),
      Font = Enum.Font.FredokaOne,
      TextSize = 15,
      TextDirection = "LeftToRight",
      TextXAlignment = Enum.TextXAlignment.Left,
      TextYAlignment = Enum.TextYAlignment.Center,
      Size = UDim2.new(0, 100, 0, 20),
      Position = UDim2.new(0, 25, 0, 5)
    })
  
    local TabIcon = Create("ImageLabel", TabButton, {
      Image = TabIcon,
      Size = UDim2.new(0, 20, 0, 20),
      Position = UDim2.new(0, 3, 0, 5),
      BackgroundTransparency = 1
    })

    TabFrame = Create("ScrollingFrame", RightScrollFrame, {
        Name = TabName,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false,  
        ScrollBarThickness = 0,
        ElasticBehavior = Enum.ElasticBehavior.Never,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new()
    })

    Create("UIListLayout", TabFrame, {
        Padding = UDim.new(0, 7),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    Tabs[TabName] = TabFrame

    
    if SelectedTab == TabName then
        TabFrame.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    end

    TabButton.MouseButton1Click:Connect(function()
        for _, button in pairs(LeftScrollFrame:GetChildren()) do
            if button:IsA("TextButton") then
                button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end
        end
        
        TabButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        for _, frame in pairs(Tabs) do
            frame.Visible = false
        end
        
        TabFrame.Visible = true
        SelectedTab = TabName 
    end)

    return TabFrame
end

end
return DarkMoonLibrary
