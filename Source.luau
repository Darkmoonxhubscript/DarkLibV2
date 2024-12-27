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
    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
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
    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
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
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    Size = UDim2.new(0, 150, 0.9, 0),
    Position = UDim2.new(0, 0, 0.1, 0)
})
Corner(LeftBar, UDim.new(0.05, 0))

local LeftScrollFrame = Create("ScrollingFrame", LeftBar, {
    Name = "TabsScrollFrame",
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
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
    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
    BorderSizePixel = 0,
    Size = UDim2.new(0, 497, 0.9, 0),
    Position = UDim2.new(0.2, 20, 0.1, 0)
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
    
    local BagulhoAzul = Create("Frame", TabButton, {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(0, 165, 255),
        Size = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1
    })
    Corner(BagulhoAzul, UDim.new(0.3, 0))  
    
    local TabNameLabel = Create("TextLabel", TabButton,{
        Text = TabName,
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        Font = Enum.Font.FredokaOne,
        TextSize = 15,
        TextDirection = "LeftToRight",
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.new(0, 110, 0, 20),
        Position = UDim2.new(0, 35, 0, 5)
    })
  
    local TabIcon = Create("ImageLabel", TabButton, {
        Image = TabIcon,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
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
        local tween = TweenService:Create(BagulhoAzul, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundTransparency = 0})
        tween:Play()
        TabButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    end

    TabButton.MouseButton1Click:Connect(function()
        for _, button in pairs(LeftScrollFrame:GetChildren()) do
            if button:IsA("TextButton") then

                local azul = button:FindFirstChild("Frame")
                if azul then
                    local tween = TweenService:Create(azul, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundTransparency = 1})
                    tween:Play()
                end
                button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end
        end

        local tween = TweenService:Create(BagulhoAzul, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundTransparency = 0})
        tween:Play()
        TabButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)

        for _, frame in pairs(Tabs) do
            frame.Visible = false
        end
        
        TabFrame.Visible = true
        SelectedTab = TabName 
    end)

    return TabFrame
end


function AddButton(Parent, Configs)
    local Name = Configs[1] or Configs.Name or Configs.Text or "Button"
    local Callback = Configs.Callback or function() print("Clicked") end
    
    local Button = Create("TextButton", Parent, {
        Name = "Button",
        Text = "",
        TextColor3 = Color3.fromRGB(240, 240, 240),
        Font = Enum.Font.FredokaOne,
        TextSize = 20,
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        Size = UDim2.new(0, 490, 0, 40),
        TextWrapped = false,
        Position = UDim2.new(0, 10, 0, 0),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })
    Corner(Button, UDim.new(0.3, 0)) 

    local TextLabel = Create("TextLabel", Button, {
      Text = Name,
      TextColor3 = Color3.fromRGB(240, 240, 240),
      Font = Enum.Font.FredokaOne,
      TextSize = 20,
      Size = UDim2.new(0, 450, 0, 40),
      TextWrapped = false,
      BackgroundTransparency = 1,
      Position = UDim2.new(0, 10, 0, 0),
      TextXAlignment = Enum.TextXAlignment.Left,
      TextYAlignment = Enum.TextYAlignment.Center
    })

    local Image = Create("ImageLabel", Button, {
        Image = "rbxassetid://10709791437",
        Size = UDim2.new(0, 25, 0, 30),
        Position = UDim2.new(1, -30, 0, 5),
        BackgroundTransparency = 1
    })

    Button.MouseButton1Click:Connect(function()
      Callback()
  local tween1 = TweenService:Create(TextLabel, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {TextColor3 = Color3.fromRGB(0, 170, 240)})
  local tween2 = TweenService:Create(Image, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(0, 170, 240)})
  tween1:Play()
  tween2:Play()
  tween1.Completed:Wait()
  local tween3 = TweenService:Create(TextLabel, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {TextColor3 = Color3.fromRGB(240, 240, 240)})
  local tween4 = TweenService:Create(Image, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {ImageColor3 = Color3.fromRGB(255, 255, 255)})
  tween3:Play()
  tween4:Play()
    end)

    return Button
end

function AddSection(Parent, Configs)
    local Name = Configs[1] or Configs.Name or Configs.Text or "Section"
    
    local SectionFrame = Create("Frame", Parent, {
        Name = "Section",
        Size = UDim2.new(0, 490, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BackgroundTransparency = 0
    })
    Corner(SectionFrame, UDim.new(0.3, 0)) 

    local SectionLabel = Create("TextLabel", SectionFrame, {
        Size = UDim2.new(0, 490, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        Text = Name,
        Font = Enum.Font.FredokaOne,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = 20,
        BackgroundTransparency = 1,
        TextWrapped = false,
        TextTruncate = "AtEnd",
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    return SectionFrame
end

function AddTextLabel(Parent, Configs)
    local Name = Configs[1] or Configs.Name or Configs.Text or "TextLabel"
    
    local TextFrame = Create("Frame", Parent, {
        Name = "TextLabel",
        Size = UDim2.new(0, 490, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BackgroundTransparency = 0
    })
    Corner(TextFrame, UDim.new(0.3, 0)) 

    local TextLabel = Create("TextLabel", TextFrame, {
        Size = UDim2.new(0, 475, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        Text = Name,
        Font = Enum.Font.FredokaOne,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = 20,
        BackgroundTransparency = 1,
        TextWrapped = false,
        TextTruncate = "AtEnd",
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    return TextFrame
end

function AddParagraph(Parent, Configs)
    local Name = Configs[1] or Configs.Name or Configs.Text or "My Title"
    local Description = Configs[2] or Configs.Description or "My Paragraph"
    
    local ParagraphFrame = Create("Frame", Parent, {
        Name = "Paragraph",
        Size = UDim2.new(0, 490, 0, 60),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BackgroundTransparency = 0
    })
    Corner(ParagraphFrame, UDim.new(0.3, 0)) 

    local ParagraphLabel1 = Create("TextLabel", ParagraphFrame, {
        Size = UDim2.new(0, 475, 0, 20),
        Position = UDim2.new(0, 10, 0, 10),
        Text = Name,
        Font = Enum.Font.FredokaOne,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = 20,
        BackgroundTransparency = 1,
        TextWrapped = false,
        TextTruncate = "AtEnd",
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })
  
  local ParagraphLabel2 = Create("TextLabel", ParagraphFrame, {
        Size = UDim2.new(0, 475, 0, 50),
        Position = UDim2.new(0, 10, 0, 10),
        Text = Description,
        Font = Enum.Font.FredokaOne,
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 17,
        BackgroundTransparency = 1,
        TextWrapped = true,
        TextTruncate = "AtEnd",
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    return ParagraphFrame
end

function AddSlider(Parent, Configs)
    local Name = Configs[1] or Configs.Name or Configs.Text or "Slider"
    local Min = Configs[2] or Configs.Min or 0
    local Max = Configs[3] or Configs.Max or 100
    local Default = Configs[5] or Configs.Default or Min
    local Increase = Configs[4] or Configs.Increase or 1
    local Callback = Configs[6] or Configs.Callback or function() end

    Min, Max = Min / Increase, Max / Increase

    local SliderFrame = Create("Frame", Parent, {
        Name = "Slider",
        Size = UDim2.new(0, 490, 0, 40),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
    })
    Corner(SliderFrame, UDim.new(0.3, 0)) 

    local SliderLabel = Create("TextLabel", SliderFrame, {
        Text = Name,
        Size = UDim2.new(1, -300, 0, 25),
        Position = UDim2.new(0, 10, 0, 8),
        Font = Enum.Font.FredokaOne,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        BackgroundTransparency = 1,
        TextSize = 20,
        TextTruncate = "AtEnd",
        TextXAlignment = Enum.TextXAlignment.Left,
    })
  
  local SliderValueLabel = Create("TextLabel", SliderFrame, {
        Text = Name,
        Size = UDim2.new(1, -425, 0, 25),
        Position = UDim2.new(0, 215, 0, 8),
        Font = Enum.Font.FredokaOne,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        BackgroundTransparency = 1,
        TextSize = 20,
        TextScaled = true,
        TextTruncate = "AtEnd",
        TextDirection = "RightToLeft",
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local SliderBarBackground = Create("Frame", SliderFrame, {
        Size = UDim2.new(1, -300, 0, 8),
        Position = UDim2.new(0, 290, 0, 16),
        BackgroundColor3 = Color3.fromRGB(120, 120, 120),
    })
    Corner(SliderBarBackground)

    local SliderBar = Create("Frame", SliderBarBackground, {
        Size = UDim2.fromScale((Default - Min) / (Max - Min), 1),
        BackgroundColor3 = Color3.fromRGB(0, 185, 255),
    })
    Corner(SliderBar)

    local SliderButton = Create("Frame", SliderBarBackground, {
        Size = UDim2.new(0, 12, 0, 24),
        Position = UDim2.fromScale((Default - Min) / (Max - Min), 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    })
    Corner(SliderButton)

    local function SnapToIncrease(value)
        return math.floor(value / Increase + 0.5) * Increase
    end

    local function UpdateSliderValue(position)
        local scaledValue = math.clamp(position, 0, 1)
        local newValue = math.floor((scaledValue * (Max - Min)) + Min)
        newValue = SnapToIncrease(newValue)

        SliderButton.Position = UDim2.new(scaledValue, 0, 0.5, 0)
        SliderBar.Size = UDim2.new(scaledValue, 0, 1, 0)
        SliderValueLabel.Text = tostring(newValue * Increase)
        Callback(newValue * Increase)
    end

    local dragging = false

    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local connection
            connection = UIS.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local relativePosition = (input.Position.X - SliderBarBackground.AbsolutePosition.X) / SliderBarBackground.AbsoluteSize.X
                    UpdateSliderValue(relativePosition)
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)

    UpdateSliderValue((Default - Min) / (Max - Min))
end

function AddToggle(Parent, Configs)
    local Name = Configs[1] or Configs.Name or Configs.Text or "Toggle"
    local Default = Configs[2] or Configs.Default or false
    local Callback = Configs.Callback or function() end

    local ToggleFrame1 = Create("Frame", Parent, {
        Size = UDim2.new(0, 490, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BackgroundTransparency = 0
    })
    Corner(ToggleFrame1, UDim.new(0.3, 0))

    local ToggleFrame2 = Create("Frame", ToggleFrame1, {
        Size = UDim2.new(0, 70, 0, 30),
        Position = UDim2.new(1, -80, 0, 5),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        BackgroundTransparency = 1
    })
    local Stroke1 = Stroke(ToggleFrame2, Color3.fromRGB(100, 100, 100), 3)
    Corner(ToggleFrame2, UDim.new(2, 0))

    local ToggleActive = Create("Frame", ToggleFrame1, {
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(0, 413, 0, 8),
        BackgroundColor3 = Color3.fromRGB(160, 160, 160),
        BackgroundTransparency = 0
    })
    local Stroke2 = Stroke(ToggleActive, Color3.fromRGB(160, 160, 160), 2.5)
    Corner(ToggleActive, UDim.new(5, 0))

    local ToggleState = false
    if Default then
      SetProps(Stroke1, {
        Color = Color3.fromRGB(0, 185, 255)
      })
    SetProps(Stroke2, {
        Color = Color3.fromRGB(0, 185, 255)
      })
      local tween = TweenService:Create(ToggleActive, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {Position = UDim2.new(1, -37, 0, 8)})
          tween:Play()
          tween.Completed:Wait()
        ToggleState = true
    end

    Callback(ToggleState)

    local TextToggle = Create("TextLabel", ToggleFrame1, {
        Text = Name,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        Font = Enum.Font.FredokaOne,
        TextSize = 20,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 200, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    local ToggleButtonArea = Create("TextButton", ToggleFrame1, {
        Text = "",
        Size = UDim2.new(0, 70, 0, 30),
        Position = UDim2.new(1, -80, 0, 5),
        BackgroundTransparency = 1
    })

    ToggleButtonArea.MouseButton1Click:Connect(function()
        if ToggleState then
          SetProps(Stroke1, {
        Color = Color3.fromRGB(70, 70, 70)
      })
    SetProps(Stroke2, {
        Color = Color3.fromRGB(160, 160, 160)
      })
    SetProps(ToggleActive, {
      BackgroundColor3 = Color3.fromRGB(160, 160, 160),
    })
          local tween = TweenService:Create(ToggleActive, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {Position = UDim2.new(0, 413, 0, 8)})
          tween:Play()
          tween.Completed:Wait()
            ToggleState = false
        elseif not ToggleState then
          SetProps(Stroke1, {
        Color = Color3.fromRGB(0, 185, 255)
      })
    SetProps(Stroke2, {
        Color = Color3.fromRGB(0, 185, 255)
      })
    SetProps(ToggleActive, {
      BackgroundColor3 = Color3.fromRGB(0, 185, 255),
    })
          local tween = TweenService:Create(ToggleActive, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {Position = UDim2.new(1, -37, 0, 8)})
          tween:Play()
          tween.Completed:Wait()
            ToggleState = true
        end
        Callback(ToggleState)
    end)

    return {ToggleActive, Callback, ToggleState}
end

function AddTextBox(Parent, Configs)
  local Name = Configs[1] or Configs.Name or Configs.Text or "TextBox"
  local Default = Configs[2] or Configs.Default or ""
  local AutoClear = Configs[3] or Configs.AutoClear or false
  local PlaceHolder = Configs[4] or Configs.PlaceHolder or "Input Here"
  local Callback = Configs[5] or Configs.Callback or function() end
  
  local TextBoxFrame = Create("Frame", Parent, {
        Size = UDim2.new(0, 490, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BackgroundTransparency = 0
    })
    Corner(TextBoxFrame, UDim.new(0.3, 0))
     
     local TextBoxText = Create("TextLabel", TextBoxFrame, {
        Text = Name,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        Font = Enum.Font.FredokaOne,
        TextSize = 20,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 200, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })
  
  local TextBox = Create("TextBox", TextBoxFrame, {
    Size = UDim2.new(0, 80, 1, -10),
    Position = UDim2.new(1, -90, 0, 5),
    ClearTextOnFocus = false,
    BackgroundColor3 = Color3.fromRGB(80, 80, 80),
    BackgroundTransparency = 0,
    Text = Default,
    TextColor3 = Color3.fromRGB(240, 240, 240),
    Font = Enum.Font.FredokaOne,
    PlaceholderText = PlaceHolder,
    TextScaled = true
  })
  Stroke(TextBox, Color3.fromRGB(60, 60, 60), 2)
  Corner(TextBox)
  
  Callback(Default)
  TextBox.FocusLost:Connect(function()
    Callback(TextBox.Text)
    if AutoClear == true then
    TextBox.Text = ""
    end
  end)
     return TextBoxFrame
  end


end

return DarkLib
