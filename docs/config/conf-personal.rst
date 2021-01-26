.. _conf-personal:

=====================================
soccer_mod_personalcannonsettings.cfg
=====================================

**soccer_mod_personalcannonsettings.cfg** is the config storing the personal cannon settings for everyone playing on your server.

	.. attention:: To make sure that nothing breaks I recommend to never manually edit this file as it is only intended as storage.
	
The structure of the file should look like this:

	.. code-block:: none
	
		"Personal Cannon Settings"
		{
			"[U:0:0]"
			{
				"randomness"  "50.000000"
				"fire_rate"   "1.500000"
				"power"       "10000.000000"
			}
			"[U:0:0]"
			{
				"randomness"  "0.000000"
				"fire_rate"   "1.500000"
				"power"       "5000.000000"
			}
			"[U:0:0]"
			{
				"randomness"  "30.000000"
				"fire_rate"   "2.500000"
				"power"       "10000.000000"
			}
		}
