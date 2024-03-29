.. _changes:

=========
Changelog
=========

-----
1.2.8
-----

***
New
***

 - Added option to the help menu to print the url of this documentation and the github project in console.
 - Added option to the help menu to open this documentation in the motd.
 - Added command to adjust GK areas ingame (!gksetup; requires RCON-flag).
 - Added option to disable the killfeed (Always enabled during capfights).
 - Added command to 'remove' spraylogos (!spray; requires GENERIC-flag). Intended to remove sprays from the ball.

*******
Changes
*******

 - Saves only count if the last hit before the gk's was done by an opponent now.
 - Reworked credits menu.
 - Reworked help menu.

*****
Fixes
*****

 - Fixed hostname status not being applied after !matchrr usage.
 - Fixed stoppage time not working properly on maps rotated by 90°.
 - Fixed !pos menu being displayed everytime a cap is started instead of only if no position or "Spec only" is set.
 
 
-----
1.2.7
-----

***
New
***

 - Added !lc command to provide an accurate overview of the join order.
 - adjustable rr tolerance to be used in conjunction with !lc.
 - Added optional hostname statuses displaying various states (f.ex. [PICKING], [HALFTIME] or the timestamp of the current match).
 - Added optional cooldown for !rank usage.
 - Added (requires Steamworks extension) a custom game description.
 - Added optional and configurable map defaults for periods, periodlength and breaklength.
 - Added option to change teamnames for the upcoming match only.
 - Added optional class selection screen disabler. 

*******
Changes
*******

 - Reorganized settings and its submenus

*****
Fixes
*****

 - Minor fixes.
 
-----
1.2.6
-----

*******
Changes
*******

 - !rank command divided into 2 commands: !rank for match rankings and !prank for public rankings

*****
Fixes
*****

 - Various fixes related to ranking & statistics.
 
-------------
1.2.3 - 1.2.5
-------------

*****
Fixes
*****

 - Fixes to customizable sprint timer added in 1.2.3.
 
-----
1.2.2
-----

***
New
***

 - Added Duckjump toggle to settings menu.

*******
Changes
*******
 
 - Adjustments to the duckjump toggle command according to the menu changes.
 
-----
1.2.1
-----

*******
Changes
*******

 - Changes to the admin menu.
 
 
-----
1.2.0
-----

*******
Changes
*******

 - Global ballcannon should no longer ask to select a ball if there is a soccer ball found in the map.

-----
1.1.6
-----

***
New
***

 - Added modular permissions for soccermod admins

*****
Fixes
*****

 - Various minor fixes.

-----
1.1.5
-----

*****
Fixes
*****

 - Various text fixes.
 - Other minor fixes.
 
-----
1.1.4
-----

***
New
***

 - Added option to remove ragdolls after playerdeath.
 
*******
Changes
*******

 - Changes to soundhandling.
 - Changed default lockset value to 0. 
 
-------------
1.1.2 - 1.1.3
-------------

*****
Fixes
*****

 - Various minor fixes.
 
-----
1.1.1
-----

***
New
***

 - Added customizable Hud-Timer displaying sprint duration & cooldown.

*****
Fixes
*****

 - Fixed Unpause not working after pausing the game for 5 minutes.
 - Other minor fixes.