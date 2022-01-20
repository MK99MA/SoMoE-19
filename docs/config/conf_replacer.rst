.. _conf-skins:

====================
soccer_mod_replacer.cfg
====================

**soccer_mod_replacer.cfg** is the config storing every decal you want to use ingame. The decals are intended to provide a way to replace outdated grasstextures by simply overlaying them, but in theory it allows you to place logos & images wherever you want them on a map on your server.

.. attention:: This has to be done manually for every decal/texture you intend to use!
	
The generated file comes with 2 pre-configured entries. You can simply add new files following their example by providing a **NAME** and the **PATH to the textures .vmt file**

The name is of importance when adding decals to a map. Each map will generate their own config file in cfg/sm_soccermod/grassreplacer.

A properly working file could look like this:

	.. code-block:: none
		
		"Positions"				// DO NOT CHANGE
		{
			"grassreplacer"		// the name of the texture set in soccer_mod_replacer.cfg!
			{
				"pos1"		"-1024.000001 0.000001 0.031250"		// each centerposition of a texture
				"pos2"		"-512.000001 0.000001 0.031250"
				"pos3"		"0.000001 0.000001 0.031250"
				"pos4"		"512.000001 0.000001 0.031250"
				"pos5"		"1024.000001 0.000001 0.031250"
				
				"pos6"		"-1024.000001 -512.000001 0.031250"
				"pos7"		"-512.000001 -512.000001 0.031250"
				"pos8"		"0.000001 -512.000001 0.031250"
				"pos9"		"512.000001 -512.000001 0.031250"
				"pos10"		"1024.000001 -512.000001 0.031250"
				
				"pos11"		"-1024.000001 -1024.000001 0.031250"
				"pos12"		"-512.000001 -1024.000001 0.031250"
				"pos13"		"0.000001 -1024.000001 0.031250"
				"pos14"		"512.000001 -1024.000001 0.031250"
				"pos15"		"1024.000001 -1024.000001 0.031250"
				
				"pos16"		"-1024.000001 -1536.000001 0.031250"
				"pos17"		"-512.000001 -1536.000001 0.031250"
				"pos18"		"0.000001 -1536.000001 0.031250"
				"pos19"		"512.000001 -1536.000001 0.031250"
				"pos20"		"1024.000001 -1536.000001 0.031250"
				
				"pos21"		"-1024.000001 512.000001 0.031250"
				"pos22"		"-512.000001 512.000001 0.031250"
				"pos23"		"0.000001 512.000001 0.031250"
				"pos24"		"512.000001 512.000001 0.031250"
				"pos25"		"1024.000001 512.000001 0.031250"
				
				"pos26"		"-1024.000001 1024.000001 0.031250"
				"pos27"		"-512.000001 1024.000001 0.031250"
				"pos28"		"0.000001 1024.000001 0.031250"
				"pos29"		"512.000001 1024.000001 0.031250"
				"pos30"		"1024.000001 1024.000001 0.031250"
				
				"pos31"		"-1024.000001 1536.000001 0.031250"
				"pos32"		"-512.000001 1536.000001 0.031250"
				"pos33"		"0.000001 1536.000001 0.031250"
				"pos34"		"512.000001 1536.000001 0.031250"
				"pos35"		"1024.000001 1536.000001 0.031250"
			}
		}

As you can see the setup is fairly easy since the shift from the previous set texture is simply equal to the size of the texture used. In this case the texture is 512px X 512px and therefore each change consists of adding or substracting 512 from the previous value.

