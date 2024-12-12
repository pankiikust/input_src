--						Copyright (c) 2024 Paskii

--	Permission is hereby granted, free of charge, to any person obtaining a copy
--	of this software and associated documentation files (the "Software"), to deal
--	in the Software without restriction, including without limitation the rights
--	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--	copies of the Software, and to permit persons to whom the Software is
--	furnished to do so, subject to the following conditions:

--	The above copyright notice and this permission notice shall be included in all
--	copies or substantial portions of the Software.

--		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--	SOFTWARE.


---------------------------------------------------------------------------------

-- input_src's goal is to offer a pretty much quicker and better controls that none other than input_src can do
-- making it rich-like for compatibility without having the need to test by your phone, additionally 
-- it also offers a way to customize your appearance which can be done by calling the update method.


-- Most of the code base is moved separately to each of their own ModuleScript
-- this one simply holds all the input modules listed in [input_src > (input name)]

-- hav fun footkickin the most awful practice codebase lol!
local input_src = {}

local replicatclient = game:GetService("ReplicatedStorage")
local input_modular = script

local joystick_modular = require(input_modular.Joystick)
local dynamic_modular = require(input_modular.Dynamic)
local fixed_modular = require(input_modular.Fixed)

--src
input_src.Joystick = joystick_modular
input_src.Dynamic = dynamic_modular
input_src.Fixed = fixed_modular

--code listed below are commented cuz it's messy as hel to struct and see autocomplete flooding the list

--local events = { --events table for handling such connections
--	["joystick_connections"] = {},
--	["dynamic_connections"] = {},
--	["fixed_connections"] = {}
--}

--type joystick_setting = {
--	scale_multi: number;
--	image_enabled: boolean;
--	disable_deadzone_visual: boolean;
--	zone_color: Color3;
--	zone_transparency: number;
--	dot_size: number;
--	dot_color: Color3;
--	dot_transparency: number;
--	zone_image_id: string;
--	dot_image_id: string;
--	dot_image_transparency: number;
--	dot_image_color: Color3;
--	zone_image_transparency: number;
--	zone_image_color: Color3;
--}

--type dynamic_setting = {
--	scale_multi: number;
--	image_enabled: boolean;
--	button_color: Color3;
--	button_text: string;
--	button_text_font: Font;
--	button_text_weight: Enum.FontWeight;
--	button_transparency: number;
--	button_image_id: string;
--	button_image_transparency: number;
--	button_image_color: Color3;
--}

--local runtime_storage = { --This is where all things stores
--	["joystick"] = {},
--	["dynamic"] = {},
--	["fixed"] = {}
--}


--[[
	Adds the border to the ScreenGUI
	existing_zone is optional if you provided a single frame filled on screen
]]
--function input_src.init_border(container: ScreenGui, existing_zone: Frame)

--	local self = setmetatable({}, input_src)
--	local zone

--	local existin = container:FindFirstChild(existing_zone.Name)
--	if not existin or existing_zone == nil then
--		zone = input_modular.zone:Clone()
--		zone.Parent = container
--	elseif existin then
--		zone = existin
--	end



--	--if input_type == "fixed" then
--	--	local pressed = false

--	--	self.fixed_settings = {
--	--		scale_multi = 1;
--	--		image_enabled = false;
--	--		button_color = Color3.new(0, 0, 0);
--	--		button_text = "Button";
--	--		button_text_font = Enum.Font.RobotoCondensed;
--	--		button_text_weight = Enum.FontWeight.Bold;
--	--		button_transparency = 0.45;
--	--		button_image_id = "";
--	--		button_image_transparency = 1;
--	--		button_image_color = Color3.new(1, 1, 1);
--	--	} :: dynamic_setting -- you'll notice the same "type" cuz dynamic and fixed are the same input types except different
--	--	id += 1

--	--	self.info = {
--	--		input_id = id;
--	--		input_type = input_type;
--	--	}

--	--	table.freeze(self.info)

--	--	self.fixed_inputbegin = signal_class.new()
--	--	self.fixed_inputend = signal_class.new()
--	--	local fixed_src = input_modular.fixed:Clone()
--	--	fixed_src.Parent = container
--	--	fixed_src:SetAttribute("input_type", self.info.input_type)

--	--	if self.fixed_settings.image_enabled then
--	--		fixed_src.BackgroundTransparency = 1
--	--		fixed_src.txt.Text = ""
--	--		fixed_src.zone_image.Visible = self.fixed_settings.image_enabled
--	--	end
--	--	fixed_src.Position = pos
--	--	events.fixed_connections[id.."_inputbegin"] = fixed_src.InputBegan:Connect(function(inputOBJ)
--	--		if inputOBJ.UserInputType == Enum.UserInputType.Touch and inputOBJ.UserInputState == Enum.UserInputState.Begin and not pressed then
--	--			pressed = true
--	--			self.fixed_inputbegin:Fire()
--	--		end
--	--	end)

--	--	events.dynamic_connections[id.."_inputend"] = zone.InputEnded:Connect(function(inputOBJ)
--	--		if inputOBJ.UserInputType == Enum.UserInputType.Touch and inputOBJ.UserInputState == Enum.UserInputState.End and pressed then
--	--			pressed = false
--	--			self.fixed_inputend:Fire()
--	--		end
--	--	end)

--	--	self.jan_j:Add(events.fixed_connections[id.."_inputbegin"], "Disconnect")
--	--	self.jan_j:Add(events.fixed_connections[id.."_inputend"], "Disconnect")
--	--	self.jan_j:Add(self.fixed_inputbegin, "DisconnectAll")
--	--	self.jan_j:Add(self.fixed_inputend, "DisconnectAll")
--	--	self.jan_j:Add(fixed_src, "Destroy")
--	--end

--	return container, zone
--end

--function input_src:toggle_visibility(bool) : "Toggles the visibility, disables the input if hidden"
--	local src = runtime_storage[self.info.input_type][self.info.input_id]
--	src.Visible = bool
--end


--function input_src:update_preference() 
--	local src: Frame = runtime_storage[self.info.input_type][self.info.input_id]
    
--	if src:GetAttribute("input_type") == "joystick" then
--		src.Size = UDim2.fromOffset(src.Size.X.Offset * self.joystick_settings.scale_multi, src.Size.Y.Offset * self.joystick_settings.scale_multi)
--		default_offset = default_offset * self.joystick_settings.scale_multi
--		src.BackgroundColor3 = self.joystick_settings.zone_color
--		src.BackgroundTransparency = self.joystick_settings.zone_transparency
--		src.dot.BackgroundColor3 = self.joystick_settings.dot_color
--		src.dot.Size = UDim2.fromOffset(src.dot.Size.X.Offset * self.joystick_settings.dot_size, src.dot.Size.Y.Offset * self.joystick_settings.dot_size)
--		src.deadzone.Size = UDim2.fromOffset(self.joystick_value_set.deadzone_set * 2, self.joystick_value_set.deadzone_set * 2)

--		if self.joystick_settings.disable_deadzone_visual == true then
--			src.deadzone.Visible = false
--		end

--		if self.joystick_settings.image_enabled == true then
--			src.dot.dot_image.Visible = self.joystick_settings.image_enabled
--			src.zone_image.Visible = self.joystick_settings.image_enabled
--			src.BackgroundTransparency = 1
--			src.dot.BackgroundTransparency = 1
--			src.zone_image.Image = self.joystick_settings.zone_image_id
--			src.dot.dot_image.Image = self.joystick_settings.dot_image_id
--			src.zone_image.Visible = self.joystick_settings.image_enabled
--			src.zone_image.ImageTransparency = self.joystick_settings.zone_image_transparency
--			src.dot.dot_image.ImageTransparency = self.joystick_settings.dot_image_transparency
--		else
--			src.dot.dot_image.Visible = self.joystick_settings.image_enabled
--			src.zone_image.Visible = self.joystick_settings.image_enabled
--			src.BackgroundTransparency = self.joystick_settings.zone_transparency
--			src.dot.BackgroundTransparency = self.joystick_settings.dot_transparency
--			src.zone_image.Image = "rbxassetid://5713982324"
--			src.dot.dot_image.Image = "rbxassetid://5713982324"
--			src.zone_image.Visible = self.joystick_settings.image_enabled
--			src.zone_image.ImageTransparency = self.joystick_settings.zone_image_transparency
--			src.dot.dot_image.ImageTransparency = self.joystick_settings.dot_image_transparency
--		end


--		if self.joystick_settings.image_enabled == false and (self.joystick_settings.zone_transparency <= 1 or self.joystick_settings.dot_transparency <= 1) then
--			src.BackgroundTransparency = 1
--			src.dot.BackgroundTransparency = 1
--		end
--	end

--	if src:GetAttribute("input_type") == "dynamic" or src:GetAttribute("input_type") == "fixed" then
--		src.Size = UDim2.fromOffset(src.Size.X.Offset * self.dynamic_settings.scale_multi, src.Size.Y.Offset * self.dynamic_settings.scale_multi)
--		src.BackgroundColor3 = self.dynamic_settings.button_color
--		src.BackgroundTransparency = self.dynamic_settings.button_transparency
--		src.txt.Text = self.dynamic_settings.button_text
--		src.txt.Font = self.dynamic_settings.button_text_font
--		src.txt.FontStyle = self.dynamic_settings.button_text_weight
--		src.zone_image.Image = self.dynamic_settings.button_image_id

--		if self.dynamic_settings.image_enabled == true then
--			src.BackgroundTransparency = 1
--			src.zone_image.Visible = self.dynamic_settings.image_enabled
--			src.zone_image.Image = self.dynamic_settings.button_image_id
--			src.zone_image.BackgroundTransparency = 1;
--			src.zone_image.ImageTransparency = 0;
--		end
--	end
--end


return input_src
