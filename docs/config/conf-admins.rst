.. _conf-admins:

=====================
soccer_mod_admins.cfg
=====================

**soccer_mod_admins.cfg** is the config storing so-called "SoccerMod Admins". SoMoE-19 uses both, Sourcemod admins as well as it's own admin file to determine which player can access which aspects of the plugin.

	.. attention:: SoccerMod Admins are supposed to be added ingame. It is possible to edit the file manually, but theres no real need to do so.

The structure of the file looks like this:

	.. code-block:: none
	
		"Admins"
		{
			"[U:0:0]"
			{
				"name"           "Playername"
				"modules"
				{
					"match"      "1"
					"cap"        "1"
					"training"   "1"
					"referee"    "1"
					"spec"       "1"
					"mapchange"  "1"
				}
			}
			"[U:0:0]"
			{
				"name"           "OtherPlayername"
				"modules"
				{
					"match"      "0"
					"cap"        "1"
					"training"   "0"
					"referee"    "1"
					"spec"       "0"
					"mapchange"  "1"
				}
			}
		}

A module set to **1** is accessible by the player with the given steamid, modules set to **0** are not. There is also no limitation regarding the number of added players.
