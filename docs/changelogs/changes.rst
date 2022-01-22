.. _changes:

=========
Changelog
=========

-----
1.3.2
-----

***
New
***

 - Added Pre-Cap-Join option to First12 Toggle
 - Added !aim command to find out coordinates to use with replacer configs

*******
Changes
*******

 
*****
Fixes
*****

 - More Fixes to joinlist
 - Minor fixes


-----
1.3.1
-----

***
New
***

 - Added First 12 Rule toggle
 - Added Grassreplacer

*******
Changes
*******

 
*****
Fixes
*****

 - Fixes to joinlist
 - Minor fixes



-----
1.3.0 BETA
-----

***
New
***

 - Added Advanced Training Mode (Lockable with a password in settings)
 - Added Training Mode
 - Added spawnable training props (Can, Hoop, Plate) (options won't show up without the files)
 - Added option to spawn static or dynamic cones
 - Added 2 target training modes (configurable ball respawn)
 - Added "!profile <name>" command to quickly display the steamprofile of a target
 - Added !spec command
 - Added built-in Shout support

*******
Changes
*******

 - Minor cleanup
 - Added cancel option to some cannon settings
 
*****
Fixes
*****

 - Fixed Duckjumpblock v3



-----
1.2.9.*
-----

***
New
***

 - Added weaponchoice for capfights (1.2.9.3)
 - Added random option to capfight weapon selection (1.2.9.4)
 - Added third alternative duckjump-block method (1.2.9.6)
 - Added option to enable celebration weapons after scoring a goal (1.2.9.6)
 - Added toggleable invisible walls at kickoff (1.2.9.7)
 - Added top3 player display at halftime (1.2.9.7)
 - Added Mapsound control (Disable / Enable ambient_generic sounds per map) (1.2.9.7)

*******
Changes
*******

 - Caps won't lose their knife if the weapon of choice is a gun (1.2.9.3 fix)
 - Cap HP during a HE-Grenade fight set to 98 to allow 1-hit kills (1.2.9.3 fix)
 - Removed Smokegrenade from capfight weapon selection (1.2.9.4)
 - Improved toggleable walls at kickoff (laser indicating borders, coloring) (1.2.9.7)
 - Changed final matchmessage to show top3 instead of only MOTM (1.2.9.7)
 
*****
Fixes
*****

 - Fixed sprint config section resetting (1.2.9.1)
 - Fixed sprint re-enabling itself after a cap fight even if it was disabled (1.2.9.2)
 - Fixed "set position"-Spam at capstart if no position set (1.2.9.4)
 - Fixed misplaced duckjump-reset function (1.2.9.5)

-----
1.2.9
-----

***
New
***

 - Added option to track only saves done by a player using the gk skin. If no player of the team is using the gk skin everyone of the team is able to earn saves inside the gk area.
 - Added admin command !ungk <target> (<target> can be either a player or t/ct).
 - Added match tracking. Everyone who is in CT or T when a round ends during a match will have his match number increased when the end ends or it is stopped (at least played till halftime). Resetting the stats is highly recommended if you intend to use the ranking based on matches.
 - Added 2 alternative commands. (!late - same as !lc; !up - same as !unp / !unpause)
 - Added new preferred duckjumpblock-mode. Duckjumpblock setting now allows 3 settings: OFF, ON, ON (NEW). Old version remains in case of unforseen issues.
 - Added ROOT command to adjust resettime for new duckjumpblock.

*******
Changes
*******

 - !gk limited to one player per team.
 - Ranking can now be sorted by either pure pts, pts/matches (match rankings only) or pts/rounds. 
 - Changed rank reset options to set every value to 0 instead of deleting the row.
 - Stats will only count in matches if it both teams have 5 players at the end of the round.
 - Added join number to pick menu
 - Added join number message for each player when cap fight starts
 - Added GK skin check prior to setting GK skin. Hopefully removes erroreneous entries from GK skin array.
 
*****
Fixes
*****

 - Fixed !pos menu being displayed everytime a cap is started instead of only if no position or "Spec only" is set again.
 - Fixes to rounds won / lost tracking.
 - Fixed gk skin being locked if a gk skin user joins spectator before leaving.
 - Fixed issues with !spray command.
 - Added missing ball entity check.

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