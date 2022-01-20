// Called at mapstart
public void GetFieldOrientation()
{
	//ResetMapData();
	t_trigger_id = -1;
	ct_trigger_id = -1;
	
	// Get goaltrigger entity IDs
	// First check xsl_stadium name, then alternative name for both teams
	t_trigger_id = GetEntityIndexByName("terro_But", "trigger_once");
	if (t_trigger_id == -1)
	{
		t_trigger_id = GetEntityIndexByName("goal_t", "trigger_once");
	}
	if (t_trigger_id == -1) //pvt 4....
	{
		t_trigger_id = GetEntityIndexByName("Terro_but", "trigger_multiple");
	}
	
	ct_trigger_id = GetEntityIndexByName("ct_But", "trigger_once");
	
	if (ct_trigger_id == -1)
	{
		ct_trigger_id = GetEntityIndexByName("goal_ct", "trigger_once");
	}
	if (ct_trigger_id == -1) //pvt 4....
	{
		ct_trigger_id = GetEntityIndexByName("ct_but", "trigger_multiple");
	}
	
	// Get ball starting position
	int soccerball_id = GetEntityIndexByName("ball", "func_physbox");
	if (soccerball_id == -1) 
	{
		soccerball_id = GetEntityIndexByName("ball", "prop_physics");
	}
	if (soccerball_id == -1) 
	{
		soccerball_id = GetEntityIndexByName("ballon", "func_physbox");
	}
	if (soccerball_id == -1) 
	{
		soccerball_id = GetEntityIndexByName("ballon", "prop_physics");
	}
	if (soccerball_id != -1) GetEntPropVector(soccerball_id, Prop_Send, "m_vecOrigin", mapBallStartPosition);
	//PrintToServer("X: %.f | Y: %.f | Z: %.f | ", mapBallStartPosition[0], mapBallStartPosition[1], mapBallStartPosition[2]);
	
	// Error if an entity is not found
	if(t_trigger_id <= 0 || ct_trigger_id <= 0 || soccerball_id <= 0)
	{
		LogError("Entity not found (BL %i, TG %i, CTG %i)",
             soccerball_id, t_trigger_id, ct_trigger_id);
		
		return;
	}

	if(ct_trigger_id != -1 && t_trigger_id != -1)	
	{
		GetGoalTriggerInfo(ct_trigger_id, t_trigger_id);
		
		// calculate fieldsize
		int goaltrig_t_ref = EntIndexToEntRef(t_trigger_id);
		int goaltrig_ct_ref = EntIndexToEntRef(ct_trigger_id);

		GetEntPropVector(goaltrig_t_ref, Prop_Data, "m_vecAbsOrigin", vec_tgoal_origin);
		GetEntPropVector(goaltrig_ct_ref, Prop_Data, "m_vecAbsOrigin", vec_ctgoal_origin);
		
		// Find out map orientation (middle line)
		/*if ((vec_tgoal_origin[0] > (vec_ctgoal_origin[0] - 100.0)) && (vec_tgoal_origin[0] < (vec_ctgoal_origin[0] + 100.0)))*/
		if (vec_tgoal_origin[0] == vec_ctgoal_origin[0])
		{
			xorientation = true;
			PrintToServer("xorient")
			//DrawLaser("gk_area_beam", -10000.0, mapBallStartPosition[1], vec_tgoal_origin[2], 10000.0, mapBallStartPosition[1], vec_ctgoal_origin[2], "255 255 255");
		}
		/*else if ((vec_tgoal_origin[1] > (vec_ctgoal_origin[1] - 100.0)) && (vec_tgoal_origin[1] < (vec_ctgoal_origin[1] + 100.0)))*/
		else if (vec_tgoal_origin[1] == vec_ctgoal_origin[1])
		{
			xorientation = false;
			PrintToServer("yorient");
			//DrawLaser("gk_area_beam", mapBallStartPosition[0], -10000.0, vec_tgoal_origin[2], mapBallStartPosition[0], 10000.0, vec_ctgoal_origin[2], "255 255 255");
		}
		
		char map[128];
		GetCurrentMap(map, sizeof(map));
		if(StrEqual(map, "ka_soccer_pvt4"))	xorientation = false;
		
		
		// TODO: auto detection in case of slight variance of origins...
		/*if ((vec_tgoal_origin[0] < 0) && (vec_ctgoal_origin[0] > 0))
		{
			
		}
		else if ((vec_ctgoal_origin[0] < 0) && (vec_tgoal_origin[0] > 0))
		{
			
		}
		
		else if (((vec_tgoal_origin[0] + vec_ctgoal_origin[0]) < 20.0) || ((vec_ctgoal_origin[0] + vec_tgoal_origin[0]) < 20.0))
		{
			xorientation = true;
			PrintToServer("xorient")
		}
		else if (((vec_tgoal_origin[1] + vec_ctgoal_origin[1]) < 20.0) || ((vec_ctgoal_origin[1] + vec_tgoal_origin[1]) < 20.0))
		{
			xorientation = false;
			PrintToServer("yorient");
		}*/
		// reference field size is defined as REFERENCE_FIELD_SIZE
		//float field_size = GetVectorDistance(vec_tgoal_origin, vec_ctgoal_origin);
	}
	
}

/*public void ResetMapData()
{
	t_trigger_id = -1;
	ct_trigger_id = -1;
	
	vec_ctgoal_origin[0] = 0.0;
	vec_ctgoal_origin[1] = 0.0;
	vec_ctgoal_origin[2] = 0.0;
	
	vec_tgoal_origin[0] = 0.0;
	vec_tgoal_origin[1] = 0.0;
	vec_tgoal_origin[2] = 0.0;
}*/

public void GetGoalTriggerInfo(int ct_goal_id, int t_goal_id)
{
	GetEntPropVector(ct_goal_id, Prop_Send, "m_vecMins", ctTriggerVecMin);
	GetEntPropVector(ct_goal_id, Prop_Send, "m_vecMaxs", ctTriggerVecMax);
	GetEntPropVector(ct_goal_id, Prop_Send, "m_vecOrigin", ctTriggerOrigin);
	
	GetEntPropVector(t_goal_id, Prop_Send, "m_vecMins", tTriggerVecMin);
	GetEntPropVector(t_goal_id, Prop_Send, "m_vecMaxs", tTriggerVecMax);
	GetEntPropVector(t_goal_id, Prop_Send, "m_vecOrigin", tTriggerOrigin);
}

public void OpenGKAreaPanel(int client)
{
	char line[128];
	int panel_keys = 0;
	bool bFound = false;
	
	int index;
	while ((index = GetEntityIndexByName("gk_area_beam", "env_beam")) != -1) AcceptEntityInput(index, "Kill");
	
	kvGKArea = new KeyValues("gk_areas");
	kvGKArea.ImportFromFile(statsKeygroupGoalkeeperAreas);
	
	char mapName[128];
	GetCurrentMap(mapName, sizeof(mapName));
	
	// Create Panel
	Panel panel = new Panel();
	panel.SetTitle("GK Area Setup:");
	panel.DrawText("_______________________");
	
	// is the current map already listed?
	if (kvGKArea.JumpToKey(mapName, false))
	{
		statsCTGKAreaMinX = kvGKArea.GetFloat("ct_min_x", 0.0);
		statsCTGKAreaMinY = kvGKArea.GetFloat("ct_min_y", 0.0);
		statsCTGKAreaMinZ = kvGKArea.GetFloat("ct_min_z", 0.0);
		statsCTGKAreaMaxX = kvGKArea.GetFloat("ct_max_x", 0.0);
		statsCTGKAreaMaxY = kvGKArea.GetFloat("ct_max_y", 0.0);
		statsCTGKAreaMaxZ = kvGKArea.GetFloat("ct_max_z", 0.0);
		
		statsTGKAreaMinX = kvGKArea.GetFloat("t_min_x", 0.0);
		statsTGKAreaMinY = kvGKArea.GetFloat("t_min_y", 0.0);
		statsTGKAreaMinZ = kvGKArea.GetFloat("t_min_z", 0.0);
		statsTGKAreaMaxX = kvGKArea.GetFloat("t_max_x", 0.0);
		statsTGKAreaMaxY = kvGKArea.GetFloat("t_max_y", 0.0);
		statsTGKAreaMaxZ = kvGKArea.GetFloat("t_max_z", 0.0);
		
		bFound = true;
	}
	kvGKArea.Rewind();
	kvGKArea.Close();
	
	// draw the lasers
	if (bFound)
	{
		DisplayZones("CT", statsCTGKAreaMinX, statsCTGKAreaMinY, statsCTGKAreaMinZ, statsCTGKAreaMaxX, statsCTGKAreaMaxY, statsCTGKAreaMaxZ);
		DisplayZones("T", statsTGKAreaMinX, statsTGKAreaMinY, statsTGKAreaMinZ, statsTGKAreaMaxX, statsTGKAreaMaxY, statsTGKAreaMaxZ);
	}
	
	// Debug Output
	if (debuggingEnabled) CPrintToChatAll("{%s}[%s] {%s}CT GK Area: %.1f, %.1f, %.1f, %.1f, %.1f, %.1f", prefixcolor, prefix, textcolor, statsCTGKAreaMinX, statsCTGKAreaMinY, statsCTGKAreaMinZ, 
		statsCTGKAreaMaxX, statsCTGKAreaMaxY, statsCTGKAreaMaxZ);
	if (debuggingEnabled) CPrintToChatAll("{%s}[%s] {%s}T GK Area: %.1f, %.1f, %.1f, %.1f, %.1f, %.1f", prefixcolor, prefix, textcolor, statsTGKAreaMinX, statsTGKAreaMinY, statsTGKAreaMinZ, 
		statsTGKAreaMaxX, statsTGKAreaMaxY, statsTGKAreaMaxZ);
	
	// constant PanelText
	panel.DrawText(" ");
	panel.DrawText("HOW TO:");
	panel.DrawText(" ");
	panel.DrawText("Move to the left or right corner of");
	panel.DrawText("your desired area that IS NOT located");
	panel.DrawText("on the goalline (For example the");
	panel.DrawText("corner of the 6-yd box) and use the");
	panel.DrawText("button of the 'Set Position' button.");
	panel.DrawText(" ");
	panel.DrawText("One position is enough to set the");
	panel.DrawText("areas for both sides. If not, you'll");
	panel.DrawText("have to adjust them manually in the");
	panel.DrawText("file itself.");
	panel.DrawText(" ");
	panel.DrawText("Lasers should indicate the currently set");
	panel.DrawText("gk areas.");
	panel.DrawText(" ");
	
	// Create Buttons
	panel_keys |= (1<<1-1);
	Format(line, sizeof(line), "->1. Set Position");
	panel.DrawText(line);
	
	panel.DrawText(" ");
	
	panel_keys |= (1<<10-1);
	Format(line, sizeof(line), "0. Close");
	panel.DrawText(line);
	
	panel.SetKeys(panel_keys);
	
	panel.Send(client, GKAreaPanelHandler, MENU_TIME_FOREVER);
	
	delete panel;
}

public int GKAreaPanelHandler(Menu menu, MenuAction action, int client, int key)
{
	if(action == MenuAction_Select && key == 1)
	{
		kvGKArea = new KeyValues("gk_areas");
		kvGKArea.ImportFromFile(statsKeygroupGoalkeeperAreas);
		
		bool bAtTGoal;
		
		char mapName[128];
		GetCurrentMap(mapName, sizeof(mapName));
		
		// get playerpos and set pos at the other side of the field
		float playerpos[3], helppos[3];
		GetClientAbsOrigin(client, playerpos);
		
		// check which goal trigger is closer
		if (GetVectorDistance(playerpos, vec_tgoal_origin) < GetVectorDistance(playerpos, vec_ctgoal_origin)) bAtTGoal = true;
		else bAtTGoal = false;
		
		// Set helpposition according to map orientation
		if(xorientation)
		{
			helppos[0] = playerpos[0];
			if (mapBallStartPosition[1] == 0) helppos[1] = mapBallStartPosition[1] - playerpos[1];
			else if (mapBallStartPosition[1] > playerpos[1]) helppos[1] = mapBallStartPosition[1] + (mapBallStartPosition[1] - playerpos[1]);
			else if (mapBallStartPosition[1] < playerpos[1]) helppos[1] = mapBallStartPosition[1] - (playerpos[1] - mapBallStartPosition[1]);
			helppos[2] = playerpos[2];
		}
		else
		{
			if (mapBallStartPosition[0] == 0) helppos[0] = mapBallStartPosition[0] - playerpos[0];
			else if (mapBallStartPosition[0] > playerpos[0]) helppos[0] = mapBallStartPosition[0] + (mapBallStartPosition[0] - playerpos[0]);
			else if (mapBallStartPosition[0] < playerpos[0]) helppos[0] = mapBallStartPosition[0] - (playerpos[0] - mapBallStartPosition[0]);
			helppos[1] = playerpos[1];
			helppos[2] = playerpos[2];
		}
		
		// if X orientated
		if(xorientation)
		{
			if(bAtTGoal)
			{
				// set Terrorist vectors
				statsTGKAreaMinX = playerpos[0];
				statsTGKAreaMinY = playerpos[1];
				statsTGKAreaMinZ = playerpos[2];
				
				//X
				if (mapBallStartPosition[0] == 0) statsTGKAreaMaxX = mapBallStartPosition[0] - playerpos[0];
				else if (mapBallStartPosition[0] > playerpos[0]) statsTGKAreaMaxX = mapBallStartPosition[0] + (mapBallStartPosition[0] - playerpos[0]);
				else if (mapBallStartPosition[0] < playerpos[0]) statsTGKAreaMaxX = mapBallStartPosition[0] - (playerpos[0] - mapBallStartPosition[0]);
				//Y
				if(vec_tgoal_origin[1] < playerpos[1]) statsTGKAreaMaxY = vec_tgoal_origin[1]+40.0;
				else statsTGKAreaMaxY = vec_tgoal_origin[1]-40.0;
				//Z
				statsTGKAreaMaxZ = playerpos[2]+120.0;
				
				// set CT vectors
				statsCTGKAreaMinX = helppos[0];
				statsCTGKAreaMinY = helppos[1];
				statsCTGKAreaMinZ = helppos[2];
				
				//X
				if (mapBallStartPosition[0] == 0) statsCTGKAreaMaxX = mapBallStartPosition[0] - helppos[0];
				else if (mapBallStartPosition[0] > helppos[0]) statsCTGKAreaMaxX = mapBallStartPosition[0] + (mapBallStartPosition[0] - helppos[0]);
				else if (mapBallStartPosition[0] < helppos[0]) statsCTGKAreaMaxX = mapBallStartPosition[0]
				- (helppos[0] - mapBallStartPosition[0]);			
				//Y
				if(vec_ctgoal_origin[1] < helppos[1]) statsCTGKAreaMaxY = vec_ctgoal_origin[1]+40.0;
				else statsCTGKAreaMaxY = vec_ctgoal_origin[1]-40.0;
				//Z
				statsCTGKAreaMaxZ = helppos[2]+120.0;
			}
			else
			{
				// set CT vectors
				statsCTGKAreaMinX = playerpos[0];
				statsCTGKAreaMinY = playerpos[1];
				statsCTGKAreaMinZ = playerpos[2];	
				
				//X
				if (mapBallStartPosition[0] == 0) statsCTGKAreaMaxX = mapBallStartPosition[0]-playerpos[0];
				else if (mapBallStartPosition[0] > playerpos[0]) statsCTGKAreaMaxX = mapBallStartPosition[0] + ( mapBallStartPosition[0] - playerpos[0]);
				else if (mapBallStartPosition[0] < playerpos[0]) statsCTGKAreaMaxX = mapBallStartPosition[0] - (playerpos[0] - mapBallStartPosition[0]);
				//Y
				if(vec_ctgoal_origin[1] < playerpos[1]) statsCTGKAreaMaxY = vec_ctgoal_origin[1]+40.0;
				else statsCTGKAreaMaxY = vec_ctgoal_origin[1]-40.0;
				//Z
				statsCTGKAreaMaxZ = playerpos[2]+120.0;
				
				// set T vectors
				statsTGKAreaMinX = helppos[0];
				statsTGKAreaMinY = helppos[1];
				statsTGKAreaMinZ = helppos[2];
				
				//X
				if (mapBallStartPosition[0] == 0) statsTGKAreaMaxX = mapBallStartPosition[0]-helppos[0];
				else if (mapBallStartPosition[0] > helppos[0]) statsTGKAreaMaxX = mapBallStartPosition[0] + (mapBallStartPosition[0] - helppos[0]);
				else if (mapBallStartPosition[0] < helppos[0]) statsTGKAreaMaxX = mapBallStartPosition[0]
				- (helppos[0] - mapBallStartPosition[0]);
				//Y
				if(vec_tgoal_origin[1] < helppos[1]) statsTGKAreaMaxY = vec_tgoal_origin[1]+40.0;
				else statsTGKAreaMaxY = vec_tgoal_origin[1]-40.0;
				//Z
				statsTGKAreaMaxZ = helppos[2]+120.0;
			}
		}
		else //if Y orientated
		{
			if(bAtTGoal)
			{
				// set Terrorist vectors
				statsTGKAreaMinX = playerpos[0];
				statsTGKAreaMinY = playerpos[1];
				statsTGKAreaMinZ = playerpos[2];
				
				//X
				if(vec_tgoal_origin[0] < playerpos[0]) statsTGKAreaMaxX = vec_tgoal_origin[0]+40.0;
				else statsTGKAreaMaxX = vec_tgoal_origin[0]-40.0;
				//Y
				if (mapBallStartPosition[1] == 1) statsTGKAreaMaxY = mapBallStartPosition[1] - playerpos[1];
				else if (mapBallStartPosition[1] > playerpos[1]) statsTGKAreaMaxY = mapBallStartPosition[1] + (mapBallStartPosition[1] - playerpos[1]);
				else if (mapBallStartPosition[1] < playerpos[1]) statsTGKAreaMaxY = mapBallStartPosition[1] - (playerpos[1] - mapBallStartPosition[1]);
				//Z
				statsTGKAreaMaxZ = playerpos[2]+120.0;
				
				// set CT vectors
				statsCTGKAreaMinX = helppos[0];
				statsCTGKAreaMinY = helppos[1];
				statsCTGKAreaMinZ = helppos[2];
				
				//X
				if(vec_ctgoal_origin[0] < helppos[0]) statsCTGKAreaMaxX = vec_ctgoal_origin[0]+40.0;
				else statsCTGKAreaMaxX = vec_ctgoal_origin[0]-40.0;
				//Y
				if (mapBallStartPosition[1] == 1) statsCTGKAreaMaxY = mapBallStartPosition[1] - helppos[1];
				else if (mapBallStartPosition[1] > helppos[1]) statsCTGKAreaMaxY = mapBallStartPosition[1] + (mapBallStartPosition[1] - helppos[1]);
				else if (mapBallStartPosition[1] < helppos[1]) statsCTGKAreaMaxY = mapBallStartPosition[1]
				- (helppos[1] - mapBallStartPosition[1]);			
				//Z
				statsCTGKAreaMaxZ = helppos[2]+120.0;
			}
			else
			{
				// set CT vectors
				statsCTGKAreaMinX = playerpos[0];
				statsCTGKAreaMinY = playerpos[1];
				statsCTGKAreaMinZ = playerpos[2];
				
				//X
				if(vec_ctgoal_origin[0] < playerpos[0]) statsCTGKAreaMaxX = vec_ctgoal_origin[0]+40.0;
				else statsCTGKAreaMaxX = vec_ctgoal_origin[0]-40.0;
				//Y
				if (mapBallStartPosition[1] == 1) statsCTGKAreaMaxY = mapBallStartPosition[1]-playerpos[1];
				else if (mapBallStartPosition[1] > playerpos[1]) statsCTGKAreaMaxY = mapBallStartPosition[1] + ( mapBallStartPosition[1] - playerpos[1]);
				else if (mapBallStartPosition[1] < playerpos[1]) statsCTGKAreaMaxY = mapBallStartPosition[1] - (playerpos[1] - mapBallStartPosition[1]);
				//Z
				statsCTGKAreaMaxZ = playerpos[2]+120.0;
				
				// set T vectors
				statsTGKAreaMinX = helppos[0];
				statsTGKAreaMinY = helppos[1];
				statsTGKAreaMinZ = helppos[2];
				
				//X
				if(vec_tgoal_origin[0] < helppos[0]) statsTGKAreaMaxX = vec_tgoal_origin[0]+40.0;
				else statsTGKAreaMaxX = vec_tgoal_origin[0]-40.0;
				//Y
				if (mapBallStartPosition[1] == 1) statsTGKAreaMaxY = mapBallStartPosition[1]-helppos[1];
				else if (mapBallStartPosition[1] > helppos[1]) statsTGKAreaMaxY = mapBallStartPosition[1] + (mapBallStartPosition[1] - helppos[1]);
				else if (mapBallStartPosition[1] < helppos[1]) statsTGKAreaMaxY = mapBallStartPosition[1]
				- (helppos[1] - mapBallStartPosition[1]);
				//Z
				statsTGKAreaMaxZ = helppos[2]+120.0;
			}
		}
				
		kvGKArea.JumpToKey(mapName, true);
		
		// Min values should be smaller than Max values
		//CT X
		if (statsCTGKAreaMinX > statsCTGKAreaMaxX)
		{
			kvGKArea.SetNum("ct_min_x",		RoundToNearest(statsCTGKAreaMaxX));
			kvGKArea.SetNum("ct_max_x",		RoundToNearest(statsCTGKAreaMinX));
		}
		else
		{
			kvGKArea.SetNum("ct_min_x",		RoundToNearest(statsCTGKAreaMinX));
			kvGKArea.SetNum("ct_max_x",		RoundToNearest(statsCTGKAreaMaxX));
		}
		//CT Y
		if (statsCTGKAreaMinY > statsCTGKAreaMaxY)
		{
			kvGKArea.SetNum("ct_min_y",		RoundToNearest(statsCTGKAreaMaxY));
			kvGKArea.SetNum("ct_max_y",		RoundToNearest(statsCTGKAreaMinY));
		}
		else
		{
			kvGKArea.SetNum("ct_min_y",		RoundToNearest(statsCTGKAreaMinY));
			kvGKArea.SetNum("ct_max_y",		RoundToNearest(statsCTGKAreaMaxY));
		}
		//CT Z
		if (statsCTGKAreaMinZ > statsCTGKAreaMaxZ)
		{
			kvGKArea.SetNum("ct_min_z",		RoundToNearest(statsCTGKAreaMaxZ));
			kvGKArea.SetNum("ct_max_z",		RoundToNearest(statsCTGKAreaMinZ));
		}
		else
		{
			kvGKArea.SetNum("ct_min_z",		RoundToNearest(statsCTGKAreaMinZ));
			kvGKArea.SetNum("ct_max_z",		RoundToNearest(statsCTGKAreaMaxZ));
		}
		//T X
		if (statsTGKAreaMinX > statsTGKAreaMaxX)
		{
			kvGKArea.SetNum("t_min_x",		RoundToNearest(statsTGKAreaMaxX));
			kvGKArea.SetNum("t_max_x",		RoundToNearest(statsTGKAreaMinX));
		}
		else
		{
			kvGKArea.SetNum("t_min_x",		RoundToNearest(statsTGKAreaMinX));
			kvGKArea.SetNum("t_max_x",		RoundToNearest(statsTGKAreaMaxX));
		}
		//T Y
		if (statsTGKAreaMinY > statsTGKAreaMaxY)
		{
			kvGKArea.SetNum("t_min_y",		RoundToNearest(statsTGKAreaMaxY));
			kvGKArea.SetNum("t_max_y",		RoundToNearest(statsTGKAreaMinY));
		}
		else
		{
			kvGKArea.SetNum("t_min_y",		RoundToNearest(statsTGKAreaMinY));
			kvGKArea.SetNum("t_max_y",		RoundToNearest(statsTGKAreaMaxY));
		}
		//T Z
		if (statsTGKAreaMinZ > statsTGKAreaMaxZ)
		{
			kvGKArea.SetNum("t_min_z",		RoundToNearest(statsTGKAreaMaxZ));
			kvGKArea.SetNum("t_max_z",		RoundToNearest(statsTGKAreaMinZ));
		}
		else
		{
			kvGKArea.SetNum("t_min_z",		RoundToNearest(statsTGKAreaMinZ));
			kvGKArea.SetNum("t_max_z",		RoundToNearest(statsTGKAreaMaxZ));
		}
		
		kvGKArea.GoBack();
		
		kvGKArea.Rewind();
		kvGKArea.ExportToFile(statsKeygroupGoalkeeperAreas);
		kvGKArea.Close();
		
		OpenGKAreaPanel(client);
	}
	else
	{
		int index;
		while ((index = GetEntityIndexByName("gk_area_beam", "env_beam")) != -1) AcceptEntityInput(index, "Kill");
	}
	
	return;
}

public void DisplayZones(char type[4], float minx, float miny, float minz, float maxx, float maxy, float maxz)
{
	if(StrEqual(type, "CT"))
	{
		DrawLaser("gk_area_beam", minx, miny, minz, maxx, miny, minz, "0 0 255");
		DrawLaser("gk_area_beam", maxx, miny, minz, maxx, maxy, minz, "0 0 255");
		DrawLaser("gk_area_beam", maxx, maxy, minz, minx, maxy, minz, "0 0 255");
		DrawLaser("gk_area_beam", minx, maxy, minz, minx, miny, minz, "0 0 255");
		DrawLaser("gk_area_beam", minx, miny, maxz, maxx, miny, maxz, "0 0 255");
		DrawLaser("gk_area_beam", maxx, miny, maxz, maxx, maxy, maxz, "0 0 255");
		DrawLaser("gk_area_beam", maxx, maxy, maxz, minx, maxy, maxz, "0 0 255");
		DrawLaser("gk_area_beam", minx, maxy, maxz, minx, miny, maxz, "0 0 255");
		DrawLaser("gk_area_beam", minx, miny, minz, minx, miny, maxz, "0 0 255");
		DrawLaser("gk_area_beam", maxx, miny, minz, maxx, miny, maxz, "0 0 255");
		DrawLaser("gk_area_beam", minx, maxy, minz, minx, maxy, maxz, "0 0 255");
		DrawLaser("gk_area_beam", maxx, maxy, minz, maxx, maxy, maxz, "0 0 255");
	}
	else if (StrEqual(type, "T"))
	{
		DrawLaser("gk_area_beam", minx, miny, minz, maxx, miny, minz, "255 0 0");
		DrawLaser("gk_area_beam", maxx, miny, minz, maxx, maxy, minz, "255 0 0");
		DrawLaser("gk_area_beam", maxx, maxy, minz, minx, maxy, minz, "255 0 0");
		DrawLaser("gk_area_beam", minx, maxy, minz, minx, miny, minz, "255 0 0");
		DrawLaser("gk_area_beam", minx, miny, maxz, maxx, miny, maxz, "255 0 0");
		DrawLaser("gk_area_beam", maxx, miny, maxz, maxx, maxy, maxz, "255 0 0");
		DrawLaser("gk_area_beam", maxx, maxy, maxz, minx, maxy, maxz, "255 0 0");
		DrawLaser("gk_area_beam", minx, maxy, maxz, minx, miny, maxz, "255 0 0");
		DrawLaser("gk_area_beam", minx, miny, minz, minx, miny, maxz, "255 0 0");
		DrawLaser("gk_area_beam", maxx, miny, minz, maxx, miny, maxz, "255 0 0");
		DrawLaser("gk_area_beam", minx, maxy, minz, minx, maxy, maxz, "255 0 0");
		DrawLaser("gk_area_beam", maxx, maxy, minz, maxx, maxy, maxz, "255 0 0");
	}
}

	// variable PanelText
	/*if(bFound)
	{
		panel.DrawText("CT GK AREA:");
		Format(line, sizeof(line), "X: %.0f  |  %.0f", statsCTGKAreaMinX, statsCTGKAreaMaxX);
		panel.DrawText(line);
		Format(line, sizeof(line), "Y: %.0f  |  %.0f", statsCTGKAreaMinY, statsCTGKAreaMaxY);
		panel.DrawText(line);
		Format(line, sizeof(line), "Z: %.0f  |  %.0f", statsCTGKAreaMinZ, statsCTGKAreaMaxZ);
		panel.DrawText(line);
		panel.DrawText("__________");
		panel.DrawText("T GK AREA:");
		Format(line, sizeof(line), "X: %.0f  |  %.0f", statsTGKAreaMinX, statsTGKAreaMaxX);
		panel.DrawText(line);
		Format(line, sizeof(line), "Y: %.0f  |  %.0f", statsTGKAreaMinY, statsTGKAreaMaxY);
		panel.DrawText(line);
		Format(line, sizeof(line), "Z: %.0f  |  %.0f", statsTGKAreaMinZ, statsTGKAreaMaxZ);
		panel.DrawText(line);
	}
	else
	{
		panel.DrawText("CT GK AREA:");
		panel.DrawText("-Not Set-");
		panel.DrawText("__________");
		panel.DrawText("T GK AREA:");
		panel.DrawText("-Not Set-");
	}
	
	
	int t_trigger_id = GetEntityIndexByName("terro_But", "trigger_once");
	int ct_trigger_id = GetEntityIndexByName("ct_But", "trigger_once");
	
	// calculate fieldsize
	int goaltrig_t_ref = EntIndexToEntRef(t_trigger_id);
	int goaltrig_ct_ref = EntIndexToEntRef(ct_trigger_id);

	GetEntPropVector(goaltrig_t_ref, Prop_Data, "m_vecAbsOrigin", vec_tgoal_origin);
	GetEntPropVector(goaltrig_ct_ref, Prop_Data, "m_vecAbsOrigin", vec_ctgoal_origin);
	
	int ball_index = GetEntityIndexByName("ballon", "func_physbox");
	
	GetEntPropVector(ball_index, Prop_Send, "m_vecOrigin", mapBallStartPosition);
	
	// cross laser
	DrawLaser("gk_area_beam", vec_tgoal_origin[0], vec_tgoal_origin[1], vec_tgoal_origin[2], vec_ctgoal_origin[0], vec_ctgoal_origin[1], vec_ctgoal_origin[2], "255 255 255");
	
	if (vec_tgoal_origin[0] == vec_ctgoal_origin[0])
	{
		xorientation = true;
		
		DrawLaser("gk_area_beam", -5000.0, mapBallStartPosition[1], vec_tgoal_origin[2], 5000.0, mapBallStartPosition[1], vec_ctgoal_origin[2], "255 255 255");
	}
	else if (vec_tgoal_origin[1] == vec_ctgoal_origin[1])
	{
		xorientation = false;
		
		DrawLaser("gk_area_beam", mapBallStartPosition[0], -5000.0, vec_tgoal_origin[2], mapBallStartPosition[0], 5000.0, vec_ctgoal_origin[2], "255 255 255");
	}
	
	float pos1[3], pos2[3];
	GetClientAbsOrigin(client, pos1);
	
	if (xorientation)
	{
		pos2[0] = pos1[0];
		pos2[1] = mapBallStartPosition[1]-pos1[1];
		pos2[2] = pos1[2];
		
		// T
		DrawLaser("gk_area_beam", pos1[0], pos1[1], vec_tgoal_origin[2], pos1[0], vec_tgoal_origin[1]-30.0, vec_tgoal_origin[2], "255 0 0");
		
		DrawLaser("gk_area_beam", pos1[0], pos1[1], vec_tgoal_origin[2], mapBallStartPosition[0]-pos1[0], pos1[1], vec_tgoal_origin[2], "255 0 0");
		
		DrawLaser("gk_area_beam", mapBallStartPosition[0]-pos1[0], pos1[1], vec_tgoal_origin[2], mapBallStartPosition[0]-pos1[0], vec_tgoal_origin[1]-30.0, vec_tgoal_origin[2], "255 0 0");
		
		DrawLaser("gk_area_beam", pos1[0], vec_tgoal_origin[1]-30.0, vec_tgoal_origin[2], mapBallStartPosition[0]-pos1[0], vec_tgoal_origin[1]-30.0, vec_tgoal_origin[2], "255 0 0");
		
		// CT
		DrawLaser("gk_area_beam", pos2[0], pos2[1], vec_ctgoal_origin[2], pos2[0], vec_ctgoal_origin[1], vec_ctgoal_origin[2], "0 0 255");
		
		DrawLaser("gk_area_beam", pos2[0], pos2[1], vec_ctgoal_origin[2], mapBallStartPosition[0]-pos2[0], pos2[1], vec_ctgoal_origin[2], "0 0 255");
		
		DrawLaser("gk_area_beam", mapBallStartPosition[0]-pos2[0], pos2[1], vec_ctgoal_origin[2], mapBallStartPosition[0]-pos2[0], vec_ctgoal_origin[1], vec_ctgoal_origin[2], "0 0 255");
		
		DrawLaser("gk_area_beam", pos2[0], vec_ctgoal_origin[1], vec_ctgoal_origin[2], mapBallStartPosition[0]-pos2[0], vec_ctgoal_origin[1], vec_ctgoal_origin[2], "0 0 255");
		
	}
	else
	{
	}*/