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

----------

```luau
input_src:update_preference()
```
Updates the preference after changed from the available settings, it only applies how the controls look
because the stored setting is in a table of your created input without applying, you won't see the changes immediately

__________

```luau
input_src:toggle_visibility(bool)
```

Toggles whenever you want the input to show or be hidden, instead of trying to destroy and recreate, you can use this instead to hide if the inputs are not supposed to be shown, if you feel like the input is no longer usable or you want to destroy it, call `kill_input()` to get a rid of it

----------
```luau
input_src:kill_input()
```
Destroys the input after no longer used, you will no longer be able to access it after this has been called

__________
## __EVENTS

```luau 
input_src.joystick_inputbegin:Connect(function()
```
Connects the joystick input event that fires only one time after they began to press, This is a custom event and is identical to UIS InputBegan but without input object required

{There is no required arguments for this, these are optional}

__________

```luau
input_src.joystick_deadzone_triggered:Connect(function(exited)
```
Connects the event when input pos has exited the dead zone for `joystick`, This fires only one each time they're outside (`fixed` and `dynamic` will not fire it since they don't have limitations in traversing)

{exited = whenever the dot reached the edge of the zone, returns true or false}

__________

```luau
input_src.normal_inputbegin:Connect(function()
```
Connects the Input that fires when it began to press, This is only available to `fixed` and `dynamic` as they both don't have a limited and dead zone, for JOYSTICK_ inputbegin, refer to joystick_inputbegin

{There is no returned arguments for this}

__________

```luau
input_src.joystick_inputend:Connect(function()
```

Connects the InputEnd after touch released, identical to regular UIS InputEnded but automatically reset to where it was before.

{There is no returned arguments for this}

_______________

# CREDITS
stravant - Signal module
ReelPlum - border limiter (from the Plum's Minimap)
HowManySmall - janitor to clean up

