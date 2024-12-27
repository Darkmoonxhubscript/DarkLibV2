loadstring(game:HttpGet("https://raw.githubusercontent.com/Darkmoonxhubscript/DarkLibV2/refs/heads/main/Source.luau"))()

local Window = MakeWindow({Title = "DarkMoonHub Library"})

AddMinimizeButton({
  Icon = "10734897102"
})

local Notify = NewNotify({
  Title = "Notification",
  Description = "Script Loaded!.",
  Time = 3
})

local Tab1 = NewTab({Name = "Universal", Icon = "10723407389"})
local Tab2 = NewTab({Name = "Game 1", Icon = "10723407389"})
local Tab3 = NewTab({Name = "Game 2", Icon = "10723407389"})

local Button1 = AddButton(Tab1, {
  Name = "Button Test",
  Callback = function()
    AddFloatToggle({
    Name = "Float Toggle",
    Callback = function(Value)
      print(Value)
      end
  })
print("Cliked")
  end
})

local TextLabel1 = AddTextLabel(Tab1, {
  Name = "My Text"
})

local Paragraph1 = AddParagraph(Tab1, {
  Name = "My Title",
  Description = "My Paragraph"
})

local Slider1 = AddSlider(Tab1, {
  Name = "Slider Test",
  Min = 0,
  Max = 1000,
  Increase = 1,
  Default = 100,
  Callback = function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

local TextBox1 = AddTextBox(Tab1, {
  Name = "TextBox Test",
  Default = "Text",
  AutoClear = false,
  PlaceHolder = "Input Here",
  Callback = function(Value)
    print(Value)
    end
})

local Toggle1 = AddToggle(Tab1, {
  Name = "Toggle Test",
  Default = false,
  Callback = function(Value)
  print(Value)
  end
})

local Dropdown1 = AddDropDown(Tab1, {
  Name = "Dropdown Test",
  Options = {"Ilha1", "Ilha2", "Ilha3", "Ilha4", "Ilha5", "Ilha6", "Ilha7", "Ilha8", "Ilha9", "Ilha10"},
  Default = "Ilha2",
  Callback = function(Value)
    print(Value)
    end
})

local ServerInvite = AddDiscordInvite(Tab1, {
  Name = "DarkMoonHub Community",
  Description = "Join our discord community to receive information about the next update",
  Logo = "10734897102",
  Invite = "https://discord.gg/YDXM43cBU6",
})
