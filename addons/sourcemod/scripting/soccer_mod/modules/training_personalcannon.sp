// ***********************************************************************************************************************
// ************************************************** COMMAND LISTENERS **************************************************
// ***********************************************************************************************************************

public void PersonalTrainingCannonSet(int client, char type[32], float number, float min, float max) 
{
	if ((number >= min && number <= max) || number == 0.0)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

		if (StrEqual(type, "randomness"))
		{
			pers_trainingCannonRandomness[client] = number;

			CPrintToChat(client, "{%s}[%s] {%s}Set the cannon randomness to %f", prefixcolor, prefix, textcolor, number);
		}
		else if (StrEqual(type, "fire_rate"))
		{
			if(number != 0.0)
			{
				pers_trainingCannonFireRate[client] = number;

				CPrintToChat(client, "{%s}[%s] {%s}Set the cannon fire rate to %f", prefixcolor, prefix, textcolor, number);
			}
			else 
			{
				OpenPersonalTrainingCannonSettingsMenu(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		else if (StrEqual(type, "power"))
		{
			if(number != 0.0)
			{
				pers_trainingCannonPower[client] = number;

				CPrintToChat(client, "{%s}[%s] {%s}Set the cannon power to %f", prefixcolor, prefix, textcolor, number);
			}
			else 
			{
				OpenPersonalTrainingCannonSettingsMenu(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}

		changeSetting[client] = "";
		OpenPersonalTrainingCannonSettingsMenu(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Type a value between %f and %f", prefixcolor, prefix, textcolor, min, max);
}

// ************************************************************************************************************
// ************************************************** EVENTS **************************************************
// ************************************************************************************************************

public void PersonalTrainingOnMapStart()
{
	for(int i = 0; i <= MaxClients; i++)
	{
		pers_trainingCannonBallIndex[i]	 = -1;

		delete pers_trainingCannonTimer[i];
	}
}

public void PersonalTrainingEventRoundStart(Event event)
{
	for(int i = 0; i <= MaxClients; i++)
	{
		pers_trainingCannonBallIndex[i]	 = -1;
		delete pers_trainingCannonTimer[i];
	}
}

// **************************************************************************************************************************
// ********************************************** PERSONAL TRAINING CANNON MENU *********************************************
// **************************************************************************************************************************

public void OpenPersonalTrainingCannonMenu(int client)
{
	Menu menu = new Menu(PersonalTrainingCannonMenuHandler);

	menu.SetTitle("Soccer Mod - Admin - Training - Personal Cannon");

	menu.AddItem("position", "Set cannon position");

	menu.AddItem("aim", "Set cannon aim");

	menu.AddItem("on", "Cannon on");

	menu.AddItem("off", "Cannon off");

	menu.AddItem("settings", "Settings");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int PersonalTrainingCannonMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		if(GetClientTeam(client) > 1 && IsPlayerAlive(client))
		{
			char menuItem[32];
			menu.GetItem(choice, menuItem, sizeof(menuItem));

			if (StrEqual(menuItem, "off"))
			{
				PersonalTrainingCannonOff(client);
				OpenPersonalTrainingCannonMenu(client);
			}
			else
			{
				if (!matchStarted)
				{
					if (StrEqual(menuItem, "position"))
					{
						PersonalTrainingCannonPosition(client);
						OpenPersonalTrainingCannonMenu(client);
					}
					else if (StrEqual(menuItem, "aim"))
					{
						PersonalTrainingCannonAimPosition(client);
						OpenPersonalTrainingCannonMenu(client);
					}
					else if (StrEqual(menuItem, "on")) PersonalTrainingCannonOn(client);
					else if (StrEqual(menuItem, "settings")) OpenPersonalTrainingCannonSettingsMenu(client);
				}
				else
				{
					CPrintToChat(client, "{%s}[%s] {%s}You can not use this option during a match", prefixcolor, prefix, textcolor);
					OpenPersonalTrainingCannonMenu(client);
				}
			}
		}
		else
		{
			CPrintToChat(client, "{%s}[%s] {%s} You have to be in a team to use this option.", prefixcolor, prefix, textcolor);
			OpenPersonalTrainingCannonMenu(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenTrainingMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenPersonalTrainingCannonSettingsMenu(int client)
{
	Menu menu = new Menu(PersonalTrainingCannonSettingsMenuHandler);

	menu.SetTitle("Soccer Mod - Admin - Training - Cannon - Personal Settings");

	char menuString[32];
	Format(menuString, sizeof(menuString), "%s: %.0f", "Randomness", pers_trainingCannonRandomness[client]);
	menu.AddItem("randomness", menuString);

	Format(menuString, sizeof(menuString), "%s: %.1f", "Fire rate", pers_trainingCannonFireRate[client]);
	menu.AddItem("fire_rate", menuString);

	Format(menuString, sizeof(menuString), "%s: %.3f", "Power", pers_trainingCannonPower[client]);
	menu.AddItem("power", menuString);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int PersonalTrainingCannonSettingsMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "randomness"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type a value between %f and %f", prefixcolor, prefix, textcolor, 0.0, 500.0);
			changeSetting[client] = "pers_randomness";
		}
		else if (StrEqual(menuItem, "fire_rate"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type a value between %f and %f, 0 to cancel", prefixcolor, prefix, textcolor, 0.1, 10.0);
			changeSetting[client] = "pers_fire_rate";
		}
		else if (StrEqual(menuItem, "power"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type a value between %f and %f, 0 to cancel", prefixcolor, prefix, textcolor, 0.001, 10000.0);
			changeSetting[client] = "pers_power";
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenPersonalTrainingCannonMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ************************************************************************************************************
// ************************************************** TIMERS **************************************************
// ************************************************************************************************************

public Action PersonalTrainingCannonShoot(Handle timer, int client)
{
	if (IsValidEntity(pers_trainingCannonBallIndex[client]))
	{
		float vec[3];
		MakeVectorFromPoints(pers_trainingCannonPosition[client], pers_trainingCannonAim[client], vec);

		vec[0] = vec[0] + (pers_trainingCannonRandomness[client] / 2.0) - (pers_trainingCannonRandomness[client] * GetRandomFloat());
		vec[1] = vec[1] + (pers_trainingCannonRandomness[client] / 2.0) - (pers_trainingCannonRandomness[client] * GetRandomFloat());
		vec[2] = vec[2] + (pers_trainingCannonRandomness[client] / 2.0) - (pers_trainingCannonRandomness[client] * GetRandomFloat());

		ScaleVector(vec, pers_trainingCannonPower[client]);
		TeleportEntity(pers_trainingCannonBallIndex[client], pers_trainingCannonPosition[client], NULL_VECTOR, vec);

		pers_trainingCannonTimer[client] = CreateTimer(pers_trainingCannonFireRate[client], PersonalTrainingCannonShoot, client);
	}
	else
	{
		pers_trainingCannonBallIndex[client] = -1;
		delete pers_trainingCannonTimer[client];

		CPrintToChat(client, "{%s}[%s] {%s}Ball cannon entity is invalid", prefixcolor, prefix, textcolor);
	}
}

// ***************************************************************************************************************
// ************************************************** FUNCTIONS **************************************************
// ***************************************************************************************************************

public void SavePersonalCannonSettings(int client)
{
	if (IsValidClient(client) && !IsFakeClient(client))
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
			
		personalCannonSettings = new KeyValues("Personal Cannon Settings");
		personalCannonSettings.ImportFromFile(personalSettingsKV);
			
		personalCannonSettings.JumpToKey(steamid, true);
		personalCannonSettings.SetFloat("randomness", pers_trainingCannonRandomness[client]);
		personalCannonSettings.SetFloat("fire_rate", pers_trainingCannonFireRate[client]);
		personalCannonSettings.SetFloat("power", pers_trainingCannonPower[client]);
			
		personalCannonSettings.Rewind();
		personalCannonSettings.ExportToFile(personalSettingsKV);
		personalCannonSettings.Close();
	}
}

public void ReadPersonalCannonSettings(int client)
{
	if (IsValidClient(client) && IsClientInGame(client) && IsClientConnected(client) && !IsFakeClient(client) && !IsClientSourceTV(client))
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		
		personalCannonSettings = new KeyValues("Personal Cannon Settings");
		personalCannonSettings.ImportFromFile(personalSettingsKV);
		
		personalCannonSettings.JumpToKey(steamid, true);
		pers_trainingCannonRandomness[client] 	= personalCannonSettings.GetFloat("randomness", 0.0);
		pers_trainingCannonFireRate[client] 	= personalCannonSettings.GetFloat("fire_rate", 2.5);
		pers_trainingCannonPower[client]		= personalCannonSettings.GetFloat("power", 10000.0);
		
		personalCannonSettings.Rewind();
		personalCannonSettings.Close();
	}
}

public void PersonalTrainingCannonOn(int client)
{
	char entityName[32];
	Format(entityName, sizeof(entityName), "soccer_mod_training_ball_%i", client);
	
	if (FileExists(trainingModelBall, true))
	{
		int index;
		bool ballSpawned = false;

		while ((index = FindEntityByClassname(index, "prop_physics")) != INVALID_ENT_REFERENCE)
		{
			char entPropString[32];
			GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));

			if (StrEqual(entPropString, entityName))
			{
				ballSpawned = true;
				//AcceptEntityInput(index, "Kill");
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

				DispatchKeyValueVector(index, "origin", pers_trainingCannonPosition[client]);

				DispatchSpawn(index);
				pers_trainingCannonBallIndex[client] = index;
			}
		}
	}
	
	if (pers_trainingCannonTimer[client] == null)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

		if (!IsValidEntity(pers_trainingCannonBallIndex[client]))
		{
			int index;

			while ((index = FindEntityByClassname(index, "prop_physics")) != INVALID_ENT_REFERENCE)
			{
				char entPropString[64];
				GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));

				if (StrEqual(entPropString, entityName))
				{
					pers_trainingCannonBallIndex[client] = index;
				}
				
			}

			delete pers_trainingCannonTimer[client];
			pers_trainingCannonTimer[client] = CreateTimer(0.0, PersonalTrainingCannonShoot, client);

			CPrintToChat(client, "{%s}[%s] {%s}Turned on your personal cannon", prefixcolor, prefix, textcolor);

			OpenPersonalTrainingCannonMenu(client);
		}
		else
		{
			delete pers_trainingCannonTimer[client];
			pers_trainingCannonTimer[client] = CreateTimer(0.0, PersonalTrainingCannonShoot, client);

			CPrintToChat(client, "{%s}[%s] {%s}Turned on your personal cannon", prefixcolor, prefix, textcolor);

			OpenPersonalTrainingCannonMenu(client);
		}
	}
	else
	{
		CPrintToChat(client, "{%s}[%s] {%s}Cannon is already on", prefixcolor, prefix, textcolor);
		OpenPersonalTrainingCannonMenu(client);
	}
}

public void PersonalTrainingCannonOff(int client)
{
	if (pers_trainingCannonTimer[client] != null)
	{
		float vec[3] = {0.0, 0.0, 0.0};
		
		delete pers_trainingCannonTimer[client];
		TeleportEntity(pers_trainingCannonBallIndex[client], NULL_VECTOR, NULL_VECTOR, vec);

		CPrintToChat(client, "{%s}[%s] {%s}Turned off your personal cannon", prefixcolor, prefix, textcolor);
		
		int index;
		char entityName[32];
		Format(entityName, sizeof(entityName), "soccer_mod_training_ball_%i", client);
		
		while ((index = FindEntityByClassname(index, "prop_physics")) != INVALID_ENT_REFERENCE)
		{
			char entPropString[32];
			GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));

			if (StrEqual(entPropString, entityName))
			{
				AcceptEntityInput(index, "Kill");
			}
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Cannon is already off", prefixcolor, prefix, textcolor);
}

public void PersonalTrainingCannonPosition(int client)
{
	GetAimOrigin(client, pers_trainingCannonPosition[client]);
	pers_trainingCannonPosition[client][2] += 15;

	CPrintToChat(client, "{%s}[%s] {%s}Set your personal cannon position", prefixcolor, prefix, textcolor);
}

public void PersonalTrainingCannonAimPosition(int client)
{
	GetAimOrigin(client, pers_trainingCannonAim[client]);

	CPrintToChat(client, "{%s}[%s] {%s}Set your personal cannon aim position", prefixcolor, prefix, textcolor);
}