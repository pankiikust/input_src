# input_src
a mobile controls made alternative to CAS

input_src is another ContextActionService that focuses on fixing it's horrible controls roblox offers to ContextActionService when turning mobile buttons parameters on, with additional features to run rather than being an inputless service based, input_src's mission is to balance the playability such as turning around while holding buttons.

## No ContextActionService
Get it outta here,,,,,, throw your nasty little service out before everyone gets pissed!!!!! you can't even try to fix it but with input_src, replace that with this and the feel is similar to it, expanding more customizability for your buttons without any struggle of changing everything for your inputs.

# DISCLAIMER 
Because the code written is entirely snake_case, if you wish to swap it to stylize within the standards, you are allowed to take this and modify it in your ways, as mentioned earlier in some of my devforum posts, I don't really like following the guides as it gets pretty confusing for me when I can't tell the differences between actual API from roblox and Custom ones

and because of how my code is structured, some of my way coding it is not efficient, friendly, painful or horrible in performances, you can submit your attempts to fix on this project later and point out what has changed

# INSTALLATION 
To install input_src for your game, get it from the marketplace or the GitHub page on the release sections, note that there is no Wally support or Rojo as this was written built-in the studio directly, I'm not familiar with those yet and it's only my first step-in module.

Once obtained, place the module in anywhere that client can access, if it's inside a server, you won't be able to find it with LocalScript

# ![API]!

`input_src.create_inputs(runtime_name: string, input_type: string, pos: Udim2, scale_multi: number, options)`

Creates the input with runtime name and input type
runtime_name - the name of input you should call, This is similar to BindAction's first arg
input_type - (JOYSTICK_ , DYNAMIC_ and FIXED_) joy stick is self explanatory, Dynamic moves your button positioned at your tap and fixed remains in one position without moving anywhere
