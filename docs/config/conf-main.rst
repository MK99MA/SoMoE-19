.. _conf-main:

==============
soccer_mod.cfg
==============

-------------------
General Information
-------------------

**soccer_mod.cfg** is the main config file for SoMoE-19 and is used to save your settings for almost every part of the plugin. Almost all of the settings can be changed ingame and a manual edit is usually not necessary.

It is divided into different sections for different aspects of the plugin

 - :ref:`admin_settings`
 - :ref:`chat_settings`
 - :ref:`match_settings`
 - :ref:`match_Info`
 - :ref:`forfeit_settings`
 - :ref:`misc_settings`
 - :ref:`sprint_settings`
 - :ref:`current_skins`
 - :ref:`stats_settings`
 - :ref:`training_settings`
 - :ref:`debug_settings`

whereas the titles should be pretty self-explanatory. Below you will find more information about each of the sections and its settings.

----

-----------------------
soccer_mod.cfg Sections
-----------------------

.. _admin_settings:

**************
Admin Settings
**************

As the name suggests this section features settings that only admins can change ingame.

	.. code-block:: none
		
		"Admin Settings"
		{
			"soccer_mod_pubmode"          "1"
			"soccer_mod_passwordlock"     "1"
			"soccer_mod_passwordlock_max" "12"
			"soccer_mod_afk_time"         "100.000000"
			"soccer_mod_afk_menu"         "20"
			"soccer_mod_matchlog"         "0"
		}

	.. attention:: Every key in this section is changeable ingame, so there is no need to edit them manually.

 - **soccer_mod_pubmode** controls the accessability of the admin portion of the menu (Allowed values: 0 - Admin only, 1 - Public Cap/Match access, 2 - Public menu).
 - **soccer_mod_passwordlock** controls the automatic serverlock when a cap is started (Allowed values: 0 - Off, 1 - On).
 - **soccer_mod_passwordlock_max** controls the number of players that has to be reached before the lock takes effect.
 - **soccer_mod_afk_time** controls the number of seconds before AFK players see the AFK-Kick captcha menu.
 - **soccer_mod_afk_menu** controls the number of seconds the captcha menu is displayed
 - **soccer_mod_matchlog** controls whether SoMoE-19 should keep track of game events in a log file(Allowed values: 0 - Off, 1 - On).
 
----
 
.. _chat_settings:

*************
Chat Settings
*************

As the name suggests, this section features settings related to the plugins chat messages.

	.. code-block:: none
	
		"Chat Settings"
		{
			"soccer_mod_prefix"               "Soccer Mod"
			"soccer_mod_textcolor"            "lightgreen"
			"soccer_mod_prefixcolor"          "green"
			"soccer_mod_mvp"                  "1"
			"soccer_mod_deadchat_mode"        "0"
			"soccer_mod_deadchat_visibility"  "0"
		}
 
	.. attention:: Every key in this section is changeable ingame, so there is no need to edit them manually. In case of the colorselection it is even advised to do this ingame as you can access a menu with every valid colorname there.

 - **soccer_mod_prefix** controls the prefix every plugin related chatmessage will display. The given value will always be enclosed by brackets "[Soccer Mod]".
 - **soccer_mod_textcolor** controls the color of the text of every plugin related chatmessage. There are exceptions where this is not the case.
 - **soccer_mod_prefixcolor** controls the color of the prefix for every plugin related chatmessage. Above mentioned exceptions may show the full message in the prefixcolor.
 - **soccer_mod_mvp** controls whether SoMoE-19 will display messages about MVPs in the chat (Allowed values: 0 - Off, 1 - On).
 - **soccer_mod_deadchat_mode** controls whether messages written by dead players or spectators are visible to everyone (Allowed values: 0 - Off, 1 - On, 2 - On, if sv_alltalk 1).
 - **soccer_mod_deadchat_visibility** controls who can see the messages written by dead players or spectators (Allowed values: 0 - Default, 1 - Teammates only, 2 - Everyone).
 
----

.. _match_settings:

**************
Match Settings
**************

As the name suggests, this section features settings related to matches.

	.. code-block:: none
	
		"soccer_mod_match_periods"              "2"
		"soccer_mod_match_period_length"        "900"
		"soccer_mod_match_period_break_length"  "60"
		"soccer_mod_match_golden_goal"          "1"
		"soccer_mod_teamnamect"                 "CT"
		"soccer_mod_teamnamet"                  "T"
		"soccer_mod_match_readycheck"           "1"

	.. attention:: Every key in this section is changeable ingame, so there is no need to edit them manually.

 - **soccer_mod_match_periods** controls the number of periods a match will consist of.
 - **soccer_mod_match_period_length** controls the number of seconds a match period will take.
 - **soccer_mod_match_period_break_length** controls the number of seconds the break between periods will take.
 - **soccer_mod_match_golden_goal** controls whether a draw after the full time will result in a golden goal.
 - **soccer_mod_teamnamect** controls the CT teams name shown in messages.
 - **soccer_mod_teamnamet** controls the T teams name shown in messages.
 - **soccer_mod_match_readycheck** controls whether pausing the game will require every player to set their state to ready before unpausing the game is possible (Allowed values: 0 - Off, 1 - Automatic unpause if everyone is ready, 2 - Manual unpause is possible as soon as everyone is ready).
 
 
----

.. _match_info:

**********
Match Info
**********

As the name suggests, this section features settings related to the match info message when a match is started.

	.. code-block:: none
	
		"soccer_mod_period_info"        "1"
		"soccer_mod_break_info"         "1"
		"soccer_mod_golden_info"        "1"
		"soccer_mod_forfeit_info"       "1"
		"soccer_mod_forfeitset_info"    "0"
		"soccer_mod_matchlog_info"      "0"

	.. attention:: Every key in this section is changeable ingame, so there is no need to edit them manually.
		Each value can either be 0 - Off or 1 - On.

 - **soccer_mod_period_info** controls the display of the period length in the message.
 - **soccer_mod_break_info** controls the display of the break length in the message.
 - **soccer_mod_golden_info** controls the display of the golden goal toggle in the message.
 - **soccer_mod_forfeit_info** controls the display of the forfeit vote toggle in the message.
 - **soccer_mod_forfeitset_info** controls the display of the forfeit settings in the message.
 - **soccer_mod_matchlog_info** controls the display of the matchlog toggle in the message.
 
----

.. _forfeit_settings:

****************
Forfeit Settings
****************

As the name suggests, this section features settings related to the toggle-able forfeit vote.

	.. code-block:: none
		
		"soccer_mod_forfeitvote"        "0"
		"soccer_mod_forfeitscore"       "8"
		"soccer_mod_forfeitpublic"      "0"
		"soccer_mod_forfeitautospec"    "0"
		"soccer_mod_forfeitcapmode"     "0"
		
	.. attention:: Every key in this section is changeable ingame, so there is no need to edit them manually.
	
 - **soccer_mod_forfeitvote** controls whether the forfeit vote is enabled.
 - **soccer_mod_forfeitscore** controls the number of goals one teams has to be in front before a vote is possible.
 - **soccer_mod_forfeitpublic** controls who is allowed to start a vote (Allowed values: 0 - Admins, 1 - Everyone).
 - **soccer_mod_forfeitautospec** controls if all players should be automatically put to spectator after a successful vote.
 - **soccer_mod_forfeitcapmode** controls whether a vote is only possible during cap matches.
 
----

.. _misc_settings:

*************
Misc Settings
*************

This section features miscellaneous settings that do not fit into any of the other sections.

	.. code-block:: none
		
		"soccer_mod_health_godmode"     "1"
		"soccer_mod_respawn_delay"      "10.000000"
		"soccer_mod_blockdj_enable"     "1"
		"soccer_mod_damagesounds"       "0"
		"soccer_mod_dissolver"          "2"
		"soccer_mod_joinclass"          "0"
		"soccer_mod_hostname"           "1"
		"soccer_mod_rrchecktime"        "90.0"
		"soccer_mod_loaddefaults"       "1"
		
	.. attention:: Most keys in this section are changeable ingame. Exceptions are *soccer_mod_health_godmode* and *soccer_mod_respawn_delay* which usually should not be changed at all.
	
 - **soccer_mod_health_godmode** controls whether players can kill each other with the ball or knives.
 - **soccer_mod_respawn_delay** controls the number of seconds it takes before a player respawns (after joining a running game or if he used the kill-command).
 - **soccer_mod_blockdj_enable** controls whether duckjumps should be suppressed.
 - **soccer_mod_damagesounds** controls whether the sound playing when a player is hit by the ball should be played or not. (Allowed values: 0 - No sound, 1 - Play sound).
 - **soccer_mod_dissolver** controls what happens to a players corpse (Allowed values: 0 - Default ragdoll, 1 - Remove ragdoll, 2 - Dissolve animation).
 - **soccer_mod_joinclass** controls whether players should see the class selection screen after joining a team.
 - **soccer_mod_hostname** controls whether SoMoE-19 should update the servers name under certain conditions (Cap started, Match running etc.)
 - **soccer_mod_rrchecktime** controls the number of seconds a player got to rejoin the server before it won't be considered a "rr" in the connection list.
 - **soccer_mod_loaddefaults** controls whether SoMoE-19 should load default mapvalues in its *soccer_mod_mapdefaults.cfg* file.
 
----

.. _sprint_settings:

***************
Sprint Settings
***************

As the name suggests, this section features settings related to the sprint system.

	.. code-block:: none
	
		"soccer_mod_sprint_enable"      "1"
		"soccer_mod_sprint_speed"       "1.250000"
		"soccer_mod_sprint_time"        "3.000000"
		"soccer_mod_sprint_cooldown"    "7.500000"
		"soccer_mod_sprint_button"      "1"
		
	.. attention:: These keys are not changeable ingame. If you want to change its settings you have to manually edit this file. However most people should be used to these settings so changes are not advised.
	
 - **soccer_mod_sprint_enable** controls whether players are able to sprint at all.
 - **soccer_mod_sprint_speed** controls the players speed while sprint is active.
 - **soccer_mod_sprint_time** controls the time a player will sprint.
 - **soccer_mod_sprint_cooldown** controls the time before a player will be able to sprint again.
 - **soccer_mod_sprint_button** controls whether players will be able to sprint by using the +use button. This does not affect !sprint at all.
 
----

.. _current_skins:

*************
Current Skins
*************

As the name suggests, this sections features the currently active skins.

	.. code-block:: none
	
		"soccer_mod_skins_model_ct"     "models/player/soccer_mod/termi/2011/away/ct_urban.mdl"
		"soccer_mod_skins_model_t"      "models/player/soccer_mod/termi/2011/home/ct_urban.mdl"
		"soccer_mod_skins_model_ct_gk"  "models/player/soccer_mod/termi/2011/gkaway/ct_urban.mdl"
		"soccer_mod_skins_model_t_gk"   "models/player/soccer_mod/termi/2011/gkhome/ct_urban.mdl"
		
	.. attention:: These keys are changeable ingame and depend on the contents of your *soccer_mod_skins.cfg* file.
	
Each key determines the skin to use for either CT or T. It is also possible to set an individual Goalkeeper skin for both teams.

----

.. _stats_settings:

**************
Stats Settings
**************

As the name suggests, this section features settings related to the stats system.

	.. code-block:: none
	
		"soccer_mod_ranking_points_goal"          "17"
		"soccer_mod_ranking_points_assist"        "12"
		"soccer_mod_ranking_points_own_goal"      "-10"
		"soccer_mod_ranking_points_hit"           "1"
		"soccer_mod_ranking_points_pass"          "5"
		"soccer_mod_ranking_points_interception"  "3"
		"soccer_mod_ranking_points_ball_loss"     "-3"
		"soccer_mod_ranking_points_save"          "8"
		"soccer_mod_ranking_points_round_won"     "10"
		"soccer_mod_ranking_points_round_lost"    "-10"
		"soccer_mod_ranking_points_mvp"           "15"
		"soccer_mod_ranking_points_motm"          "25"
		"soccer_mod_ranking_cdtime"               "300"
		
	.. attention:: These keys are not changeable ingame. If you want to change its settings you have to manually edit this file. The default values were not thoroughly tested, so feel free to adjust them to your needs if needed.
	
Each key determines the number of points a player will receive when performing the given action. *soccer_mod_ranking_points_save* does require you to setup Goalkeeper Areas for every map in *soccer_mod_GKAreas.cfg*.

 - **soccer_mod_ranking_cdtime** controls the number of seconds players have to wait between using the !rank command.
 
----

.. _training_settings:

*****************
Training Settings
*****************

As the name suggests, this section features settings related to the stats system.

	.. code-block:: none
	
		"soccer_mod_training_model_ball"   "models/soccer_mod/ball_2011.mdl"
		
	.. attention:: These keys are not changeable ingame. If you want to change its settings you have to manually edit this file. This is however only necessary if you want to use a different model for the spawnable training ball.
	
 - **soccer_mod_training_model_ball** controls which model should be used for the spawnable training ball.
 
----

.. _debug_settings:

**************
Debug Settings
**************

As the name suggests, this section features debug settings.

	.. code-block:: none
	
		"soccer_mod_debug"                    "0"

	.. attention:: These keys are not changeable ingame. If you want to change its settings you have to manually edit this file.
	
 - **soccer_mod_debug** controls whether debug mode is enabled or disabled. You should not need this option at all.
