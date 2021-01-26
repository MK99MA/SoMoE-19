// *****************************************************************************************************************
// ************************************************** SOCCER MENU **************************************************
// *****************************************************************************************************************
public void OpenMenuSoccer(int client)
{
	Menu menu = new Menu(MenuHandlerSoccer);
	menu.SetTitle("Soccer Mod");
	SetMenuPagination(menu, MENU_NO_PAGINATION);
	SetMenuExitButton(menu, true);

	Handle shoutplugin = FindPluginByFile("shout.smx");	

	if(publicmode == 0)
	{
		if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "menu"))
		{
			menu.AddItem("admin", "Admin");
		}
	}
	else if(publicmode == 2 || publicmode == 1)
	{
			menu.AddItem("admin", "Admin");		
	}

	menu.AddItem("ranking", "Ranking");

	menu.AddItem("stats", "Statistics");

	menu.AddItem("positions", "Positions");

	menu.AddItem("help", "Help");
	
	menu.AddItem("sprintinfo", "Sprintsettings");
	
	if (shoutplugin != INVALID_HANDLE)
	{
		menu.AddItem("shout", "Shouts");
	}

	menu.AddItem("credits", "Credits");

	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerSoccer(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "admin"))
		{
			if(publicmode == 0 )
			{
				if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "menu"))
				{
					OpenMenuAdmin(client);
				}
				else CPrintToChat(client, "Access denied");
			}
			else if(publicmode == 2 || publicmode == 1)
			{
				OpenMenuAdmin(client);	  
			}
		}
		else if (StrEqual(menuItem, "help"))		OpenMenuHelp(client);
		else if (StrEqual(menuItem, "credits"))	 	OpenMenuCredits(client);
		else if (StrEqual(menuItem, "sprintinfo"))  OpenInfoPanel(client); //FakeClientCommandEx(client, "sm_sprintinfo");
		else if (StrEqual(menuItem, "shout"))		FakeClientCommandEx(client, "sm_shout");
		else if (currentMapAllowed)
		{
			if (StrEqual(menuItem, "positions"))	OpenCapPositionMenu(client);
			else if (StrEqual(menuItem, "ranking")) OpenRankingMenu(client);
			else if (StrEqual(menuItem, "stats"))   OpenStatisticsMenu(client);
		}
		else
		{
			CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
			OpenMenuSoccer(client);
		}
	}
	else if (action == MenuAction_End) menu.Close();
}

// ****************************************************************************************************************
// ************************************************** ADMIN MENU **************************************************
// ****************************************************************************************************************
public void OpenMenuAdmin(int client)
{
	Menu menu = new Menu(MenuHandlerAdmin);

	menu.SetTitle("Soccer Mod - Admin");
	
	if(publicmode == 1 && !(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)))
	{
		menu.AddItem("match", "Match");

		menu.AddItem("cap", "Cap");
		
		menu.AddItem("referee", "Referee");
		
		if(IsSoccerAdmin(client, "training")) 	menu.AddItem("training", "Training");
		if(IsSoccerAdmin(client, "spec")) 		menu.AddItem("spec", "Spec Player");
		
		menu.AddItem("change", "Change Map");
	}
	else
	{
		if((CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) || IsSoccerAdmin(client, "match") || (publicmode == 2)) 		menu.AddItem("match", "Match");
		else 									menu.AddItem("match", "Match", ITEMDRAW_DISABLED);

		if((CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) || IsSoccerAdmin(client, "cap") || (publicmode == 2)) 		menu.AddItem("cap", "Cap");
		else									menu.AddItem("cap", "Cap", ITEMDRAW_DISABLED);
		
		if((CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) || IsSoccerAdmin(client, "referee") || (publicmode == 2))	menu.AddItem("referee", "Referee");
		else									menu.AddItem("referee", "Referee", ITEMDRAW_DISABLED);

		if((CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) || IsSoccerAdmin(client, "training") || (publicmode == 2))	menu.AddItem("training", "Training");
		else									menu.AddItem("training", "Training", ITEMDRAW_DISABLED);

		if((CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) || IsSoccerAdmin(client, "spec") || (publicmode == 2))		menu.AddItem("spec", "Spec Player");
		else									menu.AddItem("spec", "Spec Player", ITEMDRAW_DISABLED);

		if((CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) || IsSoccerAdmin(client, "mapchange") || (publicmode == 2))	menu.AddItem("change", "Change Map");	
		else 									menu.AddItem("change", "Change Map", ITEMDRAW_DISABLED);	

		if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC))
		{
			menu.AddItem("settings", "Settings");
		}
	}

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAdmin(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "settings"))
		{
			if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) OpenMenuSettings(client);
		}
		else if (StrEqual(menuItem, "spec"))				OpenMenuSpecPlayer(client);
		else if (StrEqual(menuItem, "change")) 
			{
				if (!matchStarted)
				{
					OpenMenuMapsChange(client);
				}
				else
				{
					CPrintToChat(client, "{%s}[%s] {%s}You can not use this option during a match", prefixcolor, prefix, textcolor);
					OpenMenuAdmin(client);
				}
			}
		else if (currentMapAllowed)
		{
			if (StrEqual(menuItem, "match"))				OpenMatchMenu(client);
			else if (StrEqual(menuItem, "cap"))			 OpenCapMenu(client);
			else if (StrEqual(menuItem, "referee"))		 OpenRefereeMenu(client);
			else if (StrEqual(menuItem, "training"))		OpenTrainingMenu(client);
		}
		else
		{
			CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
			OpenMenuAdmin(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSoccer(client);
	else if (action == MenuAction_End)					  menu.Close();
}



// **********************************************************************************************************************
// ************************************************** SPEC PLAYER MENU **************************************************
// **********************************************************************************************************************
public void OpenMenuSpecPlayer(int client)
{
	Menu menu = new Menu(MenuHandlerSpecPlayer);

	menu.SetTitle("Soccer Mod - Admin - Spec player");

	int number = 0;
	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player) && GetClientTeam(player) != 1)
		{
			number++;

			char playerid[8];
			IntToString(player, playerid, sizeof(playerid));

			char playerName[MAX_NAME_LENGTH];
			GetClientName(player, playerName, sizeof(playerName));

			menu.AddItem(playerid, playerName);
		}
	}

	if (number)
	{
		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		CPrintToChat(client, "{%s}[%s] {%s}All players already are in spectator", prefixcolor, prefix, textcolor);
		OpenMenuAdmin(client);
	}
}

public int MenuHandlerSpecPlayer(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[8];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		int target = StringToInt(menuItem);

		if (IsClientInGame(target) && IsClientConnected(target))
		{
			if (GetClientTeam(target) != 1)
			{
				ChangeClientTeam(target, 1);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has put %N to spectator", prefixcolor, prefix, textcolor, client, target);
				}

				char clientSteamid[32];
				GetClientAuthId(client, AuthId_Engine, clientSteamid, sizeof(clientSteamid));

				char targetSteamid[32];
				GetClientAuthId(target, AuthId_Engine, targetSteamid, sizeof(targetSteamid));

				LogMessage("%N <%s> has put %N <%s> to spectator", client, clientSteamid, target, targetSteamid);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}Player is already in spectator", prefixcolor, prefix, textcolor);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}Player is no longer on the server", prefixcolor, prefix, textcolor);

		OpenMenuAdmin(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}



// *********************************************************************************************************************
// ************************************************** CHANGE MAP MENU **************************************************
// *********************************************************************************************************************
public void OpenMenuMapsChange(int client)
{
	File file = OpenFile(allowedMapsConfigFile, "r");

	if (file != null)
	{
		Menu menu = new Menu(MenuHandlerMapsChange);

		menu.SetTitle("Soccer Mod - Admin - Change Map");

		char map[128];
		int length;

		while (!file.EndOfFile() && file.ReadLine(map, sizeof(map)))
		{
			length = strlen(map);
			if (map[length - 1] == '\n') map[--length] = '\0';

			if (map[0] != '/' && map[1] != '/' && map[0] && IsMapValid(map)) menu.AddItem(map, map);
		}

		file.Close();
		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		CPrintToChat(client, "{%s}[%s] {%s}Allowed maps list is empty", prefixcolor, prefix, textcolor);
		OpenMenuAdmin(client);
	}
}

public int MenuHandlerMapsChange(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char map[128];
		menu.GetItem(choice, map, sizeof(map));

		char command[128];
		Format(command, sizeof(command), "changelevel %s", map);

		Handle pack;
		CreateDataTimer(3.0, DelayedServerCommand, pack);
		WritePackString(pack, command);

		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has changed the map to %s", prefixcolor, prefix, textcolor, client, map);
			if(GetClientMenu(player) != MenuSource_None )	
			{
				CancelClientMenu(player,false);
				InternalShowMenu(player, "\10", 1); 
			}
		}

		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		LogMessage("%N <%s> has changed the map to %s", client, steamid, map);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}


// ***************************************************************************************************************
// ************************************************** HELP MENU **************************************************
// ***************************************************************************************************************
public void OpenMenuHelp(int client)
{
	Menu menu = new Menu(MenuHandlerHelp);

	menu.SetTitle("Soccer Mod - Help");

	menu.AddItem("commands", "Chat Commands");

	//Format(langString, sizeof(langString), "%T", "bind <key> say !sprint or +use key (default E) to sprint", client);
	menu.AddItem("sprint","bind <key> say !sprint or +use key (default E) to sprint", ITEMDRAW_DISABLED);

	menu.AddItem("guide", "Guide");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerHelp(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "commands"))				 OpenMenuCommands(client);
		else if (StrEqual(menuItem, "sprint"))			  OpenMenuHelp(client);
		else if (StrEqual(menuItem, "guide"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}http://steamcommunity.com/sharedfiles/filedetails/?id=267151106", prefixcolor, prefix, textcolor);
			OpenMenuHelp(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSoccer(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuCommands(int client)
{
	Menu menu = new Menu(MenuHandlerCommands);

	menu.SetTitle("Soccer Mod - Help - Chat Commands");

	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "menu")) menu.AddItem("admincom", "Admin Commands");	
	menu.AddItem("menu", "!menu");
	menu.AddItem("gk", "!gk");
	menu.AddItem("cap", "!cap");
	menu.AddItem("match", "!match");
	menu.AddItem("start", "!start");
	menu.AddItem("pause", "!pause, !p");
	menu.AddItem("matchrr", "!matchrr");
	menu.AddItem("unpause", "!unpause, !unp");
	menu.AddItem("stop", "!stop");
	menu.AddItem("rdy", "!rdy");
	menu.AddItem("maprr", "!maprr");
	menu.AddItem("training", "!training");
	menu.AddItem("pick", "!pick");
	menu.AddItem("commands", "!commands");
	menu.AddItem("admin", "!madmin");
	menu.AddItem("ref", "!ref");
	menu.AddItem("stats", "!stats");
	menu.AddItem("rank", "!rank");
	menu.AddItem("prank", "!prank");
	menu.AddItem("adminlist", "!admins");
	menu.AddItem("lc", "!lc");
	menu.AddItem("help", "!help");
	menu.AddItem("credits", "!credits");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerCommands(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "menu"))				CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer Mod main menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "help"))		CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer Mod help menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "stats"))		CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer Mod statistics menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "rank"))		CPrintToChat(client, "{%s}[%s] {%s}Shows your match ranking", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "prank"))		CPrintToChat(client, "{%s}[%s] {%s}Shows your public ranking", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "gk"))		  	CPrintToChat(client, "{%s}[%s] {%s}Enables or disables the goalkeeper skin", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "pick"))		CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer Mod cap picking menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "admin"))		CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer Mod admin menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "cap"))		 	CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer Mod cap match menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "maprr"))		CPrintToChat(client, "{%s}[%s] {%s}Reload the current map", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "match"))		CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer Mod match menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "matchrr"))		CPrintToChat(client, "{%s}[%s] {%s}Restart the match", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "training"))	CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer Mod training menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "ref"))			CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer Mod referee menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "commands"))	CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer Mod commands menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "credits")) 	CPrintToChat(client, "{%s}[%s] {%s}Opens the Soccer Mod credits menu", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "start"))		CPrintToChat(client, "{%s}[%s] {%s}Start a Match", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "pause"))		CPrintToChat(client, "{%s}[%s] {%s}Pause a Match", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "unpause"))		CPrintToChat(client, "{%s}[%s] {%s}Unpause a Match", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "stop"))		CPrintToChat(client, "{%s}[%s] {%s}Stop a Match", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "rdy"))			CPrintToChat(client, "{%s}[%s] {%s}Bring back the ready menu if you closed it by accident", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "lc"))			CPrintToChat(client, "{%s}[%s] {%s}Opens the last connected panel", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "adminlist"))	
		{
			if(publicmode == 2)						CPrintToChat(client, "{%s}[%s] {%s}Publicmode is set to everyone. Try using !menu yourself", prefixcolor, prefix, textcolor);
			else 									CPrintToChat(client, "{%s}[%s] {%s}Shows the current online admins", prefixcolor, prefix, textcolor);
		}
		else if (StrEqual(menuItem, "admincom"))
		{
			OpenMenuCommandsAdmin(client);
		}
		if (!StrEqual(menuItem, "admincom")) 		OpenMenuCommands(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuHelp(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuCommandsAdmin(int client)
{
	Menu menu = new Menu(MenuHandlerCommandsAdmin);

	menu.SetTitle("Soccer Mod - Help - Admin Commands");

	menu.AddItem("admin", "!madmin");
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true)) menu.AddItem("addadmin", "[RCON] !addadmin <SteamID>");
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "match")) menu.AddItem("rr", "[GENERIC / MATCH] !rr");
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) menu.AddItem("settingscmd", "[GENERIC] !soccerset");
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true)) menu.AddItem("forcerdycmd", "[RCON] !forcerdy");	
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true)) menu.AddItem("forceunpcmd", "[RCON] !forceunp");		
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true)) menu.AddItem("dpasswordcmd", "[RCON] !dpass");		
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true)) menu.AddItem("passwordcmd", "[RCON] !pass <PW>");
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true)) menu.AddItem("rpasswordcmd", "[RCON] !rpass");
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true)) menu.AddItem("rankwipe", "[RCON] !wiperanks <table> ");		

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerCommandsAdmin(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "rr"))		  CPrintToChat(client, "{%s}[%s] {%s}Restart the current round", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "dpasswordcmd")) CPrintToChat(client, "{%s}[%s] {%s}Manually reset to password to default / previous one", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "passwordcmd")) CPrintToChat(client, "{%s}[%s] {%s}Print the current password to console or change it", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "rpasswordcmd")) CPrintToChat(client, "{%s}[%s] {%s}Manually set a random password", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "addadmin"))	CPrintToChat(client, "{%s}[%s] {%s}!addadmin <SteamId>: Add the Steamid to soccermod admins.", prefixcolor, prefix, textcolor);	
		else if (StrEqual(menuItem, "forcerdycmd"))	CPrintToChat(client, "{%s}[%s] {%s}Forces the state of everyone to ready during a readycheck.", prefixcolor, prefix, textcolor);	
		else if (StrEqual(menuItem, "forceunpcmd"))	CPrintToChat(client, "{%s}[%s] {%s}Forces the match to unpause in case of a readycheck.", prefixcolor, prefix, textcolor);	
		else if (StrEqual(menuItem, "settingscmd"))	CPrintToChat(client, "{%s}[%s] {%s}Opens the settings menu.", prefixcolor, prefix, textcolor);	
		else if (StrEqual(menuItem, "rankwipe"))	CPrintToChat(client, "{%s}[%s] {%s}Wipes the given ranking table. {%s}THIS IS NOT REVERSIBLE!!", prefixcolor, prefix, textcolor, "crimson");	

		OpenMenuCommands(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuCommands(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ******************************************************************************************************************
// ************************************************** CREDITS MENU **************************************************
// ******************************************************************************************************************
public void OpenMenuCredits(int client)
{
	Menu menu = new Menu(MenuHandlerCredits);

	menu.SetTitle("Soccer Mod - Credits");

	menu.AddItem("marco", "Marco Boogers (Script)");
	
	menu.AddItem("arturo", "Arturo (Script edits)");

	menu.AddItem("termi", "Termiii (Player models)");

	menu.AddItem("walmar", "Walmar (Shortsprint)");
	
	menu.AddItem("group", "Soccer Mod group");
	char version[32]
	Format(version, sizeof(version), "Soccer Mod version: %s", PLUGIN_VERSION);
	menu.AddItem("group", version, ITEMDRAW_DISABLED);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerCredits(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "marco"))		CPrintToChat(client, "{%s}[%s] {%s}http://steamcommunity.com/id/fcd_marco/", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "arturo"))	CPrintToChat(client, "{%s}[%s] {%s}https://github.com/MK99MA/soccermod-2019edit", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "termi"))   CPrintToChat(client, "{%s}[%s] {%s}https://steamcommunity.com/id/Termiii/", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "walmar"))  CPrintToChat(client, "{%s}[%s] {%s}(c) 2009-2013 walmar - walmar.postbox@gmail.com - http://github.com/walmar", prefixcolor, prefix, textcolor);
		else if (StrEqual(menuItem, "group"))   CPrintToChat(client, "{%s}[%s] {%s}http://steamcommunity.com/groups/soccer_mod", prefixcolor, prefix, textcolor);

		OpenMenuCredits(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSoccer(client);
	else if (action == MenuAction_End)					  menu.Close();
}
