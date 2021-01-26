.. _conf-downloads:

========================
soccer_mod_downloads.cfg
========================

**soccer_mod_downloads.cfg** is a config determining which subdirectories and files a client should download when joining the server. Usually you want to add every skin / model you intend to use in here but also sounds or other materials.

	.. attention:: You have to manually edit this file!
	
Each line of the file has to start with **soccer_mod_downloads_add_dir** followed by a path.
The easiest setup regarding skins would be:

	.. code-block:: none
	
		soccer_mod_downloads_add_dir materials\models\player
		soccer_mod_downloads_add_dir models\player
		
This however adds EVERY file found in the player folder (and its subdirectories) to the downloadlist. So if you added 10 models to your server a player joining would have to download each of those skins first (unless he already downloaded some of them elsewhere before):

Hence it is better to only add relevant folders to the list, like this:

	.. code-block:: none
	
		//adds every file & subfolder in the termi folder
		soccer_mod_downloads_add_dir materials\models\player\soccer_mod\termi
		soccer_mod_downloads_add_dir models\player\soccer_mod\termi
		
		//adds the trainingball model to the list
		soccer_mod_downloads_add_dir materials\models\soccer_mod
		soccer_mod_downloads_add_dir models\soccer_mod
		
		//adds every file & subfolder in the psl folder
		soccer_mod_downloads_add_dir materials\models\player\psl
		soccer_mod_downloads_add_dir models\player\psl

With the above setup a skin which is located in

	.. code-block:: none
	
		models\player\tusharsl
		materials\models\player\tusharsl
		
as well as its contents would not be added to the downloadlist.	

Generally speaking: The more precise the given path is, the less "unnecessary" files your players will have to download.
