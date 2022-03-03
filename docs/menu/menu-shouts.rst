.. _menu-shouts:

======
Shouts
======

Every player can access a list of enabled (per server) shouts from the main menu or by using '!shout' in the chat. If the serverowner enabled it, the listed shouts can also be used as chat commands.

e.g.:
A shout is called 'holyshit' in the list, then using '!holyshit' would play the shout, as well as selecting the corresponding number in the shoutmenu.



=============
Shoutsettings
=============

This menu is only accessable for players with at least 'generic' sourcemod permissions. The menu can be used to control the general volume, pitch and so on of the shouts, as well as the playing mode and its radius if the mode allows it.

The different available modes are:
 - Ambient: Plays the sound from the position the shouter was when he shouted.
 - Everyone: Plays the sound to everyone, no matter where they are.
 - Team: Plays the sound to everyone in your team, no matter where they are.
 - Radius: Plays the sound to everyone in a certain radius around the 'shouter'.
 - Radius(Team): Same as above, but limited to your own team
 - Disabled: No shouts :(
 
You can also enable the 'command mode' which will allow players to bind individual sounds to keys without having to access the shout menu if they want to use that shout (see the example above).


Players with elevated sourcemod permissions will also be able to access the shout manager.
Using the manager you can (re-)scan the sounds folder for newly uploaded sounds as well as managing the available shouts.
Sounds added to the 'sounds/soccermod/shout' folder should be added automatically to the shoutlist, every other sound in the sound folder (and its subfolders) has to be added manually ingame.
Next to adding shouts you can also edit and remove shouts from this menu. Editing involves the renaming of a shout (and thus changing the command if its enabled) as well as per-shout volume and pitch.
It also features a list of the currently added shouts.

.. attention:: Please note that not every soundtype is usable. e.g. mp3 and wav are fine, m4a however are not.

