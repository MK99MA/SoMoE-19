.. _conf-shouts:

====================
soccer_mod_shoutlist.cfg
====================

**soccer_mod_shoutlist.cfg** is the config storing every shout you want to use ingame. Every sound added to the 'sounds/soccermod/shout' folder should be added automatically, sounds located in other sound-subfolders can be however added easily from the ingame menu.

Usually a manual edit of this file is not necessary.

Next to the names and paths of the shouts it will also store additional per-shout information such as per-shout volume and pitch.

An example of a config with a few quake-sounds added.

	.. code-block:: none
		
		"Shout List"
		{
			"holyshit"
			{
				"path"		"soccermod/shout/holyshit.mp3"
			}
			"godlike"
			{
				"path"		"soccermod/shout/godlike.mp3"
			}
			"unstoppable"
			{
				"path"		"soccermod/shout/unstoppable.mp3"
			}
			"humiliation"
			{
				"path"		"soccermod/shout/humiliation.mp3"
			}
			"rampage"
			{
				"path"		"soccermod/shout/rampage.mp3"
			}
			"teamkiller"
			{
				"path"		"soccermod/shout/teamkiller.mp3"
			}
		}


============================
soccer_mod_shoutsettings.cfg
============================

The storage for your shout settings. There is no need to edit this file manually, as you can simply configure these settings from the ingame menu.

	.. code-block:: none
		
		"Shout Settings"
		{
			"cooldown"		"0"
			"volume"		"100"
			"pitch"			"100"
			"Commands"		"0"
			"mode"			"1"
			"message"		"0"
			"radius"		"400"
			"debug"			"0"
		}

