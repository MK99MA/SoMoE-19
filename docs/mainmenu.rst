.. _mainmenu:

=============
SoMoE-19 Menu
=============

Alot of settings and features of SoMoE-19 are accessible from its included menu. You can open said menu by using either **!menu** in chat or **sm_menu** in your console. Both commands can also be added as a bind:

	.. code-block::
		
		bind "<key>" "say !menu"
		
		or
		
		bind "<key>" "sm_menu"
		
		Example:
		bind "k" "sm_menu"

 An overview of its structure can be seen below.
 
 - sections marked with a (*) require generic sourcemod admin privileges, the respective SoccerMod Admin privileges or the public menu being activated. 
 - sections marked with a (^) require at least generic sourcemod admin privileges.
 - sections marked with a (°) require rcon sourcemod admin privileges.
 - sections marked with a (#) require an external plugin to be running on the server to appear.
 
Unless an indicator is added, the indicator of the next higher menu applies to every sub-menu.

	.. code-block:: none
		
		 !menu
		 ├─ Admins (*)
		 │  ├─ Match (*)
		 │  │  ├─ Start / Stop
		 │  │  ├─ Pause / Unpause
		 │  │  ├─ Match Settings
		 │  │  │  ├─ Period Length
		 │  │  │  ├─ Break Length
		 │  │  │  ├─ Golden Goal
		 │  │  │  ├─ Matchlog Settings
		 │  │  │  ├─ Forfeit Vote Settings
		 │  │  │  ├─ Team Name Settings
		 │  │  │  └─ Match Info Settings
		 │  │  │
		 │  │  ├─ Match Log (*)
		 │  │  └─ Current Matchsettings
		 │  │
		 │  ├─ Cap (*)
		 │  │  ├─ Put all players to spectator
		 │  │  ├─ Add random player
		 │  │  ├─ Start cap fight (weapon)
		 │  │  └─ Cap weaponchoice
		 │  │	  └─ Weaponlist
		 │  │
		 │  ├─ Referee (*)
		 │  │  ├─ Yellow Card
		 │  │  ├─ Red Card
		 │  │  ├─ Remove Yellow Card
		 │  │  ├─ Remove Red Card
		 │  │  ├─ Remove All Cards
		 │  │  └─ Score
		 │  │
		 │  ├─ Training (*)
		 │  │  ├─ Cannon
		 │  │  │  ├─ Set Cannon position
		 │  │  │  ├─ Set Cannon aim
		 │  │  │  ├─ Cannon on
		 │  │  │  ├─ Cannon off
		 │  │  │  └─ Settings
		 │  │  │     ├─ Randomness
		 │  │  │     ├─ Fire rate
		 │  │  │     └─ Power
		 │  │  │
		 │  │  ├─ Personal Cannon (*)
		 │  │  │  ├─ Set Cannon position
		 │  │  │  ├─ Set Cannon aim
		 │  │  │  ├─ Cannon on
		 │  │  │  ├─ Cannon off
		 │  │  │  └─ Settings
		 │  │  │     ├─ Randomness
		 │  │  │     ├─ Fire rate
		 │  │  │     └─ Power
		 │  │  │
		 │  │  ├─ Disable Goals
		 │  │  ├─ Enable Goals
		 │  │  └─ Spawn / Remove Ball
		 │  │
		 │  ├─ Spec Player (*)
		 │  ├─ Change Map (*)
		 │  └─ Settings (^)
		 │     │
		 │     ├─ Manage Admins (°)
		 │     │  ├─ Add Admin (°)
		 │     │  ├─ Edit Admin (°)
		 │     │  ├─ Remove Admin (°)
		 │     │  ├─ Admin List (°)
		 │     │  └─ Online List (°)
		 │     │ 
		 │     ├─ Allowed Maps (^)
		 │     │  ├─ Add Map
		 │     │  └─ Remove Map
		 │     │
		 │     ├─ Public Mode (^)
		 │     ├─ Misc Settings (^)
		 │     │  ├─ Class Choice Toggle
		 │     │  ├─ Load Map Defaults Toggle
		 │     │  ├─ Remove Ragdoll Toggle
		 │     │  ├─ Duckjump Block Toggle
		 │     │  ├─ Kickoffwall Toggle
		 │     │  ├─ Hostname Updater Toggle
		 │     │  ├─ !rank Cooldown Setting
		 │     │  ├─ Readycheck Toggle
		 │     │  ├─ Damage Sound Toggle
		 │     │  ├─ Killfeed Toggle
		 │     │  ├─ GK saves only Toggle
		 │     │  ├─ Rankmode Toggle
		 │     │  └─ Celebration Toggle
		 │     │  
		 │     ├─ Skin Settings (^)
		 │     │  ├─ CT Skin
		 │     │  ├─ T Skin
		 │     │  ├─ CT GK Skin
		 │     │  └─ T GK Skin 
		 │     │
		 │     ├─ Chat Settings (^)
		 │     │  ├─ Chat Style
		 │     │  │  ├─ Prefix Setting
		 │     │  │  ├─ Textcolor Setting
		 │     │  │  └─ Prefixcolor Setting
		 │     │  │
		 │     │  ├─ MVP Message Toggle (^)
		 │     │  └─ DeadChat Toggle (^)
		 │     │
		 │     ├─ Sound Control (^)
		 │     │  ├─ Remove Sound
		 │     │  └─ Add Sound
		 │     │
		 │     ├─ Lock Settings (^)
		 │     │  ├─ Enable Serverlock
		 │     │  ├─ Disable Serverlock
		 │     │  ├─ Player Threshold
		 │     │  ├─ Captcha Timer Setting
		 │     │  ├─ Captchamenu Timer Setting
		 │     │  └─ Current Locksettings
		 │     │
		 │     └─ Shout Plugin (^#)
		 │
		 ├─ Ranking
		 │  ├─ Match Top 50
		 │  ├─ Public Top 50
		 │  ├─ Match Personal
		 │  ├─ Public Personal
		 │  ├─ Last Connected
		 │  └─ Reset Rank
		 │     ├─ Reset Match Ranking
		 │     └─ Reset Public Ranking
		 │
		 ├─ Statistics
		 │  ├─ Team CT
		 │  ├─ Team T
		 │  ├─ Player
		 │  ├─ Current Round
		 │  └─ Current Match
		 │
		 ├─ Positions
		 ├─ Help
		 │  ├─ Chat Commands
		 │  │  ├─ Admin Commands (*)
		 │  │  └─ Public Command List
		 │  │
		 │  └─ Guide
		 │
		 ├─ Sprintsettings
		 │  └─ Timer Settings
		 │     ├─ Timer Position
		 │     └─ Timer Color Settings
		 │        └─ Timer Color
		 │
		 ├─ Shouts (#)
		 └─ Credits
