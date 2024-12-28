# DarkLib V2
## **TIPS**
- Where it says  'Icon = "Id"' you can put either just the ID or "rbxassetid://id" both ways work.

- Where it also says ' Name = "Text" ' you can put ' Text = "Text" ' both ways work.

## LoadString (REQUIRED)
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/Darkmoonxhubscript/DarkLibV2/refs/heads/main/Source.luau"))()
```
```luau
--[[
Loads The Library
]]
```
## Make a Window
```luau
local Window = MakeWindow({Title = "DarkMoonHub Library"})
```
```luau
--[[
Title ="DarkMoonHub Library" >> UI Title (String)
]]
```
## Create Notification
```luau
local Notify = NewNotify({
Title = "Notification Title",
Description = "Notification Description.",
Time = 10
})
```
```luau
--[[
Title = "Notification Title" >> Notification Title That Will Show (String)
Description = "Notification Description." >> Notification Description That Will Show (String)
Time = 10 >> Notification Duration (Number)
]]
```
## Create Tab
```luau
local Tab1 = NewTab({Name = "Tab", Icon = "IconName"})
```
```luau
--[[
Name = "TabName" >> UI Button TabName (String)
Icon = "IconName" >> Tab Icon, No Need Put Id, You can get Icons In:.
https://github.com/Darkmoonxhubscript/DarkLibV2/blob/main/Icons.luau
]]
```
## Add a Section
```luau
local Section1 = AddSection(Tab1, {Name = "Section"})
```
```luau
--[[
Name = "Text" >> Text Of Section (String)
]]
```
## Add a Button
```luau
local Button1 = AddButton(Tab1, {
  Name = "Button",
  Callback = function()
  print("Clicked")
  end
})

```
```luau
--[[
Name = "Text" >> Button Text (String)
Callback = function(Value) -button press function
-- function here
end --end function
]]
```
## Add a Toggle
```luau
local Toggle1 = AddToggle(Tab1, {
  Name = "Toggle",
  Default = false,
  Callback = function(Value)
  print(Value)
  end
})
```
```luau
--[[
AddToggle >> Normal Toggle
AddSquareToggle >> Square Toggle
Name = "Toggle" >> Toggle Text (String)
Default = false >> Defines whether the toggle starts out on or off (Bool)
Callback = function(Value) --Value = toggle state
-- toggle function here
end
]]
```
## Add a TextBox
```luau
local TextBox1 = AddTextBox(Tab1, {
  Name = "TextBox",
  Default = "Default Text",
  AutoClear = false,
  PlaceHolder = "Input Text Here",
  Callback = function(Value)
    print(Value)
    end
})
```
```luau
--[[
Name = "TextBox" >> TextBox Name (String)
Default = "Default Text" >> TextBox Default Text (String)
AutoClear = false >> Auto Clear Text When Input (Bool)
PlaceHolder = "Input Text Here" >> PlaceHolder Text From TextBox(String)
Callback = function(Value) --Value = TextBox Text
--Function Here
end
]]
```
## Add a TextLabel
```luau
local TextLabel1 = AddTextLabel(Tab1, {
  Name = "My Text"
})
```
```luau
--[[
Name = "My Text" >> TextLabel Text (String)
]]
```
## Add a Paragraph
```luau
local Paragraph1 = AddParagraph(Tab1, {
  Name = "My Title",
  SubText = "My Paragraph"
})
```
```luau
--[[
Name = "My Title" >> Paragraph Title (String)
SubText = "My Paragraph" >> Paragraph Text (String)
]]
```
## Add a Slider
```luau
local Slider1 = AddSlider(Tab1, {
  Name = "Slider",
  Min = 0,
  Max = 100,
  Increase = 10,
  Default = 20,
  Callback = function(Value)
    print(Value)
    end
})
```
```luau
--[[
Name = "Slider" >> Slider Text (String(
Min = 0 >> Min Slider Value (Number)
Max = 100 >> Max Slider Value (Number)
Increase = 10 >> Value To Increase (Number)
Default = 20 >> Default Slider Value (Number)
Callback = function(Value) -- Value = Slider Value
--function here
end
]]
```
## Add a Dropdown
```luau
local Dropdown1 = AddDropDown(Tab1, {
  Name = "Dropdown",
  Options = {"1", "2", "3", "4", "5", "6", "7"},
  Default = "1",
  Callback = function(Value)
    print(Value)
    end
})
```
```luau
--[[
Name = "Dropdown" >> Dropdown Text (String)
Options = {"1", "2", "3", "4", "5", "6", "7"} >> Options That Can Be Selected, you can add more. (String Table)
Default = "1" >> Initial Selected Option (String)
Callback = function(Value) -- Value = Selected Option Name
-- Function Here
end
]]
```
# EXTRA
## Add a Minimize Button
```luau
AddMinimizeButton({Icon = "10734897102"})
```
```luau
--[[
Icon = "Id" >> Button Image Id (String)
You Can Get Ids in:
https://github.com/Darkmoonxhubscript/DarkLibV2/blob/main/Icons.luau or Use Custom Icon Id
]]
```
## Add a Server Invite
```luau
local ServerInvite = AddDiscordInvite(Tab1, {
  Name = "You Server Community",
  Description = "Join our discord community to receive information about the next update",
  Logo = "Id",
  Invite = "https://discord.gg/ServerCode",
})
```
```luau
--[[
Name = "Name" >> Server Name (String)
Description = "Description" >> Inform the person why they should join (String)
Logo = "Id" >> Replace "Id" with your server icon ID (String)
Invite = "https://discord.gg/ServerCode" >> Replace "ServerCode" with your server code. (String)
]]
```

## Add A Float Toggle
```luau
AddFloatToggle({
    Name = "Toggle Name",
    Callback = function(Value)
      print(Value)
      end
  })
```
```luau
--[[
Name = "Toggle Name" >> Float Toggle Text (String)
Callback = function(Value) = Value Toggle State
      --Function Here
      end
]]
```

