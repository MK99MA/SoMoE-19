// *********************************************************************************************************************
// ************************************************** CLIENT COMMANDS **************************************************
// ********************************************************************************************************************* 
public void ClientCommandPublicRanking(int client)
{
	char query[256] = "SELECT soccer_mod_players.steamid, points, rounds_won, rounds_lost FROM soccer_mod_players, soccer_mod_public_stats \
		WHERE soccer_mod_players.steamid = soccer_mod_public_stats.steamid AND hits > 0 ORDER BY points/(rounds_won + rounds_lost) desc";
	SQL_TQuery(db, ClientCommandPublicRankingCallback, query, client);
}

public void ClientCommandMatchRanking(int client)
{
	char query[256] = "SELECT soccer_mod_players.steamid, points, rounds_won, rounds_lost, matches FROM soccer_mod_players, soccer_mod_match_stats \
		WHERE soccer_mod_players.steamid = soccer_mod_match_stats.steamid AND hits > 0 ORDER BY points/matches desc";
	SQL_TQuery(db, ClientCommandMatchRankingCallback, query, client);
}

public void ClientCommandPublicRankingCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	int total;
	total = SQL_GetRowCount(hndl);

	if (hndl == INVALID_HANDLE)
	{
		LogError("Failed to query (error: %s)", error);
		CPrintToChat(client, "{%s}[%s] {%s}You are not ranked yet.", prefixcolor, prefix, textcolor);
	}
	else if (total)
	{
		char clientSteamid[32];
		GetClientAuthId(client, AuthId_Engine, clientSteamid, sizeof(clientSteamid));

		char steamid[32];
		int rank;
		int points;
		int rounds;
		while (SQL_FetchRow(hndl))
		{
			rank++;
			SQL_FetchString(hndl, 0, steamid, sizeof(steamid));
			points = SQL_FetchInt(hndl, 1);
			rounds = SQL_FetchInt(hndl, 2) + SQL_FetchInt(hndl, 3);
			if (StrEqual(clientSteamid, steamid)) break;
		}

		if (rankMode < 2)	points = points / rounds;

		for (int player = 1; player <= MaxClients; player++)
		{
			
			if (IsClientInGame(player) && IsClientConnected(player))
			{
				if(rankMode < 2) CPrintToChat(player, "{%s}[%s] {%s}%N is ranked %i with average %i points per round in the public rankings.", prefixcolor, prefix, textcolor, client, rank, points);
				else CPrintToChat(player, "{%s}[%s] {%s}%N is ranked %i with %i points in the public rankings.", prefixcolor, prefix, textcolor, client, rank, points);
			}
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}You are not ranked yet.", prefixcolor, prefix, textcolor);
}

public void ClientCommandMatchRankingCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	int total;
	total = SQL_GetRowCount(hndl);

	if (hndl == INVALID_HANDLE)
	{
		LogError("Failed to query (error: %s)", error);
		CPrintToChat(client, "{%s}[%s] {%s}You are not ranked yet.", prefixcolor, prefix, textcolor);
	}
	else if (total)
	{
		char clientSteamid[32];
		GetClientAuthId(client, AuthId_Engine, clientSteamid, sizeof(clientSteamid));

		char steamid[32];
		int rank;
		int points;
		int rounds;
		int matches;
		while (SQL_FetchRow(hndl))
		{
			rank++;
			SQL_FetchString(hndl, 0, steamid, sizeof(steamid));
			points = SQL_FetchInt(hndl, 1);
			rounds = SQL_FetchInt(hndl, 2) + SQL_FetchInt(hndl, 3);
			matches = SQL_FetchInt(hndl, 4);
			
			if (StrEqual(clientSteamid, steamid)) break;
		}
		
		if (rankMode == 0) points = points / matches;
		else if (rankMode == 1) points = points / rounds;
		
		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) 
			{
				if (rankMode == 0)CPrintToChat(player, "{%s}[%s] {%s}%N is ranked %i with average %i points per match in the match rankings.", prefixcolor, prefix, textcolor, client, rank, points);
				else if (rankMode == 1)CPrintToChat(player, "{%s}[%s] {%s}%N is ranked %i with average %i points per round in the match rankings.", prefixcolor, prefix, textcolor, client, rank, points);
				else if (rankMode == 2)CPrintToChat(player, "{%s}[%s] {%s}%N is ranked %i with %i points  in the match rankings.", prefixcolor, prefix, textcolor, client, rank, points);
			}
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}You are not ranked yet.", prefixcolor, prefix, textcolor);
}

public void ResetStats(int client, char[] table)
{
	char steamid[32];
	GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
	
	char query[1024];
	Format(query, sizeof(query), "UPDATE soccer_mod_%s_stats SET goals = 0, assists = 0, own_goals = 0, hits = 0, passes = 0, interceptions = 0, ball_losses = 0, saves = 0, rounds_lost = 0, rounds_won = 0, points = 0, mvp = 0, motm = 0, matches = 0 WHERE soccer_mod_%s_stats.steamid = '%s'", table, table, steamid);
	
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, table);
	
	SQL_TQuery(db, ClientResetRankingCallback, query, pack);
}

public void ClientResetRankingCallback(Handle owner, Handle hndl, const char[] error, any pack)
{
	ResetPack(pack);
	int client = ReadPackCell(pack);
	char steamid[32];
	GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

	if (hndl == INVALID_HANDLE)
	{
		LogError("Failed to query (error: %s)", error);
		CPrintToChat(client, "{%s}[%s] {%s}You are not ranked yet.", prefixcolor, prefix, textcolor);
		OpenRankingMenu(client);
	}
	else
	{
		char type[64], queryString[512];
		ReadPackString(pack, type, sizeof(type));
		CPrintToChat(client, "{%s}[%s] {%s}Your %s ranking has been reset.", prefixcolor, prefix, textcolor, type);
		Format(queryString, sizeof(queryString), "INSERT INTO soccer_mod_%s_stats (steamid) VALUES ('%s')", type, steamid);
		ExecuteQuery(queryString);
		/*Format(queryString, sizeof(queryString), "INSERT INTO soccer_mod_public_stats (steamid) VALUES ('%s')", type, steamid);
		ExecuteQuery(queryString);*/
		OpenRankingMenu(client);
	}
}

// ******************************************************************************************************************
// ************************************************** RANKING MENU **************************************************
// ******************************************************************************************************************
public void OpenRankingMenu(int client)
{
	Menu menu = new Menu(RankingMenuHandler);
	
	menu.SetTitle("Soccer Mod - Ranking");
	
	if (rankMode == 0) 
	{
		menu.AddItem("match_top", "Top 50 per match avg");
		
		menu.AddItem("public_top", "Public top 50 per round avg");
	}	
	else if (rankMode == 1) 
	{
		menu.AddItem("match_top", "Match top 50 per round avg");
		
		menu.AddItem("public_top", "Public top 50 per round avg");
	}
	else if (rankMode == 2) 
	{
		menu.AddItem("match_top", "Match top 50");
		
		menu.AddItem("public_top", "Public Top 50");
	}

	menu.AddItem("match_personal", "Match Personal");

	menu.AddItem("public_personal", "Public Personal");
	
	menu.AddItem("last_connected", "Last Connected");
	
	menu.AddItem("reset_rank", "Reset Rank");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int RankingMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "match_top"))				OpenRankingTopMenu(client, "match");
		else if (StrEqual(menuItem, "public_top"))		  OpenRankingTopMenu(client, "public");
		else if (StrEqual(menuItem, "match_personal"))	  OpenRankingPersonalMenu(client, "match");
		else if (StrEqual(menuItem, "public_personal"))	 OpenRankingPersonalMenu(client, "public");
		else if (StrEqual(menuItem, "last_connected"))	  OpenRankingLastConnectedMenu(client);
		else if (StrEqual(menuItem, "reset_rank"))			OpenRankingResetMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSoccer(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ******************************************************************************************************************
// ************************************************** RESETRANK MENU **************************************************
// ******************************************************************************************************************
public void OpenRankingResetMenu(int client)
{
	Menu menu = new Menu(RankingResetMenuHandler);

	menu.SetTitle("Soccer Mod - Ranking - Reset Ranks");
	
	menu.AddItem("info", "ATTENTION! Choosing any of the following 2", ITEMDRAW_DISABLED);
	menu.AddItem("info", "options will instantly reset the chosen rank.", ITEMDRAW_DISABLED);

	menu.AddItem("match_reset", "Reset Match Ranking");

	menu.AddItem("public_reset", "Reset Public Ranking");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int RankingResetMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "match_reset"))					ResetStats(client, "match");
		else if (StrEqual(menuItem, "public_reset"))		  	ResetStats(client, "public");
	}
	else if (action == MenuAction_Cancel && choice == -6)   	OpenRankingMenu(client);
	else if (action == MenuAction_End)					  		menu.Close();
}


// **********************************************************************************************************************
// ************************************************** RANKING TOP MENU **************************************************
// **********************************************************************************************************************
public void OpenRankingTopMenu(int client, char type[8])
{
	char query[512];
	if (rankMode == 0 && StrEqual(type, "match")) Format(query, sizeof(query), "SELECT soccer_mod_players.steamid, points, name, matches FROM soccer_mod_players, soccer_mod_%s_stats \
		WHERE soccer_mod_players.steamid = soccer_mod_%s_stats.steamid AND hits > 0 AND matches > 0 ORDER BY points/matches desc LIMIT 0,50", type, type);
	else if (rankMode <= 1 ) Format(query, sizeof(query), "SELECT soccer_mod_players.steamid, points, name, rounds_won, rounds_lost FROM soccer_mod_players, soccer_mod_%s_stats \
		WHERE soccer_mod_players.steamid = soccer_mod_%s_stats.steamid AND hits > 0 AND (rounds_won + rounds_lost) > 0 ORDER BY points/(rounds_won + rounds_lost) desc LIMIT 0,50", type, type);
	else if (rankMode == 2) Format(query, sizeof(query), "SELECT soccer_mod_players.steamid, points, name FROM soccer_mod_players, soccer_mod_%s_stats \
		WHERE soccer_mod_players.steamid = soccer_mod_%s_stats.steamid AND hits > 0 ORDER BY points desc LIMIT 0,50", type, type);

	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, type);

	SQL_TQuery(db, OpenRankingTopMenuCallback, query, pack);
}

public void OpenRankingTopMenuCallback(Handle owner, Handle hndl, const char[] error, any pack)
{
	ResetPack(pack);
	int client = ReadPackCell(pack);

	if (hndl == INVALID_HANDLE)
	{
		LogError("Failed to query (error: %s)", error);
		CPrintToChat(client, "{%s}[%s] {%s}No players are ranked yet", prefixcolor, prefix, textcolor);
		OpenRankingMenu(client);
	}
	else if (SQL_GetRowCount(hndl))
	{
		char type[64], title[64];
		ReadPackString(pack, type, sizeof(type));

		//char langString[64], langString1[64], langString2[64];
		//Format(langString1, sizeof(langString1), "Ranking", client);
		if (StrEqual(type, "match"))
		{
			//Format(langString2, sizeof(langString2), "%T", "Match top $number", client, 50);
			//Format(langString, sizeof(langString), "Soccer Mod - %s - %s", langString1, langString2);
			if (rankMode == 0) title = "Top 50 per match average";
			else if (rankMode == 1) title = "Match top 50 per round average";
			else if (rankMode == 2) title = "Match top 50";
			
			CreateRankingTopMenu(client, title, hndl);
		}
		else if (StrEqual(type, "public"))
		{
			//Format(langString2, sizeof(langString2), "%T", "Public top $number", client, 50);
			//Format(langString, sizeof(langString), "Soccer Mod - %s - %s", langString1, langString2);
			if (rankMode <= 1) title = "Public top 50 per round average";
			else if (rankMode == 2) title = "Public top 50";
			
			CreateRankingTopMenu(client, title, hndl);
		}
	}
	else
	{
		CPrintToChat(client, "{%s}[%s] {%s}No players are ranked yet", prefixcolor, prefix, textcolor);
		OpenRankingMenu(client);
	}
}

public void CreateRankingTopMenu(int client, char title[64], Handle hndl)
{
	Menu menu = new Menu(RankingTopMenuHandler);
	menu.SetTitle(title);

	char steamid[32];
	char name[64];
	char menuString[1024];
	int points;
	int position;
	int rounds;
	int matches;

	while (SQL_FetchRow(hndl))
	{
		position++;
		SQL_FetchString(hndl, 0, steamid, sizeof(steamid));
		SQL_FetchString(hndl, 2, name, sizeof(name));
		points = SQL_FetchInt(hndl, 1);
		if(rankMode == 0)
		{
			matches = SQL_FetchInt(hndl, 3);
			if(matches != 0)			points = points/matches;
		}
		else if(rankMode == 1)
		{
			rounds = SQL_FetchInt(hndl, 3) + SQL_FetchInt(hndl, 4);
			if(rounds != 0)				points = points/rounds;
		}
		
		Format(menuString, sizeof(menuString), "(%i) %s (%i)", position, name, points);
		menu.AddItem(steamid, menuString, ITEMDRAW_DISABLED);
	}

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int RankingTopMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)						OpenRankingMenu(client);
	else if (action == MenuAction_Cancel && choice == -6)   OpenRankingMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ***************************************************************************************************************************
// ************************************************** RANKING PERSONAL MENU **************************************************
// ***************************************************************************************************************************
public void OpenRankingPersonalMenu(int client, char type[8])
{
	char steamid[32];
	GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

	char query[512];
	Format(query, sizeof(query), "SELECT goals, assists, own_goals, passes, interceptions, ball_losses, hits, points, saves, rounds_won, rounds_lost, \
		mvp, motm, last_connected, created, play_time, matches FROM soccer_mod_players, soccer_mod_%s_stats \
		WHERE soccer_mod_players.steamid = soccer_mod_%s_stats.steamid AND soccer_mod_players.steamid = '%s'", type, type, steamid);

	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, type);

	SQL_TQuery(db, OpenRankingPersonalMenuCallback, query, pack);
}

public void OpenRankingPersonalMenuCallback(Handle owner, Handle hndl, const char[] error, any pack)
{
	ResetPack(pack);
	int client = ReadPackCell(pack);

	if (hndl == INVALID_HANDLE)
	{
		LogError("Failed to query (error: %s)", error);
		CPrintToChat(client, "{%s}[%s] {%s}You are not ranked yet", prefixcolor, prefix, textcolor);
		OpenRankingMenu(client);
	}
	else if (SQL_GetRowCount(hndl))
	{
		char type[64];
		ReadPackString(pack, type, sizeof(type));

		//char langString[64], langString1[64], langString2[64];
		//Format(langString1, sizeof(langString1), "Ranking", client);

		if (StrEqual(type, "match"))
		{
			//Format(langString2, sizeof(langString2), "%T", "Match personal", client);
			//Format(langString, sizeof(langString), "Soccer Mod - %s - %s", langString1, langString2);
			CreateRankingPersonalMenu(client, "Match personal", hndl);
		}
		else if (StrEqual(type, "public"))
		{
			//Format(langString2, sizeof(langString2), "%T", "Public personal", client);
			//Format(langString, sizeof(langString), "Soccer Mod - %s - %s", langString1, langString2);
			CreateRankingPersonalMenu(client, "Public personal", hndl);
		}
	}
	else
	{
		CPrintToChat(client, "{%s}[%s] {%s}You are not ranked yet", prefixcolor, prefix, textcolor);
		OpenRankingMenu(client);
	}
}

public void CreateRankingPersonalMenu(int client, char title[64], Handle hndl)
{
	Menu menu = new Menu(RankingPersonalMenuHandler);
	menu.SetTitle(title);

	char menuString[128];
	int number;

	while (SQL_FetchRow(hndl))
	{

		number = SQL_FetchInt(hndl, 7);
		Format(menuString, sizeof(menuString), "%s: %i", "Points", number);
		menu.AddItem("points", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 0);
		Format(menuString, sizeof(menuString), "%s: %i", "Goals", number);
		menu.AddItem("goals", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 1);
		Format(menuString, sizeof(menuString), "%s: %i", "Assists", number);
		menu.AddItem("assists", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 2);
		Format(menuString, sizeof(menuString), "%s: %i", "Own goals", number);
		menu.AddItem("own_goals", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 8);
		Format(menuString, sizeof(menuString), "%s: %i", "Saves", number);
		menu.AddItem("saves", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 3);
		Format(menuString, sizeof(menuString), "%s: %i", "Passes", number);
		menu.AddItem("passes", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 4);
		Format(menuString, sizeof(menuString), "%s: %i", "Interceptions", number);
		menu.AddItem("interceptions", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 5);
		Format(menuString, sizeof(menuString), "%s: %i", "Ball losses", number);
		menu.AddItem("ball_losses", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 6);
		Format(menuString, sizeof(menuString), "%s: %i", "Hits", number);
		menu.AddItem("hits", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 9);
		Format(menuString, sizeof(menuString), "%s: %i", "Rounds won", number);
		menu.AddItem("rounds_won", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 10);
		Format(menuString, sizeof(menuString), "%s: %i", "Rounds lost", number);
		menu.AddItem("rounds_lost", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 16);
		Format(menuString, sizeof(menuString), "%s: %i", "Matches", number);
		menu.AddItem("matches", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 11);
		Format(menuString, sizeof(menuString), "%s: %i", "MVP", number);
		menu.AddItem("mvp", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 12);
		Format(menuString, sizeof(menuString), "%s: %i", "MOTM", number);
		menu.AddItem("motm", menuString, ITEMDRAW_DISABLED);

		/*
		char dateString[32];

		number = SQL_FetchInt(hndl, 13);
		FormatTime(dateString, sizeof(dateString), NULL_STRING, number);
		Format(menuString, sizeof(menuString), "Last connected: %s", dateString);
		menu.AddItem("last_connected", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 14);
		FormatTime(dateString, sizeof(dateString), NULL_STRING, number);
		Format(menuString, sizeof(menuString), "First connected: %s", dateString);
		menu.AddItem("created", menuString, ITEMDRAW_DISABLED);

		number = SQL_FetchInt(hndl, 15);
		Format(menuString, sizeof(menuString), "Play time: %i", number);
		menu.AddItem("play_time", menuString, ITEMDRAW_DISABLED);
		*/
	}

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int RankingPersonalMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)						OpenRankingMenu(client);
	else if (action == MenuAction_Cancel && choice == -6)   OpenRankingMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *************************************************************************************************************************
// ************************************************** LAST CONNECTED MENU **************************************************
// *************************************************************************************************************************
public void OpenRankingLastConnectedMenu(int client)
{
	char query[128];
	Format(query, sizeof(query), "SELECT steamid, last_connected, name FROM soccer_mod_players ORDER BY last_connected DESC LIMIT 0,100");

	SQL_TQuery(db, OpenRankingLastConnectedMenuCallback, query, client);
}

public void OpenRankingLastConnectedMenuCallback(Handle owner, Handle hndl, const char[] error, int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("Failed to query (error: %s)", error);
		CPrintToChat(client, "{%s}[%s] {%s}No players found", prefixcolor, prefix, textcolor);
		OpenRankingMenu(client);
	}
	else if (SQL_GetRowCount(hndl))
	{
		Menu menu = new Menu(RankingLastConnectedMenuHandler);
		menu.SetTitle("Soccer Mod - Ranking - Last connected");

		char steamid[32];
		char name[64];
		int last_connected;
		int time = GetTime();
		char menuString[64];
		char timeAgo[32];

		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, steamid, sizeof(steamid));
			SQL_FetchString(hndl, 2, name, sizeof(name));
			last_connected = SQL_FetchInt(hndl, 1);

			last_connected = time - last_connected;
			if (last_connected == 1)		timeAgo = "second ago";
			else if (last_connected < 60)   timeAgo = "seconds ago";
			else if (last_connected < 120)
			{
				last_connected = last_connected / 60;
				timeAgo = "minute ago";
			}
			else if (last_connected < 3600)
			{
				last_connected = last_connected / 60;
				timeAgo = "minutes ago";
			}
			else if (last_connected < 7200)
			{
				last_connected = last_connected / 3600;
				timeAgo = "hour ago";
			}
			else if (last_connected < 86400)
			{
				last_connected = last_connected / 3600;
				timeAgo = "hours ago";
			}
			else if (last_connected < 172800)
			{
				last_connected = last_connected / 86400;
				timeAgo = "day ago";
			}
			else
			{
				last_connected = last_connected / 86400;
				timeAgo = "days ago";
			}

			Format(menuString, sizeof(menuString), "%s (%i %s)", name, last_connected, timeAgo);
			menu.AddItem(steamid, menuString, ITEMDRAW_DISABLED);
		}

		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		CPrintToChat(client, "{%s}[%s] {%s}No players found", prefixcolor, prefix, textcolor);
		OpenRankingMenu(client);
	}
}

public int RankingLastConnectedMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)						OpenRankingMenu(client);
	else if (action == MenuAction_Cancel && choice == -6)   OpenRankingMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}