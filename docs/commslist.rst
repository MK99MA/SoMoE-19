.. _commslist:

====================
Commands Information
====================

SoMoE-19 features a row of chat commands you can use to quickly access certain features.
Overall there are 32 chat commands, 13 :ref:`public` commands and 19 :ref:`admin` commands.


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
	
		Requires: GENERIC-flag (b) or SoccerMod Admin (menu)
		Opens the Soccer Mod admin menu
		
**sm_cap / !cap**

	.. code-block:: none
	
		Requires: GENERIC-flag (b) or SoccerMod Admin (cap)
		Opens the Soccer Mod cap menu
		
**sm_match / !match**

	.. code-block:: none
	
		Requires: GENERIC-flag (b) or SoccerMod Admin (match)
		Opens the Soccer Mod match menu
		
**sm_training / !training**

	.. code-block:: none
	
		Requires: GENERIC-flag (b) or SoccerMod Admin (training)
		Opens the Soccer Mod training menu
		
**sm_ref / !ref**

	.. code-block:: none
	
		Requires: GENERIC-flag (b) or SoccerMod Admin (referee)
		Opens the Soccer Mod referee menu
		
**sm_soccerset / !soccerset**

	.. code-block:: none
	
		Requires: GENERIC-flag (b)
		Shortcut to open the settings menu of the plugin
		
----
		
****************
General commands
****************

**sm_maprr / !maprr**

	.. code-block:: none
	
		Requires: GENERIC-flag (b) or SoccerMod Admin (mapchange)
		Reloads the currently running map
		
**sm_rr / !rr**

	.. code-block:: none
	
		Requires: GENERIC-flag (b) or SoccerMod Admin (match)
		Restarts the current round
		
----

**************
Match commands
**************

**sm_start / !start**

	.. code-block:: none
	
		Requires: GENERIC-flag (b) or SoccerMod Admin (match)
		Starts a match
	
**sm_matchrr / !matchrr**

	.. code-block:: none
	
		Requires: GENERIC-flag (b) or SoccerMod Admin (match)
		Stops and restarts the current match

**sm_pause / !pause / sm_p / !p**

	.. code-block:: none
	
		Requires: GENERIC-flag (b) or SoccerMod Admin (match)
		Pauses a running match
		
**sm_unpause / !unpause / sm_unp / !unp**

	.. code-block:: none
	
		Requires: GENERIC-flag (b) or SoccerMod Admin (match)
		Unpauses a match
		
**sm_stop / !stop**

	.. code-block:: none
	
		Requires: GENERIC-flag (b) or SoccerMod Admin (match)
		Stops a running match

**sm_forcerdy / !forcerdy**

	.. code-block:: none
	
		Requires: RCON-flag (z)
		Forces every player to be 'ready' if the readycheck is enabled and the match was paused
		
**sm_forceunp / !forceunp**

	.. code-block:: none
	
		Requires: RCON-flag (z)
		Forces the match to unpause if the readycheck is enabled, regardless of individual ready states

----
		
*************
Misc commands
*************

**sm_addadmin / !addadmin **

	.. code-block:: none
	
		Requires: RCON-flag (z)
		Arguments: <#steamid> <flags> <clientname>
		Add an admin to the admins_simple.ini file

**sm_dpass / !dpass**

	.. code-block:: none
	
		Requires: RCON-flag (z)
		Reset the server password to the default value set in your server.cfg

**sm_pass / !pass**

	.. code-block:: none
	
		Requires: RCON-flag (z)
		Arguments: <password>
		Set a custom server password

**sm_rpass / !rpass**

	.. code-block:: none
	
		Requires: RCON-flag (z)
		Sets a randomly generated server password

----

.. _public:

---------------
Public Commands
---------------

*************
Menu commands
*************
**sm_menu / !menu **

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
		
**sm_rank / !rank**

	.. code-block:: none
	
		Prints your match rank in the chat

**sm_prank / !prank**

	.. code-block:: none
	
		Prints your public rank in the chat
				
**sm_forfeit / !forfeit**

	.. code-block:: none
	
		Starts a forfeit vote if forfeits are enabled
