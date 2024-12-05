# input_src
a mobile controls made for mobile compatibility games 

input_src is a mobile controls input tool that focuses on fixing it's horrible controls roblox offers to ContextActionService when turning mobile buttons parameters on and several naïve solutions, input_src's goal is to offer a pretty much quicker and better controls that none other than input_src can do, making it rich-like for compatibility without having the need to test by your phone, additionally it also offers a way to customize your appearance which can be done directly and call the update method.

# DISCLAIMER 
Because the code written is entirely snake_case, if you wish to stylize within the standards, you are allowed to take this and modify it in your ways, as mentioned earlier in some of my devforum posts, I don't really like following the guides as it gets pretty confusing for me when I can't tell the differences between actual API from roblox and Custom ones, and lastly you should be aware that while this is intentionally an open source tool, codes can come in a messy structure or in some line where it's unnecessary or straight out impractical here

# INSTALLATION 
To install input_src for your game, get it from the marketplace or the GitHub page on the release sections, note that there is no Wally support or Rojo as this was written built-in the studio directly, I'm not familiar with those and it's only my first tool released for the first time.

Once obtained, place the module in anywhere that client can access, if it's inside a server, you won't be able to find it with LocalScript

# ![API]!

```luau
input_src.[input_type].create(...)
```

### Creates the input by using container along with zone provided, it is based on the type you are getting

You can only use 3 types of controls the module offers, The following has

Joystick - Creates a circular input, Joystick or commonly referred as Thumbstick is based on Joystick, it contains deadzone which triggers after out of zone and inside

Dynamic - Creates a fixed button, instead of staying in one position, Dynamic follows your tap position no matter where it goes

Fixed - Creates a fixed button, a plain UI that stays in one position, There is no rendering involved and it's the simplest function ever made.

## __METHODS (obj refers to a created input)
```luau
obj:relocate_input(pos: UDim2)
```
Moves your input UI position with specified UDim2 scale or offset, moving inputs can be useful if you are implementing a keybind editor

pos: UDim2 - Position of where it should go to

----------

```luau
obj:update_preference()
```
Updates the preference after changed from the available settings, it only applies how the controls look
because the stored setting is in a table of your created input without applying, you won't see the changes immediately so it is always required to call this

__________

```luau
obj:toggle_visibility(bool)
```

Toggles whenever you want the input to show or be hidden, instead of trying to destroy and recreate, you can use this instead to hide if the inputs are not supposed to be shown, if you feel like the input is no longer usable or you want to destroy it, call `delete()` to get a rid of it

----------
```luau
obj:delete()
```
Destroys the input after no longer used, you will no longer be able to access it after this has been called, By default when you destroy the input manually either from the `ResetOnSpawn` or somewhere else, it can do the job but sometimes they're not properly cleaned since there could be a task running it aswell

it is recommended that you stop functions from running before calling this, otherwise memory leaks can occur especially if called at the time threads are still yielding

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

