// ***********************************************************************************************************************
// ************************************************** COMMAND LISTENERS **************************************************
// ***********************************************************************************************************************
public void TrainingCannonSet(int client, char type[32], float number, float min, float max)
{
	if ((number >= min && number <= max) || number == 0.0)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

		if (StrEqual(type, "randomness"))
		{
			trainingCannonRandomness = number;

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the cannon randomness to %f", prefixcolor, prefix, textcolor, client, number);
			}

			LogMessage("%N <%s> has set the cannon randomness to %.0f", client, steamid, number);
		}
		else if (StrEqual(type, "fire_rate"))
		{
			if(number != 0.0)
			{
				trainingCannonFireRate = number;

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the cannon fire rate to %f", prefixcolor, prefix, textcolor, client, number);
				}

				LogMessage("%N <%s> has set the cannon fire rate to %.1f", client, steamid, number);
			}
			else 
			{
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		else if (StrEqual(type, "power"))
		{
			if(number != 0.0)
			{
				trainingCannonPower = number;

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the cannon power to %f", prefixcolor, prefix, textcolor, client, number);
				}

				LogMessage("%N <%s> has set the cannon power to %.3f", client, steamid, number);
			}
			else 
			{
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}

		changeSetting[client] = "";
		OpenTrainingCannonSettingsMenu(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Type a value between %f and %f", prefixcolor, prefix, textcolor, min, max);
}

// ************************************************************************************************************
// ************************************************** EVENTS **************************************************
// ************************************************************************************************************
public void TrainingOnPluginStart()
{
	if (StrEqual(gamevar, "cstrike")) trainingModelBall = "models/soccer_mod/ball_2011.mdl";
	
	if(!FileExists(personalSettingsKV))
	{
		File hFile = OpenFile(personalSettingsKV, "w");
		hFile.Close();
	}
}

public void TrainingOnMapStart()
{
	trainingCannonBallIndex	 = -1;
	trainingGoalsEnabled		= true;

	//KillTrainingCannonTimer();
	delete trainingCannonTimer;
	
	for (int i = 0; i < MAXPLAYERS; i++) 
	{
		g_pGrabbedEnt[i] = -1;
		g_eRotationAxis[i] = -1;
		g_pLastButtonPress[i] = 0.0;
		
		g_pWasInNoclip[i] = false;
		g_pInRotationMode[i] = false;
		g_eReleaseFreeze[i] = true;
		
		g_eGrabTimer[i] = null;
	}
}

public void TrainingOnClientDisconnect(int client)
{
	if (g_pGrabbedEnt[client] != -1 && IsValidEntity(g_pGrabbedEnt[client]))	UnGrabEntity(client);
	// Kill the grab timer and reset control values
	if (g_eGrabTimer[client] != null) {
		KillTimer(g_eGrabTimer[client]);
		g_eGrabTimer[client] = null;
	}

	g_eRotationAxis[client] = -1;
	
	g_pLastButtonPress[client] = 0.0;
	
	g_pWasInNoclip[client] = false;
	g_pInRotationMode[client] = false;
	g_eReleaseFreeze[client] = true;
	
	//remove props
	RemoveProp(client, "can");
	RemoveProp(client, "plate");
	RemoveProp(client, "hoop");
}

public void RemoveProp(int client, char type[32])
{
	char entityName[32];
	Format(entityName, sizeof(entityName), "soccer_mod_training_%s_%i", type, client);	
	char triggerName[64];
	Format(triggerName, sizeof(triggerName), "soccer_mod_training_%strigger_%i", type, client);
	
	int prop, trigger;
	while ((prop = FindEntityByClassname(prop, "prop_dynamic")) != INVALID_ENT_REFERENCE)
	{
		char entPropString[32];
		GetEntPropString(prop, Prop_Data, "m_iName", entPropString, sizeof(entPropString));

		if (StrEqual(entPropString, entityName))
		{
			if(StrEqual(type, "hoop"))			
			AcceptEntityInput(prop, "Kill");
		}
	}
	while ((trigger = FindEntityByClassname(trigger, "trigger_multiple")) != INVALID_ENT_REFERENCE)
	{
		char entPropString[64];
		GetEntPropString(trigger, Prop_Data, "m_iName", entPropString, sizeof(entPropString));

		if (StrEqual(entPropString, triggerName))
		{
			AcceptEntityInput(trigger, "Kill");
		}
	}	
	pers_hoopIndex[client] = -1;
	pers_canIndex[client] = -1;
	pers_plateIndex[client] = -1;
}

public void TrainingEventRoundStart(Event event)
{
	if (matchStarted) 
	{
		delete trainingCannonTimer;//KillTrainingCannonTimer();
		trainingModeEnabled = false;
	}
	else if (!trainingGoalsEnabled)
	{
		int index;
		while ((index = FindEntityByClassname(index, "trigger_once")) != INVALID_ENT_REFERENCE) AcceptEntityInput(index, "Kill");
	}
	for(int i = 0; i <= 1; i++)
	{
		respawnIndex[i] = -1;
		lastTargetBallId[i] = -1;
	}
	
}

// *******************************************************************************************************************
// ************************************************** TRAINING MENU **************************************************
// *******************************************************************************************************************
public void OpenTrainingMenu(int client)
{
	Menu menu = new Menu(TrainingMenuHandler);
	
	char goalString[32];
	if(trainingGoalsEnabled)	goalString = "Disable Goals";
	else						goalString = "Enable Goals";
	

	menu.SetTitle("Soccer Mod - Admin - Training");

	menu.AddItem("cannon", "Cannon");
	
	menu.AddItem("personal", "Personal Cannon");

	menu.AddItem("control_goals", goalString);

	menu.AddItem("spawn", "Spawn/Remove Ball");
	
	if(FileExists(trainingModelHoop, true) || FileExists(trainingModelCan, true)) menu.AddItem("prop", "Spawn Prop Menu");
		
	if(FileExists(trainingModelTarget, true)) menu.AddItem("advtrain", "Advanced Training");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int TrainingMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		if (!matchStarted)
		{
			char menuItem[32];
			menu.GetItem(choice, menuItem, sizeof(menuItem));

			if (StrEqual(menuItem, "control_goals"))
			{
				if(trainingGoalsEnabled)	TrainingDisableGoals(client);
				else 						TrainingEnableGoals(client);
				OpenTrainingMenu(client);
			}
			else if (StrEqual(menuItem, "spawn"))
			{
				if(GetClientTeam(client) > 1 && IsPlayerAlive(client))
				{
					TrainingSpawnBall(client);
					OpenTrainingMenu(client);
				}
				else 
				{
					CPrintToChat(client,"{%s}[%s] {%s}Only alive players can spawn a ball.", prefixcolor, prefix, textcolor);
					OpenTrainingMenu(client);
				}
			}
			else if (StrEqual(menuItem, "prop")) OpenSpawnMenu(client);
			else if (StrEqual(menuItem, "cannon")) OpenTrainingCannonMenu(client);
			else if (StrEqual(menuItem, "personal")) OpenPersonalTrainingCannonMenu(client);
			else if (StrEqual(menuItem, "advtrain")) 
			{
				if(AdvTrain_PWReqSet == 1)
				{
					if(!accessgranted[client])
					{
						//Chat listener
						CPrintToChat(client, "{%s}[%s] {%s}The advanced training menu requires a password. Please enter the password in chat to access all features or !cancel.", prefixcolor, prefix, textcolor);
						changeSetting[client] = "AdvTrainingPWInput";
					}
					else OpenAdvancedTrainingMenu(client);
				}
				else OpenAdvancedTrainingMenu(client);
			}
		}
		else
		{
			CPrintToChat(client, "{%s}[%s] {%s}You can not use this option during a match", prefixcolor, prefix, textcolor);
			OpenTrainingMenu(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// **************************************************************************************************************************
// ************************************************** TRAINING CANNON MENU **************************************************
// **************************************************************************************************************************
public void OpenTrainingCannonMenu(int client)
{
	Menu menu = new Menu(TrainingCannonMenuHandler);

	menu.SetTitle("Soccer Mod - Admin - Training - Cannon");

	menu.AddItem("position", "Set cannon position");

	menu.AddItem("aim", "Set cannon aim");

	menu.AddItem("on", "Cannon on");

	menu.AddItem("off", "Cannon off");

	menu.AddItem("settings", "Settings");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int TrainingCannonMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		if(GetClientTeam(client) > 1  && IsPlayerAlive(client))
		{
			char menuItem[32];
			menu.GetItem(choice, menuItem, sizeof(menuItem));

			if (StrEqual(menuItem, "off"))
			{
				TrainingCannonOff(client);
				OpenTrainingCannonMenu(client);
			}
			else
			{
				if (!matchStarted)
				{
					if (StrEqual(menuItem, "position"))
					{
						TrainingCannonPosition(client);
						OpenTrainingCannonMenu(client);
					}
					else if (StrEqual(menuItem, "aim"))
					{
						TrainingCannonAimPosition(client);
						OpenTrainingCannonMenu(client);
					}
					else if (StrEqual(menuItem, "on")) TrainingCannonOn(client);
					else if (StrEqual(menuItem, "settings")) OpenTrainingCannonSettingsMenu(client);
				}
				else
				{
					CPrintToChat(client, "{%s}[%s] {%s}You can not use this option during a match", prefixcolor, prefix, textcolor);
					OpenTrainingCannonMenu(client);
				}
			}
		}
		else
		{
			CPrintToChat(client, "{%s}[%s] {%s} You have to be in a team to use this option.", prefixcolor, prefix, textcolor);
			OpenTrainingCannonMenu(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenTrainingMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenTrainingCannonSelectBallMenu(int client, int count, int[] numbers)
{
	Menu menu = new Menu(TrainingChooseBallMenuHandler);

	menu.SetTitle("Soccer Mod - Admin - Training - Cannon - Select ball");

	for (int i = 0; i < count; i++)
	{
		char entPropString[64];
		GetEntPropString(numbers[i], Prop_Data, "m_iName", entPropString, sizeof(entPropString));

		char menuString[64];
		Format(menuString, sizeof(menuString), "%i", numbers[i]);

		menu.AddItem(menuString, entPropString);
	}

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int TrainingChooseBallMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		trainingCannonBallIndex = StringToInt(menuItem);

		//KillTrainingCannonTimer();
		delete trainingCannonTimer;
		trainingCannonTimer = CreateTimer(0.0, TrainingCannonShoot);

		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has turned the cannon on", prefixcolor, prefix, textcolor, client);
		}

		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		LogMessage("%N <%s> has turned the cannon on", client, steamid);

		OpenTrainingCannonMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenTrainingCannonMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenTrainingCannonSettingsMenu(int client)
{
	Menu menu = new Menu(TrainingCannonSettingsMenuHandler);

	menu.SetTitle("Soccer Mod - Admin - Training - Cannon - Settings");

	char menuString[32];
	Format(menuString, sizeof(menuString), "%s: %.0f", "Randomness", trainingCannonRandomness);
	menu.AddItem("randomness", menuString);

	Format(menuString, sizeof(menuString), "%s: %.1f", "Fire rate", trainingCannonFireRate);
	menu.AddItem("fire_rate", menuString);

	Format(menuString, sizeof(menuString), "%s: %.3f", "Power", trainingCannonPower);
	menu.AddItem("power", menuString);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int TrainingCannonSettingsMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "randomness"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type a value between %f and %f", prefixcolor, prefix, textcolor, 0.0, 500.0);
			changeSetting[client] = "randomness";
		}
		else if (StrEqual(menuItem, "fire_rate"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type a value between %f and %f, 0 to cancel.", prefixcolor, prefix, textcolor, 0.1, 10.0);
			changeSetting[client] = "fire_rate";
		}
		else if (StrEqual(menuItem, "power"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type a value between %f and %f, 0 to cancel.", prefixcolor, prefix, textcolor, 0.001, 10000.0);
			changeSetting[client] = "power";
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenTrainingCannonMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ************************************************************************************************************
// ************************************************** TIMERS **************************************************
// ************************************************************************************************************
public Action TrainingCannonShoot(Handle timer)
{
	if (IsValidEntity(trainingCannonBallIndex))
	{
		float vec[3];
		MakeVectorFromPoints(trainingCannonPosition, trainingCannonAim, vec);

		vec[0] = vec[0] + (trainingCannonRandomness / 2.0) - (trainingCannonRandomness * GetRandomFloat());
		vec[1] = vec[1] + (trainingCannonRandomness / 2.0) - (trainingCannonRandomness * GetRandomFloat());
		vec[2] = vec[2] + (trainingCannonRandomness / 2.0) - (trainingCannonRandomness * GetRandomFloat());

		ScaleVector(vec, trainingCannonPower);
		TeleportEntity(trainingCannonBallIndex, trainingCannonPosition, NULL_VECTOR, vec);

		trainingCannonTimer = CreateTimer(trainingCannonFireRate, TrainingCannonShoot);
	}
	else
	{
		trainingCannonBallIndex = -1;
		//KillTrainingCannonTimer()
		delete trainingCannonTimer;

		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}Ball cannon entity is invalid", prefixcolor, prefix, textcolor);
		}
	}
}

// ***************************************************************************************************************
// ************************************************** FUNCTIONS **************************************************
// ***************************************************************************************************************
/*public void KillTrainingCannonTimer()
{
	if (trainingCannonTimer != null)
	{
		KillTimer(trainingCannonTimer);
		trainingCannonTimer = null;
	}
}*/

public void TrainingDisableGoals(int client)
{
	if (trainingGoalsEnabled)
	{
		trainingGoalsEnabled = false;

		int index;
		while ((index = FindEntityByClassname(index, "trigger_once")) != INVALID_ENT_REFERENCE) AcceptEntityInput(index, "Kill");

		for (int player = 1; player <= MaxClients; player++)
		{
			if (trainingModeEnabled)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has enabled the training mode.", prefixcolor, prefix, textcolor, client);
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}Goals and joining the CT team are disabled.", prefixcolor, prefix, textcolor);
			}
			else
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has disabled the goals", prefixcolor, prefix, textcolor, client);
			}
		}

		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		LogMessage("%N <%s> has disabled the goals", client, steamid);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Goals are already disabled", prefixcolor, prefix, textcolor);
}

public void TrainingEnableGoals(int client)
{
	if (!trainingGoalsEnabled)
	{
		trainingGoalsEnabled = true;
		ServerCommand("mp_restartgame 1");

		for (int player = 1; player <= MaxClients; player++)
		{
			if (trainingModeEnabled)
			{
				trainingModeEnabled = false;
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has disabled the training mode.", prefixcolor, prefix, textcolor, client);
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}Goals and joining the CT team are enabled.", prefixcolor, prefix, textcolor);
			}
			else
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has enabled the goals", prefixcolor, prefix, textcolor, client);
			}
		}

		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		LogMessage("%N <%s> has enabled the goals", client, steamid);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Goals are already enabled", prefixcolor, prefix, textcolor);
}

public void TrainingSpawnBall(int client)
{
	int currentTime = GetTime();
	if (trainingballCD[client] != -1 && trainingballCD[client] > currentTime)
	{
		int cdinfo[MAXPLAYERS+1]
		cdinfo[client] = trainingballCD[client] - currentTime;
		if(cdinfo[client] != cdTemp[client])
		{
			CPrintToChat(client,"{%s}[%s] {%s}Spawning a ball is on cooldown, %i seconds left.", prefixcolor, prefix, textcolor, cdinfo[client]);
			cdTemp[client] = cdinfo[client];
		}
	}
	else
	{
		if (FileExists(trainingModelBall, true))
		{
			if(pers_trainingCannonTimer[client] != null)
			{
				char entityName[32];
				Format(entityName, sizeof(entityName), "soccer_mod_training_ball_%i", client);
				int index;
				delete pers_trainingCannonTimer[client];
				CPrintToChat(client, "{%s}[%s] {%s}Turned off your personal cannon", prefixcolor, prefix, textcolor);
				while ((index = FindEntityByClassname(index, "prop_physics")) != INVALID_ENT_REFERENCE)
				{
					char entPropString[32];
					GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));

					if (StrEqual(entPropString, entityName))
					{
						AcceptEntityInput(index, "Kill");
						
						trainingballCD[client] = currentTime + 5;
					}
				}
			}
		
			char entityName[32];
			Format(entityName, sizeof(entityName), "soccer_mod_training_ball_%i", client);

			int index;
			bool ballSpawned = false;	

			while ((index = FindEntityByClassname(index, "prop_physics")) != INVALID_ENT_REFERENCE)
			{
				char entPropString[32];
				GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));

				if (StrEqual(entPropString, entityName))
				{
					ballSpawned = true;
					AcceptEntityInput(index, "Kill");
					
					trainingballCD[client] = currentTime + 5;
				}
			}

			if (!ballSpawned)
			{
				index = CreateEntityByName("prop_physics");
				if (index)
				{
					if (!IsModelPrecached(trainingModelBall)) PrecacheModel(trainingModelBall);

					DispatchKeyValue(index, "targetname", entityName);
					DispatchKeyValue(index, "model", trainingModelBall);

					float aimPosition[3];
					GetAimOrigin(client, aimPosition);
					DispatchKeyValueVector(index, "origin", aimPosition);

					DispatchSpawn(index);
				}
			}
		}
		else CPrintToChat(client, "{%s}[%s] {%s}Cant spawn model %s", prefixcolor, prefix, textcolor, trainingModelBall);
	}
}

public void TrainingCannonOn(int client)
{
	if (trainingCannonTimer == null)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		
		int index2 = GetEntityIndexByName("ball", "prop_physics");
		if (index2 == -1) {
			index2 = GetEntityIndexByName("ball", "func_physbox");
		}
		if (index2 == -1) {
			index2 = GetEntityIndexByName("ballon", "func_physbox");
		}
		if (index2 == -1) 
		{
			index2 = GetEntityIndexByName("ballon", "prop_physics");
		}
		if (index2 != -1) trainingCannonBallIndex = index2;

		if (!IsValidEntity(trainingCannonBallIndex))
		{
			int count = 0;
			int numbers[64];
			int index;

			while ((index = FindEntityByClassname(index, "func_physbox")) != INVALID_ENT_REFERENCE)
			{
				char entPropString[64];
				GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));

				if (entPropString[0])
				{
					numbers[count] = index;
					count++;
				}
			}

			while ((index = FindEntityByClassname(index, "prop_physics")) != INVALID_ENT_REFERENCE)
			{
				char entPropString[64];
				GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));

				if (entPropString[0])
				{
					numbers[count] = index;
					count++;
				}	
			}

			if (count > 1 )
			{
				CPrintToChat(client, "{%s}[%s] {%s}More than one possible ball found", prefixcolor, prefix, textcolor);
				OpenTrainingCannonSelectBallMenu(client, count, numbers);
			}
			else
			{
				trainingCannonBallIndex = numbers[0];
				//KillTrainingCannonTimer();
				delete trainingCannonTimer;
				trainingCannonTimer = CreateTimer(0.0, TrainingCannonShoot);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has turned the cannon on", prefixcolor, prefix, textcolor, client);
				}

				LogMessage("%N <%s> has turned the cannon on", client, steamid);
				OpenTrainingCannonMenu(client);
			}
		}
		else
		{
			//KillTrainingCannonTimer();
			delete trainingCannonTimer;
			trainingCannonTimer = CreateTimer(0.0, TrainingCannonShoot);

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has turned the cannon on", prefixcolor, prefix, textcolor, client);
			}

			LogMessage("%N <%s> has turned the cannon on", client, steamid);
			OpenTrainingCannonMenu(client);
		}
	}
	else
	{
		CPrintToChat(client, "{%s}[%s] {%s}Cannon is already on", prefixcolor, prefix, textcolor);
		OpenTrainingCannonMenu(client);
	}
}

public void TrainingCannonOff(int client)
{
	if (trainingCannonTimer != null)
	{
		float vec[3] = {0.0, 0.0, 0.0};
		
		//KillTrainingCannonTimer();
		delete trainingCannonTimer;
		TeleportEntity(trainingCannonBallIndex, NULL_VECTOR, NULL_VECTOR, vec);

		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has turned the cannon off", prefixcolor, prefix, textcolor, client);
		}
		
		//trainingCannonBallIndex = -1;
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		LogMessage("%N <%s> has turned the cannon off", client, steamid);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Cannon is already off", prefixcolor, prefix, textcolor);
}

public void TrainingCannonPosition(int client)
{
	GetAimOrigin(client, trainingCannonPosition);
	trainingCannonPosition[2] += 15;

	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the cannon position", prefixcolor, prefix, textcolor, client);
	}

	char steamid[32];
	GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
	LogMessage("%N <%s> has set the cannon position", client, steamid);
}

public void TrainingCannonAimPosition(int client)
{
	GetAimOrigin(client, trainingCannonAim);

	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the cannon aim position", prefixcolor, prefix, textcolor, client);
	}

	char steamid[32];
	GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
	LogMessage("%N <%s> has set the cannon aim position", client, steamid);
}

// *******************************************************************************************************************
// ************************************************* TRAINING PROPS **************************************************
// *******************************************************************************************************************

public void TrainingSpawnProp(int client, char type[32], bool spawn)
{
	char trainingModelProp[128];
	int index;
	if (StrEqual(type, "hoop"))
	{
		trainingModelProp = trainingModelHoop;
		index = pers_hoopIndex[client];
	}
	else if(StrEqual(type, "can"))
	{
		trainingModelProp = trainingModelCan;
		index = pers_canIndex[client];
	}
	else if(StrEqual(type, "plate"))
	{
		trainingModelProp = trainingModelPlate;
		index = pers_plateIndex[client];
	}

	if (FileExists(trainingModelProp, true))
	{
		char entityName[32];
		Format(entityName, sizeof(entityName), "soccer_mod_training_%s_%i", type, client);	
		char triggerName[64];
		Format(triggerName, sizeof(triggerName), "soccer_mod_training_%strigger_%i", type, client);
		
		int prop, trigger;
		if(!spawn)
		{
			while ((prop = FindEntityByClassname(prop, "prop_dynamic")) != INVALID_ENT_REFERENCE)
			{
				char entPropString[32];
				GetEntPropString(prop, Prop_Data, "m_iName", entPropString, sizeof(entPropString));

				if (StrEqual(entPropString, entityName))
				{
					if(StrEqual(type, "hoop"))			pers_hoopIndex[client] = -1;
					else if (StrEqual(type, "can"))		pers_canIndex[client] = -1;
					else if (StrEqual(type, "plate"))	pers_plateIndex[client] = -1;
					AcceptEntityInput(prop, "Kill");
				}
			}
			while ((trigger = FindEntityByClassname(trigger, "trigger_multiple")) != INVALID_ENT_REFERENCE)
			{
				char entPropString[64];
				GetEntPropString(trigger, Prop_Data, "m_iName", entPropString, sizeof(entPropString));

				if (StrEqual(entPropString, triggerName))
				{
					AcceptEntityInput(trigger, "Kill");
				}
			}	
			
			OpenSpawnMenu(client);
		}
		else
		{
			if (index == -1)
			{
				index = CreateEntityByName("prop_dynamic");
				if (index)
				{
					if (!IsModelPrecached(trainingModelProp)) PrecacheModel(trainingModelProp);

					DispatchKeyValue(index, "targetname", entityName);
					DispatchKeyValue(index, "model", trainingModelProp);
					DispatchKeyValue(index, "solid", "6");

					// set position above ground
					float aimPosition[3];
					GetAimOrigin(client, aimPosition);
					if(StrEqual(type, "hoop")) aimPosition[2] += 23.0;
					else if(StrEqual(type, "can")) aimPosition[2] += 29.0;
					else if(StrEqual(type, "plate")) aimPosition[2] += 0.0;
					
					// set y angle according to view
					
					DispatchKeyValueVector(index, "origin", aimPosition);
					
					DispatchSpawn(index);
					
					SetEntityRenderColor(index, 255, 0, 0, 255);

					if(StrEqual(type, "hoop"))			pers_hoopIndex[client] = index;
					else if(StrEqual(type, "plate"))	pers_plateIndex[client] = index;
					else								pers_canIndex[client] = index;
					
					if(!StrEqual(type, "hoop")) SpawnTrigger(client, index, entityName, aimPosition);
					OpenSpawnMenu(client);
				}
			}
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Cant spawn model %s", prefixcolor, prefix, textcolor, trainingModelHoop);
}

public void SpawnTrigger(int client, int prop_index, char prop_name[32], float prop_pos[3])
{
	char type[32];
	if(trainingPropType[client] == 0)		type = "hoop";
	else if (trainingPropType[client] == 1)	type = "can";
	else if (trainingPropType[client] == 2)	type = "plate";

	int index = CreateEntityByName("trigger_multiple");
	if (index != -1)
	{
		char entityName[64];
		Format(entityName, sizeof(entityName), "soccer_mod_training_%strigger_%i", type, client);

		DispatchKeyValue(index, "targetname", entityName);
		DispatchKeyValue(index, "parentname", prop_name);
		DispatchKeyValue(index, "spawnflags", "8");
		
		DispatchSpawn(index);
		ActivateEntity(index);

		TeleportEntity(index, prop_pos, NULL_VECTOR, NULL_VECTOR);
		parentEntity(index, prop_index, "");
		
		if (!IsModelPrecached(trainingModelPlate)) PrecacheModel(trainingModelPlate);
		SetEntityModel(index, trainingModelPlate);
		//SetEntityMoveType(index, MOVETYPE_NOCLIP);

		float minbounds[3] = {-0.5, -0.5, -0.5};
		float maxbounds[3] = {0.5, 0.5, 0.5};

		SetEntPropVector(index, Prop_Send, "m_vecMins", minbounds);
		SetEntPropVector(index, Prop_Send, "m_vecMaxs", maxbounds);
		
		SetEntProp(index, Prop_Send, "m_nSolidType", 2);
		
		int enteffects = GetEntProp(index, Prop_Send, "m_fEffects");
		enteffects |= 32;
		SetEntProp(index, Prop_Send, "m_fEffects", enteffects);
	}
}

public void PropOnStartTouch(int caller, int activator, int client, char entityName[64], char type[32])
{
	char callerClassname[64];
	GetEntityClassname(caller, callerClassname, sizeof(callerClassname));

	char callerName[64];
	GetEntPropString(caller, Prop_Data, "m_iName", callerName, sizeof(callerName));
		
	// get target prop
	int prop;
	if(StrEqual(type, "can"))	prop = pers_canIndex[client];
	else if (StrEqual(type, "plate"))	prop = pers_plateIndex[client];
	
	if(StrEqual(callerName, entityName))
	{
		if(prop != -1)	
		{
			SetEntityRenderColor(prop, 50, 250, 50, 255);
		}
	}
}

public void PropOnEndTouch(int caller, int activator, int client, char entityName[64], char type[32])
{
	DataPack pack = new DataPack();
	CreateDataTimer(1.0, ResetPropColorTimer, pack); 
	WritePackCell(pack, caller);
	WritePackCell(pack, client);
	WritePackString(pack, entityName);
	WritePackString(pack, type);
}

public Action ResetPropColorTimer(Handle timer, DataPack pack)
{
	ResetPack(pack);
	int caller, client;
	char entityName[64], type[32];
	caller = ReadPackCell(pack);
	client = ReadPackCell(pack);
	ReadPackString(pack, entityName, sizeof(entityName));
	ReadPackString(pack, type, sizeof(type));

	char callerClassname[64];
	GetEntityClassname(caller, callerClassname, sizeof(callerClassname));

	char callerName[64];
	GetEntPropString(caller, Prop_Data, "m_iName", callerName, sizeof(callerName));
	
	// get target prop
	int prop;
	if(StrEqual(type, "can"))			prop = pers_canIndex[client];
	else if (StrEqual(type, "plate"))	prop = pers_plateIndex[client];
	
	if(StrEqual(callerName, entityName))
	{
		if(prop != -1)	SetEntityRenderColor(prop, 255, 0, 0, 255);
	}
}

public void OpenSpawnMenu(int client)
{
	Menu menu = new Menu(OpenSpawnMenuHandler);
	menu.SetTitle("Spawn Prop Menu");

	if(FileExists(trainingModelHoop, true)) menu.AddItem("hoop", "Spawn/Remove Hoop");
	if(FileExists(trainingModelCan, true)) menu.AddItem("can", "Spawn/Remove Can");
	if(FileExists(trainingModelPlate, true)) menu.AddItem("plate", "Spawn/Remove Plate");
	if(FileExists(trainingModelPlate, true) || FileExists(trainingModelHoop, true) || FileExists(trainingModelCan, true)) menu.AddItem("grab", "Position Prop");
	/*if(FileExists(trainingModelHoop, true)) menu.AddItem("remhoop", "Remove Hoop");
	if(FileExists(trainingModelCan, true)) menu.AddItem("remcan", "Remove Can");
	if(FileExists(trainingModelPlate, true)) menu.AddItem("remplate", "Remove Plate");*/
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int OpenSpawnMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		if (!matchStarted)
		{			
			char menuItem[32];
			menu.GetItem(choice, menuItem, sizeof(menuItem));
			
			if (StrEqual(menuItem, "hoop")) 
			{
				if(GetClientTeam(client) > 1 && IsPlayerAlive(client))
				{
					if(pers_hoopIndex[client] == -1)
					{
						trainingPropType[client] = 0;
						TrainingSpawnProp(client, "hoop", true);
					}
					else
					{
						TrainingSpawnProp(client, "hoop", false);
					}
				}
				else 
				{
					CPrintToChat(client,"{%s}[%s] {%s}Only alive players can spawn a hoop.", prefixcolor, prefix, textcolor);
					OpenSpawnMenu(client);
				}
			}
			else if (StrEqual(menuItem, "can")) 
			{
				if(GetClientTeam(client) > 1 && IsPlayerAlive(client))
				{
					if(pers_canIndex[client] == -1)
					{
						trainingPropType[client] = 1;
						TrainingSpawnProp(client, "can", true);
					}
					else
					{
						TrainingSpawnProp(client, "can", false);
					}
				}
				else 
				{
					CPrintToChat(client,"{%s}[%s] {%s}Only alive players can spawn a can.", prefixcolor, prefix, textcolor);
					OpenSpawnMenu(client);
				}
			}
			else if (StrEqual(menuItem, "plate")) 
			{
				if(GetClientTeam(client) > 1 && IsPlayerAlive(client))
				{
					if(pers_plateIndex[client] == -1)
					{
						trainingPropType[client] = 2;
						TrainingSpawnProp(client, "plate", true);
					}
					else
					{
						TrainingSpawnProp(client, "plate", false);
					}
				}
				else 
				{
					CPrintToChat(client,"{%s}[%s] {%s}Only alive players can spawn a plate.", prefixcolor, prefix, textcolor);
					OpenSpawnMenu(client);
				}
			}
			else if(StrEqual(menuItem, "grab"))
			{
				ControlPropInfo(client);
			}
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenTrainingMenu(client);
	else if (action == MenuAction_End) 		menu.Close();
}


// explanation here + enable cmd_grab
public void ControlPropInfo(int client)
{
	char sBuf[256];
	Handle h_Infopanel = CreatePanel();
	int panel_keys = 0;

	Format(sBuf, sizeof(sBuf), "Aim at your prop and hit grab.");
	DrawPanelText(h_Infopanel, sBuf);
	DrawPanelText(h_Infopanel, " ");
	
	char sItem_display[32] = "Grab / Ungrab"
	
	for(int i = 1; i <= 1; i++)
	{
		panel_keys |= (1<<i-1);
		Format(sBuf, sizeof(sBuf), "->%i. %s", i, sItem_display[(i-1)]);
		DrawPanelText(h_Infopanel, sBuf);
	}
	
	DrawPanelText(h_Infopanel, " ");
	Format(sBuf, sizeof(sBuf), "________________________");
	DrawPanelText(h_Infopanel, sBuf);
	DrawPanelText(h_Infopanel, " ");
	Format(sBuf, sizeof(sBuf), "Buttons (Default Bindings)");
	DrawPanelText(h_Infopanel, sBuf);
	DrawPanelText(h_Infopanel, " ");
	Format(sBuf, sizeof(sBuf), "Move Prop: Mouse Movement");
	DrawPanelText(h_Infopanel, sBuf);
	Format(sBuf, sizeof(sBuf), "Push: Primary Attack");
	DrawPanelText(h_Infopanel, sBuf);
	Format(sBuf, sizeof(sBuf), "Pull: Secondary Attack");
	DrawPanelText(h_Infopanel, sBuf);
	Format(sBuf, sizeof(sBuf), "________________________");
	DrawPanelText(h_Infopanel, sBuf);
	Format(sBuf, sizeof(sBuf), "Rotation Mode: Reload");
	DrawPanelText(h_Infopanel, sBuf);
	Format(sBuf, sizeof(sBuf), "Select Axis: 'A', 'S', 'D'");
	DrawPanelText(h_Infopanel, sBuf);
	Format(sBuf, sizeof(sBuf), "Show Rings: 'W'");
	DrawPanelText(h_Infopanel, sBuf);
	DrawPanelText(h_Infopanel, " ");
	Format(sBuf, sizeof(sBuf), "Reset Rotation: ");
	DrawPanelText(h_Infopanel, sBuf);
	Format(sBuf, sizeof(sBuf), "'A'+'S'+'D'");
	DrawPanelText(h_Infopanel, sBuf);
	Format(sBuf, sizeof(sBuf), "________________________");
	DrawPanelText(h_Infopanel, sBuf);
	DrawPanelText(h_Infopanel, " ");

	panel_keys |= (1<<8-1);
	Format(sBuf, sizeof(sBuf), "8. Ungrab & Back");
	DrawPanelText(h_Infopanel, sBuf);
	panel_keys |= (1<<10-1);
	Format(sBuf, sizeof(sBuf), "0. Ungrab & Exit");
	DrawPanelText(h_Infopanel, sBuf);

	SetPanelKeys(h_Infopanel, panel_keys);

	SendPanelToClient(h_Infopanel, client, ControlPropInfoReturn, MENU_TIME_FOREVER);
	CloseHandle(h_Infopanel);
}

public int ControlPropInfoReturn(Handle panel, MenuAction action, int client, int key)
{
	if (action == MenuAction_Select && key == 1)
	{		
		if(GetClientTeam(client) > 1 && IsPlayerAlive(client))
		{
			GrabEntity(client, "prop", -1);
			ControlPropInfo(client);
		}
		else
		{
			CPrintToChat(client,"{%s}[%s] {%s}Only alive players can grab a prop.", prefixcolor, prefix, textcolor);
			ControlPropInfo(client);
		}
	}
	else if (action == MenuAction_Select && key == 8)
	{
		UnGrabEntity(client);
		OpenSpawnMenu(client);
	}
	else if (action == MenuAction_Select && key == 0)
	{
		UnGrabEntity(client);
	}

	return;
}

public Action GrabEntity(int client, char type[32], int team)
{
	int indexhoop, indexcan, indexplate, ent;
	indexhoop = pers_hoopIndex[client];
	indexcan = pers_canIndex[client];
	indexplate = pers_plateIndex[client];
	
	if (g_pGrabbedEnt[client] > 0 && IsValidEntity(g_pGrabbedEnt[client])) 
	{
		if(StrEqual(type, "spawn")) AcceptEntityInput(respawnIndex[0], "DisableCollision");
		UnGrabEntity(client);
		return Plugin_Handled;
	}
	
	float entOrigin[3], playerGrabOrigin[3];
	// is the prop owned by the client?
	if(StrEqual(type, "prop"))
	{
		ent = GetClientAimTarget(client, false);
		if (ent != indexhoop && ent != indexcan && ent != indexplate)
		{
			PrintHintText(client, "Please aim at one of your props when using this option.");
			return Plugin_Handled;
		}
		
		GetClientEyePosition(client, playerGrabOrigin);
		GetEntPropVector(ent, Prop_Send, "m_vecOrigin", entOrigin);
	}
	else if (StrEqual(type, "spawn"))
	{
		AcceptEntityInput(respawnIndex[team], "EnableCollision");
		ent = GetClientAimTarget(client, false);
		
		if (ent != respawnIndex[team])
		{
			PrintHintText(client, "Please aim at the (correct) respawnpoint when using this option.");
			AcceptEntityInput(respawnIndex[team], "DisableCollision");
			return Plugin_Handled;
		}
		
		PrintHintText(client,"Ballspawn moving enabled. Press 'R' to remove the spawnpoint.");
	}
	if (ent == -1 || !IsValidEntity(ent))								return Plugin_Handled;
	
	GetClientEyePosition(client, playerGrabOrigin);
	GetEntPropVector(ent, Prop_Send, "m_vecOrigin", entOrigin);
	
	g_pGrabbedEnt[client] = ent;
	
	// Watch change in client physics type
	SDKHook(client, SDKHook_PreThink, OnPreThink);
	
	// Get the point at which the ray first hit the entity
	float initialRay[3];
	initialRay[0] = GetInitialRayPosition(client, 'x');
	initialRay[1] = GetInitialRayPosition(client, 'y');
	initialRay[2] = GetInitialRayPosition(client, 'z');
	
	// Calculate the offset between intitial ray hit and the entities origin
	g_fGrabOffset[client][0] = entOrigin[0] - initialRay[0];
	g_fGrabOffset[client][1] = entOrigin[1] - initialRay[1];
	g_fGrabOffset[client][2] = entOrigin[2] - initialRay[2];
	
	// Calculate the distance between ent and player
	float xDis = Pow(initialRay[0]-(playerGrabOrigin[0]), 2.0);
	float yDis = Pow(initialRay[1]-(playerGrabOrigin[1]), 2.0);
	float zDis = Pow(initialRay[2]-(playerGrabOrigin[2]), 2.0);
	g_fGrabDistance[client] = SquareRoot((xDis)+(yDis)+(zDis));

	// Get and Store entities original color (useful if colored)
	int entColor[4];
	int colorOffset = GetEntSendPropOffs(ent, "m_clrRender");
	
	if (colorOffset > 0) 
	{
		entColor[0] = GetEntData(ent, colorOffset, 1);
		entColor[1] = GetEntData(ent, colorOffset + 1, 1);
		entColor[2] = GetEntData(ent, colorOffset + 2, 1);
		entColor[3] = GetEntData(ent, colorOffset + 3, 1);
	}
	
	g_eOriginalColor[client][0] = entColor[0];
	g_eOriginalColor[client][1] = entColor[1];
	g_eOriginalColor[client][2] = entColor[2];
	g_eOriginalColor[client][3] = entColor[3];
	
	// Set entities color to grab color (green and semi-transparent)
	SetEntityRenderMode(ent, RENDER_TRANSALPHA);
	SetEntityRenderColor(ent, 0, 255, 0, 235);
	
	// Freeze entity
	char sClass[64];
	GetEntityClassname(ent, sClass, sizeof(sClass)); TrimString(sClass);
	
	if (StrEqual(sClass, "player", false))
		SetEntityMoveType(ent, MOVETYPE_NONE);
	else
		AcceptEntityInput(ent, "DisableMotion");
	
	// Disable weapon prior to timer
	SetWeaponDelay(client, 1.0);
	
	// Make sure rotation mode can immediately be entered
	g_pLastButtonPress[client] = GetGameTime() - 2.0;
	g_pInRotationMode[client] = false;
	
	DataPack pack;
	g_eGrabTimer[client] = CreateDataTimer(0.1, Timer_UpdateGrab, pack, TIMER_REPEAT);
	pack.WriteCell(client);
	pack.WriteCell(team);
	pack.WriteString(type);
	
	return Plugin_Handled;
}

public Action Timer_UpdateGrab(Handle timer, DataPack pack) {
	int client, team;
	char type[32];
	pack.Reset();
	client = pack.ReadCell();
	team = pack.ReadCell();
	pack.ReadString(type, sizeof(type));
	
	if (!IsValidEntity(client) || client < 1 || client > MaxClients || !IsClientInGame(client))
		return Plugin_Stop;
	
	if (g_pGrabbedEnt[client] == -1 || !IsValidEntity(g_pGrabbedEnt[client]))
		return Plugin_Stop;
	
	// Continuously delay use of weapon, as to not fire any bullets when pushing/pulling/rotating
	SetWeaponDelay(client, 1.0);	
	
	// *** Enable/Disable Rotation Mode
	if (GetClientButtons(client) & IN_RELOAD) 
	{
		// Avoid instant enable/disable of rotation mode by requiring a one second buffer
		if (GetGameTime() - g_pLastButtonPress[client] >= 1.0) 
		{
			if(StrEqual(type, "prop"))
			{
				g_pLastButtonPress[client] = GetGameTime();
				g_pInRotationMode[client] = g_pInRotationMode[client] == true ? false : true;
				PrintToChat(client, "\x04[SM]\x01 Rotation Mode \x05%s\x01", g_pInRotationMode[client] == true ? "Enabled" : "Disabled");		
				
				// Restore the entities color and alpha if enabling
				if(g_pInRotationMode[client]) 
				{
					SetEntityRenderColor(g_pGrabbedEnt[client], 255, 255, 255, 255);
					PrintToChat(client, "\x05[A]\x01 RED \x05[S]\x01 GREEN \x05[D]\x01 BLUE \x05[W]\x01 SHOW RINGS");
				}
				// Change back to grabbed color if disabling
				else
					SetEntityRenderColor(g_pGrabbedEnt[client], 0, 255, 0, 235);
			}
			else if(StrEqual(type, "spawn"))
			{
				UnGrabEntity(client);
				AcceptEntityInput(respawnIndex[team], "Kill");
				respawnIndex[team] = -1;
				OpenAdvancedTrainingTargetMenu(client);
			}
		}
	}
	// ***In Rotation Mode
	if (g_pInRotationMode[client]) 
	{
		SDKUnhook(client, SDKHook_PreThink, OnPreThink);
		SetEntityMoveType(client, MOVETYPE_NONE);
		
		float ang[3], pos[3], mins[3], maxs[3];
		GetEntPropVector(g_pGrabbedEnt[client], Prop_Send, "m_angRotation", ang);
		GetEntPropVector(g_pGrabbedEnt[client], Prop_Send, "m_vecOrigin", pos);
		GetEntPropVector(g_pGrabbedEnt[client], Prop_Send, "m_vecMins", mins);
		GetEntPropVector(g_pGrabbedEnt[client], Prop_Send, "m_vecMaxs", maxs);
		
		// If the entity is a child, it will have a null position, so we'll hesitantly use the parents position
		int parent = GetEntPropEnt(g_pGrabbedEnt[client], Prop_Data, "m_hMoveParent");
		if (parent > 0 && IsValidEntity(parent))
			GetEntPropVector(parent, Prop_Send, "m_vecOrigin", pos);
		
		// Get rotation axis from button press
		int buttonPress = GetClientButtons(client);	
		switch(buttonPress) 
		{
			case IN_FORWARD: g_eRotationAxis[client] = -1;  // [W] = Show Rings
			case IN_MOVELEFT: g_eRotationAxis[client] = 0;  // [A] = x axis
			case IN_BACK: g_eRotationAxis[client] = 1; 		// [S] = y axis
			case IN_MOVERIGHT: g_eRotationAxis[client] = 2; // [D] = z axis
		}
			
		// Reset angles when A+S+D is pressed
		if((buttonPress & IN_MOVELEFT) && (buttonPress & IN_BACK) && (buttonPress & IN_MOVERIGHT)) 
		{ 
			ang[0] = 0.0; ang[1] = 0.0; ang[2] = 0.0;
			g_eRotationAxis[client] = -1;
		}
		
		// Largest side should dictate the diameter of the rings
		float diameter, sendAng[3];
		diameter = (maxs[0] > maxs[1]) ? (maxs[0] + 10.0) : (maxs[1] + 10.0);
		diameter = ((maxs[2] + 10.0) > diameter) ? (maxs[2] + 10.0) : diameter;
		
		// Sending original ang will cause non-stop rotation issue
		sendAng = ang; 
		
		// Draw rotation rings
		switch(g_eRotationAxis[client]) 
		{
			case -1: CreateRing(client, sendAng, pos, diameter, 0, true); // all 3 rings
			case 0:  CreateRing(client, sendAng, pos, diameter, 0, false); // red (x)
			case 1:  CreateRing(client, sendAng, pos, diameter, 1, false); // green (y)
			case 2:  CreateRing(client, sendAng, pos, diameter, 2, false); // blue (z)
		}
		
		// Rotate with mouse if on a rotation axis (A,S,D)
		if (g_eRotationAxis[client] != -1) 
		{
			// + Rotate
			if (GetClientButtons(client) & IN_ATTACK) 
				ang[g_eRotationAxis[client]] += 10.0;
			// - Rotate
			else if (GetClientButtons(client) & IN_ATTACK2) 
				ang[g_eRotationAxis[client]] -= 10.0;
		}
		
		TeleportEntity(g_pGrabbedEnt[client], NULL_VECTOR, ang, NULL_VECTOR);
	}
	// ***Not in Rotation Mode
	if (!g_pInRotationMode[client] || g_eRotationAxis[client] == -1) 
	{
		// Keep track of player noclip as to avoid forced enable/disable
		if(!g_pInRotationMode[client]) {
			SDKHook(client, SDKHook_PreThink, OnPreThink);
			
			if (g_pWasInNoclip[client])
				SetEntityMoveType(client, MOVETYPE_NOCLIP);
			else 
				SetEntityMoveType(client, MOVETYPE_ISOMETRIC);
		}
		// Push entity (Allowed if we're in rotation mode, not on a rotation axis (-1))
		if (GetClientButtons(client) & IN_ATTACK) 
		{
			if (g_fGrabDistance[client] < 60)
	    		g_fGrabDistance[client] += 1;
			else
	    		g_fGrabDistance[client] += g_fGrabDistance[client] / 25;
		}
		// Pull entity (Allowed if we're in rotation mode, not on a rotation axis (-1))
		else if (GetClientButtons(client) & IN_ATTACK2 && g_fGrabDistance[client] > 25) 
		{
			if (g_fGrabDistance[client] < 60)
	    		g_fGrabDistance[client] -= 1;
			else
	    		g_fGrabDistance[client] -= g_fGrabDistance[client] / 25;		
		}
		
		g_eRotationAxis[client] = -1;
	}

	// *** Runs whether in rotation mode or not
	float entNewPos[3];
	entNewPos[0] = GetEntNewPosition(client, 'x') + g_fGrabOffset[client][0];
	entNewPos[1] = GetEntNewPosition(client, 'y') + g_fGrabOffset[client][1];
	entNewPos[2] = GetEntNewPosition(client, 'z') + g_fGrabOffset[client][2];
	
	// Move Portposition
	if(team == 0)
	{
		ballPortPosT = entNewPos;
		ballPortPosT[2] += 15.0;
	}
	else if (team == 1)
	{
		ballPortPosCT = entNewPos;
		ballPortPosCT[2] += 15.0;
	}
	
	TeleportEntity(g_pGrabbedEnt[client], entNewPos, NULL_VECTOR, NULL_VECTOR);
	
	return Plugin_Handled;
}

public void UnGrabEntity(int client)
{
	// Avoid forced removal of noclip or player stuck
	if (GetEntityMoveType(client) == MOVETYPE_NONE && !g_pWasInNoclip[client])
		SetEntityMoveType(client, MOVETYPE_ISOMETRIC);
	else if (GetEntityMoveType(client) == MOVETYPE_NOCLIP || g_pWasInNoclip[client])
		SetEntityMoveType(client, MOVETYPE_NOCLIP);
	
	if(g_pGrabbedEnt[client] != -1)
	{
		// UNhook client physics
		SDKUnhook(client, SDKHook_PreThink, OnPreThink);
		
		// Unfreeze if target was a player and unfreeze if setting is set to 0
		char sClass[64];
		GetEntityClassname(g_pGrabbedEnt[client], sClass, sizeof(sClass)); TrimString(sClass);
		
		if (StrEqual(sClass, "player", false))
			//SetEntityMoveType(g_pGrabbedEnt[client], MOVETYPE_WALK);
			AcceptEntityInput(g_pGrabbedEnt[client], "Sleep");
		else if (g_eReleaseFreeze[client] == false)
			AcceptEntityInput(g_pGrabbedEnt[client], "EnableMotion");
			
		// Restore color and alpha to original prior to grab
		SetEntityRenderColor(g_pGrabbedEnt[client], g_eOriginalColor[client][0], g_eOriginalColor[client][1], g_eOriginalColor[client][2], g_eOriginalColor[client][3]);
		
		// Kill the grab timer and reset control values
		if (g_eGrabTimer[client] != null) {
			KillTimer(g_eGrabTimer[client]);
			g_eGrabTimer[client] = null;
		}
		
		g_pGrabbedEnt[client] = -1;
		g_eRotationAxis[client] = -1;
		g_pInRotationMode[client] = false;
	}
}

//============================================================================
//							***		UTILITIES	***							//
//============================================================================
stock float GetEntNewPosition(int client, char axis)
{ 
	if (client > 0 && client <= MaxClients && IsClientInGame(client)) {
		float endPos[3], clientEye[3], clientAngle[3], direction[3];
		GetClientEyePosition(client, clientEye);
		GetClientEyeAngles(client, clientAngle);

		GetAngleVectors(clientAngle, direction, NULL_VECTOR, NULL_VECTOR);
		ScaleVector(direction, g_fGrabDistance[client]);
		AddVectors(clientEye, direction, endPos);

		TR_TraceRayFilter(clientEye, endPos, MASK_SOLID, RayType_EndPoint, TraceRayFilterEnt, client);
		if (TR_DidHit(INVALID_HANDLE))
			TR_GetEndPosition(endPos);

		if      (axis == 'x') return endPos[0]; 
		else if (axis == 'y') return endPos[1];
		else if (axis == 'z') return endPos[2];
	}

	return 0.0;
}
/////
stock float GetInitialRayPosition(int client, char axis)
{ 
	if (client > 0 && client <= MaxClients && IsClientInGame(client)) {
		float endPos[3], clientEye[3], clientAngle[3];
		GetClientEyePosition(client, clientEye);
		GetClientEyeAngles(client, clientAngle);

		TR_TraceRayFilter(clientEye, clientAngle, MASK_SOLID, RayType_Infinite, TraceRayFilterActivator, client);
		if (TR_DidHit(INVALID_HANDLE))
			TR_GetEndPosition(endPos);

		if      (axis == 'x') return endPos[0]; 
		else if (axis == 'y') return endPos[1];
		else if (axis == 'z') return endPos[2];
	}

	return 0.0;
}
/////
stock void SetWeaponDelay(int client, float delay)
{
	if (IsValidEntity(client) && client > 0 && client <= MaxClients && IsClientInGame(client)) {
		int pWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		
		if (IsValidEntity(pWeapon) && pWeapon != -1) {
			SetEntPropFloat(pWeapon, Prop_Send, "m_flNextPrimaryAttack", GetGameTime() + delay); 
			SetEntPropFloat(pWeapon, Prop_Send, "m_flNextSecondaryAttack", GetGameTime() + delay); 
		}
	}
}
/////
stock void CreateRing(int client, float ang[3], float pos[3], float diameter, int axis, bool trio)
{
	if (!IsValidEntity(client) || client < 1 || client > MaxClients || !IsClientInGame(client))
		return;
		
	float ringVecs[26][3];
	int ringColor[3][4];

	ringColor[0] = { 255, 0, 0, 255 };
	ringColor[1] = { 0, 255, 0, 255 };
	ringColor[2] = { 0, 0, 255, 255 };
	
	int numSides = (!trio) ? 26 : 17;
	float angIncrement = (!trio) ? 15.0 : 24.0;

	for (int i = 1; i < numSides; i++) 
	{
		float direction[3], endPos[3];
		switch(axis) 
		{
			case 0: GetAngleVectors(ang, direction, NULL_VECTOR, NULL_VECTOR);
			case 1:
			{
				ang[2] = 0.0;
				GetAngleVectors(ang, NULL_VECTOR, direction, NULL_VECTOR);
			}
			case 2: GetAngleVectors(ang, NULL_VECTOR, NULL_VECTOR, direction);
		}
	
		ScaleVector(direction, diameter);
		AddVectors(pos, direction, endPos);

		if (i == 1) ringVecs[0] = endPos;
			
		ringVecs[i] = endPos;
		ang[axis] += angIncrement;
		
		TE_SetupBeamPoints(ringVecs[i-1], ringVecs[i], g_BeamSprite, g_HaloSprite, 0, 15, 0.2, 2.5, 2.5, 1, 0.0, ringColor[axis], 10);
		TE_SendToClient(client, 0.0);
		
		if(trio && i == numSides-1 && axis < 2) 
		{
			i = 0;
			ang[axis] -= angIncrement * (numSides-1);
			axis += 1;
		}
	}
}

//============================================================================
//							***		FILTERS		***							//
//============================================================================
public bool TraceRayFilterEnt(int entity, int mask, any client)
{
	if (entity == client || entity == g_pGrabbedEnt[client]) 
		return false;
	return true;
}  
/////
public bool TraceRayFilterActivator(int entity, int mask, any activator)
{
	if (entity == activator)
		return false;
	return true;
}

//============================================================================
//							***		HOOKS		***							//
//============================================================================
public void OnPreThink(int client) 
{
	if (GetEntityMoveType(client) == MOVETYPE_NOCLIP && GetEntityMoveType(client) != MOVETYPE_NONE)
		g_pWasInNoclip[client] = true;
	else
		g_pWasInNoclip[client] = false;
}

public void ResetTrainingIndex(int client)
{
	pers_hoopIndex[client]				= -1;
	pers_canIndex[client]				= -1;
	pers_plateIndex[client]				= -1;
}

public void parentEntity(int child, int parent, const char[] attachment) 
{
    SetVariantString("!activator");
    AcceptEntityInput(child, "SetParent", parent, child, 0);
    if(!StrEqual(attachment, "", false)) 
	{
        SetVariantString(attachment);
        AcceptEntityInput(child, "SetParentAttachment", child, child, 0);
    }
}