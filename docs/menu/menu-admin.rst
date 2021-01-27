.. _menu-admin:

=====
Admin
=====

The admin portion of the menu is the central place to control most of SoMoE-19's functions and settings.
It is divided into the following sub-menus: 

 - :ref:`match-sub`
 - :ref:`cap-sub`
 - :ref:`referee-sub`
 - :ref:`training-sub`
 - :ref:`spec-sub`
 - :ref:`map-sub`
 - :ref:`set-sub`

.. note::

	The structure of the menu you can see ingame might vary depending on your permissions. See :ref:`mainmenu` for a rundown on the menu-trees structure and the required permissions.


----

.. _match-sub:

--------------
Match sub-menu
--------------

This menu is used to control the matches. Next to options to **Start and Stop** them you can also **Pause and Unpause** them using this menu. While these options are also available as commands to be used as a shortcut (see :ref:`commslist`), the menu also features a sub-menu to control the :ref:`matchset-sub` from within the game.

Another notable entry in this menu is the :ref:`matchlog-sub`.

The structure of the menu looks like this:

	.. admonition:: Match menu
	
		 - Start / Stop
		 - Pause / Unpause
		 - Match Settings
		 - Match Log (if enabled)
		 - Info (Period length | break length)
		 - Info (T name | CT name)
		 - Info (Golden Goal | Matchlog)

.. tip::
   The last 3 lines of the menu will give you a quick overview over certain match-related settings.

----

.. _matchset-sub:

**************
Match Settings
**************

The match settings sub-menu can be used to control the following settings:

 - **Period length** - Set the length of the half (So obviously 2*<period length> = match length).
 - **Break length** - Set the length of the halftime break.
 - **Golden goal** - Set if the match will continue after full time if its a draw.
 - **Matchlog Settings** - Control aspects of the matchlogging. (see :ref:`logset-sub`; relevant for :ref:`matchlog-sub`).
 - **Forfeit Vote Settings** - Control aspects of forfeit voting (see :ref:`forfeit-sub`)
 - **Team Name Settings** - Control the teams names (see :ref:`name-sub`).
 - **Match Info Settings** - Control the Match Info that is being displayed at the start of a match (see :ref:`info-sub`).

----

.. _logset-sub:

^^^^^^^^^^^^^^^^^
Matchlog Settings
^^^^^^^^^^^^^^^^^

The Matchlog Settings can be used to toggle on or off matchlogging. It also features an optional time-based mode that will automatically enable this feature at set days, during a set period of time.

The last line in this menu also tells you whether your set period of time is valid or might cause problems.
 
----

.. _forfeit-sub:

^^^^^^^^^^^^^^^^
Forfeit Settings
^^^^^^^^^^^^^^^^

As the name suggests, this menu can be used to control various aspects of the optional forfeit vote system.

 - **Forfeit Vote** - Enable / Disable the feature.
 - **Vote Condition** - Set how many goals one team has to be in front before a forfeit vote (if enabled) is possible.
 - **Availability** - Allow everyone to start a vote or limit it to admins.
 - **Auto-Spec** - If enabled will put every player to spectator after a successful vote.
 - **Cap-only Mode** - If enabled will limit forfeit votes to cap matches only. (Forfeit Vote has to be set to *ON*!).

----

.. _name-sub:

^^^^^^^^^^^^^^^^^^
Team Name Settings
^^^^^^^^^^^^^^^^^^

This menu allows you to set the teams names. The options marked with **[Perm]** will permanently change the names, options marked with **[Match]** will revert back to the permanent / default value after the next match ends. 

.. admonition:: Example
	
	If you set the **[Perm]** name of the terrorists team to *Terror* and change the **[Match]** name of the terrorists team to *FC* before starting a match, the T team will be called *FC*. If you instantly restart the match with the *!matchrr* command the name will be reverted and the T team will be called *Terror* in the restarted match. 

.. note::
	I might add the team names to the :ref:`conf-defaults` file at a later point so they will reverted to the default value on reloading the map only but currently this is not implemented.
	
----

.. _info-sub:

^^^^^^^^^^^^^^^^^^^
Match Info Settings
^^^^^^^^^^^^^^^^^^^

This menu allows you to control the information displayed whenever a match starts. The full message (if every option in this menu is enabled) looks like this:

.. admonition:: Matchinfo Example 1

	| [MatchInfo]  Halftime length: 15:00 Minutes | Break length: 5 seconds | Golden Goal: On |
	| [MatchInfo]  FF vote: Enabled | FF Condition: 4 goals | FF Auto-Spec: OFF | Matchlog: Off |
	
Only enabling the first 3 options would look like this:

.. admonition:: Matchinfo Example 1

	[MatchInfo]  Halftime length: 15:00 Minutes | Break length: 5 seconds | Golden Goal: On |
	
As soon as you select 4 optinos at the same time the message will be split. Please note that the option *Forfeit vote settings info* does consist of 2 information strings (Condition & Auto-Spec) but still counts as only 1 option.

----

.. _matchlog-sub:

***************
Matchlog Viewer
***************

The Matchlog Viewer can be used to track the events of the currently running or last match. It keeps track of every goal together with its timestamp and the involved players (scorer & assister). 

A submenu can also be used to track the given cards and their timestamp.

----

.. _cap-sub:

------------
Cap sub-menu
------------

This menu is used to control cap fights. It provides a fast option to prepare the upcoming cap fight by putting everyone on the server to spec as well as an option to randomly assign players to each team. (If you use the option twice, 1 player will be assigned to the T team, the other one will be put into the CT team)

The last notable option can be used to start the fight.

Starting the fight will freeze every player and start a countdown to prepare them for the fight. During a cap fight godmode will be deactivated and the HP of every participitating player will be set to 101. Sprint will be disabled during the fight.

The structure of the menu looks like this:

	.. admonition:: Cap menu
	
		 - Put all players to spectator
		 - Add random player
		 - Start cap fight

----

.. _referee-sub:

----------------
Referee sub-menu
----------------

This menu is used to keep players in check breaking the rules. The effects are similar to those of the real-life sport. Giving a yellow card serves as a warning and should persuade the target to behave. A second yellow card will result in a yellow-red card and the same effects as a directly given red card.
The targeted player will be instantly moved to spectator. This will repeat whenever he tries to join either team as long as the red or yellow-red card is in place.

It is possible to remove given cards, either individually (red or yellow) or by removing every currently given card at once.

It is alos possible to control the score of the current match by adding or removing goals for either team. This is useful if a team scored while one of the opponents was AFK or the running match was stopped and should be continued with its original score.

The structure of the menu looks like this:

	.. admonition:: Referee menu
	
		 - Yellow Card
		 - Red Card
		 - Remove Yellow Card
		 - Remove Red Card
		 - Remove All Cards
		 - Score

----

.. _training-sub:

-----------------
Training sub-menu
-----------------

This menu provides tools to train your skills. You can create a **global or personal ball cannon, can spawn or despawn an additional ball and disable or enable the goals**.
The ball cannons can be customized regarding their *fire rate*, *randomness* or *power*. You can also freely change their *position* and *aim*.

The structure of the menu looks like this:

	.. admonition:: Training menu
	
		 - Cannon
		 - Personal Cannon
		 - Disable Goals
		 - Enable Goals
		 - Spawn / Remove Ball
		 
Both Cannon menus provide submenus to customize their settings.

----

.. _spec-sub:

--------------------
Spec Player sub-menu
--------------------

This menu provides a list of all players in either CT or T. Selecting a name from this list will put the targeted player to spectator. This is intended to be used if a player is AFK and has to removed from the field to make place for his substitution.

----

.. _map-sub:

-------------------
Change Map sub-menu
-------------------

This menu provides a list of all allowed maps found on the server. It can be used to change the currently running map.

.. _set-sub:

-----------------
Settings sub-menu
-----------------

This menu provides various settings that can be adjusted ingame. Please refer to :ref:`menu-settings` for a detailed rundown.