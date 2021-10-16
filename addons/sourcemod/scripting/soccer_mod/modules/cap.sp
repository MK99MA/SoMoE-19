// ************************************************************************************************************
// ************************************************** EVENTS **************************************************
// ************************************************************************************************************
public void CapOnPluginStart()
{
}

public void CapEventPlayerDeath(Event event)
{
	if (capFightStarted)
	{
		int attacker = event.GetInt("attacker");

		if (attacker == 0) CPrintToChatAll("{%s}[%s]Cap fight invalid. Please restart the fight.", prefixcolor, prefix);
		else
		{
			if (attacker)
			{
				int attackerid = GetClientOfUserId(attacker);
				capPicker = attackerid;

				int userid = event.GetInt("userid");
				int deadid = GetClientOfUserId(userid);
				int team = GetClientTeam(attackerid);

				if (team == 2)
				{
					capCT = deadid;
					capT = attackerid;
				}
				else if (team == 3)
				{
					capCT = attackerid;
					capT = deadid;
				}
			}
			
			//Check for Cap only mode in ffvote			
			if(ForfeitCapMode == 1) 
			{
				ForfeitEnabled = 1;
				ForfeitRRCheck = true;
				CPrintToChatAll("{%s}[%s]CapFight detected. Forfeit vote will be enabled for the match");
				UpdateConfigInt("Forfeit Settings", "soccer_mod_forfeitvote", ForfeitEnabled);
			}
		}
	}
}

public void CapEventRoundEnd(Event event)
{
	if (capFightStarted)
	{
		capFightStarted = false;
		
		HostName_Change_Status("Picking");
		
		//reenable sprint
		if (tempSprint)		bSPRINT_ENABLED = 1;

		int winner = event.GetInt("winner");
		if (winner == 2) 
		{
			OpenCapPickMenu(capT);
		}
		else if (winner == 3) 
		{
			OpenCapPickMenu(capCT);
		}
	}
}

// **************************************************************************************************************
// ************************************************** CAP MENU **************************************************
// **************************************************************************************************************
public void OpenCapMenu(int client)
{
	Menu menu = new Menu(CapMenuHandler);

	menu.SetTitle("Soccer - Admin - Cap");

	menu.AddItem("spec", "Put all players to spectator");

	menu.AddItem("random", "Add random player");

	menu.AddItem("start", "Start cap fight");

	if(publicmode == 0 || publicmode == 2) menu.ExitBackButton = true;
	else if(publicmode == 1) 
	{
		if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "cap")) menu.ExitBackButton = true;
		else menu.ExitBackButton = false;
	}
	menu.Display(client, MENU_TIME_FOREVER);
}

public int CapMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		if (!matchStarted)
		{
			char menuItem[32];
			menu.GetItem(choice, menuItem, sizeof(menuItem));

			if (StrEqual(menuItem, "spec"))		 CapPutAllToSpec(client);
			else if (StrEqual(menuItem, "random"))  CapAddRandomPlayer(client);
			else if (StrEqual(menuItem, "start"))
			{
				CapStartFight(client);
				if(GetClientCount() >= PWMAXPLAYERS+1 && passwordlock == 1 && pwchange == true)
				{
					CPrintToChatAll("{%s}[%s] {%s}At least %i players when the capfight started; Changing the pw...", prefixcolor, prefix, textcolor, PWMAXPLAYERS+1);
					RandPass();
				}
			}			
		}
		else CPrintToChat(client, "{%s}[%s]{%s}You can not use this option during a match", prefixcolor, prefix, textcolor);

		OpenCapMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}



// ***************************************************************************************************************
// ************************************************** PICK MENU **************************************************
// ***************************************************************************************************************
public void OpenCapPickMenu(int client)
{
	if (client)
	{
		if (client == capT || client == capCT)
		{
			if (client == capPicker)
			{
				int count;
				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player) && GetClientTeam(player) < 2 && !IsClientSourceTV(player)) count++;
				}

				if (count > 0)
				{
					capPicker = client;
					CapCreatePickMenu(client);
				}
				else CPrintToChat(client, "{%s}[%s] {%s}No players available to pick", prefixcolor, prefix, textcolor);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}It is not your turn to pick", prefixcolor, prefix, textcolor);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}You are not a cap", prefixcolor, prefix, textcolor);
	}
}

public int CapPickMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		int target = StringToInt(menuItem);
		if (IsClientInGame(target) && IsClientConnected(target))
		{
			char steamid[32];
			GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

			char targetSteamid[32];
			GetClientAuthId(target, AuthId_Engine, targetSteamid, sizeof(targetSteamid));
			capPicksLeft--;

			if (client == capCT)
			{
				int team = GetClientTeam(capCT);
				ChangeClientTeam(target, team);
				if(GetClientMenu(target) != MenuSource_None)
				{
					CancelClientMenu(target, false);
					InternalShowMenu(target, "\10", 1); 
				}

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has picked %N", prefixcolor, prefix, textcolor, client, target);
				}

				LogMessage("%N <%s> has picked %N <%s>", client, steamid, target, targetSteamid);

				capPicker = capT;
				if (capPicksLeft > 0) OpenCapPickMenu(capT);
			}
			else if (client == capT)
			{
				int team = GetClientTeam(capT);
				ChangeClientTeam(target, team);
				if(GetClientMenu(target) != MenuSource_None)
				{
					CancelClientMenu(target, false);
					InternalShowMenu(target, "\10", 1); 
				}

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has picked %N", prefixcolor, prefix, textcolor, client, target);
				}

				LogMessage("%N <%s> has picked %N <%s>", client, steamid, target, targetSteamid);

				capPicker = capCT;
				if (capPicksLeft > 0) OpenCapPickMenu(capCT);
			}
		}
		else
		{
			CPrintToChat(client, "{%s}[%s] {%s}Player is no longer on the server", prefixcolor, prefix, textcolor);

			if (client == capCT) OpenCapPickMenu(capCT);
			else if (client == capT) OpenCapPickMenu(capT);
		}
	}
	else if (action == MenuAction_End) menu.Close();
}

// *******************************************************************************************************************
// ************************************************** POSITION MENU **************************************************
// *******************************************************************************************************************
public void OpenCapPositionMenu(int client)
{
	KeyValues keygroup = new KeyValues("capPositions");
	keygroup.ImportFromFile(pathCapPositionsFile);
	char langString[64], langString1[64], langString2[64];
	char steamid[32];
	GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
	keygroup.JumpToKey(steamid, true);

	Menu menu = new Menu(CapPositionMenuHandler);

	menu.SetTitle("Soccer Mod - Cap - Positions");

	int keyValue = keygroup.GetNum("gk", 0);
	Format(langString1, sizeof(langString1), "Goalkeeper", client);
	if (keyValue) Format(langString2, sizeof(langString2), "Yes", client);
	else Format(langString2, sizeof(langString2), "No", client);
	Format(langString, sizeof(langString), "%s: %s", langString1, langString2);
	menu.AddItem("gk", langString);

	keyValue = keygroup.GetNum("lb", 0);
	Format(langString1, sizeof(langString1), "Left back", client);
	if (keyValue) Format(langString2, sizeof(langString2), "Yes", client);
	else Format(langString2, sizeof(langString2), "No", client);
	Format(langString, sizeof(langString), "%s: %s", langString1, langString2);
	menu.AddItem("lb", langString);

	keyValue = keygroup.GetNum("rb", 0);
	Format(langString1, sizeof(langString1), "Right back", client);
	if (keyValue) Format(langString2, sizeof(langString2), "Yes", client);
	else Format(langString2, sizeof(langString2), "No", client);
	Format(langString, sizeof(langString), "%s: %s", langString1, langString2);
	menu.AddItem("rb", langString);

	keyValue = keygroup.GetNum("mf", 0);
	Format(langString1, sizeof(langString1), "Midfielder", client);
	if (keyValue) Format(langString2, sizeof(langString2), "Yes", client);
	else Format(langString2, sizeof(langString2), "No", client);
	Format(langString, sizeof(langString), "%s: %s", langString1, langString2);
	menu.AddItem("mf", langString);

	keyValue = keygroup.GetNum("lw", 0);
	Format(langString1, sizeof(langString1), "Left wing", client);
	if (keyValue) Format(langString2, sizeof(langString2), "Yes", client);
	else Format(langString2, sizeof(langString2), "No", client);
	Format(langString, sizeof(langString), "%s: %s", langString1, langString2);
	menu.AddItem("lw", langString);

	keyValue = keygroup.GetNum("rw", 0);
	Format(langString1, sizeof(langString1), "Right wing", client);
	if (keyValue) Format(langString2, sizeof(langString2), "Yes", client);
	else Format(langString2, sizeof(langString2), "No", client);
	Format(langString, sizeof(langString), "%s: %s", langString1, langString2);
	menu.AddItem("rw", langString);

	keyValue = keygroup.GetNum("spec", 0);
	Format(langString1, sizeof(langString1), "Spec only", client);
	if (keyValue) Format(langString2, sizeof(langString2), "Yes", client);
	else Format(langString2, sizeof(langString2), "No", client);
	Format(langString, sizeof(langString), "%s: %s", langString1, langString2);
	menu.AddItem("spec", langString);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);

	keygroup.Close();
}

public int CapPositionMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

		KeyValues keygroup = new KeyValues("capPositions");
		keygroup.ImportFromFile(pathCapPositionsFile);

		keygroup.JumpToKey(steamid, true);

		int keyValue = keygroup.GetNum(menuItem, 0);
		if (keyValue) keygroup.SetNum(menuItem, 0);
		else keygroup.SetNum(menuItem, 1);

		keygroup.Rewind();
		keygroup.ExportToFile(pathCapPositionsFile);
		keygroup.Close();

		OpenCapPositionMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSoccer(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ************************************************************************************************************
// ************************************************** TIMERS **************************************************
// ************************************************************************************************************
public Action TimerCapFightCountDown(Handle timer, any seconds)
{
	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player)) PrintCenterText(player, "Cap fight will start in %i seconds", seconds);
	}
}

public Action TimerCapFightCountDownEnd(Handle timer)
{
	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player))
		{
			PrintCenterText(player, "[%s] FIGHT!", prefix);
			if (GetClientTeam(player) > 1  && IsPlayerAlive(player)) 
			{
				SetEntProp(player, Prop_Data, "m_takedamage", 2, 1);
				//Set Armor to 0 and cancel Timer
				SetEntProp(player, Prop_Send, "m_iHealth", 101)
				SetEntProp(player, Prop_Send, "m_ArmorValue", 0.0);
			}
		}
	}

	UnfreezeAll();
}

// ***************************************************************************************************************
// ************************************************** FUNCTIONS **************************************************
// ***************************************************************************************************************
public void CapPutAllToSpec(int client)
{
	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player))
		{
			CPrintToChat(player, "{%s}[%s] {%s}%N has put all players to spectator", prefixcolor, prefix, textcolor, client);
			if (GetClientTeam(player) != 1) ChangeClientTeam(player, 1);
		}
	}
	
	HostName_Change_Status("Specced");

	char steamid[32];
	GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
	LogMessage("%N <%s> has put all players to spectator", client, steamid);
}

public void CapAddRandomPlayer(int client)
{
	int players[32], count;
	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player) && GetClientTeam(player) < 2 && !IsClientSourceTV(player))
		{
			players[count] = player;
			count++;
		}
	}

	if (count)
	{
		int randomPlayer = players[GetRandomInt(0, count - 1)];
		if (GetTeamClientCount(2) < GetTeamClientCount(3)) ChangeClientTeam(randomPlayer, 2);
		else ChangeClientTeam(randomPlayer, 3);

		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has forced %N as random player", prefixcolor, prefix, textcolor, client, randomPlayer);
		}

		char steamid[32], targetSteamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		GetClientAuthId(client, AuthId_Engine, targetSteamid, sizeof(targetSteamid));
		LogMessage("%N <%s> has forced %N <%s> as random player", client, steamid, randomPlayer, targetSteamid);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}No players in spectator", prefixcolor, prefix, textcolor);
}

public void CapStartFight(int client)
{
	if (!capFightStarted)
	{
		if(passwordlock == 1)
		{
			pwchange = true;
			CPrintToChatAll("{%s}[%s] {%s}AFK Kick enabled.", prefixcolor, prefix, textcolor);
			AFKKick();
		}
		
		if(bSPRINT_ENABLED == 1)
		{
			bSPRINT_ENABLED = 0;
			tempSprint = true;
		}
		else tempSprint = false;
		
		capFightStarted = true;
		capPicksLeft = (matchMaxPlayers - 1) * 2;
		
		bool noPos[MAXPLAYERS+1] = false;
		int posnr[MAXPLAYERS+1];
		
		CreateTimer(0.0, TimerCapFightCountDown, 3);
		CreateTimer(1.0, TimerCapFightCountDown, 2);
		CreateTimer(2.0, TimerCapFightCountDown, 1);
		CreateTimer(3.0, TimerCapFightCountDownEnd);

		KeyValues keygroup = new KeyValues("capPositions");
		keygroup.ImportFromFile(pathCapPositionsFile);

		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player))
			{
				char playerSteamid[32];
				GetClientAuthId(player, AuthId_Engine, playerSteamid, sizeof(playerSteamid));
				
				if (GetClientTeam(player) > 1  && IsPlayerAlive(player)) SetEntityMoveType(player, MOVETYPE_NONE);
				else
				{
					noPos[player] = false;
					
					
					keygroup.JumpToKey(playerSteamid, true);

					int gk = keygroup.GetNum("gk", 0);
					int lb = keygroup.GetNum("lb", 0);
					int rb = keygroup.GetNum("rb", 0);
					int mf = keygroup.GetNum("mf", 0);
					int lw = keygroup.GetNum("lw", 0);
					int rw = keygroup.GetNum("rw", 0);
					int spec = keygroup.GetNum("spec", 0);

					if (spec == 1 || (!gk && !lb && !rb && !mf && !lw && !rw))
					{
						noPos[player] = true; // array + clear array function
					}
				}
				
				posnr[player] = ImportJoinNumber(playerSteamid)
			}
		}
		
		

		keygroup.Close();

		for (int player = 1; player <= MaxClients; player++)
		{
			if (noPos[client] == true) 
			{
				CPrintToChat(client, "{%s}[%s] {%s}Please set your position to help the caps with picking", prefixcolor, prefix, textcolor);
				OpenCapPositionMenu(client);
			}
			
			if (IsClientInGame(player) && IsClientConnected(player)) 
			{
				//PrintToServer("%N : %i", player, posnr[player]); 
				CPrintToChat(player, "{%s}[%s] {%s}%N has started a cap fight", prefixcolor, prefix, textcolor, client);
				CPrintToChat(player, "{%s}[%s] {%s}You joined this cap on position number {%s}%i.", prefixcolor, prefix, textcolor, prefixcolor, posnr[player]);
			}
		}

		HostName_Change_Status("Capfight");

		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		LogMessage("%N <%s> has started a cap fight", client, steamid);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Cap fight already started", prefixcolor, prefix, textcolor);
}

public void CapCreatePickMenu(int client)
{
	Menu menu = new Menu(CapPickMenuHandler);

	menu.SetTitle("[Join Nr] Name [Positions]");

	KeyValues keygroup = new KeyValues("capPositions");
	keygroup.ImportFromFile(pathCapPositionsFile);

	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player) && !IsFakeClient(player) && !IsClientSourceTV(player))
		{
			int team = GetClientTeam(player);
			if (team < 2)
			{
				char playerid[4];
				IntToString(player, playerid, sizeof(playerid));

				char playerName[MAX_NAME_LENGTH];
				GetClientName(player, playerName, sizeof(playerName));

				char steamid[32];
				GetClientAuthId(player, AuthId_Engine, steamid, sizeof(steamid));
				keygroup.JumpToKey(steamid, true);

				char positions[32] = "";
				if (keygroup.GetNum("gk", 0)) Format(positions, sizeof(positions), "%s[GK]", positions);
				if (keygroup.GetNum("lb", 0)) Format(positions, sizeof(positions), "%s[LB]", positions);
				if (keygroup.GetNum("rb", 0)) Format(positions, sizeof(positions), "%s[RB]", positions);
				if (keygroup.GetNum("mf", 0)) Format(positions, sizeof(positions), "%s[MF]", positions);
				if (keygroup.GetNum("lw", 0)) Format(positions, sizeof(positions), "%s[LW]", positions);
				if (keygroup.GetNum("rw", 0)) Format(positions, sizeof(positions), "%s[RW]", positions);
				if (keygroup.GetNum("spec", 0)) Format(positions, sizeof(positions), "[SPEC ONLY]");

				int posnr = ImportJoinNumber(steamid);

				char menuString[64];
				if (positions[0]) Format(menuString, sizeof(menuString), "[%i] %s %s", posnr, playerName, positions);
				else Format(menuString, sizeof(menuString), "[%i] %s", posnr, playerName);
				//menuString = playerName;
				menu.AddItem(playerid, menuString);
				keygroup.Rewind();
			}
		}
	}

	delete keygroup;

	menu.Display(client, MENU_TIME_FOREVER);
}

public int ImportJoinNumber(char steamid[32])
{
	int nr = 0;
	int entries = 0;
	char buffer[32];
	
	if (kvConnectlist.GotoFirstSubKey())
	{
		entries++;
		while (kvConnectlist.GotoNextKey())
		{
			entries++;
		}
	}
	kvConnectlist.Rewind();
	
	kvConnectlist.GotoFirstSubKey();
	kvConnectlist.SavePosition();
	
	for (int i = 1; i <= entries; i++)
	{
		kvConnectlist.GetSectionName(buffer, sizeof(buffer));
		
		if(bIsOnServer(buffer))	nr++;
		
		kvConnectlist.GotoNextKey();
		kvConnectlist.SavePosition();
		
		if (StrEqual(buffer, steamid)) 
		{
			kvConnectlist.Rewind();
			return nr; 
		}
	}
	kvConnectlist.Rewind();
	
	return 0;
}