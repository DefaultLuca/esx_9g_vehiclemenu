## 9g_vehiclemenu
### VEHICLE MENU for ESX Framework

## <br /> Introduction

Simple vehicle menu for tweaking with doors and windows.
Also toggle indicator, headlight, searchlight for heli, and extra for admin.
(engine toggle and locksystem events from other resources)


## <br /> Requirements

- ESX Framework


## <br /> Support

-   https://github.com/DefaultLuca
-   Feel free to edit the code, just refer the author.


## <br /> Installation

- Download the resource and add this in your server.cfg:
```lua 
start esx_9g_vehiclemenu
```

## <br /> How it works

- Allow the player to toggle doors, windows and etc.
- To open menu, default button: F5.
- The player must be in a vehicle and/or in the driver seat. 
- Admin and Superadmin can toggle vehicle EXTRAS.
- If you are not in the driver seat you are restricted to toggle stuff(door and window) of the relative position.
- For the engine toggle and locksystem you need to edit the code with your own event (line #38 and #41).
- I'm using a edited version of esx_locksystem45, the event ls:togglelock is not in the original.
- For the engine toggle I made my own resource.
- Targeting with the Heli search light is not implemented yet.


## <br /> Credits

- ESX Framework
    https://github.com/ESX-Org


## <br /> DefaultLuca

-    https://github.com/DefaultLuca

-   [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YJRFFHWWFHDVG&source=url)


## <br /> License
    9g_vehiclemenu
    Copyright (C) 2019 DefaultLuca https://github.com/DefaultLuca

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
    
