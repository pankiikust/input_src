local input_service = game:GetService("UserInputService")
local replicatclient = game:GetService("ReplicatedStorage")
local run_service = game:GetService("RunService")
local http_sv = game:GetService("HttpService")
local input_modular = script.Parent

type joystick_setting = {
	scale_multi: number;
	image_enabled: boolean;
	disable_deadzone_visual: boolean;
	zone_color: Color3;
	zone_transparency: number;
	dot_size: number;
	dot_color: Color3;
	dot_transparency: number;
	zone_image_id: string;
	dot_image_id: string;
	dot_image_transparency: number;
	dot_image_color: Color3;
	zone_image_transparency: number;
	zone_image_color: Color3;
}

type info = {
	input_id: number;
	input_type: Joystick;
	absolute_magnitude: number;
}

type output = {
	direction: Vector2;
	angle: number;
	magnitude: number;
}


local limit_bord = require(input_modular.library.BorderSnap)
local signal_class = require(input_modular.library.Signal)
local janitor = require(input_modular.library.Janitor)

local default_offset = 73 --for joystick, change this if ui does not center on touch
local id = input_modular.id

local joystick = {}

local events = {}
local runtime_storage = {}

--[[
	Creates a circular based input
	comes with a dot and deadzone that triggers if a dot exited
]]
function joystick.create(container: ScreenGui, zone: Frame, pos: UDim2, scale: number)
	if not container:IsA("ScreenGui") then error("The only GUI type supported is ScreenGui, others than BillboardGUI or SurfaceGui cannot return actual pos of on-screen") end
	if container == nil then 
		error("input_src requires you to provide container, The container it requires is ScreenGUI") 
	elseif container ~= nil and zone == nil then
		error("You need a zone frame to run this, zone is used to handle inputend") 
	end
	
	
	local self = setmetatable({}, joystick)
	
	self.jan_j = janitor.new()
	self.pressed = false
	
	local deb = false
	
	self.joystick_settings = {
		scale_multi = 1;
		image_enabled = false;
		disable_deadzone_visual = true;
		zone_color = Color3.new(0,0,0);
		zone_transparency = 0.45;
		dot_size = 1;
		dot_color = Color3.new(1, 1, 1);
		dot_transparency = 0.45;
		zone_image_id = nil;
		dot_image_id = nil;
		dot_image_transparency = 0;
		dot_image_color = Color3.new(1, 1, 1);
		zone_image_transparency = 0;
		zone_image_color = Color3.new(1, 1, 1)
	} :: joystick_setting

	id.Value += 1

	self.joystick_inputbegin = signal_class.new()
	self.joystick_inputend = signal_class.new()
	self.joystick_deadzone_triggered = signal_class.new()

	local ico_zone = input_modular.ico_zone:Clone()
	ico_zone.Parent = container
	
	local touched_id = nil
	local deadzone_fired = false

	self.info = {
		input_id = id.Value;
		input_type = "Joystick";
		absolute_magnitude = ico_zone.Size.X.Offset/2;
	} :: info
	
	self.output = {
		direction = Vector2.new(0, 0);
		angle = 0;
		magnitude = ico_zone.Size.X.Offset/2;
	}
	
	self.joystick_value_set = {
		deadzone_set = 30,
		default_offset = 73,
		magnitude_scale = 20,
	}
	ico_zone:SetAttribute("input_type", self.info.input_type)


	ico_zone.Position = pos or UDim2.fromScale(0.744, 0.684)
	ico_zone.Size = UDim2.fromOffset(ico_zone.Size.X.Offset * scale, ico_zone.Size.Y.Offset * scale)
	ico_zone.deadzone.Size = UDim2.fromOffset(self.joystick_value_set.deadzone_set * 2, self.joystick_value_set.deadzone_set * 2)
	if self.joystick_settings.image_enabled == true then
		ico_zone.dot.dot_image.Visible = self.joystick_settings.image_enabled
		ico_zone.zone_image.Visible = self.joystick_settings.image_enabled
		ico_zone.BackgroundTransparency = 1
		ico_zone.dot.BackgroundTransparency = 1
		ico_zone.zone_image.Visible = self.joystick_settings.image_enabled
		ico_zone.zone_image.ImageTransparency = self.joystick_settings.zone_image_transparency
		ico_zone.dot.dot_image.ImageTransparency = self.joystick_settings.dot_image_transparency
	end
	
	--[[
		Updates the theme made from `joystick_settings`
	]]
	function self:update_preference()
		local src: Frame = ico_zone
		
		src.Size = UDim2.fromOffset(src.Size.X.Offset * self.joystick_settings.scale_multi, src.Size.Y.Offset * self.joystick_settings.scale_multi)
		self.joystick_value_set.default_offset = self.joystick_value_set.default_offset * self.joystick_settings.scale_multi
		src.BackgroundColor3 = self.joystick_settings.zone_color
		src.BackgroundTransparency = self.joystick_settings.zone_transparency
		src.dot.BackgroundColor3 = self.joystick_settings.dot_color
		src.dot.Size = UDim2.fromOffset(src.dot.Size.X.Offset * self.joystick_settings.dot_size, src.dot.Size.Y.Offset * self.joystick_settings.dot_size)
		src.deadzone.Size = UDim2.fromOffset(self.joystick_value_set.deadzone_set * 2, self.joystick_value_set.deadzone_set * 2)

		if self.joystick_settings.disable_deadzone_visual == true then
			src.deadzone.Visible = false
		end

		if self.joystick_settings.image_enabled == true then
			src.dot.dot_image.Visible = self.joystick_settings.image_enabled
			src.zone_image.Visible = self.joystick_settings.image_enabled
			src.BackgroundTransparency = 1
			src.dot.BackgroundTransparency = 1
			src.zone_image.Image = self.joystick_settings.zone_image_id or "rbxassetid://102395683953835"
			src.dot.dot_image.Image = self.joystick_settings.dot_image_id or "rbxassetid://139947822294897"
			src.zone_image.Visible = self.joystick_settings.image_enabled
			src.zone_image.ImageTransparency = self.joystick_settings.zone_image_transparency
			src.dot.dot_image.ImageTransparency = self.joystick_settings.dot_image_transparency
		else
			src.dot.dot_image.Visible = self.joystick_settings.image_enabled
			src.zone_image.Visible = self.joystick_settings.image_enabled
			src.BackgroundTransparency = self.joystick_settings.zone_transparency
			src.dot.BackgroundTransparency = self.joystick_settings.dot_transparency
			src.zone_image.Image = "rbxassetid://102395683953835"
			src.dot.dot_image.Image = "rbxassetid://139947822294897"
			src.zone_image.Visible = self.joystick_settings.image_enabled
			src.zone_image.ImageTransparency = self.joystick_settings.zone_image_transparency
			src.dot.dot_image.ImageTransparency = self.joystick_settings.dot_image_transparency
		end
		
	end
	
	--[[
		Toggles the visibility whether or not you can show and disable the input during hidden
	]]
	function self:toggle_visibility(bool)
		local src = ico_zone
		src.Visible = bool
	end
	
	--[[
		Moves your input by using UDim2
	]]
	--function self:move_input(pos: UDim2)
		
	--end
	
	
	--[[
		Deletes your input after it's no longer in use, This must be called since Destroying doesn't guarantee the deletions
	]]
	function self:delete()
		self.jan_j:Destroy()
	end

	events[self.info.input_id.."_inputbegin"] = ico_zone.dot.InputBegan:Connect(function(inputOBJ)
		
		if inputOBJ.UserInputType == Enum.UserInputType.Touch and inputOBJ.UserInputState == Enum.UserInputState.Begin and not self.pressed and ico_zone.Visible == true and touched_id == nil then
			self.pressed = true
			inputOBJ:SetAttribute("touch_id", http_sv:GenerateGUID(false))
			touched_id = inputOBJ:GetAttribute("touch_id")
			self.joystick_inputbegin:Fire()

			run_service:BindToRenderStep("hold_input"..tostring(self.info.input_id), Enum.RenderPriority.Input.Value, function(dt)
				local center_pos = Vector2.new(ico_zone.AbsolutePosition.X + ico_zone.AbsoluteSize.X/2, ico_zone.AbsolutePosition.Y + ico_zone.AbsoluteSize.Y/2)
				local relative_pos = Vector2.new(inputOBJ.Position.X - center_pos.X + (self.joystick_value_set.default_offset * scale), inputOBJ.Position.Y - center_pos.Y + (self.joystick_value_set.default_offset * scale))

				local tap_magnitude = (center_pos - Vector2.new(ico_zone.dot.AbsolutePosition.X + ico_zone.dot.AbsoluteSize.X/2, ico_zone.dot.AbsolutePosition.Y + ico_zone.dot.AbsoluteSize.Y/2)).Magnitude
				local unit_src = (center_pos - Vector2.new(inputOBJ.Position.X, inputOBJ.Position.Y)).Unit
				local angle = math.ceil(math.deg(Vector2.yAxis:Angle(unit_src, true)))
				local subtraction_num = 35.859 --dont mind me, it's here cuz i hate math /j

				tap_magnitude = math.clamp(tap_magnitude / subtraction_num * (self.joystick_value_set.magnitude_scale / 2), 0, self.joystick_value_set.magnitude_scale)


				self.output.direction = unit_src
				self.output.magnitude = tap_magnitude
				self.output.angle = angle
				

				relative_pos = limit_bord:ClampToBorder(relative_pos, Vector2.new(ico_zone.AbsoluteSize.X, ico_zone.AbsoluteSize.Y), ico_zone.UICorner.CornerRadius)
				ico_zone.dot.Position = UDim2.fromOffset(relative_pos.X, relative_pos.Y)

				if (center_pos - Vector2.new(inputOBJ.Position.X, inputOBJ.Position.Y)).Magnitude > self.joystick_value_set.deadzone_set and not deadzone_fired then
					deadzone_fired = true
					self.joystick_deadzone_triggered:Fire(true)
				elseif (center_pos - Vector2.new(inputOBJ.Position.X, inputOBJ.Position.Y)).Magnitude < self.joystick_value_set.deadzone_set and deadzone_fired then
					deadzone_fired = false
					self.joystick_deadzone_triggered:Fire(false)
				end

			end)
		end
		
		if inputOBJ.UserInputType == Enum.UserInputType.MouseMovement and inputOBJ.UserInputState == Enum.UserInputState.Begin and not self.pressed and ico_zone.Visible == true and touched_id ~= nil and not deb then
			deb = true
			inputOBJ:SetAttribute("touch_id", touched_id)
		end
	end)
	
	events[self.info.input_id.."_inputend"] = zone.InputEnded:Connect(function(inputOBJ)
		local matched_touch_id = inputOBJ:GetAttribute("touch_id")
		if touched_id ~= matched_touch_id then return end
		
		if inputOBJ.UserInputType == Enum.UserInputType.Touch and inputOBJ.UserInputState == Enum.UserInputState.End and self.pressed and ico_zone.Visible == true and touched_id ~= nil and touched_id == matched_touch_id or inputOBJ.UserInputType == Enum.UserInputType.MouseMovement and inputOBJ.UserInputState == Enum.UserInputState.End and self.pressed and ico_zone.Visible == true then
			self.pressed = false
			touched_id = nil
			
			if deadzone_fired then
				deadzone_fired = false
				self.joystick_deadzone_triggered:Fire(false)
			end
			
			
			
			self.joystick_inputend:Fire()
			run_service:UnbindFromRenderStep("hold_input"..tostring(self.info.input_id))
			ico_zone.dot.Position = UDim2.new(0.5, 0, 0.5, 0)
		end
	end)

	self.jan_j:Add(events[self.info.input_id.."_inputbegin"], "Disconnect")
	self.jan_j:Add(events[self.info.input_id.."_inputend"], "Disconnect")
	self.jan_j:Add(self.joystick_inputbegin, "DisconnectAll")
	self.jan_j:Add(self.joystick_inputend, "DisconnectAll")
	self.jan_j:Add(self.joystick_deadzone_triggered, "DisconnectAll")
	self.jan_j:Add(ico_zone, "Destroy")
	
	return self
end




--[[
	Performs a deletion and cleanup of the object
]]


return joystick
