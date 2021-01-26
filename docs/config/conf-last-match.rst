.. _conf-last-match:

=========================
soccer_mod_last_match.txt
=========================

**soccer_mod_last_match.txt** isn't a config file and **should not be edited manually!**
Doing so does not do any harm, but the only thing this would achive would be a manipulation of the ingame display of the matchlog. In addition to that a new file will be generated as soon as a new match is started, while the old log will be moved to:

	.. code-block:: none
	
		cfg/sm_soccermod/logs

An example matchlog could look like this:

	.. code-block:: none
	
		"Match Log"
		{
			"CT_vs_T"
			{
				"CT"     "CT"
				"T"      "T"
			}
			"Scoresheet"
			{
				"0:1"
				{
					"Time:"         "00:01"
					"Scorer:"       "Player [U:X:XXXXXXXX]"
				}
				"0:2"
				{
					"Time:"         "00:04"
					"Scorer:"       "Playerr [U:X:XXXXXXXX]"
				}
				"0:3"
				{
					"Time:"         "00:19"
					"Scorer:"       "Playerr [U:X:XXXXXXXX]"
				}
				"0:4"
				{
					"Time:"         "00:51"
					"Scorer:"       "Player [U:X:XXXXXXXX]"
				}
			}
			"Playerstats"
			{
				"[U:X:XXXXXXXX]"
				{
					"Name:"         "Player"
					"Goals:"        "4"
					"Assists:"      "0"
					"Owngoals:"     "0"
					"Other Names:"  "Player | Playerr"
				}
			}
			"Cards"
			{
				"00:14"
				{
					"Card:"         "Yellow Card"
					"Player:"       "Playerr"
				}
			}
		}
		