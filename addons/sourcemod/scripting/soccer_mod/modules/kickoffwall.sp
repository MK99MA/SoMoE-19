/*public void SideWall()
{
	char map[128];
	GetCurrentMap(map, sizeof(map));
	if(StrEqual(map, "ka_soccer_xsl_stadium_b1")) 
	{
		int entindex
		entindex = CreateEntityByName("prop_dynamic");//_override");
		
		if (entindex != -1)
		{
			DispatchKeyValue(entindex, "solid", "6");
			DispatchKeyValue(entindex, "targetname", "entrywall_small");
			DispatchKeyValue(entindex, "angles", "0 90 0");
		}
		if (!IsModelPrecached("models/props/cs_office/address.mdl")) PrecacheModel("models/props/cs_office/address.mdl");
		SetEntityModel(entindex, "models/props/cs_office/address.mdl");

		float sidewallPos[3] = {-1282.5, 0.0, 0.0}
		TeleportEntity(entindex, sidewallPos, NULL_VECTOR, NULL_VECTOR);
		
		DispatchSpawn(entindex);
		ActivateEntity(entindex);

		float minbounds[3], maxbounds[3];
		minbounds[0] = 0.0;
		minbounds[1] = -130.0;
		minbounds[2] = 0.0;
		maxbounds[0] = 0.0;
		maxbounds[1] = 130.0;
		maxbounds[2] = 30.0;

		SetEntPropVector(entindex, Prop_Send, "m_vecMins", minbounds);
		SetEntPropVector(entindex, Prop_Send, "m_vecMaxs", maxbounds);
		
		SetEntProp(entindex, Prop_Send, "m_nSolidType", 2);

		int enteffects = GetEntProp(entindex, Prop_Send, "m_fEffects");
		enteffects |= 32;
		SetEntProp(entindex, Prop_Send, "m_fEffects", enteffects); 
		
		DrawLaser("entrywall_small", sidewallPos[0], minbounds[1], sidewallPos[2]+45.0, sidewallPos[0], maxbounds[1], sidewallPos[2]+45.0, "64 64 64");
	}
}

public void KillSideWall()
{
	int entityid;
	entityid = GetEntityIndexByName("entrywall_small", "prop_dynamic");
	if (entityid != -1)
	{
		AcceptEntityInput(entityid, "Kill");
	}
	
	int index;
	while ((index = GetEntityIndexByName("entrywall_small", "env_beam")) != -1) AcceptEntityInput(index, "Kill");
}*/

public void KickOffWall()
{
	if(KickoffWallSet == 1)
	{
		float radius;
		char map[128];
		GetCurrentMap(map, sizeof(map));
		if(StrEqual(map, "ka_xsl_indoorcup"))		radius = 175.0;
		else if(StrEqual(map, "ka_parkhead"))		radius = 350.0;
		else 										radius = 252.5;
	
		//wall on line
		if(xorientation) //orientation of the middle line
		{	
			//create box to allow kickoff
			if(matchLastScored > 1)
			{
				if (matchLastScored == CS_TEAM_T) //t scored
				{
					//create first half		
					CreateInvisWall(-4000.0, 0.0, -1000.0, -1*radius, 0.0, 1300.0, "wallminus", 0, CS_TEAM_CT); 			

					//create second half
					CreateInvisWall(radius, 0.0, -1000.0, 4000.0, 0.0, 1300.0, "wallplus", 1, CS_TEAM_CT);
					
					//xsl_stadium close wall
					if(StrEqual(map, "ka_soccer_xsl_stadium_b1")) CreateInvisWall(-1280.0, -130.0, 0.0, -1280.0, 130.0, 1300.0, "entrywall", 5, CS_TEAM_CT);
					
					// check coords
					if (vec_tgoal_origin[1] > vec_ctgoal_origin[1]) //t ct-
					{
						if(FileExists(wallmodel)) CreateInvisWallCircleX("wallcircle", CS_TEAM_CT, radius);
						else 
						{
							CreateInvisWall(-130.0, 0.0, 0.0, -130.0, 130.0, 1300.0, "boxside1", 2, CS_TEAM_CT);							
							CreateInvisWall(130.0, 0.0, 0.0, 130.0, 130.0, 1300.0, "boxside2", 3, CS_TEAM_CT);									
							CreateInvisWall(-130.0, 130.0, 0.0, 130.0, 130.0, 1300.0, "boxback", 4, CS_TEAM_CT);
						}
					}
					else if (vec_tgoal_origin[1] < vec_ctgoal_origin[1]) //t- ct
					{
						if(FileExists(wallmodel)) CreateInvisWallCircleX("wallcircle", CS_TEAM_CT, -1*radius);
						else
						{
							CreateInvisWall(-130.0, -130.0, 0.0, -130.0, 0.0, 1300.0, "boxside1", 2, CS_TEAM_CT);	
							CreateInvisWall(130.0, -130.0, 0.0, 130.0, 0.0, 1300.0, "boxside2", 3, CS_TEAM_CT);
							CreateInvisWall(-130.0, -130.0, 0.0, 130.0, -130.0, 1300.0, "boxback", 4, CS_TEAM_CT);
						}
					}
				}
				else if(matchLastScored == CS_TEAM_CT) //ct scored
				{
					//create first half		
					CreateInvisWall(-4000.0, 0.0, -1000.0, -1*radius, 0.0, 1300.0, "wallminus", 0, CS_TEAM_T); 			
					//create second half
					CreateInvisWall(radius, 0.0, -1000.0, 4000.0, 0.0, 1300.0, "wallplus", 1, CS_TEAM_T);
					
					//xsl_stadium close wall
					if(StrEqual(map, "ka_soccer_xsl_stadium_b1")) CreateInvisWall(-1280.0, -130.0, 0.0, -1280.0, 130.0, 1300.0, "entrywall", 5, CS_TEAM_T);
					
					// check coords
					if (vec_tgoal_origin[1] > vec_ctgoal_origin[1]) //t ct-
					{
						if(FileExists(wallmodel)) CreateInvisWallCircleX("wallcircle", CS_TEAM_T, -1*radius);
						else
						{
							CreateInvisWall(-130.0, -130.0, 0.0, -130.0, 0.0, 1300.0, "boxside1", 2, CS_TEAM_T); 
							CreateInvisWall(130.0, -130.0, 0.0, 130.0, 0.0, 1300.0, "boxside2", 3, CS_TEAM_T); 
							CreateInvisWall(-130.0, -130.0, 0.0, 130.0, -130.0, 1300.0, "boxback", 4, CS_TEAM_T);
						}
					}
					else if (vec_tgoal_origin[1] < vec_ctgoal_origin[1]) //t- ct
					{
						if(FileExists(wallmodel)) CreateInvisWallCircleX("wallcircle", CS_TEAM_T, radius);
						else
						{
							CreateInvisWall(-130.0, 0.0, 0.0, -130.0, 130.0, 1300.0, "boxside1", 2, CS_TEAM_T); 
							CreateInvisWall(130.0, 0.0, 0.0, 130.0, 130.0, 1300.0, "boxside2", 3, CS_TEAM_T);
							CreateInvisWall(-130.0, 130.0, 0.0, 130.0, 130.0, 1300.0, "boxback", 4, CS_TEAM_T);
						}
					}
				}
			}
			else
			{
				if (matchToss == CS_TEAM_T)	//t starts
				{
					//create first half		
					CreateInvisWall(-4000.0, 0.0, -1000.0, -1*radius, 0.0, 1300.0, "wallminus", 0, CS_TEAM_T); 			
					
					//create second half
					CreateInvisWall(radius, 0.0, -1000.0, 4000.0, 0.0, 1300.0, "wallplus", 1, CS_TEAM_T);
					
					//xsl_stadium close wall
					if(StrEqual(map, "ka_soccer_xsl_stadium_b1")) CreateInvisWall(-1280.0, -130.0, 0.0, -1280.0, 130.0, 1300.0, "entrywall", 5, CS_TEAM_T);
					
					// check coords
					if (vec_tgoal_origin[1] < vec_ctgoal_origin[1]) //t ct-
					{
						if(FileExists(wallmodel)) CreateInvisWallCircleX("wallcircle", CS_TEAM_T, radius);
						else
						{
							CreateInvisWall(-130.0, 0.0, 0.0, -130.0, 130.0, 1300.0, "boxside1", 2, CS_TEAM_T); 
							CreateInvisWall(130.0, 0.0, 0.0, 130.0, 130.0, 1300.0, "boxside2", 3, CS_TEAM_T); 
							CreateInvisWall(-130.0, 130.0, 0.0, 130.0, 130.0, 1300.0, "boxback", 4, CS_TEAM_T);
						}
					}
					else if (vec_tgoal_origin[1] > vec_ctgoal_origin[1]) //t- ct
					{
						if(FileExists(wallmodel)) CreateInvisWallCircleX("wallcircle", CS_TEAM_T, -1*radius);
						else
						{
							CreateInvisWall(-130.0, -130.0, 0.0, -130.0, 0.0, 1300.0, "boxside1", 2, CS_TEAM_T);
							CreateInvisWall(130.0, -130.0, 0.0, 130.0, 0.0, 1300.0, "boxside2", 3, CS_TEAM_T);
							CreateInvisWall(-130.0, -130.0, 0.0, 130.0, -130.0, 1300.0, "boxback", 4, CS_TEAM_T);	
						}
					}
				}
				else if(matchToss == CS_TEAM_CT)		//ct starts
				{
					//create first half		
					CreateInvisWall(-4000.0, 0.0, -1000.0, -1*radius, 0.0, 1300.0, "wallminus", 0, CS_TEAM_CT); 			
					
					//create second half
					CreateInvisWall(radius, 0.0, -1000.0, 4000.0, 0.0, 1300.0, "wallplus", 1, CS_TEAM_CT);
					
					//xsl_stadium close wall
					if(StrEqual(map, "ka_soccer_xsl_stadium_b1")) CreateInvisWall(-1280.0, -130.0, 0.0, -1280.0, 130.0, 1300.0, "entrywall", 5, CS_TEAM_CT);
					
					// check coords
					if (vec_tgoal_origin[1] < vec_ctgoal_origin[1]) //t ct-
					{
						if(FileExists(wallmodel)) CreateInvisWallCircleX("wallcircle", CS_TEAM_CT, -1*radius);
						else
						{
							CreateInvisWall(-130.0, -130.0, 0.0, -130.0, 0.0, 1300.0, "boxside1", 2, CS_TEAM_CT); 
							CreateInvisWall(130.0, -130.0, 0.0, 130.0, 0.0, 1300.0, "boxside2", 3, CS_TEAM_CT);
							CreateInvisWall(-130.0, -130.0, 0.0, 130.0, -130.0, 1300.0, "boxback", 4, CS_TEAM_CT);
						}
					}
					else if (vec_tgoal_origin[1] > vec_ctgoal_origin[1]) //t- ct
					{
						if(FileExists(wallmodel)) CreateInvisWallCircleX("wallcircle", CS_TEAM_CT, radius);
						else
						{
							CreateInvisWall(-130.0, 0.0, 0.0, -130.0, 130.0, 1300.0, "boxside1", 2, CS_TEAM_CT);
							CreateInvisWall(130.0, 0.0, 0.0, 130.0, 130.0, 1300.0, "boxside2", 3, CS_TEAM_CT);
							CreateInvisWall(-130.0, 130.0, 0.0, 130.0, 130.0, 1300.0, "boxback", 4, CS_TEAM_CT); 
						}
					}
				}
			}
		}
		else //yorient
		{
			// TODO: WallCircle
			//create box to allow kickoff
			if(matchLastScored > 1)
			{
				if (matchLastScored == CS_TEAM_T) //t scored
				{
					//create first half		
					CreateInvisWall(0.0, -4000.0, -1000.0, 0.0, -130.0, 1300.0, "wallminus", 0, CS_TEAM_CT); 			
					
					//create second half
					CreateInvisWall(0.0, 130.0, -1000.0, 0.0, 4000.0, 1300.0, "wallplus", 1, CS_TEAM_CT);
					
					// check coords
					if (vec_tgoal_origin[0] > vec_ctgoal_origin[0]) //t ct-
					{
						//first side
						CreateInvisWall(0.0, -130.0, 0.0, 130.0, -130.0, 1300.0, "boxside1", 2, CS_TEAM_CT);
						
						//second side		
						CreateInvisWall(0.0, 130.0, 0.0, 130.0, 130.0, 1300.0, "boxside2", 3, CS_TEAM_CT);
						
						//backside				
						CreateInvisWall(130.0, -130.0, 0.0, 130.0, 130.0, 1300.0, "boxback", 4, CS_TEAM_CT);
					}
					else if (vec_tgoal_origin[0] < vec_ctgoal_origin[0]) //t- ct
					{
						//first side
						CreateInvisWall(-130.0, -130.0, 0.0, 0.0, -130.0, 1300.0, "boxside1", 2, CS_TEAM_CT);
						
						//second side		
						CreateInvisWall(-130.0, 130.0, 0.0, 0.0, 130.0, 1300.0, "boxside2", 3, CS_TEAM_CT);
						
						//backside				
						CreateInvisWall(-130.0, -130.0, 0.0, -130.0, 130.0, 1300.0, "boxback", 4, CS_TEAM_CT);
					}
				}
				else //ct scored
				{
					//create first half		
					CreateInvisWall(0.0, -4000.0, -1000.0, 0.0, -130.0, 1300.0, "wallminus", 0, CS_TEAM_T); 			
					
					//create second half
					CreateInvisWall(0.0, 130.0, -1000.0, 0.0, 4000.0, 1300.0, "wallplus", 1, CS_TEAM_T);
					
					// check coords
					if (vec_tgoal_origin[0] > vec_ctgoal_origin[0]) //t ct-
					{
						//first side
						CreateInvisWall(-130.0, -130.0, 0.0, 0.0, -130.0, 1300.0, "boxside1", 2, CS_TEAM_T);
						
						//second side		
						CreateInvisWall(-130.0, 130.0, 0.0, 0.0, 130.0, 1300.0, "boxside2", 3, CS_TEAM_T);
						
						//backside				
						CreateInvisWall(-130.0, -130.0, 0.0, -130.0, 130.0, 1300.0, "boxback", 4, CS_TEAM_T);
					}
					else if (vec_tgoal_origin[0] < vec_ctgoal_origin[0]) //t- ct
					{
						//first side
						CreateInvisWall(0.0, -130.0, 0.0, 130.0, -130.0, 1300.0, "boxside1", 2, CS_TEAM_T);
						
						//second side		
						CreateInvisWall(0.0, 130.0, 0.0, 130.0, 130.0, 1300.0, "boxside2", 3, CS_TEAM_T);
						
						//backside				
						CreateInvisWall(130.0, -130.0, 0.0, 130.0, 130.0, 1300.0, "boxback", 4, CS_TEAM_T);
					}
				}
			}
			else
			{
				if (matchToss == CS_TEAM_T)	//t starts
				{
					//create first half		
					CreateInvisWall(0.0, -4000.0, -1000.0, 0.0, -130.0, 1300.0, "wallminus", 0, CS_TEAM_T); 			
					
					//create second half
					CreateInvisWall(0.0, 130.0, -1000.0, 0.0, 4000.0, 1300.0, "wallplus", 1, CS_TEAM_T);
					
					// check coords
					if (vec_tgoal_origin[0] < vec_ctgoal_origin[0]) //t ct-
					{
						//first side
						CreateInvisWall(0.0, -130.0, 0.0, 130.0, -130.0, 1300.0, "boxside1", 2, CS_TEAM_T);
						
						//second side		
						CreateInvisWall(0.0, 130.0, 0.0, 130.0, 130.0, 1300.0, "boxside2", 3, CS_TEAM_T);
						
						//backside				
						CreateInvisWall(130.0, -130.0, 0.0, 130.0, 130.0, 1300.0, "boxback", 4, CS_TEAM_T);
					}
					else if (vec_tgoal_origin[0] > vec_ctgoal_origin[0]) //t- ct
					{
						//first side
						CreateInvisWall(-130.0, -130.0, 0.0, 0.0, -130.0, 1300.0, "boxside1", 2, CS_TEAM_CT);
						
						//second side		
						CreateInvisWall(-130.0, 130.0, 0.0, 0.0, 130.0, 1300.0, "boxside2", 3, CS_TEAM_T);
						
						//backside				
						CreateInvisWall(-130.0, -130.0, 0.0, -130.0, 130.0, 1300.0, "boxback", 4, CS_TEAM_CT);
					}
				}
				else if(matchToss == CS_TEAM_CT)//t starts
				{
					//create first half		
					CreateInvisWall(0.0, -4000.0, -1000.0, 0.0, -130.0, 1300.0, "wallminus", 0, CS_TEAM_CT); 			
					
					//create second half
					CreateInvisWall(130.0, 0.0, -1000.0, 4000.0, 0.0, 3000.0, "wallplus", 1, CS_TEAM_CT);
					
					// check coords
					if (vec_tgoal_origin[0] < vec_ctgoal_origin[0]) //t ct-
					{
						//first side
						CreateInvisWall(-130.0, -130.0, 0.0, 0.0, -130.0, 1300.0, "boxside1", 2, CS_TEAM_CT);
						
						//second side		
						CreateInvisWall(-130.0, 130.0, 0.0, 0.0, 130.0, 1300.0, "boxside2", 3, CS_TEAM_CT);
						
						//backside				
						CreateInvisWall(-130.0, -130.0, 0.0, -130.0, 130.0, 1300.0, "boxback", 4, CS_TEAM_CT);
					}
					else if (vec_tgoal_origin[0] > vec_ctgoal_origin[0]) //t- ct
					{
						//first side
						CreateInvisWall(0.0, -130.0, 0.0, 130.0, -130.0, 1300.0, "boxside1", 2, CS_TEAM_CT);
						
						//second side		
						CreateInvisWall(0.0, 130.0, 0.0, 130.0, 130.0, 1300.0, "boxside2", 3, CS_TEAM_CT);
						
						//backside				
						CreateInvisWall(130.0, -130.0, 0.0, 130.0, 130.0, 1300.0, "boxback", 4, CS_TEAM_CT);
					}
				}
			}
		}
	}
}

public void KillWalls()
{
	int index;
	while ((index = GetEntityIndexByName("wallminus", "prop_dynamic")) != -1) AcceptEntityInput(index, "Kill");
	while ((index = GetEntityIndexByName("wallplus", "prop_dynamic")) != -1) AcceptEntityInput(index, "Kill");
	while ((index = GetEntityIndexByName("entrywall", "prop_dynamic")) != -1) AcceptEntityInput(index, "Kill");
	while ((index = GetEntityIndexByName("wallcircle", "prop_dynamic")) != -1) AcceptEntityInput(index, "Kill");
	while ((index = GetEntityIndexByName("boxside1", "prop_dynamic")) != -1) AcceptEntityInput(index, "Kill");
	while ((index = GetEntityIndexByName("boxside2", "prop_dynamic")) != -1) AcceptEntityInput(index, "Kill");
	while ((index = GetEntityIndexByName("boxback", "prop_dynamic")) != -1) AcceptEntityInput(index, "Kill");
	
	while ((index = GetEntityIndexByName("wallminus", "env_beam")) != -1) AcceptEntityInput(index, "Kill");
	while ((index = GetEntityIndexByName("wallplus", "env_beam")) != -1) AcceptEntityInput(index, "Kill");
	while ((index = GetEntityIndexByName("entrywall", "env_beam")) != -1) AcceptEntityInput(index, "Kill");
	while ((index = GetEntityIndexByName("wallcircle", "env_beam")) != -1) AcceptEntityInput(index, "Kill");
	while ((index = GetEntityIndexByName("boxside1", "env_beam")) != -1) AcceptEntityInput(index, "Kill");
	while ((index = GetEntityIndexByName("boxside2", "env_beam")) != -1) AcceptEntityInput(index, "Kill");
	while ((index = GetEntityIndexByName("boxback", "env_beam")) != -1) AcceptEntityInput(index, "Kill");
}

// ******************************************************************************************************************
// ************************************************** CREATE WALLS **************************************************
// ******************************************************************************************************************

public void CreateInvisWall(float minX, float minY, float minZ, float maxX, float maxY, float maxZ, char targetname[32], int index, int team) //bool bteam) //int orient)
{
	int entindex[6]
	entindex[index] = CreateEntityByName("prop_dynamic");//_override");
	
	float spawn[3];
	spawn = mapBallStartPosition;
	spawn[2] -= 200.0; 
	
	if (entindex[index] != -1)
	{
		DispatchKeyValue(entindex[index], "solid", "6");
		DispatchKeyValue(entindex[index], "targetname", targetname);
	}
	if (!IsModelPrecached("models/props/cs_office/address.mdl")) PrecacheModel("models/props/cs_office/address.mdl");
	SetEntityModel(entindex[index], "models/props/cs_office/address.mdl");
	
	DispatchSpawn(entindex[index]);
	ActivateEntity(entindex[index]);
	
	TeleportEntity(entindex[index], spawn, NULL_VECTOR, NULL_VECTOR);

	float minbounds[3], maxbounds[3];
	minbounds[0] = minX;
	minbounds[1] = minY;
	minbounds[2] = minZ;
	maxbounds[0] = maxX;
	maxbounds[1] = maxY;
	maxbounds[2] = maxZ;

	SetEntPropVector(entindex[index], Prop_Send, "m_vecMins", minbounds);
	SetEntPropVector(entindex[index], Prop_Send, "m_vecMaxs", maxbounds);
	
	SetEntProp(entindex[index], Prop_Send, "m_nSolidType", 2);

	int enteffects = GetEntProp(entindex[index], Prop_Send, "m_fEffects");
	enteffects |= 32;
	SetEntProp(entindex[index], Prop_Send, "m_fEffects", enteffects);
	
	KickOffLaser(targetname, minX, minY, minZ, maxX, maxY, maxZ, index, team);
}

public void CreateInvisWallCircleX(char targetname[32], int team, float radius)
{
	char color[32];
	if(team == CS_TEAM_CT) color = "0 0 255";
	else if (team == CS_TEAM_T) color = "255 0 0";
	
	float pi = 3.1415926536897932384626433832795;
	
	float angle, x, y;
	float ang[3] = {0.0, 90.0, 0.0};
	float pos1[3], pos2[3];
	int entindex[26];
	int count = 0;
	
	
	pos2[0] = mapBallStartPosition[0] + radius;
	pos2[1] = mapBallStartPosition[1];
	pos2[2] = mapBallStartPosition[2] - 18.0;
	
	angle += pi/24;
	ang[1] += 180.0/24;
	
	while(angle <= pi)
	{
		x = radius * Cosine(angle);
		y = radius * Sine(angle);			
		
		pos1[0] = mapBallStartPosition[0] + x;
		pos1[1] = mapBallStartPosition[1] + y;
		pos1[2] = mapBallStartPosition[2] - 18.0;
		
		entindex[count] = CreateEntityByName("prop_dynamic");
		
		if (!IsModelPrecached(wallmodel)) PrecacheModel(wallmodel);
		
		if (entindex[count] != -1)
		{
			DispatchKeyValue(entindex[count], "solid", "6");
			DispatchKeyValue(entindex[count], "targetname", targetname);
			DispatchKeyValue(entindex[count], "model", wallmodel);
			DispatchKeyValueVector(entindex[count], "origin", pos1);
		}	
		
		DispatchSpawn(entindex[count]);
		ActivateEntity(entindex[count]);
		
		TeleportEntity(entindex[count], NULL_VECTOR, ang, NULL_VECTOR);
		
		int enteffects = GetEntProp(entindex[count], Prop_Send, "m_fEffects");
		enteffects |= 32;
		SetEntProp(entindex[count], Prop_Send, "m_fEffects", enteffects);
		
		DrawLaser(targetname, pos1[0], pos1[1], mapBallStartPosition[2]-18.0, pos1[0], pos1[1], mapBallStartPosition[2]+110.0, color);
		DrawLaser(targetname, pos1[0], pos1[1], mapBallStartPosition[2]+110.0, pos2[0], pos2[1], mapBallStartPosition[2]+110.0, color);
		/*TE_SetupBeamPoints(pos1, pos2, g_BeamSprite, g_HaloSprite, 0, 0, 8.0, view_as<float>(5.0), view_as<float>(5.0), 5, 0.0, {255,255,255,255}, 3);
		TE_SendToAll();*/
		
		pos2[0] = pos1[0];
		pos2[1] = pos1[1];
		pos2[2] = pos1[2];
		
		angle += pi/12;
		ang[1] += 180.0/12;
		count += 1;
	}
	
	pos1[0] = mapBallStartPosition[0] - radius;
	pos1[1] = mapBallStartPosition[1];
	pos1[2] = mapBallStartPosition[2] - 18.0;

	DrawLaser(targetname, pos1[0], pos1[1], mapBallStartPosition[2]+110.0, pos2[0], pos2[1], mapBallStartPosition[2]+110.0, color);
}

/*public void CreateInvisWallCircleY(char targetname[32], int team, float radius)
{
	char color[32];
	if(team == CS_TEAM_CT) color = "0 0 255";
	else if (team == CS_TEAM_T) color = "255 0 0";
	
	float pi = 3.1415926536897932384626433832795;
	
	float angle, x, y;
	float ang[3] = {0.0, 90.0, 0.0};
	float pos1[3], pos2[3];
	int entindex[26];
	int count = 0;
	
	
	pos2[0] = mapBallStartPosition[0] + radius;
	pos2[1] = mapBallStartPosition[1];
	pos2[2] = mapBallStartPosition[2] - 18.0;
	
	angle += pi/24;
	ang[1] += 180.0/24;
	
	while(angle <= pi)
	{
		x = radius * Cosine(angle);
		y = radius * Sine(angle);			
		
		pos1[0] = mapBallStartPosition[0] + x;
		pos1[1] = mapBallStartPosition[1] + y;
		pos1[2] = mapBallStartPosition[2] - 18.0;
		
		entindex[count] = CreateEntityByName("prop_dynamic");
		
		if (!IsModelPrecached(wallmodel)) PrecacheModel(wallmodel);
		
		if (entindex[count] != -1)
		{
			DispatchKeyValue(entindex[count], "solid", "6");
			DispatchKeyValue(entindex[count], "targetname", targetname);
			DispatchKeyValue(entindex[count], "model", wallmodel);
			DispatchKeyValueVector(entindex[count], "origin", pos1);
		}	
		
		DispatchSpawn(entindex[count]);
		ActivateEntity(entindex[count]);
		
		TeleportEntity(entindex[count], NULL_VECTOR, ang, NULL_VECTOR);
		
		int enteffects = GetEntProp(entindex[count], Prop_Send, "m_fEffects");
		enteffects |= 32;
		SetEntProp(entindex[count], Prop_Send, "m_fEffects", enteffects);
		
		DrawLaser(targetname, pos1[0], pos1[1], mapBallStartPosition[2]-18.0, pos1[0], pos1[1], mapBallStartPosition[2]+110.0, color);
		DrawLaser(targetname, pos1[0], pos1[1], mapBallStartPosition[2]+110.0, pos2[0], pos2[1], mapBallStartPosition[2]+110.0, color);
		
		pos2[0] = pos1[0];
		pos2[1] = pos1[1];
		pos2[2] = pos1[2];
		
		angle += pi/12;
		ang[1] += 180.0/12;
		count += 1;
	}
	
	pos1[0] = mapBallStartPosition[0] - radius;
	pos1[1] = mapBallStartPosition[1];
	pos1[2] = mapBallStartPosition[2] - 18.0;

	DrawLaser(targetname, pos1[0], pos1[1], mapBallStartPosition[2]+110.0, pos2[0], pos2[1], mapBallStartPosition[2]+110.0, color);
}*/


public void KickOffLaser(char targetname[32], float minX, float minY, float minZ, float maxX, float maxY, float maxZ, int index, int team)
{
	char color[32];
	if(team == CS_TEAM_CT) color = "0 0 255";
	else if (team == CS_TEAM_T) color = "255 0 0";
	
	//vert laser
	DrawLaser(targetname, mapBallStartPosition[0]+minX, mapBallStartPosition[1]+minY, mapBallStartPosition[2]-18, mapBallStartPosition[0]+minX, mapBallStartPosition[1]+minY, mapBallStartPosition[2]+110.0, color);
	DrawLaser(targetname, mapBallStartPosition[0]+maxX, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]-18, mapBallStartPosition[0]+maxX, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, color);
	if(index <= 1) 
	{
		if(xorientation)
		{
			// vert borders
			DrawLaser(targetname, mapBallStartPosition[0]+1280.0, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]-18, mapBallStartPosition[0]+1280.0, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, color);
			DrawLaser(targetname, mapBallStartPosition[0]+640.0, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]-18, mapBallStartPosition[0]+640.0, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, color);
			DrawLaser(targetname, mapBallStartPosition[0]-1280.0, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]-18, mapBallStartPosition[0]-1280.0, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, color);
			DrawLaser(targetname, mapBallStartPosition[0]-640.0, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]-18, mapBallStartPosition[0]-640.0, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, color);
		}
		else
		{
			// vert borders
			DrawLaser(targetname, mapBallStartPosition[0]+maxX, mapBallStartPosition[1]+1280.0, mapBallStartPosition[2]-18, mapBallStartPosition[0]+maxX, mapBallStartPosition[1]+1280.0, mapBallStartPosition[2]+110.0, color);
			DrawLaser(targetname, mapBallStartPosition[0]+maxX, mapBallStartPosition[1]+640.0, mapBallStartPosition[2]-18, mapBallStartPosition[0]+maxX, mapBallStartPosition[1]+640.0, mapBallStartPosition[2]+110.0, color);
			DrawLaser(targetname, mapBallStartPosition[0]+maxX, mapBallStartPosition[1]-1280.0, mapBallStartPosition[2]-18, mapBallStartPosition[0]+maxX, mapBallStartPosition[1]-1280.0, mapBallStartPosition[2]+110.0, color);
			DrawLaser(targetname, mapBallStartPosition[0]+maxX, mapBallStartPosition[1]-640.0, mapBallStartPosition[2]-18, mapBallStartPosition[0]+maxX, mapBallStartPosition[1]-640.0, mapBallStartPosition[2]+110.0, color);
		}
	}
	//horiz laser
	char map[128];
	GetCurrentMap(map, sizeof(map));
	if(StrEqual(map, "ka_soccer_xsl_stadium_b1"))
	{
		//wall
		if (index == 0)
		{
			DrawLaser(targetname, mapBallStartPosition[0]-1280.0, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, mapBallStartPosition[0]+maxX, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, color);
		}
		else if (index == 1)
		{
			DrawLaser(targetname, mapBallStartPosition[0]+minX, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, mapBallStartPosition[0]+1280.0, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, color);
		}
		else 
		{
			DrawLaser(targetname, mapBallStartPosition[0]+minX, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, mapBallStartPosition[0]+maxX, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, color);
		}
		//box sides
		DrawLaser(targetname, mapBallStartPosition[0]+minX, mapBallStartPosition[1]+minY, mapBallStartPosition[2]+110.0, mapBallStartPosition[0]+minX, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, color);
	}
	else
	{
		// walls
		DrawLaser(targetname, mapBallStartPosition[0]+minX, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, mapBallStartPosition[0]+maxX, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, color);
		// sides
		DrawLaser(targetname, mapBallStartPosition[0]+minX, mapBallStartPosition[1]+minY, mapBallStartPosition[2]+110.0, mapBallStartPosition[0]+minX, mapBallStartPosition[1]+maxY, mapBallStartPosition[2]+110.0, color);
	}
}