.. _conf-pos:

============================
soccer_mod_cap_positions.txt
============================

**soccer_mod_positions.txt** isn't a config file and **should not be edited manually!**
Doing so does not much harm, but the file is only intended to store the position values of your players. In addition to that the plugin reads those values from this file to add the selected positions of each player behind their name in the cap pick-menu.
	
The structure of the file should look like this:

	.. code-block:: none
	
		"capPositions"
		{
			"[U:0:0]"
			{
				"gk"        "0"
			}
			"[U:0:0]"
			{
				"gk"        "1"
				"lb"        "1"
				"rb"        "1"
				"mf"        "1"
				"lw"        "1"
				"spec"      "1"
			}
			"[U:0:0]"
			{
				"spec"      "0"
				"gk"        "1"
				"lb"        "1"
				"lw"        "1"
				"mf"        "1"
			}
		}
