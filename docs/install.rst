.. _install:

===================
Installing SoMoE-19
===================

----------------
Pre-requirements
----------------

SoMoE-19 is a Sourcemod plugin, so make sure to install Sourcemod and its pre-requirements for your OS properly.

As such the pre-requirements are:
 - Metamod:Source 1.10 or higher
 - SourceMod 1.10 or higher
 - (OPTIONAL) Steamworks
 - (OPTIONAL) Updater.smx

The installation of Steamworks and Updater.smx is completely optional but recommended to be able to use all of the included features.

.. tip::
   If you installed SourceMod plugins before you can probably skip most of this section.

----

*************************************
Preparing Metamod: Source & SourceMod
*************************************

First find out the OS your server is running on. Usually many gameservers are running on Linux machines, but there are exceptions.

If you can't find any information about the OS used on the webpage of your hoster you can find out the OS by the types of certain files on the server.

 - .so binaries indicate it is running on **Linux**.
 - .dll binaries indicate it is running on **Windows**.

After you have determined the OS download the release for your OS of 
 - `Metamod:Source  <http://www.sourcemm.net/downloads.php?branch=stable>`_
 - `SourceMod  <https://www.sourcemod.net/downloads.php?branch=stable>`_

Extract the contents of both of the archives by using a tool like 7-zip or WinRar to a location of your choice.

Either continue with the :ref:`optionals` or :ref:`install_somoe`.

----

.. _optionals:

*********************************************
(OPTIONAL) Preparing SteamWorks & Updater.smx
*********************************************

2 features of SoMoe-19 require you to install additional tools in order to use them:
 - Setting the game name in the serverlist to "CS:S Soccer Mod"
 - Automatic Updater functionality

Both of these options depend on Steamworks, so if you want to use either one please visit
 - `SteamWorks <http://users.alliedmods.net/~kyles/builds/SteamWorks/>`_

and downlod the version for your OS.

After downloading the archive, extract the contents of the archive to the same location you already extracted Metamod and Sourcemod to.

If you want to activate the auto-update functionality you also have to download 'Updater.smx' from:
 - `Updater.smx <https://github.com/Teamkiller324/Updater>`_

In the location where you extracted the archives from before should be a folder called 'addons'. Place the downloaded .smx file in:

	.. code-block:: none

		addons/sourcemod/plugins/

Now you can finally move on to SoMoE-19.

----

.. _install_somoe:

------------------
Preparing SoMoE-19
------------------

If you did not install SoMoe-19 before please download the latest full archive from here:
 - `SoMoE-19 Archive <https://github.com/MK99MA/SoMoE-19/releases/tag/1.2.7>`_
 
I do not create a full release for every subversion, so if you are not using **Updater.smx** also check if there is already a newer version found here:
 - `SoMoE-19.smx <https://github.com/MK99MA/SoMoE-19/blob/master/addons/sourcemod/plugins/soccer_mod.smx>`_

Again extract the contents of the archive to the location you chose before.

Usually SoccerMod Servers are using soccer related skins. A few possible skins can be found here:
 - `Skins <https://github.com/MK99MA/soccermod-2019edit/tree/master/skins#alternative-skins-screenshots-below>`_

The most commonly used and default ones are those created by `Termi <https://github.com/MK99MA/soccermod-2019edit/tree/master/skins#alternative-skins-screenshots-below>`_


Please note that SoMoE-19 generates a config for the skins created by Termi and thus every other chosen skin has to be added to the skins and download config files manually. More information about the relevant files can be found `here <config_skins>` and `here <config_downloads>`.

After downloading the skins of your choice again extract them to the same location as everything else. You can now proceed with the last step of the installation.

.. tip::
   If it's the first time you're using SoMoE-19, you should check out the other sections of this documentation too.

----

-----------------------------
Installing the prepared files
-----------------------------

If you downloaded and extracted everything required, you should now have 5 folders in the location you chose.
 - addons
 - cfg
 - materials
 - models
 - sound

.. attention:: To avoid alot of chat spam you might want to edit addons/sourcemod/config/core.cfg and set '!' as a silent chat trigger. You can either simply swap the silent and public triggers or add '!' to the silent trigger-list.

If you are running your server locally copy those folders to: 

    .. code-block:: none

        <path-to-your-server>\cstrike

else, if it is running on a hosted server upload the files to:

    .. code-block:: none

		/home/cstrike

If the upload of the 2 .exe files in sourcemod/scripting fails, you do not have to mind them, since they're only used when you're actually (re-)compiling a plugin.

.. attention:: The installation will be completed after you restarted your server.
