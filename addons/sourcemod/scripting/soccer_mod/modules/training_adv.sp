// *******************************************************************************************************************
// *********************************************** ADV TRAIN MAIN MENU ***********************************************
// *******************************************************************************************************************
public void OpenAdvancedTrainingMenu(int client)
{
	Menu menu = new Menu(MenuHandlerAdvTraining);

	menu.SetTitle("Soccer Mod - Advanced Training");

	char TrainModeString[32]; //,TrailString[32]
	
	if(trainingModeEnabled)		TrainModeString = "Trainingmode: ON";
	else						TrainModeString = "Trainingmode: OFF";
	
	//if(trailset == 0)				TrailString = "Player Trails: OFF";
	//else if (trailset == 1)			TrailString = "Player Trails: ON";

	menu.AddItem("trainmode", TrainModeString);	
	if (FileExists(trainingModelTarget, true) && FileExists(trainingModelBlock, true)) menu.AddItem("goaltarget", "Goaltargets"); //submenu ct / t activation
	menu.AddItem("cone", "Cone Manager");
	/*menu.AddItem("gkblock", "Simple GK"); //submenu ct / t activation
	if (FileExists(trainingModelPass, true))menu.AddItem("passtrain", "Spawn / Remove passing net");
	if (FileExists(trainingModel1v1, true))menu.AddItem("1v1", "Spawn / Remove 1v1 pitch");
	menu.AddItem("trails", TrailString);*/
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAdvTraining(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "trainmode"))
		{
			if(!trainingModeEnabled)
			{
				trainingModeEnabled = true;
				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsValidClient(player) && GetClientTeam(player) == 3)
					{
						//Move CT to T
						ChangeClientTeam(player, 2);
					}
				}
				TrainingDisableGoals(client);
				OpenAdvancedTrainingMenu(client);
			}
			else
			{
				trainingModeEnabled = false;
				TrainingEnableGoals(client);
				OpenAdvancedTrainingMenu(client);
			}
		}
		else if (StrEqual(menuItem, "cone"))			OpenAdvancedTrainingConeMenu(client);
		else if (StrEqual(menuItem, "goaltarget"))		OpenAdvancedTrainingTargetMenu(client);
		/*else if (StrEqual(menuItem, "trails"))
		{
			//TrainingEnableTrails(client);
			OpenAdvancedTrainingMenu(client);
		}
		else if (StrEqual(menuItem, "gkblock"))			OpenAdvancedTrainingSimpleGKMenu(client);
		else if (StrEqual(menuItem, "passtrain"))		
		{
			if(GetClientTeam(client) > 1 && IsPlayerAlive(client))
			{
				//TrainingSpawnPassnet(client);
				OpenAdvancedTrainingMenu(client);
			}
			else 
			{
				CPrintToChat(client,"{%s}[%s] {%s}Only alive players can spawn this device.", prefixcolor, prefix, textcolor);
				OpenAdvancedTrainingMenu(client);
			}
		}
		else if (StrEqual(menuItem, "1v1"))
		{
			if(GetClientTeam(client) > 1 && IsPlayerAlive(client))
			{
				if(!minigameActive	)
				{
					//TrainingSpawn1v1(client);
					OpenAdvancedTrainingMenu(client);
				}
				else
				{
					CPrintToChat(client,"{%s}[%s] {%s}Only 1 pitch is allowed at the same time.", prefixcolor, prefix, textcolor);
					OpenAdvancedTrainingMenu(client);
				}
			}
			else 
			{
				CPrintToChat(client,"{%s}[%s] {%s}Only alive players can spawn cones.", prefixcolor, prefix, textcolor);
				OpenAdvancedTrainingMenu(client);
			}
		}	*/
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenTrainingMenu(client);
	else if (action == MenuAction_End)					 	menu.Close();
}


// *******************************************************************************************************************
// ************************************************* GOALTARGET MENU *************************************************
// *******************************************************************************************************************
public void OpenAdvancedTrainingTargetMenu(int client)
{
	Menu menu = new Menu(MenuHandlerAdvTrainingTarget);

	menu.SetTitle("Soccer Mod - Advanced Training");

	char CTString[32], TString[32], ModeString[32], TPosString[32], CTPosString[32], AutoCTString[32], AutoTString[32], AutoFullString[32];
	
	if (targetmode == 0)		ModeString = "Mode: Single";
	else if (targetmode == 1)	ModeString = "Mode: Multi";

	if(tgoaltarget)				TString = "T Target: ON";
	else 						TString = "T Target: OFF";
	
	if(ctgoaltarget)			CTString = "CT Target: ON";
	else 						CTString = "CT Target: OFF";
	
	if(lastTargetBallId[0] == -1)								TPosString = "Select Ball (T Side)";
	else if(lastTargetBallId[0] != -1 && respawnIndex[0] == -1)	TPosString = "Set Ball Respawn(T Side)";
	else														TPosString = "Move Ball Respawn(T Side)";
	
	if(lastTargetBallId[1] == -1)								CTPosString = "Select Ball (CT Side)";
	else if(lastTargetBallId[0] != -1 && respawnIndex[0] == -1)	CTPosString = "Set Ball Respawn(CT Side)";
	else														CTPosString = "Move Ball Respawn(CT Side)";
	
	if(autoToggle[0])			AutoTString = "T: ON";
	else						AutoTString = "T: OFF";
	if(autoToggle[1])			AutoCTString = "CT: ON";
	else						AutoCTString = "CT: OFF";
	Format(AutoFullString, sizeof(AutoFullString), "AutoReset: %s | %s", AutoTString, AutoCTString);

	menu.AddItem("targetmode", ModeString);
	menu.AddItem("goaltarget_t", TString);
	menu.AddItem("goaltarget_ct", CTString);
	menu.AddItem("resetball", "Reset Ball");
	menu.AddItem("autoreset", AutoFullString);
	menu.AddItem("ballspawnt", TPosString);
	menu.AddItem("ballspawnct", CTPosString);
	menu.AddItem("resetT", "Reset T Ball & Spawn");
	menu.AddItem("resetCT", "Reset CT Ball & Spawn");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAdvTrainingTarget(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		int modehelper;
		modehelper = targetmode
		
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "targetmode"))
		{
			if(targetmode == 0)	targetmode = 1;
			else if (targetmode == 1) targetmode = 0;
			
			OpenAdvancedTrainingTargetMenu(client);
		}
		else if (StrEqual(menuItem, "goaltarget_t"))					
		{		
			if(trainingModeEnabled)	
			{
				if(tgoaltarget) 
				{
					tgoaltarget = false;
					SpawnGoalTarget(client, CS_TEAM_T, false, modehelper);
				}
				else 
				{
					tgoaltarget = true;
					SpawnGoalTarget(client, CS_TEAM_T, true, modehelper);
					CPrintToChat(client,"{%s}[%s] {%s}T Target enabled.", prefixcolor, prefix, textcolor);
				}
			}
			else CPrintToChat(client,"{%s}[%s] {%s}Please activate the training mode to enable the goaltargets.", prefixcolor, prefix, textcolor);

		}
		else if (StrEqual(menuItem, "goaltarget_ct"))				
		{
			if(trainingModeEnabled)	
			{
				if(ctgoaltarget) 
				{
					ctgoaltarget = false;
					SpawnGoalTarget(client, CS_TEAM_CT, false, modehelper);
				}
				else
				{
					ctgoaltarget = true;
					SpawnGoalTarget(client, CS_TEAM_CT, true, modehelper);
					CPrintToChat(client,"{%s}[%s] {%s}CT Target enabled.", prefixcolor, prefix, textcolor);
				}
			}
			else CPrintToChat(client,"{%s}[%s] {%s}Please activate the training mode to enable the goaltargets.", prefixcolor, prefix, textcolor);
		}
		else if (StrEqual(menuItem, "ballspawnt"))		
		{
			if(trainingModeEnabled)	
			{
				if(lastTargetBallId[0] != -1)
				{
					if(respawnIndex[0] == -1)	SelectPosition(client, 0);
					else						
					{	
						GrabEntity(client, "spawn", 0);
					}
				}
				else if (lastTargetBallId[0] == -1)
				{
					SelectBall(client, 0);
				}
			}
			else CPrintToChat(client,"{%s}[%s] {%s}Please activate the training mode to set the ball respawn.", prefixcolor, prefix, textcolor);
		}
		else if (StrEqual(menuItem, "ballspawnct"))
		{
			if(trainingModeEnabled)
			{
				if(lastTargetBallId[1] != -1)
				{
					if(respawnIndex[1] == -1)	SelectPosition(client, 1);
					else						
					{
						GrabEntity(client, "spawn", 1);
					}
				}
				else if (lastTargetBallId[1] == -1)
				{
					SelectBall(client, 1);
				}
			}
			else CPrintToChat(client,"{%s}[%s] {%s}Please activate the training mode to set the ball respawn.", prefixcolor, prefix, textcolor);
		}
		else if (StrEqual(menuItem, "resetball"))
		{
			ResetBall(client, false);
		}
		else if (StrEqual(menuItem, "autoreset"))
		{
			ResetBall(client, true);
		}
		else if (StrEqual(menuItem, "resetT"))
		{
			AcceptEntityInput(respawnIndex[0], "Kill");
			lastTargetBallId[0] = -1;
			respawnIndex[0] = -1;
			CPrintToChat(client,"{%s}[%s] {%s}T Ballrespawn reset.", prefixcolor, prefix, textcolor);
		}
		else if (StrEqual(menuItem, "resetCT"))
		{
			AcceptEntityInput(respawnIndex[1], "Kill");
			lastTargetBallId[1] = -1;
			respawnIndex[1] = -1;
			CPrintToChat(client,"{%s}[%s] {%s}CT Ballrespawn reset.", prefixcolor, prefix, textcolor);
		}
		
		OpenAdvancedTrainingTargetMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenAdvancedTrainingMenu(client);
	else if (action == MenuAction_End)					  	menu.Close();
}

public void ResetBall(int client, bool toggle)
{
	float nullvec[3] = {0.0, 0.0, 0.0}
	float playerPos[3];
	char activatorname[64];
	char ballnumber[64];
	int ballnum;
	GetClientAbsOrigin(client, playerPos);
	if(AreVectorsEqual(ballPortPosT, nullvec) && AreVectorsEqual(ballPortPosCT, nullvec))
	{
		CPrintToChat(client,"{%s}[%s] {%s}No positions set.", prefixcolor, prefix, textcolor);
	}
	else
	{
		if(GetVectorDistance(playerPos, ballPortPosT) < GetVectorDistance(playerPos, ballPortPosCT))
		{
			if(lastTargetBallId[0] != -1)	
			{
				hitHelper[0] = false;
				
				if(toggle)
				{
					if(autoToggle[0]) //t true
					{
						autoToggle[0] = false;
					}
					else
					{
						autoToggle[0] = true;
					}
				}
				else
				{
					GetEntPropString(lastTargetBallId[0], Prop_Data, "m_iName", activatorname, sizeof(activatorname));
					
					if(StrEqual(activatorname, "ball") || StrEqual(activatorname, "ballon"))
					{
						if (trainingCannonTimer == null)
						{
							if(lastTargetBallId[0] != -1)
							{
								delete trainingBallResetTimer[0];
								TeleportEntity(lastTargetBallId[0], ballPortPosT, nullvec, nullvec);
								AcceptEntityInput(lastTargetBallId[0], "Sleep");
							}
						}
					}
					else if (StrContains(activatorname, "soccer_mod_training_ball_") != -1)
					{
						ballnumber = activatorname;
						ReplaceString(ballnumber, sizeof(ballnumber), "soccer_mod_training_ball_", "");
						ballnum = StringToInt(ballnumber);
						
						if (pers_trainingCannonTimer[ballnum] == null)
						{
							if(lastTargetBallId[0] != -1)
							{
								delete trainingBallResetTimer[0];
								TeleportEntity(lastTargetBallId[0], ballPortPosT, nullvec, nullvec);
								AcceptEntityInput(lastTargetBallId[0], "Sleep");
							}
						}
					}
				}
			}
			else CPrintToChat(client,"{%s}[%s] {%s}No ball set for this side.", prefixcolor, prefix, textcolor);
		}
		else if (GetVectorDistance(playerPos, ballPortPosT) > GetVectorDistance(playerPos, ballPortPosCT))
		{
			if(lastTargetBallId[1] != -1)	
			{
				hitHelper[1] = false;
				
				if(toggle)
				{
					if(autoToggle[1]) //ct true
					{
						autoToggle[1] = false;
					}
					else
					{
						autoToggle[1] = true;
					}
				}
				else
				{
					GetEntPropString(lastTargetBallId[1], Prop_Data, "m_iName", activatorname, sizeof(activatorname));
					
					if(StrEqual(activatorname, "ball") || StrEqual(activatorname, "ballon"))
					{
						if(lastTargetBallId[1] != -1)
						{
							if (trainingCannonTimer == null)
							{
								delete trainingBallResetTimer[1];
								TeleportEntity(lastTargetBallId[1], ballPortPosCT, nullvec, nullvec);
								AcceptEntityInput(lastTargetBallId[1], "Sleep");
							}
						}
					}
					else if (StrContains(activatorname, "soccer_mod_training_ball_") != -1)
					{
						ballnumber = activatorname;
						ReplaceString(ballnumber, sizeof(ballnumber), "soccer_mod_training_ball_", "");
						ballnum = StringToInt(ballnumber);
						
						if(lastTargetBallId[1] != -1)
						{
							if (pers_trainingCannonTimer[ballnum] == null)
							{
								delete trainingBallResetTimer[1];
								TeleportEntity(lastTargetBallId[1], ballPortPosCT, nullvec, nullvec);
								AcceptEntityInput(lastTargetBallId[1], "Sleep");
							}
						}
					}
				}
			}
			else CPrintToChat(client,"{%s}[%s] {%s}No ball set for this side.", prefixcolor, prefix, textcolor);
		}
	}
}

public void SelectPosition(int client, int team)
{
	// Spawn visual indicator
	int ind;
	float aimPos[3];
	float dir[3] = {0.0, 0.0, 90.0};
	char entityName[64];
	GetAimOrigin(client, aimPos);
	
	Format(entityName, sizeof(entityName), "soccer_mod_training_ballspawn_%i", team);
	
	ind = CreateEntityByName("prop_dynamic");
	
	if(ind != -1)
	{
		if (!IsModelPrecached(trainingModelPlate)) PrecacheModel(trainingModelPlate);
		
		DispatchKeyValue(ind, "targetname", entityName);
		DispatchKeyValue(ind, "model", trainingModelPlate);
		DispatchKeyValueFloat(ind, "modelscale", 0.5);
		DispatchKeyValueVector(ind, "origin", aimPos);
		//DispatchKeyValue(ind, "solid", "0"); // 6
		SetEntProp(ind, Prop_Data, "m_nSolidType", 0);
		DispatchKeyValueVector(ind, "angles", dir);
		DispatchSpawn(ind);
		SetEntityRenderMode(ind, RENDER_TRANSALPHA);
		if(team == 0)			SetEntityRenderColor(ind, 255, 0, 0, 90);
		else if (team == 1)		SetEntityRenderColor(ind, 0, 0, 255, 90);
	}
	
	if(team == 0)
	{
		ballPortPosT = aimPos;
		ballPortPosT[2] += 15.0;
		respawnIndex[0] = ind;
	}
	else if (team == 1)
	{
		ballPortPosCT = aimPos;
		ballPortPosCT[2] += 15.0;
		respawnIndex[1] = ind;
	}
	CPrintToChat(client,"{%s}[%s] {%s}Ballport position set!", prefixcolor, prefix, textcolor);
	//PrintToChatAll("T: %i CT: %i", respawnIndex[0], respawnIndex[1]);
}

public void SelectBall(int client, int arraypos)
{
	float aimPos[3], ballPos[3];
	GetAimOrigin(client, aimPos);
	int ball_id;
	
	if(lastTargetBallId[arraypos] == -1)
	{
		while ((ball_id = FindEntityByClassname(ball_id, "func_physbox")) != INVALID_ENT_REFERENCE)
		{
			if(ball_id != -1)
			{
				GetEntPropVector(ball_id, Prop_Send, "m_vecOrigin", ballPos);
				if (GetVectorDistance(ballPos, aimPos) <= 50.0)
				{
					lastTargetBallId[arraypos] = ball_id;
				}
			}
		}
	}
	
	if(lastTargetBallId[arraypos] == -1)
	{
		while ((ball_id = FindEntityByClassname(ball_id, "prop_physics")) != INVALID_ENT_REFERENCE)
		{
			if(ball_id != -1)
			{
				GetEntPropVector(ball_id, Prop_Send, "m_vecOrigin", ballPos);
				if (GetVectorDistance(ballPos, aimPos) <= 50.0)
				{
					lastTargetBallId[arraypos] = ball_id;
				}
			}
		}
	}

	if(lastTargetBallId[arraypos] == -1)
	{
		while ((ball_id = FindEntityByClassname(ball_id, "prop_physics")) != INVALID_ENT_REFERENCE)
		{
			if(ball_id != -1)
			{
				char ballName[64];
				GetEntPropString(ball_id, Prop_Data, "m_iName", ballName, sizeof(ballName));
				if(StrContains(ballName, "soccer_mod_training_ball_") != -1)
				{
					GetEntPropVector(ball_id, Prop_Send, "m_vecOrigin", ballPos);
					if (GetVectorDistance(ballPos, aimPos) <= 50.0)
					{
						lastTargetBallId[arraypos] = ball_id;
					}
				}
			}
		}
	}
	if(arraypos == 0)
	{
		if(lastTargetBallId[arraypos] == lastTargetBallId[1] && lastTargetBallId[1] != -1) 
		{
			CPrintToChat(client,"{%s}[%s] {%s}Ball already in use!", prefixcolor, prefix, textcolor);
			lastTargetBallId[arraypos] = -1;
		}
		else if(lastTargetBallId[arraypos] == -1)
		{
			CPrintToChat(client,"{%s}[%s] {%s}No valid ball found!", prefixcolor, prefix, textcolor);
		}
		else  CPrintToChat(client,"{%s}[%s] {%s}Ball selected!", prefixcolor, prefix, textcolor);
	}
	else if (arraypos == 1)
	{
		if(lastTargetBallId[arraypos] == lastTargetBallId[0] && lastTargetBallId[0] != -1) 
		{
			CPrintToChat(client,"{%s}[%s] {%s}Ball already in use!", prefixcolor, prefix, textcolor);
			lastTargetBallId[arraypos] = -1;
		}
		else if(lastTargetBallId[arraypos] == -1)
		{
			CPrintToChat(client,"{%s}[%s] {%s}No valid ball found!", prefixcolor, prefix, textcolor);
		}
		else  CPrintToChat(client,"{%s}[%s] {%s}Ball selected!", prefixcolor, prefix, textcolor);
	}
}

public void SpawnGoalTarget(int client, int team, bool spawn, int mode)
{
	int index = -1;
	float spawnPos[3];
	if(team == CS_TEAM_T)			spawnPos  = tTriggerOrigin;
	else if (team == CS_TEAM_CT)	spawnPos  = ctTriggerOrigin;
	spawnPos[2] = mapBallStartPosition[2]-15.0;
	
	if (FileExists(trainingModelTarget, true))
	{	
		char entityName[32];
		Format(entityName, sizeof(entityName), "soccer_mod_training_target_%i", team);		
		
		if(mode == 0)
		{
			if(spawn) //spawn
			{
				if (index == -1)
				{
					index = CreateEntityByName("prop_dynamic");

					if (index)
					{
						SpawnTarget(index, team, entityName, spawnPos);
						
						for (int i = 1; i <= 10; i++)
						{	
							SpawnTargetMulti(i, client, team, spawnPos, "block");
						}
						SpawnTargetTrigger(index, team, entityName, spawnPos, 0);
					}
				}
			}
			else	RemoveTarget(index, team);  //remove
		}
		else if (mode == 1)
		{
			if (spawn)
			{				
				/*if (index == -1)
				{
					index = CreateEntityByName("prop_dynamic");

					if (index)
					{*/
						for (int i = 1; i <= 10; i++)
						{	
							SpawnTargetMulti(i, client, team, spawnPos, "target");
						}						
					/*}
				}*/
			}
			else 
			{
				if(team == CS_TEAM_T)			targetcounter[0] = 0;
				else if (team == CS_TEAM_CT)	targetcounter[1] = 0;
				RemoveTarget(index, team);  //remove
			}
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Cant spawn model %s", prefixcolor, prefix, textcolor, trainingModelTarget);
	
}

// *******************************************************************************************************************
// *********************************************** HANDLE GOALTARGETS ************************************************
// *******************************************************************************************************************

public void SpawnTarget(int index, int team, char entityName[32], float spawnPos[3])
{
	if (!IsModelPrecached(trainingModelTarget)) PrecacheModel(trainingModelTarget);

	DispatchKeyValue(index, "targetname", entityName);
	DispatchKeyValue(index, "model", trainingModelTarget);
	DispatchKeyValue(index, "solid", "6");

	if(xorientation)	
	{
		spawnPos[0] = GetRandomPos(spawnPos, 0); // 1-5 
		spawnPos[1] = GetOffset(spawnPos); //30.0
	}
	else				
	{
		spawnPos[0] = GetOffset(spawnPos); //30.0
		spawnPos[1] = GetRandomPos(spawnPos, 1); // 1-5
		
		DispatchKeyValue(index, "angles", "0 90 0");
	}
	spawnPos[2]						= GetRandomPos(spawnPos, 2); // 1-2
	
	DispatchKeyValueVector(index, "origin", spawnPos);
	SetEntityRenderColor(index, 255, 255, 255, 0);
	
	DispatchSpawn(index);
}

public void RemoveTarget(int index, int team)
{
	char targetName[32];
	Format(targetName, sizeof(targetName), "soccer_mod_training_target_%i", team);
	char blockName[64], entPropString[64],triggerName[64];
	
	Format(triggerName, sizeof(triggerName), "soccer_mod_training_targettrigger_%i", team);

	index = GetEntityIndexByName(targetName, "prop_dynamic");
	if(index != -1)
	{
		GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));
		if (StrEqual(entPropString, targetName))		AcceptEntityInput(index, "Kill");
	}
	
	index = GetEntityIndexByName(triggerName, "trigger_multiple");
	if(index != -1)
	{
		GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));
		if (StrEqual(entPropString, triggerName))		AcceptEntityInput(index, "Kill");
	}

	for (int i = 1; i <= 10; i++)
	{
		Format(blockName, sizeof(blockName), "soccer_mod_training_block_%i_%i", team, i);
		
		index = GetEntityIndexByName(blockName, "prop_dynamic");
		if(index != -1)
		{
			GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));
			if (StrEqual(entPropString, blockName))	AcceptEntityInput(index, "Kill");
		}
		
		Format(targetName, sizeof(targetName), "soccer_mod_training_target_%i_%i", team, i);
		
		index = GetEntityIndexByName(targetName, "prop_dynamic");
		if(index != -1)
		{
			GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));
			if (StrEqual(entPropString, targetName))	AcceptEntityInput(index, "Kill");
		}
		
		Format(triggerName, sizeof(triggerName), "soccer_mod_training_targettrigger_%i_%i", team, i);
		index = GetEntityIndexByName(triggerName, "trigger_once");
		if(index != -1)
		{
			GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));
			if (StrEqual(entPropString, triggerName))		AcceptEntityInput(index, "Kill");
		}
		
	}
}

public void SpawnTargetMulti(int i, int client, int team, float targetPos[3], char type[32])
{
	int index = -1;
	float spawnPos[3];
	if(team == CS_TEAM_T)
	{
		spawnPos  = tTriggerOrigin;
	}
	else if (team == CS_TEAM_CT)
	{
		spawnPos  = ctTriggerOrigin;
	}
	spawnPos[2] = mapBallStartPosition[2]-15.0;
	
	if (FileExists(trainingModelBlock, true))
	{
		char entityName[32], entityModel[128];
		if(StrEqual(type, "block"))
		{
			Format(entityName, sizeof(entityName), "soccer_mod_training_block_%i_%i", team, i);		
			entityModel = trainingModelBlock;
		}
		else if (StrEqual(type, "target"))
		{
			Format(entityName, sizeof(entityName), "soccer_mod_training_target_%i_%i", team, i);		
			entityModel = trainingModelTarget;
		}
		
		index = CreateEntityByName("prop_dynamic");
		
		if (index != -1)
		{
			float tempPos[3];
			if(xorientation)	
			{
				tempPos = GetOffsetPos(spawnPos, i);
				
				spawnPos[0] = tempPos[0];
				spawnPos[2] = tempPos[2];
				
				spawnPos[1] = GetOffset(spawnPos); //30.0
			}
			else				
			{
				tempPos = GetOffsetPos(spawnPos, i);
				spawnPos[1] = tempPos[1];
				spawnPos[2] = tempPos[2];
				
				spawnPos[0] = GetOffset(spawnPos); //30.0
				
				DispatchKeyValue(index, "angles", "0 90 0");
			}
			
			if(!AreVectorsEqual(spawnPos, targetPos)) 
			//if(GetVectorDistance(spawnPos, targetPos) > 10.0) 
			{
				index = CreateEntityByName("prop_dynamic");
				if (index)
				{
					if (!IsModelPrecached(entityModel)) PrecacheModel(entityModel);

					DispatchKeyValue(index, "targetname", entityName);
					DispatchKeyValue(index, "model", entityModel);
					DispatchKeyValue(index, "solid", "6");
					
					DispatchKeyValueVector(index, "origin", spawnPos);
					
					DispatchSpawn(index);
				}
			}
			
			if(StrEqual(type, "target")) SpawnTargetTrigger(index, team, entityName, spawnPos, i);
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Cant spawn model %s", prefixcolor, prefix, textcolor, trainingModelBlock);
}

public void SpawnTargetTrigger(int prop_index, int team, char prop_name[32], float prop_pos[3], int i)
{
	int index = -1;
	float minbounds[3], maxbounds[3], spawnPos[3];
	if(team == CS_TEAM_T)
	{
		minbounds = tTriggerVecMin;
		maxbounds = tTriggerVecMax;
		spawnPos  = tTriggerOrigin;
	}
	else if (team == CS_TEAM_CT)
	{
		minbounds = ctTriggerVecMin;
		maxbounds = ctTriggerVecMax;
		spawnPos  = ctTriggerOrigin;
	}
	spawnPos[2] = mapBallStartPosition[2]-15.0;
	
	if (targetmode == 0) index = CreateEntityByName("trigger_multiple");
	else if(targetmode == 1) index = CreateEntityByName("trigger_once");
	
	if (index != -1)
	{
		char entityName[64];
		if (targetmode == 0) Format(entityName, sizeof(entityName), "soccer_mod_training_targettrigger_%i", team);
		else if(targetmode ==1) 
		{
			//ReplaceString(prop_name, sizeof(prop_name), "soccer_mod_training_target_", "", false);
			Format(entityName, sizeof(entityName), "soccer_mod_training_targettrigger_%i_%i", team, i);
		}

		if (targetmode == 1)
		{
			float tempPos[3];
			if(xorientation)
			{
				minbounds[0] = -5.0;
				minbounds[1] = -0.5;
				minbounds[2] = -5.0;
				maxbounds[0] = 5.0;
				maxbounds[1] = 0.5;
				maxbounds[2] = 5.0;
				
				tempPos = GetOffsetPos(spawnPos, i);
				spawnPos[0] = tempPos[0];
				spawnPos[2] = tempPos[2];
			}
			else				
			{
				minbounds[0] = -0.5;
				minbounds[1] = -5.0;
				minbounds[2] = -5.0;
				maxbounds[0] = 0.5;
				maxbounds[1] = 5.0;
				maxbounds[2] = 5.0;
				
				tempPos = GetOffsetPos(spawnPos, i);
				spawnPos[1] = tempPos[1];
				spawnPos[2] = tempPos[2];
				
				DispatchKeyValue(index, "angles", "0 90 0");
			}
		}

		DispatchKeyValue(index, "targetname", entityName);
		DispatchKeyValue(index, "spawnflags", "8");
		DispatchKeyValueVector(index, "origin", spawnPos);
		
		DispatchSpawn(index);
		ActivateEntity(index);
		
		if (!IsModelPrecached(trainingModelPlate)) PrecacheModel(trainingModelPlate);
		SetEntityModel(index, trainingModelPlate);

		SetEntPropVector(index, Prop_Send, "m_vecMins", minbounds);
		SetEntPropVector(index, Prop_Send, "m_vecMaxs", maxbounds);
		
		SetEntProp(index, Prop_Send, "m_nSolidType", 2);
		
		int enteffects = GetEntProp(index, Prop_Send, "m_fEffects");
		enteffects |= 32;
		SetEntProp(index, Prop_Send, "m_fEffects", enteffects);
	}
}

// *******************************************************************************************************************
// ******************************************** TRAINING ENTITY OUTPUTS **********************************************
// *******************************************************************************************************************

public void TargetOnStartTouch(int caller, int activator, int team)
{
	//disable trigger to disallow double input (activator == toucher aka ball)	
	char callerClassname[64];
	GetEntityClassname(caller, callerClassname, sizeof(callerClassname));

	char callerName[64];
	GetEntPropString(caller, Prop_Data, "m_iName", callerName, sizeof(callerName));

	char targetName[64], triggerName[64];
	int trigger, target;

	if(team == CS_TEAM_T)					
	{
		hitHelper[0] = false;
		delete trainingBallResetTimer[0];
	}
	else if (team == CS_TEAM_CT)			
	{
		hitHelper[1] = false;
		delete trainingBallResetTimer[1];
	}
	
	if (StrEqual(callerClassname, "trigger_once"))
	{
		for(int i = 1; i <= 10; i++)
		{
			Format(triggerName, sizeof(triggerName), "soccer_mod_training_targettrigger_%i_%i", team, i);
			trigger = GetEntityIndexByName(triggerName, "trigger_once");
			
			Format(targetName, sizeof(targetName), "soccer_mod_training_target_%i_%i", team, i);
			target = GetEntityIndexByName(targetName, "prop_dynamic");			
			
			if(StrEqual(callerName, triggerName))
			{
				if(target != -1)	
				{
					SetEntityRenderColor(target, 50, 250, 50, 255);

					ToggleOtherTrigger(i, team, false);
					
					DataPack pack = new DataPack();
					CreateDataTimer(0.3, ChangeTargetTimer, pack);
					WritePackCell(pack, target);
					WritePackCell(pack, team);
					WritePackCell(pack, activator);	//ball
					WritePackCell(pack, caller);	//trigger
					WritePackCell(pack, i); //i
					WritePackCell(pack, 1); //multi
				}
			}
		}
	}
	else if(StrEqual(callerClassname, "trigger_multiple"))
	{
		Format(triggerName, sizeof(triggerName), "soccer_mod_training_targettrigger_%i", team);
		trigger = GetEntityIndexByName(triggerName, "trigger_multiple");

		// get target prop
		Format(targetName, sizeof(targetName), "soccer_mod_training_target_%i", team);
		target = GetEntityIndexByName(targetName, "prop_dynamic");
		
		if(StrEqual(callerName, triggerName))
		{
			if(target != -1)	
			{	
				SetEntityRenderColor(target, 50, 250, 50, 255);
				AcceptEntityInput(trigger, "Disable");
				
				DataPack pack = new DataPack();
				CreateDataTimer(0.5, ChangeTargetTimer, pack);
				WritePackCell(pack, target);
				WritePackCell(pack, team);
				WritePackCell(pack, activator);	//ball
				WritePackCell(pack, caller);	//trigger
				WritePackCell(pack, 0); //ignore
				WritePackCell(pack, 0); //single
			}
		}
	}
}

public Action ChangeTargetTimer(Handle timer, DataPack pack)
{
	ResetPack(pack);
	int index, team, activator, type, trigger, num;
	index = ReadPackCell(pack);
	team = ReadPackCell(pack);
	activator = ReadPackCell(pack);
	trigger = ReadPackCell(pack);
	num = ReadPackCell(pack);
	type = ReadPackCell(pack);
	
	float ballPortPos[3];
	float nullvec[3] = {0.0, 0.0, 0.0}
	if(team == CS_TEAM_T) 
	{
		ballPortPos = ballPortPosT;
		if(lastTargetBallId[0] == -1)		lastTargetBallId[0] = activator;
		if(activator == lastTargetBallId[0] && activator == lastTargetBallId[1]) lastTargetBallId[0] = activator;
	}
	else if (team == CS_TEAM_CT) 
	{
		ballPortPos = ballPortPosCT;
		if(lastTargetBallId[1] == -1)		lastTargetBallId[1] = activator;
		if(activator == lastTargetBallId[0] && activator == lastTargetBallId[1]) lastTargetBallId[1] = activator;
	}
	
	//CHECK FOR ACTIVE CANNONS
	char activatorname[64];
	GetEntPropString(activator, Prop_Data, "m_iName", activatorname, sizeof(activatorname));
	
	if(StrEqual(activatorname, "ball") || StrEqual(activatorname, "ballon"))
	{
		if (trainingCannonTimer == null)
		{
			if(AreVectorsEqual(ballPortPos, nullvec))
			{
				ballPortPos[2] += 15.0;
				TeleportEntity(activator, ballPortPos, nullvec, nullvec);
				AcceptEntityInput(activator, "Sleep");
			}
			else
			{
				TeleportEntity(activator, ballPortPos, nullvec, nullvec);
				AcceptEntityInput(activator, "Sleep");
			}
		}
	}
	else if (StrContains(activatorname, "soccer_mod_training_ball_") != -1)
	{
		char ballnumber[64];
		int ballnum;
		ballnumber = activatorname;
		ReplaceString(ballnumber, sizeof(ballnumber), "soccer_mod_training_ball_", "");
		ballnum = StringToInt(ballnumber);
		
		if (pers_trainingCannonTimer[ballnum] == null)
		{
			if(AreVectorsEqual(ballPortPos, nullvec))
			{
				ballPortPos[2] += 15.0;
				TeleportEntity(activator, ballPortPos, nullvec, nullvec);
				AcceptEntityInput(activator, "Sleep");
			}
			else
			{
				TeleportEntity(activator, ballPortPos, nullvec, nullvec);
				AcceptEntityInput(activator, "Sleep");
			}
		}
		
		/*for(int i = 0; i < MaxClients; i++)
		{
			if (pers_trainingCannonTimer[i] == null)
			{
				if(AreVectorsEqual(ballPortPos, nullvec))
				{
					ballPortPos[2] += 15.0;
					TeleportEntity(activator, ballPortPos, nullvec, nullvec);
					AcceptEntityInput(activator, "Sleep");
				}
				else
				{
					TeleportEntity(activator, ballPortPos, nullvec, nullvec);
					AcceptEntityInput(activator, "Sleep");
				}
			}
		}*/
	}	
	if(index != -1) SetEntityRenderColor(index, 255, 255, 255, 0);
	
	if(type == 0) TeleportTarget(index, team, trigger);
	else if(type == 1) DisableTarget(index, team, trigger, num);
}

// *******************************************************************************************************************
// ********************************************* GOALTARGET FUNCTIONS ************************************************
// *******************************************************************************************************************

public void TeleportTarget(int index, int team, int trigger)
{
	float newPos[3], oldPos[3], blockPos[3], spawnPos[3];
	if(team == CS_TEAM_T)			spawnPos  = tTriggerOrigin;
	else if (team == CS_TEAM_CT)	spawnPos  = ctTriggerOrigin;

	char blockToMove[64];
	int block;
	//Get current pos
	GetEntPropVector(index, Prop_Send, "m_vecOrigin", oldPos);
	//Get new random pos
	if(xorientation)	
	{
		newPos[0] = GetRandomPos(spawnPos, 0); // 1-5 
		newPos[1] = oldPos[1];
	}
	else				
	{
		newPos[0] = oldPos[0];
		newPos[1] = GetRandomPos(spawnPos, 1); // 1-5
	}
	newPos[2]						= GetRandomPos(spawnPos, 2); // 1-2
	
	for (int i = 1; i <= 10; i++)
	{
		Format(blockToMove, sizeof(blockToMove), "soccer_mod_training_block_%i_%i", team, i);	
		block = GetEntityIndexByName(blockToMove, "prop_dynamic");
		
		if(block != -1)
		{
			GetEntPropVector(block, Prop_Send, "m_vecOrigin", blockPos);
			if(AreVectorsEqual(blockPos, newPos))
			{
				blockPos = oldPos;
				break;
			}
		}
	}
	
	TeleportEntity(index, newPos, NULL_VECTOR, NULL_VECTOR);
	TeleportEntity(block, blockPos, NULL_VECTOR, NULL_VECTOR);
	
	AcceptEntityInput(trigger, "Enable");
}

public void DisableTarget(int index, int team, int trigger, int num)
{
	char targetName[64], triggerName[64], number[64], teamName[32];
	float spawnPos[3], targetPos[3];
	int t;
	if(team == CS_TEAM_T)
	{	
		spawnPos  = tTriggerOrigin;
		t = 0;
		teamName = "Terrorist";
	}
	else if (team == CS_TEAM_CT)
	{
		spawnPos  = ctTriggerOrigin;
		t = 1;
		teamName = "Counter-Terrorist";
	}
	
	GetEntPropString(index, Prop_Data, "m_iName", number, sizeof(number));
	GetEntPropVector(index, Prop_Send, "m_vecOrigin", targetPos);
	ReplaceString(number, sizeof(number), "soccer_mod_training_target_", "", false);

	Format(targetName, sizeof(targetName), "soccer_mod_training_block_%s", number);
	
	AcceptEntityInput(index, "Kill");
	
	index = CreateEntityByName("prop_dynamic");
	if (index)
	{
		if (!IsModelPrecached(trainingModelBlock)) PrecacheModel(trainingModelBlock);

		DispatchKeyValue(index, "targetname", targetName);
		DispatchKeyValue(index, "model", trainingModelBlock);
		DispatchKeyValue(index, "solid", "6");
		
		spawnPos = targetPos;
		if(!xorientation)
		{
			DispatchKeyValue(index, "angles", "0 90 0");
		}
	
		DispatchKeyValueVector(index, "origin", spawnPos);
	
		DispatchSpawn(index);	
		
		GetEntPropString(index, Prop_Data, "m_iName", triggerName, sizeof(triggerName));
	}
	ToggleOtherTrigger(num, team, true); 	
	
	targetcounter[t] = targetcounter[t] + 1;
	if(targetcounter[t] == 10)
	{
		PrintCenterTextAll("%s target practice completed!", teamName);
		targetcounter[t] = 0;
		//Remove completed target
		if(team == CS_TEAM_T)			
		{
			targetcounter[0] = 0;
			spawnPos = tTriggerOrigin;
		}
		else if (team == CS_TEAM_CT)	
		{
			targetcounter[1] = 0;
			spawnPos = ctTriggerOrigin;
		}
		
		RemoveTarget(index, team);
		
		if (index)
		{
			for (int i = 1; i <= 10; i++)
			{	
				SpawnTargetMulti(i, 0, team, spawnPos, "target");
			}						
		}
	}
}

public void ToggleOtherTrigger(int exception, int team, bool enable)
{
	int index;
	char triggerName[64];
	
	for(int i = 1; i <= 10; i++)
	{
		if( i != exception)
		{
			Format(triggerName, sizeof(triggerName), "soccer_mod_training_targettrigger_%i_%i", team, i);
			index = GetEntityIndexByName(triggerName ,"trigger_once");
			
			if(index != -1)
			{
				if(enable) AcceptEntityInput(index, "Enable");
				else AcceptEntityInput(index, "Disable");
			}
		}
	}
}

public Action AutoResetBall(Handle timer, DataPack pack)
{
	float nullvec[3] = {0.0, 0.0, 0.0}
	int team, activator, ballnum;
	char activatorname[64], ballnumber[64];
	
	ResetPack(pack);
	team = ReadPackCell(pack);
	activator = ReadPackCell(pack);
	
	GetEntPropString(activator, Prop_Data, "m_iName", activatorname, sizeof(activatorname));
	
	if(team == CS_TEAM_T)
	{
		hitHelper[0] = false;
		
		if(StrEqual(activatorname, "ball") || StrEqual(activatorname, "ballon"))
		{
			if (trainingCannonTimer == null)
			{
				if(lastTargetBallId[0] != -1)
				{
					TeleportEntity(lastTargetBallId[0], ballPortPosT, nullvec, nullvec);
					AcceptEntityInput(lastTargetBallId[0], "Sleep");
					trainingBallResetTimer[0] = null;
				}
			}
		}
		else if (StrContains(activatorname, "soccer_mod_training_ball_") != -1)
		{
			for(int i = 0; i < MaxClients; i++)
			{
			if (pers_trainingCannonTimer[i] == null)
				{
					if(lastTargetBallId[0] != -1)
					{
						TeleportEntity(lastTargetBallId[0], ballPortPosT, nullvec, nullvec);
						AcceptEntityInput(lastTargetBallId[0], "Sleep");
						trainingBallResetTimer[0] = null;
					}
				}
			}
		}
	}
	else if (team == CS_TEAM_CT)
	{
		hitHelper[1] = false;
		
		if(StrEqual(activatorname, "ball") || StrEqual(activatorname, "ballon"))
		{
			if (trainingCannonTimer == null)
			{
				if(lastTargetBallId[1] != -1)
				{
					TeleportEntity(lastTargetBallId[1], ballPortPosCT, nullvec, nullvec);
					AcceptEntityInput(lastTargetBallId[1], "Sleep");
					trainingBallResetTimer[1] = null;
				}
			}
		}
		else if (StrContains(activatorname, "soccer_mod_training_ball_") != -1)
		{
			ballnumber = activatorname;
			ReplaceString(ballnumber, sizeof(ballnumber), "soccer_mod_training_ball_", "");
			ballnum = StringToInt(ballnumber);
			
			if (pers_trainingCannonTimer[ballnum] == null)
			{
				if(lastTargetBallId[1] != -1)
				{
					TeleportEntity(lastTargetBallId[1], ballPortPosCT, nullvec, nullvec);
					AcceptEntityInput(lastTargetBallId[1], "Sleep");
					trainingBallResetTimer[1] = null;
				}
			}
		}	
	}
}

public float GetRandomPos(float pos[3], int coord)
{
	float newpos;
	// -100 -50 0 +50 +100
	if(coord == 0 || coord == 1)
	{
		target_randint[0] = GetRandomInt(1, 5);
		
		switch(target_randint[0])
		{
			case 1:
			{
				newpos = pos[coord]+100.0;
			}
			case 2:
			{
				newpos = pos[coord]+50.0;
			}
			case 3:
			{
				newpos = pos[coord];				
			}
			case 4:
			{
				newpos = pos[coord]-50.0;
			}
			case 5:
			{
				newpos = pos[coord]-100.0;
			}
		}
	}
	
	// +25 +75
	
	// null z pos
	pos[2] = mapBallStartPosition[2]-15.0;
	if(coord == 2)
	{
		target_randint[1] = GetRandomInt(1, 2);
		switch(target_randint[1])
		{
			case 1:
			{
				newpos = pos[coord]+22.0;
			}
			case 2:
			{
				newpos = pos[coord]+72.0;
			}
		}
	}
	
	return newpos;
}

public float GetOffset(float pos[3])
{
	float newpos;
	
	if(xorientation)	
	{
		if(pos[1] > mapBallStartPosition[1])			newpos = pos[1]-45.0;
		else if (pos[1] < mapBallStartPosition[1])		newpos = pos[1]+45.0;
	}
	else
	{
		if(pos[0] > mapBallStartPosition[0])			newpos = pos[0]-45.0;
		else if (pos[0] < mapBallStartPosition[0])		newpos = pos[0]+45.0;
	}
	
	return newpos;
}


float GetOffsetPos(float spawnPos[3], int i)
{
	if(xorientation)
	{
		switch(i)
		{
			case 1: // top 2
			{
				spawnPos[0] += 100.0; // 1-5 
				spawnPos[2]	+= 72.0; // 1-2
			}
			case 2: // top 1
			{
				spawnPos[0] += 50.0; // 1-5 
				spawnPos[2]	+= 72.0; // 1-2
			}
			case 3: // top 0
			{
				spawnPos[0] += 0.0; // 1-5 
				spawnPos[2]	+= 72.0; // 1-2
			}
			case 4: // top -1
			{
				spawnPos[0] -= 50.0; // 1-5 
				spawnPos[2]	+= 72.0; // 1-2
			}
			case 5: // top -2
			{
				spawnPos[0] -= 100.0; // 1-5 
				spawnPos[2]	+= 72.0; // 1-2
			}
			case 6: // bottom 2
			{
				spawnPos[0] += 100.0; // 1-5 
				spawnPos[2]	+= 22.0; // 1-2
			}
			case 7: // bottom 1
			{
				spawnPos[0] += 50.0; // 1-5 
				spawnPos[2]	+= 22.0; // 1-2
			}
			case 8: // bottom 0
			{
				spawnPos[0] += 0.0; // 1-5 
				spawnPos[2]	+= 22.0; // 1-2
			}
			case 9: // bottom -1
			{
				spawnPos[0] -= 50.0; // 1-5 
				spawnPos[2]	+= 22.0; // 1-2
			}
			case 10: // bottom -2
			{
				spawnPos[0] -= 100.0; // 1-5 
				spawnPos[2]	+= 22.0; // 1-2
			}
		}
	}
	else
	{
		switch(i)
		{
			case 1: // top 2
			{
				spawnPos[1] += 100.0; // 1-5 
				spawnPos[2]	+= 72.0; // 1-2
			}
			case 2: // top 1
			{
				spawnPos[1] += 50.0; // 1-5 
				spawnPos[2]	+= 72.0; // 1-2
			}
			case 3: // top 0
			{
				spawnPos[1] += 0.0; // 1-5 
				spawnPos[2]	+= 72.0; // 1-2
			}
			case 4: // top -1
			{
				spawnPos[1] -= 50.0; // 1-5 
				spawnPos[2]	+= 72.0; // 1-2
			}
			case 5: // top -2
			{
				spawnPos[1] -= 100.0; // 1-5 
				spawnPos[2]	+= 72.0; // 1-2
			}
			case 6: // bottom 2
			{
				spawnPos[1] += 100.0; // 1-5 
				spawnPos[2]	+= 22.0; // 1-2
			}
			case 7: // bottom 1
			{
				spawnPos[1] += 50.0; // 1-5 
				spawnPos[2]	+= 22.0; // 1-2
			}
			case 8: // bottom 0
			{
				spawnPos[1] += 0.0; // 1-5 
				spawnPos[2]	+= 22.0; // 1-2
			}
			case 9: // bottom -1
			{
				spawnPos[1] -= 50.0; // 1-5 
				spawnPos[2]	+= 22.0; // 1-2
			}
			case 10: // bottom -2
			{
				spawnPos[1] -= 100.0; // 1-5 
				spawnPos[2]	+= 22.0; // 1-2
			}
		}
	}
	return spawnPos;
}


// *******************************************************************************************************************
// ************************************************* SIMPLE GK MENU **************************************************
// *******************************************************************************************************************
/*public void OpenAdvancedTrainingSimpleGKMenu(int client)
{
	Menu menu = new Menu(MenuHandlerAdvTrainingSimpleGK);

	menu.SetTitle("Soccer Mod - Advanced Training");

	char CTString[32], TString[32];

	if(tgoalgk)					TString = "T GK: ON";
	else 						TString = "T GK: OFF";
	
	if(ctgoalgk)				CTString = "CT GK: ON";
	else 						CTString = "CT GK: OFF";

	menu.AddItem("simpgk_t", TString);
	menu.AddItem("simpgk_ct", CTString);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAdvTrainingSimpleGK(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "simpgk_t"))
		{
			//SpawnSimpGK(t);
			OpenAdvancedTrainingSimpleGKMenu(client);
		}
		else if (StrEqual(menuItem, "simpgk_ct"))
		{
			//SpawnSimpGK(ct);
			OpenAdvancedTrainingSimpleGKMenu(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenAdvancedTrainingMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}
*/

// *******************************************************************************************************************
// *************************************************** CONE MENU *****************************************************
// *******************************************************************************************************************

public void OpenAdvancedTrainingConeMenu(int client)
{
	Menu menu = new Menu(MenuHandlerAdvTrainingCone);

	menu.SetTitle("Soccer Mod - Cone Manager");

	char ConeTypeString[32], ConeString[32], RemoveString[32], type[32];
	
	if(coneDynamic)				
	{
		ConeTypeString = "Cone Type: Dynamic (red)";
		RemoveString = "Remove all red cones";
		type = "Dynamic";
	}
	else 						
	{
		ConeTypeString = "Cone Type: Static (blue)";
		RemoveString = "Remove all blue cones";
		type = "Static";
	}
	
	Format(ConeString, sizeof(ConeString), "Place/Remove Cone (%i left)", MAXCONES_STA + MAXCONES_DYN - conecounter);
	
	menu.AddItem("type", ConeTypeString);
	menu.AddItem("cone", ConeString);
	menu.AddItem("remall", RemoveString);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAdvTrainingCone(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "type"))
		{
			if(coneDynamic) coneDynamic = false;
			else 			coneDynamic = true;
		}
		else if (StrEqual(menuItem, "cone"))
		{
			if(GetClientTeam(client) > 1 && IsPlayerAlive(client))
			{
				TrainingSpawnCone(client);
			}
			else 
			{
				CPrintToChat(client,"{%s}[%s] {%s}Only alive players can spawn cones.", prefixcolor, prefix, textcolor);
			}
		}
		else if (StrEqual(menuItem, "remall"))
		{
			RemoveAllCones(client);
		}
		OpenAdvancedTrainingConeMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenAdvancedTrainingMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// ********************************************* CONE HANDLER FUNCTIONS **********************************************
// *******************************************************************************************************************

public void TrainingSpawnCone(int client)
{
	if (FileExists(trainingModelCone, true))
	{
		char entityName[32];
		bool removed = false;
		int index;

		float aimPosition[3];
		GetAimOrigin(client, aimPosition);
		
		char classtype[32];
		if(coneDynamic)		classtype = "prop_physics";
		else				classtype = "prop_dynamic_override";
		
		if(coneDynamic)
		{
			//refuses to find prop_dynamic_override for some odd reason...
			while ((index = FindEntityByClassname(index, classtype)) != INVALID_ENT_REFERENCE)
			{
				char entPropString[32];
				float entPropVec[3];
				GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));
				GetEntPropVector(index, Prop_Data, "m_vecOrigin", entPropVec, 0);

				for(int i = 0; i <= MAXCONES_DYN + MAXCONES_STA; i++)
				{
					Format(entityName, sizeof(entityName), "soccer_mod_training_cone_%i", i);
					if (StrEqual(entPropString, entityName))
					{
						//PrintToChatAll("match");
						if (GetVectorDistance(entPropVec, aimPosition) <= 20.0)
						{
							conecounter -= 1;
							removed = true;
							AcceptEntityInput(index, "Kill");
							CPrintToChat(client, "{%s}[%s] {%s}Target cone removed.", prefixcolor, prefix, textcolor);
						}
					}
				}
			}
		}
		else
		{
			float entPropVec[3];
			for(int i = 0; i < MAXCONES_STA + MAXCONES_DYN; i++)
			{
				if(staticconehelper[i] != -1)
				{
					GetEntPropVector(staticconehelper[i], Prop_Data, "m_vecOrigin", entPropVec, 0);
					if (GetVectorDistance(entPropVec, aimPosition) <= 20.0)
					{
						conecounter -= 1;
						removed = true;
						AcceptEntityInput(staticconehelper[i], "Kill");
						staticconehelper[i] = -1;
						CPrintToChat(client, "{%s}[%s] {%s}Target cone removed.", prefixcolor, prefix, textcolor);
					}
				}
			}
		}

		if (MAXCONES_STA + MAXCONES_DYN - conecounter > 0 && !removed)
		{
			index = CreateEntityByName(classtype);
			if (index)
			{
				if (!IsModelPrecached(trainingModelCone)) PrecacheModel(trainingModelCone);
		
				Format(entityName, sizeof(entityName), "soccer_mod_training_cone_%i", conecounter);
	
				DispatchKeyValue(index, "targetname", entityName);
				DispatchKeyValue(index, "model", trainingModelCone);
				DispatchKeyValue(index, "solid", "6");
				
				if (StrEqual(classtype, "prop_dynamic_override"))	
				{
					aimPosition[2] += 15;
					if(staticconehelper[conecounter] == -1)	staticconehelper[conecounter] = index;
					else
					{
						for(int i = 0; i < MAXCONES_STA+MAXCONES_DYN; i++)
						{
							if(staticconehelper[i] == -1) 
							{
								staticconehelper[i] = index;
								break;
							}
						}
					}
				}
				if(coneDynamic)	DispatchKeyValue(index, "rendercolor", "255 0 0");
				else 			DispatchKeyValue(index, "rendercolor", "0 0 255");
				DispatchKeyValueVector(index, "origin", aimPosition);
				DispatchKeyValue(index, "renderamt", "255");
				DispatchKeyValue(index, "rendermode", "2");

				DispatchSpawn(index);
				
				conecounter += 1;
				CPrintToChat(client, "{%s}[%s] {%s}Cone placed. %i cones left.", prefixcolor, prefix, textcolor, MAXCONES_DYN + MAXCONES_STA - conecounter);
			}
		}
		else if (MAXCONES_STA + MAXCONES_DYN - conecounter == 0)
		{
			CPrintToChat(client, "{%s}[%s] {%s}No placable cones left. Remove placed ones to place another one.", prefixcolor, prefix, textcolor);
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Cant spawn model %s", prefixcolor, prefix, textcolor, trainingModelCone);
}

public void RemoveAllCones(int client)
{
	if (FileExists(trainingModelCone, true))
	{
		int index;
		char entityName[32];
		char type[32];

		if(coneDynamic)
		{
			// refuses to find prop_dynamic_override for some reason..
			while ((index = FindEntityByClassname(index, "prop_physics")) != INVALID_ENT_REFERENCE)
			{
				char entPropString[32];
				GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));

				for(int i = 0; i < MAXCONES_DYN+MAXCONES_STA; i++)
				{
					Format(entityName, sizeof(entityName), "soccer_mod_training_cone_%i", i);

					if (StrEqual(entPropString, entityName))
					{
						conecounter -= 1;
						AcceptEntityInput(index, "Kill");
					}
				}
			}
			type = "dynamic";
		}
		else
		{
			for(int i = 0; i < MAXCONES_STA+MAXCONES_DYN; i++)
			{
				if(staticconehelper[i] != -1)
				{
					conecounter -= 1;
					AcceptEntityInput(staticconehelper[i], "kill");
					staticconehelper[i] = -1;
				}
			}
			type = "static";
		}
		CPrintToChatAll("{%s}[%s] {%s}%N has removed all %s cones.", prefixcolor, prefix, textcolor, client, type);
		OpenAdvancedTrainingConeMenu(client);
	}
}


// *******************************************************************************************************************
// ************************************************ ADV TRAIN RESET **************************************************
// *******************************************************************************************************************

public void ResetAdvTrainingStates()
{
	//minigameActive	 = false;
	tgoaltarget = false;
	ctgoaltarget = false;
	//tgoalgk	= false;
	//ctgoalgk = false;
	//trailset = 0;
	conecounter = 0;
	for(int i = 0; i < MaxClients; i++)
	{
		pers_hoopIndex[i] = -1;
	}
	for(int i = 0; i < MaxClients; i++)
	{
		pers_canIndex[i] = -1;
	}
	for(int i = 0; i < MaxClients; i++)
	{
		pers_plateIndex[i] = -1;
	}
	for(int x = 0; x < MAXCONES_STA; x++)
	{
		if(staticconehelper[x] != -1) 
		{
			staticconehelper[x] = -1;
		}
	}
	targetcounter[0] = 0;
	targetcounter[1] = 0;
	lastTargetBallId[0] = -1;
	lastTargetBallId[1] = -1;
}

stock bool AreVectorsEqual(float vVec1[3], float vVec2[3])
{
    return (vVec1[0] == vVec2[0] && vVec1[1] == vVec2[1] && vVec1[2] == vVec2[2]);
} 