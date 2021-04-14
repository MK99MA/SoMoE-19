// ***********************************************************************************************************************
// ************************************************** COMMAND LISTENERS **************************************************
// ***********************************************************************************************************************
public void TrainingCannonSet(int client, char type[32], float number, float min, float max)
{
	if (number >= min && number <= max)
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
			trainingCannonFireRate = number;

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the cannon fire rate to %f", prefixcolor, prefix, textcolor, client, number);
			}

			LogMessage("%N <%s> has set the cannon fire rate to %.1f", client, steamid, number);
		}
		else if (StrEqual(type, "power"))
		{
			trainingCannonPower = number;

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the cannon power to %f", prefixcolor, prefix, textcolor, client, number);
			}

			LogMessage("%N <%s> has set the cannon power to %.3f", client, steamid, number);
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
}

public void TrainingEventRoundStart(Event event)
{
	if (matchStarted) delete trainingCannonTimer;//KillTrainingCannonTimer();
	else if (!trainingGoalsEnabled)
	{
		int index;
		while ((index = FindEntityByClassname(index, "trigger_once")) != INVALID_ENT_REFERENCE) AcceptEntityInput(index, "Kill");
	}
}

// *******************************************************************************************************************
// ************************************************** TRAINING MENU **************************************************
// *******************************************************************************************************************
public void OpenTrainingMenu(int client)
{
	Menu menu = new Menu(TrainingMenuHandler);

	menu.SetTitle("Soccer Mod - Admin - Training");

	menu.AddItem("cannon", "Cannon");
	
	menu.AddItem("personal", "Personal Cannon");

	menu.AddItem("disable_goals", "Disable goals");

	menu.AddItem("enable_goals", "Enable goals");

	menu.AddItem("spawn", "Spawn/Remove ball");

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

			if (StrEqual(menuItem, "disable_goals"))
			{
				TrainingDisableGoals(client);
				OpenTrainingMenu(client);
			}
			else if (StrEqual(menuItem, "enable_goals"))
			{
				TrainingEnableGoals(client);
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
			else if (StrEqual(menuItem, "cannon")) OpenTrainingCannonMenu(client);
			else if (StrEqual(menuItem, "personal")) OpenPersonalTrainingCannonMenu(client);
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
			CPrintToChat(client, "{%s}[%s] {%s}Type a value between %f and %f", prefixcolor, prefix, textcolor, 0.1, 10.0);
			changeSetting[client] = "fire_rate";
		}
		else if (StrEqual(menuItem, "power"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type a value between %f and %f", prefixcolor, prefix, textcolor, 0.001, 10000.0);
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
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has disabled the goals", prefixcolor, prefix, textcolor, client);
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
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has enabled the goals", prefixcolor, prefix, textcolor, client);
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
