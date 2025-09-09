local input_service = game:GetService("UserInputService")
local replicatclient = game:GetService("ReplicatedStorage")
local http_sv = game:GetService("HttpService")
local run_service = game:GetService("RunService")
local input_modular = script.Parent

type fixed_setting = {
	scale_multi: number;
	image_enabled: boolean;
	button_color: Color3;
	button_text: string;
	button_text_font: Font;
	button_text_weight: Enum.FontWeight;
	button_transparency: number;
	button_image_id: string;
	button_image_transparency: number;
	button_image_color: Color3;
}

type fixed_val = {
	position_set: UDim2;
}

local signal_class = require(input_modular.library.Signal)
local janitor = require(input_modular.library.Janitor)

local id = input_modular.id

local fixed = {}

local events = {}
local runtime_storage = {}

--[[
	Creates a fixed button
	Identical to TextButton and ImageButton, stops the function even if the touch pos is outside the bound
]]
function fixed.create(container: ScreenGui, zone: Frame, pos: UDim2, scale: number)
	if not container:IsA("ScreenGui") then error("The only GUI type supported is ScreenGui, others than BillboardGUI or SurfaceGui cannot return actual pos of on-screen") end
	if container == nil then 
		error("input_src requires you to provide container, The container it requires is ScreenGUI") 
	elseif container ~= nil and zone == nil then
		error("You need a zone frame to run this, zone is used to handle inputend") 
	end
	
	local self = setmetatable({}, fixed)
	
	local pressed = false
	local touched_id = nil
	
	self.jan_j = janitor.new()

	self.fixed_settings = {
		scale_multi = 1;
		image_enabled = false;
		button_color = Color3.new(0, 0, 0);
		button_text = "Button";
		button_text_font = Enum.Font.RobotoCondensed;
		button_text_weight = Enum.FontWeight.Bold;
		button_transparency = 0.45;
		button_image_id = "";
		button_image_transparency = 1;
		button_image_color = Color3.new(1, 1, 1);
	} :: fixed_setting
	id.Value += 1
	
	self.info = {
		input_id = id.Value;
		input_type = "Fixed";
	}

	self.fixed_value_set = {
		position_set = pos
	} :: fixed_val

	self.fixed_inputbegin = signal_class.new()
	self.fixed_inputend = signal_class.new()
	local fixed_src = input_modular.fixed:Clone()
	fixed_src.Parent = container
	fixed_src:SetAttribute("input_type", self.info.input_type)
	
	--[[
		Toggles the visibility whether or not you can show and disable the input during hidden
	]]
	function self:toggle_visibility(bool)
		local src = fixed_src
		src.Visible = bool
	end


	--[[
		Deletes your input after it's no longer in use, This must be called since Destroying doesn't guarantee the deletions
	]]
	function self:delete()
		self.jan_j:Destroy()
	end
	
	function self:update_preference()
		local src: Frame = fixed_src
		
		src.Size = UDim2.fromOffset(src.Size.X.Offset * self.fixed_settings.scale_multi, src.Size.Y.Offset * self.fixed_settings.scale_multi)
		src.BackgroundColor3 = self.fixed_settings.button_color
		src.Position = self.fixed_value_set.position_set
		src.BackgroundTransparency = self.fixed_settings.button_transparency
		src.txt.Text = self.fixed_settings.button_text
		src.txt.Font = self.fixed_settings.button_text_font
		src.txt.FontFace.Weight = self.fixed_settings.button_text_weight
		src.zone_image.Image = self.fixed_settings.button_image_id
		src.Position = self.fixed_value_set.position_set

		if self.fixed_settings.image_enabled == true then
			src.BackgroundTransparency = 1
			src.zone_image.Visible = self.fixed_settings.image_enabled
			src.zone_image.Image = self.fixed_settings.button_image_id
			src.zone_image.ImageTransparency = self.fixed_settings.button_image_transparency;
			src.zone_image.ImageColor3 = self.fixed_settings.button_image_color
		else
			src.BackgroundTransparency = self.fixed_settings.button_transparency
			src.zone_image.Visible = self.fixed_settings.image_enabled
			src.zone_image.Image = self.fixed_settings.button_image_id
			src.zone_image.ImageTransparency = self.fixed_settings.button_image_transparency;
			src.zone_image.ImageColor3 = self.fixed_settings.button_image_color
		end
	end
	
	fixed_src.Position = pos
	events[self.info.input_id.."_inputbegin"] = fixed_src.InputBegan:Connect(function(inputOBJ)
		if inputOBJ.UserInputType == Enum.UserInputType.Touch and inputOBJ.UserInputState == Enum.UserInputState.Begin and not pressed and fixed_src.Visible == true and touched_id == nil then
			pressed = true
			inputOBJ:SetAttribute("touch_id", http_sv:GenerateGUID(false))
			touched_id = inputOBJ:GetAttribute("touch_id")
			self.fixed_inputbegin:Fire()
		end
	end)

	events[self.info.input_id.."_inputend"] = input_service.InputEnded:Connect(function(inputOBJ)
		local matched_id = inputOBJ:GetAttribute("touch_id")
		if touched_id ~= matched_id then return end
		
		if inputOBJ.UserInputType == Enum.UserInputType.Touch and inputOBJ.UserInputState == Enum.UserInputState.End and pressed or inputOBJ.UserInputType == Enum.UserInputType.MouseMovement and inputOBJ.UserInputState == Enum.UserInputState.End and pressed and touched_id ~= nil and touched_id == matched_id then
			pressed = false
			touched_id = nil
			self.fixed_inputend:Fire()
		end
	end)
	
	self.jan_j:Add(events[self.info.input_id.."_inputbegin"], "Disconnect")
	self.jan_j:Add(events[self.info.input_id.."_inputend"], "Disconnect")
	self.jan_j:Add(self.fixed_inputbegin, "DisconnectAll")
	self.jan_j:Add(self.fixed_inputend, "DisconnectAll")
	self.jan_j:Add(fixed_src, "Destroy")
	
	return self
end


return fixed
