public void RegisterServerCommandsSkins()
{
	RegServerCmd
	(
		"soccer_mod_skins_model_ct",
		ServerCommandsSkins,
		"Sets the model of the counter-terrorists - values: [path/to/dir/file.mdl] [skin number]"
	);
	RegServerCmd
	(
		"soccer_mod_skins_model_t",
		ServerCommandsSkins,
		"Sets the model of the terrorists - values: [path/to/dir/file.mdl] [skin number]"
	);
	RegServerCmd
	(
		"soccer_mod_skins_model_ct_gk",
		ServerCommandsSkins,
		"Sets the model of the counter-terrorist goalkeeper - values: [path/to/dir/file.mdl] [skin number]"
	);
	RegServerCmd
	(
		"soccer_mod_skins_model_t_gk",
		ServerCommandsSkins,
		"Sets the model of the terrorist goalkeeper - values: [path/to/dir/file.mdl] [skin number]"
	);
}

public Action ServerCommandsSkins(int args)
{
	char serverCommand[64], cmdArg1[128], cmdArg2[4];
	GetCmdArg(0, serverCommand, sizeof(serverCommand));
	GetCmdArg(1, cmdArg1, sizeof(cmdArg1));
	GetCmdArg(2, cmdArg2, sizeof(cmdArg2));

	if (StrEqual(serverCommand, "soccer_mod_skins_model_ct"))		   SkinsServerCommandModelCT(cmdArg1, cmdArg2);
	else if (StrEqual(serverCommand, "soccer_mod_skins_model_t"))	   SkinsServerCommandModelT(cmdArg1, cmdArg2);
	else if (StrEqual(serverCommand, "soccer_mod_skins_model_ct_gk"))   SkinsServerCommandModelCTGoalkeeper(cmdArg1, cmdArg2);
	else if (StrEqual(serverCommand, "soccer_mod_skins_model_t_gk"))	SkinsServerCommandModelTGoalkeeper(cmdArg1, cmdArg2);

	return Plugin_Handled;
}

public void SkinsServerCommandModelCT(char model[128], char number[4])
{
	if (FileExists(model, true))
	{
		skinsModelCT = model;
		if (!number[0]) number = "0";
		skinsModelCTNumber = number;
		UpdateConfigModels("Current Skins", "soccer_mod_skins_model_ct", skinsModelCT);
		
		if (!IsModelPrecached(model)) PrecacheModel(model);

		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsClientInGame(client) && IsClientConnected(client) && IsPlayerAlive(client))
			{
				int team = GetClientTeam(client);
				if (!skinsIsGoalkeeper[client] && team == 3)
				{
					SetEntityModel(client, model);
					DispatchKeyValue(client, "skin", number);
				}
			}
		}

		PrintToServer("[%s] Counter-terrorist model set to %s and skin number %s", prefix, model, number);
		CPrintToChatAll("{%s}[%s] {%s}Counter-terrorist model set to %s and skin number %s", prefixcolor, prefix, textcolor, model, number);
	}
	else
	{
		PrintToServer("[%s] Can't set counter-terrorist model to %s", prefix, model);
		CPrintToChatAll("{%s}[%s] {%s}Can't set counter-terrorist model to %s", prefixcolor, prefix, textcolor, model);
	}
}

public void SkinsServerCommandModelT(char model[128], char number[4])
{
	if (FileExists(model, true))
	{
		skinsModelT = model;
		if (!number[0]) number = "0";
		skinsModelTNumber = number;
		UpdateConfigModels("Current Skins", "soccer_mod_skins_model_t", skinsModelT);

		if (!IsModelPrecached(model)) PrecacheModel(model);

		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsClientInGame(client) && IsClientConnected(client) && IsPlayerAlive(client))
			{
				int team = GetClientTeam(client);
				if (!skinsIsGoalkeeper[client] && team == 2)
				{
					SetEntityModel(client, model);
					DispatchKeyValue(client, "skin", number);
				}
			}
		}

		PrintToServer("[%s] Terrorist model set to %s and skin number %s", prefix, model, number);
		CPrintToChatAll("{%s}[%s] {%s}Terrorist model set to %s and skin number %s", prefixcolor, prefix, textcolor, model, number);
	}
	else
	{
		PrintToServer("[%s] Can't set terrorist model to %s", prefix, model);
		CPrintToChatAll("{%s}[%s] {%s}Can't set terrorist model to %s", prefixcolor, prefix, textcolor, model);
	}
}

public void SkinsServerCommandModelCTGoalkeeper(char model[128], char number[4])
{
	if (FileExists(model, true))
	{
		skinsModelCTGoalkeeper = model;
		if (!number[0]) number = "0";
		skinsModelCTGoalkeeperNumber = number;
		UpdateConfigModels("Current Skins", "soccer_mod_skins_model_ct_gk", skinsModelCTGoalkeeper);

		if (!IsModelPrecached(model)) PrecacheModel(model);

		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsClientInGame(client) && IsClientConnected(client) && IsPlayerAlive(client))
			{
				int team = GetClientTeam(client);
				if (skinsIsGoalkeeper[client] && team == 3)
				{
					SetEntityModel(client, model);
					DispatchKeyValue(client, "skin", number);
				}
			}
		}

		PrintToServer("[%s] Counter-terrorist goalkeeper model set to %s and skin number %s", prefix, model, number);
		CPrintToChatAll("{%s}[%s] {%s}Counter-terrorist goalkeeper model set to %s and skin number %s", prefixcolor, prefix, textcolor, model, number);
	}
	else
	{
		PrintToServer("[%s] Can't set counter-terrorist goalkeeper model to %s", prefix, model);
		CPrintToChatAll("{%s}[%s] {%s}Can't set counter-terrorist goalkeeper model to %s", prefixcolor, prefix, textcolor, model);
	}
}

public void SkinsServerCommandModelTGoalkeeper(char model[128], char number[4])
{
	if (FileExists(model, true))
	{
		skinsModelTGoalkeeper = model;
		if (!number[0]) number = "0";
		skinsModelTGoalkeeperNumber = number;
		UpdateConfigModels("Current Skins", "soccer_mod_skins_model_t_gk", skinsModelTGoalkeeper);

		if (!IsModelPrecached(model)) PrecacheModel(model);

		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsClientInGame(client) && IsClientConnected(client) && IsPlayerAlive(client))
			{
				int team = GetClientTeam(client);
				if (skinsIsGoalkeeper[client] && team == 2)
				{
					SetEntityModel(client, model);
					DispatchKeyValue(client, "skin", number);
				}
			}
		}

		PrintToServer("[%s] Terrorist goalkeeper model set to %s and skin number %s", prefix, model, number);
		CPrintToChatAll("{%s}[%s] {%s}Terrorist goalkeeper model set to %s and skin number %s", prefixcolor, prefix, textcolor, model, number);
	}
	else
	{
		PrintToServer("[%s] Can't set terrorist goalkeeper model to %s", prefix, model);
		CPrintToChatAll("{%s}[%s] {%s}Can't set terrorist goalkeeper model to %s", prefixcolor, prefix, textcolor, model);
	}
}