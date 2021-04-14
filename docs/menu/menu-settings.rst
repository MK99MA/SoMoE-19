.. _menu-settings:

================
Admin - Settings
================

As the name suggests is the Settings menu your go-to point if you want to adjust certain settings of SoMoE-19.

.. note:: To see and access the option you require sourcemod generic admin privileges (b). However, to access every part of it you require sourcemod rcon admin privileges (z).

The structure of this menu looks like this:

.. admonition:: Settings menu

	 - :ref:`manage-admins` (*)
	 - :ref:`allowed-maps`
	 - :ref:`public-mode`
	 - :ref:`misc-settings`
	 - :ref:`skin-settings`
	 - :ref:`chat-settings`
	 - :ref:`lock-settings`
	 - :ref:`shout-plugin` (#)
	 
	Items marked with a (*) require the rcon flag (z).
	Items marked with a (#) require an additional plugin to be loaded.



----

.. _manage-admins:

-------------
Manage Admins
-------------

This sub-menu allows you to manage your admins from within the game. To access the menu rcon-flag (z) permissions are required for obvious reasons. 

The structure of this menu looks like this:

.. admonition:: Settings menu

	 - :ref:`add-admin`
	 - :ref:`edit-admin`
	 - :ref:`remove-admin`
	 - :ref:`admin-lists`
	 - :ref:`online-list`
	 
	Items marked with a (*) require the rcon flag (z).
	Items marked with a (#) require an additional plugin to be loaded.


----

.. _add-admin:

*********
Add Admin
*********

As the name suggests, this option is used to add players as an admin. After selecting a player from the list you can select what kind of admin privileges you intend to give.
You can either add them to the sourcemod admin list or the SoccerMod admin list. In case of sourcemod admins you also got the choice between adding them to the *admins.cfg* file or the *admins_simple.ini*.

.. note:: The option to add players to the *admins_simple.ini* is not advised and was superseded by the *admins.cfg* option.

If the target it already an admin of any kind you won't be able to proceed.

----

.. _edit-admin:

**********
Edit Admin
**********

As the name suggests, this option is used to edit your admins from within the game. The editing function is divided into 3 options:

Edit SM Admin
"""""""""""""

Allows you to change the *Name*, *Flags*, *Immunity* and *Admin Group* of your target.


Edit SoccerMod Admin
""""""""""""""""""""

Allows you to enable or disable the access to certain modules of your target.
The selectable modules are identical to the sub-menus of the admin menu, except for *settings*.


Promote Soccer Admin
""""""""""""""""""""

Allows you to quickly remove your target from the SoccerMod Admin list and add it to the sourcemod admin list at the same time.

----

.. _remove-admin:

************
Remove Admin
************

As the name suggests, this option is used to remove players from the admin list. It is divided into 2 options, one targeting your sourcemod admins, the other one targeting your soccermod admins.

----

.. _admin-lists:

***********
Admin Lists
***********

This menu provides a quick and separated overview over your admins. It is divided into 3 possible displays:

 - **SoccerMod List** which displays only your SoccerMod admins.
 - **admins.cfg List** which displays every SourceMod admin in your *admins.cfg* file.
 - **admins_simple.ini** which displays every SourceMod admin in your *admins_simple.ini* file. 

----

.. _online-list:

***********
Online List
***********

This menu provides a quick overview over the admins currently on the server.

----

.. _allowed-maps:

------------
Allowed Maps
------------

This menu is used to add or remove maps from SoMoE-19's allowed maps list. Certain features are only enabled if the current mapname is found in this file.

The structure of this menu looks like this:

.. admonition:: Allowed maps menu

	 - **Add Map**
	 - **Remove Map**

----

.. _public-mode:

-----------
Public Mode
-----------

SoMoE-19 features 3 different access modes which can be changed with this menu.

The structure of this menu looks like this:

.. admonition:: Public Mode menu

	 - **Admin Access Only**
	 - **Public !cap and !match**
	 - **Public !menu**
	 
**Admin Access Only** blocks players from accessing the admin menu portion unless they're found in any of the possible admin lists. Which parts of the menu will be visible and accessible depends on the admin type. In case of SoccerMod admins only the allowed modules will be visible. SourceMod admins will see everything by default.

**Public !cap and !match** is a combination of the other 2 modes. Every player can access a limited version of the admin menu, while admins can still access everything.

**Public !menu** allows every player to access every part a full SoccerMod admin could access whether they're admins or not.

----

.. _misc-settings:

-------------
Misc Settings
-------------

The misc settings menu contains a collection of features that did not fit anywhere else.

The following features are toggleable or changeable:

 - **Class Choice** - *Toggle* - Enables or Disables the class selection screen after joining a team.
 - **Load Map Defaults** - *Toggle* - Enable or Disable loading per map defaults when loading that map.
 - **Remove Ragdoll** - *Toggle* - Select 1 of 3 modes of ragdoll handling (Do nothing / Remove ragdoll / Dissolve ragdoll).
 - **Duckjump Block** - *Toggle* - Enable or Disable the Duckjump preventions. Features 2 attempts at doing so.
 - **Hostname Info** - *Toggle* - Enable or Disable status updates in the servers name.
 - **!rank cooldown** - *Value* - Change the cooldown between !rank usages - 0 to disable.
 - **Ready Check** - *Toggle* - Select 1 of 3 modes of unpause handling (Default / Auto-Unpause if everyone ready / Block unpause unless everyone is ready).
 - **Damage Sounds** - *Toggle* - Enable or Disable hurt-sounds when being hit by the ball.
 - **Killfeed** - *Toggle* - Enable or Disable the killfeed in the upper right corner.
 - **GK saves only** - *Toggle* - Enable or Disable save tracking only for players using the gk skin. If this option is enabled and no player of the team is using the gk skin, everyone will be able to earn saves in the gk area.
 - **Rank Mode** - *Toggle* - Select 1 of 3 ranking modes ( pts/matches, pts/rounds, pts).
 
----

.. _skin-settings:

-------------
Skin Settings
-------------

This menu allows you to select the currently used skins from a list defined in :ref:`conf-skins`. Each skin can be set individually as long as its defined in the configuration file.
There are 4 skinslots you can set:

 - CT Team
 - T Team
 - CT GK
 - T GK
 
----

.. _chat-settings:

-------------
Chat Settings
-------------

This menu allows you to adjust chat related settings. Next to the appearance of the messages (*colors* and *prefix*) you can also enable or disable MVP messages or toggle Deadchat options.

The structure of this menu looks like this:

.. admonition:: Chat Settings

	 - **Chat Style** - Allows changing the *prefix*, *prefixcolor* and *textcolor* for every plugin related chat message.
	 - **MVP Messages** - Enable or Disable the display of MVP / MOTM messages and MVP stars.
	 - **DeadChat** - Enable or Disable the display of messages written by spectators and dead players to everyone. Features 3 modes and additional visibility options.
	 
----

.. _lock-settings:

-------------
Lock Settings
-------------	 

Allows the configuration of any serverlock related setting. Serverlock is a feature to automatically change the servers password to a random value as soon as certain criterias are met. The main criteria is a started cap fight, a variable one is the number of players before the lock is activated. As soon as the playercount falls below the set threshold the password is reverted. This is to ensure that the required number of players for a match can still be achieved if people leave or are kicked because of inactivity. While the Serverlock is active an AFK-Kicker will also take effect, acting according to configurable time frames.

The structure of this menu looks like this:

.. admonition:: Lock Settings

	 - **Enable Serverlock** - Enable an automatic passwordchange if a cap fight is started and the number of players is higher than a set threshold.
	 - **Disable Serverlock** - Disables the feature.
	 - **Player Threshold** - Change the threshold of players that has to be crossed before the passwordchange takes effect.
	 - **Captcha Timer** - Time of inactivity before the AFK-Kicker sends a captcha menu to inactive players to check whether they're actually there.
	 - **Captchamenu Timer** Time before the Captcha menu closes itself and considers an inactive player as AFK.
	 - **Serverlock Info (Status / Threshold value)**
	 
----

.. _shout-plugin:

------------
Shout Plugin
------------	 

This option is only displayed if *shout.smx* is running on the server. It simply serves as a shortcut to settings menu of the shout-plugin, which is also accessible by using *!shoutset / sm_shoutset*
 