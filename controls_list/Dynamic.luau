local input_service = game:GetService("UserInputService")
local replicatclient = game:GetService("ReplicatedStorage")
local run_service = game:GetService("RunService")
local http_sv = game:GetService("HttpService")
local input_modular = script.Parent

type dynamic_setting = {
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

type dynamic_val = {
	default_offsetx: number;
	default_offsety: number;
	position_set: UDim2;
}

local signal_class = require(input_modular.library.Signal)
local janitor = require(input_modular.library.Janitor)

local id = input_modular.id

local dynamic = {}

local events = {}
local runtime_storage = {}

--[[
	Creates a fixed button
	Instead of being in a fixed position, it follows your tap position
]]
function dynamic.create(container: ScreenGui, zone: Frame, pos: UDim2, scale: number)
	if not container:IsA("ScreenGui") then error("The only GUI type supported is ScreenGui, others than BillboardGUI or SurfaceGui cannot return actual pos of on-screen") end
	if container == nil then 
		error("input_src requires you to provide container, The container it requires is ScreenGUI") 
	elseif container ~= nil and zone == nil then
		error("You need a zone frame to run this, zone is used to handle inputend") 
	end
	
	local self = setmetatable({}, dynamic)
	
	local pressed = false
	local touched_id = nil
	
	self.jan_j = janitor.new()

	self.dynamic_settings = {
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
	} :: dynamic_setting
	id.Value += 1
	
	self.info = {
		input_id = id.Value;
		input_type = "Dynamic";
	}

	self.dynamic_value_set = {
		default_offsetx = 40, --these shouldn't be changed unless your input is not at the center with touch pos
		default_offsety = 50, --these shouldn't be changed unless your input is not at the center with touch pos
		position_set = pos
	} :: dynamic_val

	self.dynamic_inputbegin = signal_class.new()
	self.dynamic_inputend = signal_class.new()
	local dynamic_src = input_modular.dynamic:Clone()
	dynamic_src.Parent = container
	dynamic_src:SetAttribute("input_type", self.info.input_type)

	--runtime_storage[self.info.input_id] = dynamic_src
	
	function self:update_preference()
		local src: Frame = dynamic_src
		self.dynamic_value_set.default_offsetx = self.dynamic_value_set.default_offsetx
		self.dynamic_value_set.default_offsety = self.dynamic_value_set.default_offsety
		
		src.Size = UDim2.fromOffset(src.Size.X.Offset * self.dynamic_settings.scale_multi, src.Size.Y.Offset * self.dynamic_settings.scale_multi)
		src.BackgroundColor3 = self.dynamic_settings.button_color
		src.BackgroundTransparency = self.dynamic_settings.button_transparency
		src.txt.Text = self.dynamic_settings.button_text
		src.txt.Font = self.dynamic_settings.button_text_font
		src.txt.FontFace.Weight = self.dynamic_settings.button_text_weight
		src.zone_image.Image = self.dynamic_settings.button_image_id
		src.Position = self.dynamic_value_set.position_set

		if self.dynamic_settings.image_enabled == true then
			src.BackgroundTransparency = 1
			src.zone_image.Visible = self.dynamic_settings.image_enabled
			src.zone_image.Image = self.dynamic_settings.button_image_id
			src.zone_image.ImageTransparency = self.dynamic_settings.button_image_transparency;
			src.zone_image.ImageColor3 = self.dynamic_settings.button_image_color
		else
			src.zone_image.Visible = self.dynamic_settings.image_enabled
			src.zone_image.Image = self.dynamic_settings.button_image_id
			src.zone_image.ImageTransparency = self.dynamic_settings.button_image_transparency;
			src.zone_image.ImageColor3 = self.dynamic_settings.button_image_color
		end
	end
	
	dynamic_src.Position = pos
	events[self.info.input_id.."_inputbegin"] = dynamic_src.InputBegan:Connect(function(inputOBJ)
		if inputOBJ.UserInputType == Enum.UserInputType.Touch and inputOBJ.UserInputState == Enum.UserInputState.Begin and not pressed and dynamic_src.Visible == true and touched_id == nil then
			pressed = true
			self.dynamic_inputbegin:Fire()
			inputOBJ:SetAttribute("touch_id", http_sv:GenerateGUID(false))
			touched_id = inputOBJ:GetAttribute("touch_id")
			run_service:BindToRenderStep("hold_input"..tostring(self.info.input_id), Enum.RenderPriority.Input.Value, function()
				dynamic_src.Position = UDim2.fromOffset(inputOBJ.Position.X + self.dynamic_value_set.default_offsetx, inputOBJ.Position.Y + self.dynamic_value_set.default_offsety) --oml pls sav me
			end)
		end
	end)

	events[self.info.input_id.."_inputend"] = zone.InputEnded:Connect(function(inputOBJ)
		local matched_id = inputOBJ:GetAttribute("touch_id")
		
		if touched_id ~= matched_id then return end
		
		if inputOBJ.UserInputType == Enum.UserInputType.Touch and inputOBJ.UserInputState == Enum.UserInputState.End and pressed or inputOBJ.UserInputType == Enum.UserInputType.MouseMovement and inputOBJ.UserInputState == Enum.UserInputState.End and pressed and touched_id ~= nil and touched_id == matched_id then
			pressed = false
			self.dynamic_inputend:Fire()
			touched_id = nil
			run_service:UnbindFromRenderStep("hold_input"..tostring(self.info.input_id))
			dynamic_src.Position = pos
		end
	end)
	
	self.jan_j:Add(events[self.info.input_id.."_inputbegin"], "Disconnect")
	self.jan_j:Add(events[self.info.input_id.."_inputend"], "Disconnect")
	self.jan_j:Add(self.dynamic_inputbegin, "DisconnectAll")
	self.jan_j:Add(self.dynamic_inputend, "DisconnectAll")
	self.jan_j:Add(dynamic_src, "Destroy")
	
	return self
end




--[[
	Performs a deletion and cleanup of the object
]]


return dynamic
