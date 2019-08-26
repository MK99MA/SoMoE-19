# Soccer Mod - 2019 Edit
A edited Version of Marco Boogers SourceMod plugin aimed at Counter-Strike:Source soccer servers
I merely edited and added stuff without any real knowledge, so expect some heavily improvable code.  

### If you used a previous (edited) version of soccermod:  
  ● Remove "exec soccer_mod.cfg" from your server.cfg  
  ● Remove the file "soccer_mod.cfg" from your cstrike/cfg folder  
  ● Remove / Move shortsprint.smx and duckjumpblocker.smx to the disabled folder  
  ● (OPTIONAL) Copy the contents of the old soccermod created files (addons/sourcemod/config and /data) to the new ones (created after the plugin loaded) in cfg/sm_soccermod  
  ● (OPTIONAL) Remove SoccerMod only admins from admins_simple.ini and add them to the new SoccerMod admin file. (SteamID and Name required)  

## [>>DOWNLOAD<< Please still read all the information below](https://github.com/MK99MA/soccermod-2019edit/releases)  
#### [>>Default skins download<< if you need them](https://github.com/MK99MA/soccermod-2019edit/raw/master/skins/termi/termi_models.zip)  
#### [>Alternate skins download<](https://github.com/MK99MA/soccermod-2019edit/tree/master/skins#alternative-skins-screenshots-below)  

## Credits:
I incorporated work of the following plugins and only modified it in a way so it would fit into one plugin file. Therefore almost all credit should go to:  
  ● Original version by Marco Boogers - https://github.com/marcoboogers/soccermod  
  ● Duckjump Script by Marco Boogers  
  ● Allchat (aka DeadChat) by Frenzzy - https://forums.alliedmods.net/showthread.php?t=171734  
  ● ShortSprint by walmar - https://forums.alliedmods.net/showthread.php?p=2294299  
  
## Changelog
### New:
#### Centralized and generated config files in cfg/sm_soccermod:
  ● soccer_mod.cfg - Main Config updates with ingame changes  
  ● soccer_mod_admins.cfg - SoccerMod Admin File, add and remove player ingame  
  ● soccer_mod_allowed_maps.cfg - Allowed maps, addable ingame  
  ● soccer_mod_cap_positions.txt  
  ● soccer_mod_downloads.cfg - Add the directories player should download in here  
  ● soccer_mod_GKAreas.cfg - Coords for the area in which players should get additional pts for saves  
  ● soccer_mod_skins.cfg - List of models, changeable ingame. You have to add them to the file manually!  
    
#### Admin Management:  
![AdminManagementImage](https://github.com/MK99MA/soccermod-2019edit/blob/master/images/adminmgmt.png)  
 ● Add or remove Soccermod only Admins, granting only access to the adminmenu  
 ● Add Sourcemod Admins ingame (Full Admin = 99:z flags, Custom Admin allows manual input; b Flag is still required for Soccermod)  
 ● Promote a Soccermod Admin to a Sourcemod Admin ingame  
 ● Admin Lists for both, Sourcemod (admins_simple.ini only) and Soccermod Admins  
 ● Online List, showing everyone who can access the admin portion of the menu  
  
#### Chat Settings:  
![ChatSetImage](https://github.com/MK99MA/soccermod-2019edit/blob/master/images/chatsettings.png)  
 ● Toggleable DeadChat, with different visibility settings  
 ● Customizable Chat messages (Prefix, Prefixcolor, Textcolor)  
  
#### Match Menu:  
![MatchSet](https://github.com/MK99MA/soccermod-2019edit/blob/master/images/matchmenu.png)  
 ● Match menu reworked + added display of certain settings  
 ● Match settings changeable ingame (Image of the menu below)    
 ● (RCONFLAG ADMIN ONLY) Possibility to rename the teams (custom, default, clantag of a player)
  
#### Misc:
 ● Added toggleable duckjump block script  
 ● Added toggleable password change after starting a cap and hitting a set threshold (Image of the menu below)  
 ● Switchable modes - Public menu, public cap/match, admins only (Image of the menu below)  
 ● New entries in settings menu + added display of certain settings (Image of the menu below)   
 ● Rearranged a few menu options    

#### Commands:
 ● (RCONFLAG ADMIN ONLY) !addadmin <steamid> <flags> <name> - adds an entry with the specified values to the admins_simple.ini  
 ● (RCONFLAG ADMIN ONLY) !pass <password> - Set the current sv password  
 ● !admins - Shows a list of online admins  
  
#### Map:  
 ● I added a recompiled version of ka_soccer_xsl_stadium_b1, so expect differences in the ball behaviour  
 
### Modified:
 ● Toggleable MVP stars & messages  
 ● Replaced "Hold-shift" Sprint with walmars ShortSprint  
 ● (TEST) Reduced restart time when a match starts from 5 secs to 1 sec  
 ● Unpausing countdown will also display as centertext  
 ● Every mod chat message will use the set chat settings  
  
### Removed:
 ● Code to auto-spectate players during a match if they would exceed a set threshold  
  
## Installation
### 1. Download the required plugins
To run Soccer Mod on your server you need the following plugins:  
 ● Metamod:Source 1.10 or higher  
http://www.sourcemm.net/downloads.php?branch=stable  
 ● SourceMod 1.7 or higher  
https://www.sourcemod.net/downloads.php?branch=stable  
 ● Soccer Mod (2019 Edit)  
https://github.com/MK99MA/soccermod-2019edit/releases  
  
Click the links and select the correct download for your server (Linux or Windows). Save the zip files in the same location, for example on your desktop.  
  
### 2. Extract the zip files
Right click on each zip file and select "Extract Here". After extracting the 3 zip files you should have 5 folders on your desktop:  
 ● addons  
 ● maps  
  
### 3. Copy or upload the folders
Copy or upload the folders to your server's "csgo" folder, for example:  
 ● D:\Servers\Counter-Strike Global Offensive\csgo (local server)  
 ● /home/csgo (hosted server)  
  
Soccer Mod is now fully installed and will be loaded automatically when the server is restarted.

![lockimg](https://github.com/MK99MA/soccermod-2019edit/blob/master/images/lockmenu.png)
![pubimg](https://github.com/MK99MA/soccermod-2019edit/blob/master/images/pubmode.png)
![setimg](https://github.com/MK99MA/soccermod-2019edit/blob/master/images/settingsmenu.png)
![matchset](https://github.com/MK99MA/soccermod-2019edit/blob/master/images/matchsettings.png)
