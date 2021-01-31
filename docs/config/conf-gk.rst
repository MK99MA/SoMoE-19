.. _conf-gk:

======================
soccer_mod_GKAreas.cfg
======================

**soccer_mod_GKAreas.cfg** is the config storing the coordinates spanning the box in which players will be able to receive points for saves. Ideally this box should be in front of the goals and not too small or too big. 

An area that is too small could prevent the goalkeepers from receiving deserved saves, an area that is too big could reward defensive players with saves for regular interceptions. The coordinates provided in the generated configuration file are the same size as the 5m-boxes / 6yd-boxes in front of the goals and as high as the goals..

.. attention:: Starting with version 1.2.8 it is possible to set the areas from within the game. You can still edit the file manually, as it is possible that different maps will use the same coordinates if the creator used the same map as a template. 
	
		You can use *cl_drawpos 1* to display the coordinates of your current position.
		
	
The file, in case it wasn't generated properly should look like this:

	.. code-block:: none
	
		"gk_areas"
		{
			"ka_soccer_xsl_stadium_b1"
			{
				"ct_min_x"      "-313"
				"ct_max_x"      "313"
				"ct_min_y"      "-1379"
				"ct_max_y"      "-1188"
				"ct_min_z"      "0"
				"ct_max_z"      "120"
				"t_min_x"       "-313"
				"t_max_x"       "313"
				"t_min_y"       "1188"
				"t_max_y"       "1379"
				"t_min_z"       "0"
				"t_max_z"       "120"
			}
			"ka_soccer_avalon_v8"
			{
				"ct_min_x"      "-313"
				"ct_max_x"      "313"
				"ct_min_y"      "-1379"
				"ct_max_y"      "-1188"
				"ct_min_z"      "0"
				"ct_max_z"      "120"
				"t_min_x"       "-313"
				"t_max_x"       "313"
				"t_min_y"       "1188"
				"t_max_y"       "1379"
				"t_min_z"       "0"
				"t_max_z"       "120"
			}
		}
		
Other known setups:

	.. code-block:: none
	
		"gk_areas"
		{
			"ka_soccer_comp_2020_final_v1_fix"
			{
				"ct_min_x"      "-313"
				"ct_max_x"      "313"
				"ct_min_y"      "-1379"
				"ct_max_y"      "-1188"
				"ct_min_z"      "0"
				"ct_max_z"      "120"
				"t_min_x"       "-313"
				"t_max_x"       "313"
				"t_min_y"       "1188"
				"t_max_y"       "1379"
				"t_min_z"       "0"
				"t_max_z"       "120"
			}
		}
		