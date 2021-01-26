.. _conf-skins:

====================
soccer_mod_skins.cfg
====================

**soccer_mod_skins.cfg** is the config storing every skin you want to use ingame. While only 2 skins per team (normal + gk) can be active at a time, you can freely switch between any skins declared inside this file.

	.. attention:: This has to be done manually for every skin you intend to use!
	
The generated file comes with support for Termi's skins, which are considered the default soccer skins.

An example configuration adding support for 4 additional skinssets could look like this:

	.. code-block:: none
	
		"Skins"
		{
			"Termi"
			{
				"CT"        "models/player/soccer_mod/termi/2011/away/ct_urban.mdl"
				"T"         "models/player/soccer_mod/termi/2011/home/ct_urban.mdl"
				"CTGK"      "models/player/soccer_mod/termi/2011/gkaway/ct_urban.mdl"
				"TGK"       "models/player/soccer_mod/termi/2011/gkhome/ct_urban.mdl"
			}
			"PSL"
			{
				"CT"        "models/player/psl/public2014/ct/aus_neill.mdl"
				"T"         "models/player/psl/public2014/t/aus_neill.mdl"
				"CTGK"      "models/player/psl/public2014/gk/ct/aus_neill.mdl"
				"TGK"       "models/player/psl/public2014/gk/t/aus_neill.mdl"
			}
			"Natsu"
			{
				"CT"        "models/player/soccer_mod/natsu2021/away/ct_urban.mdl"
				"T"         "models/player/soccer_mod/natsu2021/home/ct_urban.mdl"
				"CTGK"      "models/player/soccer_mod/natsu2021/gkaway/ct_urban.mdl"
				"TGK"       "models/player/soccer_mod/natsu2021/gkhome/ct_urban.mdl"
			}
			"teamukr"
			{
				"CT"        "models/player/tusharsl/teamukr/ct_urban.mdl"
				"T"         "models/player/tusharsl/teamukr/ct_urban.mdl"
			}
			"teamrus"
			{
				"CT"        "models/player/tusharsl/teamrus/ct_urban.mdl"
				"T"         "models/player/tusharsl/teamrus/ct_urban.mdl"
			}
		}

As you can see *teamrus* and *teamukr* could be assigned to both teams (which you would not want to do at the same time for obvious reasons). The other 3 sets are complete sets providing 2 skins per team. Ingame however you would be still able to use this example setup:

	.. code-block:: none
	
		"CT"        "models/player/soccer_mod/termi/2011/away/ct_urban.mdl"
		"T"         "models/player/tusharsl/teamrus/ct_urban.mdl"
		"CTGK"      "models/player/soccer_mod/natsu2021/gkaway/ct_urban.mdl"
		"TGK"       "models/player/psl/public2014/gk/t/aus_neill.mdl"

As you can see this file only determines which skins are choosable ingame and in which sub-menu (the sectionname) they are listed.
