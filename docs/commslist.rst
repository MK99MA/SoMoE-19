.. _commslist:

====================
Commands Information
====================

SoMoE-19 features a row of chat commands you can use to quickly access certain features.
Overall there are 38 chat commands, 15 :ref:`public` and 23 :ref:`admin`.


----

.. _admin:

--------------
Admin Commands
--------------

*************
Menu commands
*************

**sm_madmin / !madmin**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z) or SoccerMod Admin (menu)
		Opens the Soccer Mod admin menu
		
**sm_cap / !cap**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z) or SoccerMod Admin (cap)
		Opens the Soccer Mod cap menu
		
**sm_match / !match**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z) or SoccerMod Admin (match)
		Opens the Soccer Mod match menu
		
**sm_training / !training**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z) or SoccerMod Admin (training)
		Opens the Soccer Mod training menu
		
**sm_ref / !ref**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z) or SoccerMod Admin (referee)
		Opens the Soccer Mod referee menu
		
**sm_soccerset / !soccerset**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z)
		Shortcut to open the settings menu of the plugin
		
----
		
****************
General commands
****************

**sm_maprr / !maprr**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z) or SoccerMod Admin (mapchange)
		Reloads the currently running map
		
**sm_rr / !rr**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z) or SoccerMod Admin (match)
		Restarts the current round
		
----

**************
Match commands
**************

**sm_start / !start**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z) or SoccerMod Admin (match)
		Starts a match
	
**sm_matchrr / !matchrr**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z) or SoccerMod Admin (match)
		Stops and restarts the current match

**sm_pause / !pause | sm_p / !p**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z) or SoccerMod Admin (match)
		Pauses a running match
		
**sm_unpause / !unpause | sm_unp / !unp | sm_up / !up**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z) or SoccerMod Admin (match)
		Unpauses a match
		
**sm_stop / !stop**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z) or SoccerMod Admin (match)
		Stops a running match

**sm_forcerdy / !forcerdy**

	.. code-block:: none
	
		Requires: RCON-flag (m or z)
		Forces every player to be 'ready' if the readycheck is enabled and the match was paused
		
**sm_forceunp / !forceunp**

	.. code-block:: none
	
		Requires: RCON-flag (m or z)
		Forces the match to unpause if the readycheck is enabled, regardless of individual ready states

----
		
*************
Misc commands
*************

**sm_addadmin / !addadmin**

	.. code-block:: none
	
		Requires: RCON-flag (m or z)
		Arguments: <#steamid> <flags> <clientname>
		Add an admin to the admins_simple.ini file

**sm_dpass / !dpass**

	.. code-block:: none
	
		Requires: RCON-flag (m or z)
		Reset the server password to the default value set in your server.cfg
		
**sm_gksetup / !gksetup**

	.. code-block:: none
	
		Requires: RCON-flag (m or z)
		Opens a panel to set or change the gk areas of the current map.

**sm_pass / !pass**

	.. code-block:: none
	
		Requires: RCON-flag (m or z)
		Arguments: <password>
		Set a custom server password

**sm_rpass / !rpass**

	.. code-block:: none
	
		Requires: RCON-flag (m or z)
		Sets a randomly generated server password
		
**sm_spray / !spray**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z)
		Re-Move the spraylogo you're looking at. (Actually gets moved to another position)
		
**sm_ungk / !ungk**

	.. code-block:: none
	
		Requires: GENERIC-flag (b or z)
		Arguments: <target>
		Remove the gk skin of your target. DOES NOT set the gk skin on a target that is not using a skin.
		
**sm_wiperanks / !wiperanks**

	.. code-block:: none
	
		Requires: RCON-flag (m or z)
		Sets every value in the stats database for every entry to 0. THIS IS NOT REVERSIBLE! USE WITH CAUTION OR MAKE A BACKUP FIRST!

**sm_jumptime / !jumptime**

	.. code-block:: none
	
		Requires: ROOT-flag (z)
		Arguments: <time>
		Set the time before you can use +duck after jumping again. Default: 0.45.

----

.. _public:

---------------
Public Commands
---------------

*************
Menu commands
*************
**sm_menu / !menu**

	.. code-block:: none
	
		Opens the Soccer Mod main menu

**sm_pick / !pick**

	.. code-block:: none
	
		Re-opens the Soccer Mod pick menu after a capfight

**sm_stats / !stats**

	.. code-block:: none
	
		Opens the Soccer Mod statistics menu
		
**sm_pos / !pos**

	.. code-block:: none
	
		Opens the Soccer Mod positions menu
		
**sm_help / !help**

	.. code-block:: none
	
		Opens the Soccer Mod help menu

**sm_admins / !admins**

	.. code-block:: none
	
		Opens a menu to display the currently active admins, separated into different lists	
		
**sm_commands / !commands**

	.. code-block:: none
	
		Opens the Soccer Mod commandlist menu
		
**sm_info / !info**

	.. code-block:: none
	
		Opens the Soccer Mod credits menu

----

****************
General commands
****************

**sm_gk / !gk**

	.. code-block:: none
	
		Toggles the Goalkeeper skin		

**sm_rdy / !rdy**

	.. code-block:: none
	
		Re-opens the Readycheck panel if its enabled and the game was paused	

**sm_lc / !lc | sm_late / !late**

	.. code-block:: none
	
		Displays an accurate numbered list of players. People leaving will only be completely removed from their position after being away for a specified timeframe. If a player leaves he won't be visible on the list and only reappear if he rejoins.
		
**sm_pick / !pick**

	.. code-block:: none
	
		(Re-)Opens the cap pick menu.

**sm_rank / !rank**

	.. code-block:: none
	
		Prints your match rank in the chat

**sm_prank / !prank**

	.. code-block:: none
	
		Prints your public rank in the chat
				
**sm_forfeit / !forfeit**

	.. code-block:: none
	
		Starts a forfeit vote if forfeits are enabled
		
**sm_profile <name> / !profile <name>**

	.. code-block:: none
	
		Opens the steamprofile of the target in the MOTD window
