.. _conf-defaults:

==========================
soccer_mod_mapdefaults.cfg
==========================

**soccer_mod_mapdefaults.cfg** is the config storing your per-map default values.

	.. attention:: Except for the generated entry you have to manually add the entries for any map you intend to use. 
	
At the time of writing this documentation there are 3 supported values:

 - default_periodlength
 - default_breaklength
 - default_periods
	
The structure of the file should look like this:

	.. code-block:: none
	
		"Map Defaults"
		{
			"ka_soccer_xsl_stadium_b1"
			{
				"default_periodlength"    "900"
				"default_breaklength"     "5"
				"default_periods"         "2"
			}
			"ka_soccer_avalon_v8"
			{
				"default_periods"         "3"
			}
		}

As you can see you don't have to add all 3 values to a newly added entry. Only the one you actually want to set is required.
