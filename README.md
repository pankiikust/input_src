# input_src
a mobile controls made alternative to CAS

input_src is a mobile controls input tool that focuses on fixing it's horrible controls roblox offers to ContextActionService when turning mobile buttons parameters on, input_src's goal is to offer a pretty much quicker and better controls that none other than input_src can do, making it rich-like for compatibility without having the need to test by your phone, additionally it also offers a way to customize your appearance which can be done directly and call the update method.

# DISCLAIMER 
Because the code written is entirely snake_case, if you wish to stylize within the standards, you are allowed to take this and modify it in your ways, as mentioned earlier in some of my devforum posts, I don't really like following the guides as it gets pretty confusing for me when I can't tell the differences between actual API from roblox and Custom ones, and lastly you should be aware that while this is intentionally an open source tool, codes can come in a messy structure or in some line where it's unnecessary or straight out impractical here

# INSTALLATION 
To install input_src for your game, get it from the marketplace or the GitHub page on the release sections, note that there is no Wally support or Rojo as this was written built-in the studio directly, I'm not familiar with those and it's only my first tool released for the first time.

Once obtained, place the module in anywhere that client can access, if it's inside a server, you won't be able to find it with LocalScript

# ![API]!

```luau
input_src.create_inputs(runtime_name: string, input_type: string, pos: Udim2, scale_multi: number, options)
```

### Creates the input with runtime name and input type
runtime_name: string - the name of input you should call, This is similar to BindAction's first arg

input_type: string - (JOYSTICK_ , DYNAMIC_ and FIXED_) joy stick is self explanatory, Dynamic moves your button positioned at your tap and fixed remains in one position without moving anywhere

pos: Udim2 - Specifies where your position should be at, can use both Scale and Offset

scale_multi: number - Multiplies the scale of how much should it be, similar to the UIScale and scaling uses offset (scale will squeeze it)

options - options, basically options for the specified input type, each input type has its own settings that works in certain cases, refer to "ARGUMENT LIST" to see available options for each

## __METHODS
```luau
input_src:relocate_input(runtime_name: string, pos: UDim2)
```
Moves your input UI position with specified UDim2 scale or offset

runtime_name: string - Existing input created from `create_inputs` API, This field is Case Sensitive

pos: UDim2 - Position of where it should go to
__________

```luau
input_src:scale(scale_num: number)
```
Rescales the input UI, There is no UDim2 and this is only made for the Joystick input

scale_num: number - The number of the scale, identical to UIScale

----------

```luau
input_src:edit_appearance(properties)
```
Edits it's appearance of the input such as images of the button, This doesn't contain scale and position because it is separated as a method

properties: a set of properties that are available for each inputs, note that these are not related to the actual ui elements properties roblox has been giving

_________

## __EVENTS

```luau 
input_src.joystick_inputbegin:Connect(function(magnitude, direction)
```
Connects the joystick input event that fires only one time after they began to press, This is a custom event and is identical to UIS InputBegan but without input object required

parameters: magnitude refers to how far your pos between the center and the tap pos is, 

{There is no required arguments for this, these are optional}

__________

```luau
input_src.deadzone_exited:Connect(function()
```
Connects the event when input pos has exited the dead zone for JOYSTICK_, This fires only one each time they're outside (FIXED_ and DYNAMIC_ will not fire it since they remain in one position)

{There is no required arguments for this}

__________

```luau
input_src.normal_inputbegin:Connect(function()
```
Connects the Input that fires when it began to press, This is only available to FIXED_ and DYNAMIC_ as they both don't have a limited and dead zone, for JOYSTICK_ inputbegin, refer to joystick_inputbegin

{There is no required arguments for this}

__________

```luau
input_src.joystick_inputstopped:Connect(function()
```

Connects the InputStopped after touch released, identical to regular UIS InputEnded but automatically reset to where it was before.

{There is no required arguments for this}

_______________

# CREDITS
## stravant - Signal module
## ReelPlum - border limiter (from the Plum's Minimap)
## HowManySmall - janitor to clean up

