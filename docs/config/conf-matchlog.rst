.. _conf-matchlog:

===============================
soccer_mod_matchlogsettings.cfg
===============================

**soccer_mod_matchlogsettings.cfg** is a config storing settings to determine when SoMoE-19 should automatically turn on its matchlog feature.

.. attention:: These settings can be changed ingame. Editing them manually should be fine too.
	
The structure of the file looks like this:

	.. code-block:: none
	
		"Matchlog Settings"
		{
			"Days"
			{
				"Monday"      "1"
				"Tuesday"     "1"
				"Wednesday"   "1"
				"Thursday"    "1"
				"Friday"      "1"
				"Saturday"    "1"
				"Sunday"      "1"
			}
			"Starttime"
			{
				"Hour"        "8"
				"Minute"      "20"
			}
			"Stoptime"
			{
				"Hour"        "9"
				"Minute"      "20"
			}
		}

The **Days** section determines the days on which the plugin should enable the matchlog option starting with the time given in the **Starttime** section. The **Stoptime** section is obviously used to disable the feature at a given time again. There is no individual setting per day, so a configuration like this

	.. code-block:: none
	
		"Matchlog Settings"
		{
			"Days"
			{
				"Monday"      "0"
				"Tuesday"     "0"
				"Wednesday"   "0"
				"Thursday"    "0"
				"Friday"      "0"
				"Saturday"    "1"
				"Sunday"      "1"
			}
			"Starttime"
			{
				"Hour"        "18"
				"Minute"      "0"
			}
			"Stoptime"
			{
				"Hour"        "22"
				"Minute"      "0"
			}
		}
		
would enable the matchlog generation every saturday and sunday between 6 pm and 10 pm.
