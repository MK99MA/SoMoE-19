.. _configs:

=========================
General Information
=========================

SoMoE-19 creates different config files at its first start or whenever one of those files is missing.
Overal there are 11 files that are generated and found in

	.. code-block:: none
	
		cstrike/cfg/sm_soccermod

whereas 3 of them are only used to store information and **should not be edited manually**.

Most other files can be edited manually, but only 
 - soccer_mod_GKAreas.cfg
 - soccer_mod_mapdefaults.cfg
 - soccer_mod_skins.cfg
 - soccer_mod_downloads.cfg

have to be edited by opening them with a text-editor of your choice.

Every other file is editable ingame.

----

-------------------------------
List of generated files
-------------------------------

|**soccer_mod.cfg**
|Main configuration controlling most toggles and settings.

|**soccer_mod_admins.cfg**_
|Custom admin file to grant players access to certain admin features.

|**soccer_mod_allowed_maps.cfg**
|List of maps that should activate certain features of the plugin.

|**soccer_mod_cap_positions.txt**
|*NO CONFIG* - Storage for the selected positions of every player.

|**soccer_mod_downloads.cfg**
|*MANUAL CONFIG* - Determines which files are downloaded to the clients when joining.

|**soccer_mod_GKAreas.cfg**
|*MANUAL CONFIG* - Determines the areas around a goal needed to allow tracking of saves.

|**socer_mod_last_match.txt**
|*NO CONFIG* - Storage for matchlogs (if activated). Old logs will be moved to /sm_soccermod/logs.

|**soccer_mod_mapdefaults.cfg**
|*MANUAL CONFIG* - Set default values for period and breaklength per map.

|**soccer_mod_matchlogsettings.cfg**
|Advanced control regarding automatic matchlog generation.

|**soccer_mod_personalcannonsettings.cfg**
|*NO CONFIG* - Storage for personal cannon settings of every client.

|**soccer_mod_skins.cfg**
|*MANUAL CONFIG* - Add skins that are selectable ingame form a menu in here.

.. tip::
   Every file got its own site in this documentation. Make sure to check them out if you're having issues!
