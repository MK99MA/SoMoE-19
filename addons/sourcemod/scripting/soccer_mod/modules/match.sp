int matchLastScored			 = 0;
int matchPeriod				 = 1;
int matchScoreCT				= 0;
int matchScoreT				 = 0;
int matchStoppageTime		   = 0;
int matchTime				   = 0;
int matchToss				   = 2;
bool matchGoldenGoalActive	  = false;
bool matchKickOffTaken		  = false;
bool matchPaused				= false;
bool matchPeriodBreak		   = false;
bool matchStoppageTimeStarted   = false;
Handle matchTimer			   = null;
int teamIndicator;

char tagName[32];
int tagindex = 1;
int tagCount = 1;

float matchBallStartPosition[3];

// ********************************************************************************************************************
// ************************************************** ENTITY OUTPUTS **************************************************
// ********************************************************************************************************************
public void MatchOnAwakened(int caller, int activator)
{
	if (matchStarted && !matchKickOffTaken)
	{
		matchKickOffTaken = true;
		KillMatchTimer();

		if (matchGoldenGoalActive) matchTimer = CreateTimer(0.0, MatchGoldenGoalTimer, matchTime);
		else if (matchStoppageTimeStarted) matchTimer = CreateTimer(0.0, MatchPeriodStoppageTimer, matchStoppageTime);
		else matchTimer = CreateTimer(0.0, MatchPeriodTimer, matchTime);
	}
}

public void MatchOnStartTouch(int caller, int activator)
{
	EndStoppageTime();
}

// ************************************************************************************************************
// ************************************************** EVENTS **************************************************
// ************************************************************************************************************
public void MatchOnMapStart()
{
	MatchReset();
}

public void MatchEventRoundStart(Event event)
{
	UnfreezeAll();

	if (matchStarted)
	{
		matchKickOffTaken = false;

		if (matchPaused || matchPeriodBreak) FreezeAll();

		if (matchGoldenGoalActive || !matchPeriodBreak)
		{
			KillMatchTimer();
			matchTimer = CreateTimer(0.0, MatchDisplayTimerMessage);
		}

		LoadConfigMatch();
	}
	else LoadConfigPublic();

	CS_SetTeamScore(2, matchScoreT);
	CS_SetTeamScore(3, matchScoreCT);
	SetTeamScore(2, matchScoreT);
	SetTeamScore(3, matchScoreCT);

	int index = GetEntityIndexByName("ball", "prop_physics");
	if (index == -1) {
		index = GetEntityIndexByName("ball", "func_physbox");
	}
	if (index == -1) {
		index = GetEntityIndexByName("ballon", "func_physbox");
	}
	if (index != -1) GetEntPropVector(index, Prop_Send, "m_vecOrigin", matchBallStartPosition);
}

public void MatchEventRoundEnd(Event event)
{
	if (matchGoldenGoalActive) CreateTimer(0.1, DelayMatchEnd);
	else if (matchStarted && !matchPeriodBreak && !matchPaused)
	{
		KillMatchTimer();
		matchTimer = CreateTimer(0.0, MatchDisplayTimerMessage);
	}

	if (!matchPaused && !matchPeriodBreak)
	{
		int winner = event.GetInt("winner");
		if (winner > 1)
		{
			if (winner == 2)
			{
				matchScoreT++;
				matchLastScored = 2;
			}
			else
			{
				matchScoreCT++;
				matchLastScored = 3;
			}
		}
	}

	CS_SetTeamScore(2, matchScoreT);
	CS_SetTeamScore(3, matchScoreCT);
	SetTeamScore(2, matchScoreT);
	SetTeamScore(3, matchScoreCT);
}

public void MatchEventCSWinPanelMatch(Event event)
{
	MatchReset();
}

// ****************************************************************************************************************
// ************************************************** MATCH MENU **************************************************
// ****************************************************************************************************************
public void OpenMatchMenu(int client)
{
	char currentMatchSet[64], currentMatchSet2[64], currentMatchSet3[64];
	char goldenstate[32];
	if(matchGoldenGoal == 1) goldenstate = "On"
	else if(matchGoldenGoal == 0) goldenstate = "Off"
	Format(currentMatchSet, sizeof(currentMatchSet), "Period length: %i | Break length: %i", matchPeriodLength, matchPeriodBreakLength);
	//Format(currentMatchSet2, sizeof(currentMatchSet2), "Player per Team(max): %i | GoldenGoal: %s", matchMaxPlayers , goldenstate);
	Format(currentMatchSet2, sizeof(currentMatchSet2), "GoldenGoal: %s", goldenstate);
	Format(currentMatchSet3, sizeof(currentMatchSet3), "T team name: %s | CT team name: %s", custom_name_t , custom_name_ct);
	Menu menu = new Menu(MatchMenuHandler);

	menu.SetTitle("Soccer Mod - Admin - Match");

	menu.AddItem("start", "Start / Stop");

	menu.AddItem("pause", "Pause / Unpause");

	if(publicmode == 1 && !((CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) || IsSoccerAdmin(client)))	menu.AddItem("referee", "Referee");
	
	menu.AddItem("settings", "Match Settings");
	menu.AddItem("locknumber", currentMatchSet, ITEMDRAW_DISABLED);
	menu.AddItem("locknumber", currentMatchSet3, ITEMDRAW_DISABLED);
	menu.AddItem("locknumber", currentMatchSet2, ITEMDRAW_DISABLED);


	if(publicmode == 0 || publicmode == 1 || publicmode == 2) menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MatchMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "start"))
		{
			if (!matchStarted)
			{
				if(passwordlock == 1 && pwchange == true)
				{
					ResetPass();
					pwchange = false;
				}
				MatchStart(client);
				OpenMatchMenu(client);
			}
			else if (matchStarted)
			{
				MatchStop(client);
				OpenMatchMenu(client);
			}
		}
		else if (StrEqual(menuItem, "pause"))
		{
			if (matchPaused)
			{
			MatchUnpause(client);
			OpenMatchMenu(client);
			}
			else if (!matchPaused)
			{
			MatchPause(client);
			OpenMatchMenu(client);
			}
		}
		else if (StrEqual(menuItem, "unpause"))
		{
			MatchUnpause(client);
			OpenMatchMenu(client);
		}
		else if (StrEqual(menuItem, "stop"))
		{
			MatchStop(client);
			OpenMatchMenu(client);
		}
		else if (StrEqual(menuItem, "referee"))
		{
			if (publicmode == 1) OpenRefereeMenu(client);
		}
		else if (StrEqual(menuItem, "settings"))
		{
			if (!matchStarted)
			{
				OpenMenuMatchSettings(client);
			}
			else
			{
				CPrintToChat(client, "{%s}[%s] {%s}You can not use this option during a match", prefixcolor, prefix, textcolor);
				OpenMatchMenu(client);
			}
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}


// ***************************************************************************************************************
// ****************************************** MATCH SETTINGS MENU ************************************************
// ***************************************************************************************************************
public void OpenMenuMatchSettings(int client)
{
	Menu menu = new Menu(MenuHandlerMatchSettings);

	menu.SetTitle("Soccer Mod - Match Settings");

	menu.AddItem("period", "Period Length");

	menu.AddItem("break", "Break Length");
	
	menu.AddItem("golden", "Golden Goal");
	
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) menu.AddItem("name_t_menu", "Change Terrorists Name");
	
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) menu.AddItem("name_ct_menu", "Change CTs Name");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerMatchSettings(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "period"))					   OpenMenuMatchPeriod(client);
		else if (StrEqual(menuItem, "break"))				   OpenMenuMatchBreak(client);
		else if (StrEqual(menuItem, "golden"))				  OpenMenuMatchGolden(client);
		else if (StrEqual(menuItem, "name_t_menu"))	
		{
			teamIndicator = 2;
			OpenMenuTeamName(client);
		}
		else if (StrEqual(menuItem, "name_ct_menu"))
		{
			teamIndicator = 3;
			OpenMenuTeamName(client);
		}
	}

	else if (action == MenuAction_Cancel && choice == -6)	OpenMatchMenu(client);
	else if (action == MenuAction_End)						  menu.Close();
}

// ****************************************** NAME SETTINGS ************************************************

public void OpenMenuTeamName(int client)
{
	Menu menu = new Menu(MenuHandlerTeam);
	//menu.SetTitle("Team Names");

	if(teamIndicator == 2)
	{
		menu.SetTitle("Terrorists Name");
		menu.AddItem("tag_name_t", "Clan Tag for Name");

		menu.AddItem("cust_name_t", "Custom Name");

		menu.AddItem("def_name_t", "T");
	}
	else if(teamIndicator == 3)
	{
		menu.SetTitle("Counter-Terrorists Name");
		menu.AddItem("tag_name_ct", "Clan Tag for Name");

		menu.AddItem("cust_name_ct", "Custom Name");

		menu.AddItem("def_name_ct", "CT");
	}

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerTeam(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		int playerNumT, playerNumCT;
		tagCount = GetClientCount(true);
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		playerNumT = GetTeamClientCount(2);
		playerNumCT = GetTeamClientCount(3);

		if (StrEqual(menuItem, "tag_name_t"))
		{
			if (playerNumT == 0)
			{
				CPrintToChat(client, "{%s}[%s] {%s}No targets found", prefixcolor, prefix, textcolor);
				OpenMenuTeamName(client);
			}
			else if(playerNumT == 1)
			{
				CS_GetClientClanTag(tagindex, tagName, sizeof(tagName));
				if(StrEqual(tagName, ""))
				{
					CPrintToChat(client, "{%s}[%s] {%s}No targets found", prefixcolor, prefix, textcolor);
					OpenMenuTeamName(client);
				}
				else OpenMenuTeamNameList(client);
			}
			else OpenMenuTeamNameList(client);
		}
		else if (StrEqual(menuItem, "cust_name_t"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type in the name of the Terrorists team, current name is %s", prefixcolor, prefix, textcolor, custom_name_t);
			changeSetting[client] = "CustomNameTeamT";
		}
		else if (StrEqual(menuItem, "def_name_t"))
		{
			custom_name_t = "T";
			UpdateConfig("Match Settings", "soccer_mod_teamnamet", custom_name_t);
			CPrintToChatAll("{%s}[%s] {%s}%N has set the name of the Terrorists to T", prefixcolor, prefix, textcolor, client);
			OpenMenuTeamName(client);
		}
		else if (StrEqual(menuItem, "tag_name_ct"))
		{
			if (playerNumCT == 0)
			{
				CPrintToChat(client, "{%s}[%s] {%s}No targets found", prefixcolor, prefix, textcolor);
				OpenMenuTeamName(client);
			}
			else if(playerNumCT == 1)
			{
				CS_GetClientClanTag(tagindex, tagName, sizeof(tagName));
				if(StrEqual(tagName, ""))
				{
					CPrintToChat(client, "{%s}[%s] {%s}No targets found", prefixcolor, prefix, textcolor);
					OpenMenuTeamName(client);
				}
				else OpenMenuTeamNameList(client);
			}
			else OpenMenuTeamNameList(client);
		}
		else if (StrEqual(menuItem, "cust_name_ct"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type in the name of the Counter-Terrorists team, current name is %s", prefixcolor, prefix, textcolor, custom_name_ct);
			changeSetting[client] = "CustomNameTeamCT";
		}
		else if (StrEqual(menuItem, "def_name_ct"))
		{
			custom_name_ct = "CT";
			UpdateConfig("Match Settings", "soccer_mod_teamnamect", custom_name_ct);
			CPrintToChatAll("{%s}[%s] {%s}%N has set the name of the Counter-Terrorists to CT", prefixcolor, prefix, textcolor, client);
			OpenMenuTeamName(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMatchSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}


public void OpenMenuTeamNameList(int client)
{
	tagCount = GetClientCount(true);
	Menu menu = new Menu(MenuHandlerTeamMenuList);

	if(teamIndicator == 2)
	{
		menu.SetTitle("Select Name for T");
		for (tagindex = 1; tagindex <= tagCount; tagindex++)
		{	
			if (IsClientInGame(tagindex) && IsClientConnected(tagindex) && !IsFakeClient(tagindex) && !IsClientSourceTV(tagindex) && (GetClientTeam(tagindex) == CS_TEAM_T))
			{
				CS_GetClientClanTag(tagindex, tagName, sizeof(tagName))
				if (strlen(tagName) > 0) AddMenuItem(menu, tagName, tagName)
			}
		}
	}
	else if(teamIndicator == 3)
	{	
		menu.SetTitle("Select Name for CT");
		for (tagindex = 1; tagindex <= tagCount; tagindex++)
		{	
			if (IsClientInGame(tagindex) && IsClientConnected(tagindex) && !IsFakeClient(tagindex) && !IsClientSourceTV(tagindex) && (GetClientTeam(tagindex) == CS_TEAM_CT))
			{
				CS_GetClientClanTag(tagindex, tagName, sizeof(tagName))
				if (strlen(tagName) > 0) AddMenuItem(menu, tagName, tagName)
			}
		}
	}

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerTeamMenuList(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		if (action == MenuAction_Select)
		{
			if(teamIndicator == 2)
			{
				
				menu.GetItem(choice, tagName, sizeof(tagName));
				custom_name_t = tagName;
				UpdateConfig("Match Settings", "soccer_mod_teamnamet", custom_name_t);
				CPrintToChatAll("{%s}[%s] {%s}%N has set the name of the Terrorists to %s", prefixcolor, prefix, textcolor, client, tagName);
				OpenMenuTeamName(client);
			}
			else if(teamIndicator == 3)
			{
				menu.GetItem(choice, tagName, sizeof(tagName));
				custom_name_ct = tagName;
				UpdateConfig("Match Settings", "soccer_mod_teamnamect", custom_name_ct);
				CPrintToChatAll("{%s}[%s] {%s}%N has set the name of the Counter-Terrorists to %s", prefixcolor, prefix, textcolor, client, tagName);
				OpenMenuTeamName(client);
			}
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuTeamName(client);
	else if (action == MenuAction_End)					  menu.Close();
	tagindex = 1;
}

// ****************************************** PERIOD SETTINGS ************************************************

public void OpenMenuMatchPeriod(int client)
{
	Menu menu = new Menu(MenuHandlerMatchPeriod);
	menu.SetTitle("Soccer Mod - Match Settings - Period Length");

	menu.AddItem("15Mins", "15 Minutes");

	menu.AddItem("10Mins", "10 Minutes");

	menu.AddItem("75Mins", "7.5 Minutes");
	
	menu.AddItem("Custom", "Custom");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerMatchPeriod(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "15Mins"))
		{
			matchPeriodLength = 900;
			UpdateConfigInt("Match Settings", "soccer_mod_match_period_length", matchPeriodLength);
			CPrintToChatAll("{%s}[%s] {%s}Period length was set to %i", prefixcolor, prefix, textcolor, matchPeriodLength);
			OpenMenuMatchSettings(client);
		}
		else if (StrEqual(menuItem, "10Mins"))
		{
			matchPeriodLength = 600;
			UpdateConfigInt("Match Settings", "soccer_mod_match_period_length", matchPeriodLength);
			CPrintToChatAll("{%s}[%s] {%s}Period length was set to %i", prefixcolor, prefix, textcolor, matchPeriodLength);
			OpenMenuMatchSettings(client);
		}
		else if (StrEqual(menuItem, "75Mins"))
		{
			matchPeriodLength = 450;
			UpdateConfigInt("Match Settings", "soccer_mod_match_period_length", matchPeriodLength);
			CPrintToChatAll("{%s}[%s] {%s}Period length was set to %i", prefixcolor, prefix, textcolor, matchPeriodLength);
			OpenMenuMatchSettings(client);
		}
		else if (StrEqual(menuItem, "Custom"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type a value for the period length, current value is %i", prefixcolor, prefix, textcolor, matchPeriodLength);
			changeSetting[client] = "CustomPeriodLength";
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMatchSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ****************************************** BREAK SETTINGS ************************************************

public void OpenMenuMatchBreak(int client)
{
	Menu menu = new Menu(MenuHandlerMatchBreak);
	menu.SetTitle("Soccer Mod - Match Settings - Break Length");

	menu.AddItem("FullMin", "60 Seconds");

	menu.AddItem("HalfMin", "30 Seconds");
	
	menu.AddItem("QuartMin", "15 Seconds");
	
	menu.AddItem("5Secs", "5 Seconds");
	
	menu.AddItem("Custom", "Custom");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerMatchBreak(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "FullMin"))
		{
			matchPeriodBreakLength = 60;
			UpdateConfigInt("Match Settings", "soccer_mod_match_break_length", matchPeriodBreakLength);
			CPrintToChatAll("{%s}[%s] {%s}Period length was set to %i", prefixcolor, prefix, textcolor, matchPeriodBreakLength);
			OpenMenuMatchSettings(client);
		}
		else if (StrEqual(menuItem, "HalfMin"))
		{
			matchPeriodBreakLength = 30;
			UpdateConfigInt("Match Settings", "soccer_mod_match_break_length", matchPeriodBreakLength);
			CPrintToChatAll("{%s}[%s] {%s}Period length was set to %i", prefixcolor, prefix, textcolor, matchPeriodBreakLength);
			OpenMenuMatchSettings(client);
		}
		else if (StrEqual(menuItem, "QuartMin"))
		{
			matchPeriodBreakLength = 15;
			UpdateConfigInt("Match Settings", "soccer_mod_match_break_length", matchPeriodBreakLength);
			CPrintToChatAll("{%s}[%s] {%s}Period length was set to %i", prefixcolor, prefix, textcolor, matchPeriodBreakLength);
			OpenMenuMatchSettings(client);
		}
		else if (StrEqual(menuItem, "5Secs"))
		{
			matchPeriodBreakLength = 5;
			UpdateConfigInt("Match Settings", "soccer_mod_match_break_length", matchPeriodBreakLength);
			CPrintToChatAll("{%s}[%s] {%s}Period length was set to %i", prefixcolor, prefix, textcolor, matchPeriodBreakLength);
			OpenMenuMatchSettings(client);
		}
		else if (StrEqual(menuItem, "Custom"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type a value for the break length, current value is %i", prefixcolor, prefix, textcolor, matchPeriodBreakLength);
			changeSetting[client] = "CustomPeriodBreakLength";
		}

	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMatchSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ****************************************** GOLDEN GOAL SETTINGS ************************************************

public void OpenMenuMatchGolden(int client)
{
	Menu menu = new Menu(MenuHandlerMatchGolden);
	menu.SetTitle("Soccer Mod - Match Settings - Golden Goal");

	menu.AddItem("EnableGolden", "Enable");

	menu.AddItem("DisableGolden", "Disable");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerMatchGolden(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "EnableGolden"))
		{
			matchGoldenGoal = 1;
			UpdateConfigInt("Match Settings", "soccer_mod_match_golden_goal", matchGoldenGoal);
			CPrintToChat(client, "{%s}[%s] {%s}Golden Goal was enabled", prefixcolor, prefix, textcolor);
			OpenMenuMatchSettings(client);
		}
		else if (StrEqual(menuItem, "DisableGolden"))
		{
			matchGoldenGoal = 0;
			UpdateConfigInt("Match Settings", "soccer_mod_match_golden_goal", matchGoldenGoal);
			CPrintToChat(client, "{%s}[%s] {%s}Golden Goal was enabled", prefixcolor, prefix, textcolor);
			OpenMenuMatchSettings(client);
		}

	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMatchSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ***********************************************************************************************************************
// ************************************************** COMMAND LISTENERS **************************************************
// ***********************************************************************************************************************
public void MatchSet(int client, char type[32], int intnumber, int min, int max)
{
	if (intnumber >= min && intnumber <= max)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

		if (StrEqual(type, "CustomPeriodBreakLength"))
		{
			matchPeriodBreakLength = intnumber;
			UpdateConfigInt("Match Settings", "soccer_mod_match_break_length", matchPeriodBreakLength);

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the break length to %i", prefixcolor, prefix, textcolor, client, intnumber);
			}

			LogMessage("%N <%s> has set the break length to %i", client, steamid, intnumber);
		}
		else if (StrEqual(type, "CustomPeriodLength"))
		{
			matchPeriodLength = intnumber;
			UpdateConfigInt("Match Settings", "soccer_mod_match_period_length", matchPeriodLength);
			
			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the match period length to %i", prefixcolor, prefix, textcolor, client, intnumber);
			}

			LogMessage("%N <%s> has set the period length to %i", client, steamid, intnumber);
		}

		changeSetting[client] = "";
		OpenMenuMatchSettings(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Type a value between %i and %i", prefixcolor, prefix, textcolor, min, max);
}

public void NameSet(int client, char type[32], char custom_teamname[32])
{
	int min = 0;
	int max = 15;
	if (strlen(custom_teamname) >= min && strlen(custom_teamname) <= max)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

		if (StrEqual(type, "CustomNameTeamT"))
		{
			custom_name_t = custom_teamname;
			UpdateConfig("Match Settings", "soccer_mod_teamnamet", custom_name_t);

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the name of the Terrorists to %s", prefixcolor, prefix, textcolor, client, custom_teamname);
			}

			LogMessage("%N <%s> has set the name of the terrorists to %s", client, steamid, custom_teamname);
		}
		if (StrEqual(type, "CustomNameTeamCT"))
		{
			custom_name_ct = custom_teamname;
			UpdateConfig("Match Settings", "soccer_mod_teamnamect", custom_name_ct);

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the name of the Counter-Terrorists to %s", prefixcolor, prefix, textcolor, client, custom_teamname);
			}

			LogMessage("%N <%s> has set the name of the counter-terrorists to %s", client, steamid, custom_teamname);
		}

		changeSetting[client] = "";
		OpenMenuTeamName(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Type a value between %i and %i", prefixcolor, prefix, textcolor, min, max);
}

// ************************************************************************************************************
// ************************************************** TIMERS **************************************************
// ************************************************************************************************************
public Action MatchDisplayTimerMessage(Handle timer)
{
	char timeString[16];
	getTimeString(timeString, matchTime);

	if (matchPaused)
	{
		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player))
			{
				PrintHintText(player, "%s: %s %i - %i %s | %s", "Paused", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString);
			}
		}
	}
	else if (roundEnded)
	{
		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player))
			{
				PrintHintText(player, "%s: %s %i - %i %s | %s", "Goal scored", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString);
			}
		}
	}
	else
	{
		if (matchKickOffTaken) PrintHintTextToAll("%s %i - %i %s | %s", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString);
		else
		{
			if (matchLastScored > 1)
			{
				if (matchLastScored == 2)
				{
					for (int player = 1; player <= MaxClients; player++)
					{
						if (IsClientInGame(player) && IsClientConnected(player))
						{
							PrintHintText(player, "Kick off %s: %s %i - %i %s | %s", custom_name_ct, custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString);
						}
					}
				}
				else
				{
					for (int player = 1; player <= MaxClients; player++)
					{
						if (IsClientInGame(player) && IsClientConnected(player))
						{
							PrintHintText(player, "Kick off %s: %s %i - %i %s | %s", custom_name_t, custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString);
						}
					}
				}
			}
			else
			{
				if (matchToss == 2)
				{
					for (int player = 1; player <= MaxClients; player++)
					{
						if (IsClientInGame(player) && IsClientConnected(player))
						{
							PrintHintText(player, "Kick off %s: %s %i - %i %s | %s", custom_name_ct, custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString);
						}
					}
				}
				else
				{
					for (int player = 1; player <= MaxClients; player++)
					{
						if (IsClientInGame(player) && IsClientConnected(player))
						{
							PrintHintText(player, "Kick off %s: %s %i - %i %s | %s", custom_name_t, custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString);
						}
					}
				}
			}
		}
	}

	matchTimer = CreateTimer(1.0, MatchDisplayTimerMessage);
}

public Action MatchPeriodTimer(Handle timer, any time)
{
	matchTime = time;

	char timeString[16];
	getTimeString(timeString, matchTime);
	PrintHintTextToAll("%s %i - %i %s | %s", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString);

	int periodEnd = matchPeriod * matchPeriodLength;
	if (time < periodEnd) matchTimer = CreateTimer(1.0, MatchPeriodTimer, time + 1);
	else
	{
		matchStoppageTimeStarted = true;

		int index = CreateEntityByName("trigger_once");
		if (index != -1)
		{
			DispatchKeyValue(index, "targetname", "end_stoppage_time");
			DispatchKeyValue(index, "spawnflags", "8");

			DispatchSpawn(index);
			ActivateEntity(index);

			TeleportEntity(index, matchBallStartPosition, NULL_VECTOR, NULL_VECTOR);

			if (!IsModelPrecached("models/props/cs_office/vending_machine.mdl")) PrecacheModel("models/props/cs_office/vending_machine.mdl");
			SetEntityModel(index, "models/props/cs_office/vending_machine.mdl");

			float minbounds[3] = {-2000.0, -1.0, -10.0};
			float maxbounds[3] = {2000.0, 1.0, 5000.0};
			SetEntPropVector(index, Prop_Send, "m_vecMins", minbounds);
			SetEntPropVector(index, Prop_Send, "m_vecMaxs", maxbounds);

			SetEntProp(index, Prop_Send, "m_nSolidType", 2);

			int enteffects = GetEntProp(index, Prop_Send, "m_fEffects");
			enteffects |= 32;
			SetEntProp(index, Prop_Send, "m_fEffects", enteffects);
		}

		matchTimer = CreateTimer(0.0, MatchPeriodStoppageTimer, matchStoppageTime);
	}
}

public Action MatchPeriodStoppageTimer(Handle timer, any time)
{
	matchStoppageTime = time;

	char timeString[16];
	getTimeString(timeString, matchTime);
	char stoppageTimeString[16];
	getTimeString(stoppageTimeString, matchStoppageTime);
	PrintHintTextToAll("%s %i - %i %s | %s +%s", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString, stoppageTimeString);

	matchTimer = CreateTimer(1.0, MatchPeriodStoppageTimer, matchStoppageTime + 1);
}

public Action MatchPeriodBreakTimer(Handle timer, any time)
{
	char matchTimerMessage[32] = "";

	if (matchPeriods > 2) matchTimerMessage = "Period break: ";
	else matchTimerMessage = "Half time: ";

	char timeString[16];
	getTimeString(timeString, time);
	PrintHintTextToAll("%s %s %i - %i %s | %s", matchTimerMessage, custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString);

	if (time < 1)
	{
		matchPeriodBreak = false;
		matchLastScored = 0;

		ServerCommand("mp_restartgame 1");
		KillMatchTimer();

		if (matchToss == 2) matchToss = 3;
		else matchToss = 2;
	}
	else matchTimer = CreateTimer(1.0, MatchPeriodBreakTimer, time - 1);
}

public Action MatchGoldenGoalTimer(Handle timer, any time)
{
	matchTime = time;

	char timeString[16];
	getTimeString(timeString, time);

	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player))
		{
			PrintHintText(player, "%s: %s %i - %i %s | %s", "Golden goal", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString);
		}
	}

	matchTimer = CreateTimer(1.0, MatchGoldenGoalTimer, time + 1);
}

public Action MatchUnpauseCountdown(Handle timer, any time)
{
	if (time > 1)
	{
		PrintHintTextToAll("Unpausing in %i seconds", time);
		PrintCenterTextAll("Unpausing in %i seconds", time);
	}
	else
	{
		PrintHintTextToAll("Unpausing in %i second", time);
		PrintCenterTextAll("Unpausing in %i second", time);
	}

	if (time < 1)
	{
		UnfreezeAll();

		if (matchGoldenGoalActive)
		{
			if (matchKickOffTaken) matchTimer = CreateTimer(0.0, MatchGoldenGoalTimer, matchTime);
			else matchTimer = CreateTimer(0.0, MatchDisplayTimerMessage);
		}
		else if (matchStoppageTimeStarted)
		{
			if (matchKickOffTaken) matchTimer = CreateTimer(0.0, MatchPeriodStoppageTimer, matchStoppageTime);
			else matchTimer = CreateTimer(0.0, MatchDisplayTimerMessage);
		}
		else
		{
			if (matchKickOffTaken) matchTimer = CreateTimer(0.0, MatchPeriodTimer, matchTime);
			else matchTimer = CreateTimer(0.0, MatchDisplayTimerMessage);
		}
	}
	else matchTimer = CreateTimer(1.0, MatchUnpauseCountdown, time - 1);
}

public Action DelayFreezePlayer(Handle timer, any client)
{
	SetEntityMoveType(client, MOVETYPE_NONE);
}

public Action DelayMatchEnd(Handle timer)
{
	char timeString[16];
	getTimeString(timeString, matchTime);

	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player))
		{
			PrintHintText(player, "%s: %s %i - %i %s | %s", "Goal scored", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString);
			CPrintToChat(player, "{%s}[%s] {%s}1 %s: %s %i - %i %s", prefixcolor, prefix, textcolor, "Final score", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t);
		}
	}

	LogMessage("Final score: %s %i - %i %s", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t);

	ShowManOfTheMatch();
	MatchReset();
	ServerCommand("mp_restartgame 5");
}

// ***************************************************************************************************************
// ************************************************** FUNCTIONS **************************************************
// ***************************************************************************************************************
public void MatchReset()
{
	matchGoldenGoalActive	   = false;
	matchStarted				= false;
	matchKickOffTaken		   = false;
	matchPaused				 = false;
	matchPeriodBreak			= false;
	matchStoppageTimeStarted	= false;

	matchTime = 0;
	matchStoppageTime = 0;
	matchPeriod = 1;
	KillMatchTimer();

	matchToss = 2;
	matchLastScored = 0;

	matchScoreT = 0;
	matchScoreCT = 0;
}

public void MatchStart(int client)
{
	if (!matchStarted)
	{
		ServerCommand("mp_restartgame 1");

		FreezeAll();
		MatchReset();
		LoadConfigMatch();
		ResetMatchStats();

		matchStarted = true;
		matchKickOffTaken = true;
		matchToss = GetRandomInt(2, 3);

		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has started a match", prefixcolor, prefix, textcolor, client);
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%s (CT) will face %s (T)", prefixcolor, prefix, textcolor, custom_name_ct, custom_name_t);
		}

		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		LogMessage("%N <%s> has started a match", client, steamid);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Match already started", prefixcolor, prefix, textcolor);
}

public void MatchPause(int client)
{
	if (matchStarted)
	{
		if (!matchPaused)
		{
			matchPaused = true;

			if (!matchPeriodBreak)
			{
				FreezeAll();
				KillMatchTimer();
				matchTimer = CreateTimer(0.0, MatchDisplayTimerMessage);
			}

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has paused the match", prefixcolor, prefix, textcolor, client);
			}

			char steamid[32];
			GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
			LogMessage("%N <%s> has paused the match", client, steamid);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}Match already paused", prefixcolor, prefix, textcolor);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}No match started", prefixcolor, prefix, textcolor);
}

public void MatchUnpause(int client)
{
	if (matchStarted)
	{
		if (matchPaused)
		{
			matchPaused = false;

			if (!matchPeriodBreak)
			{
				KillMatchTimer();
				matchTimer = CreateTimer(0.0, MatchUnpauseCountdown, 5);
			}

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has unpaused the match", prefixcolor, prefix, textcolor, client);
			}

			char steamid[32];
			GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
			LogMessage("%N <%s> has unpaused the match", client, steamid);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}Match already unpaused", prefixcolor, prefix, textcolor);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}No match started", prefixcolor, prefix, textcolor);
}

public void MatchStop(int client)
{
	if (matchStarted)
	{
		MatchReset();
		UnfreezeAll();

		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has stopped the match", prefixcolor, prefix, textcolor, client);
		}

		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		LogMessage("%N <%s> has stopped the match", client, steamid);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}No match started", prefixcolor, prefix, textcolor);
}

stock bool getTimeString(char[] name, int time)
{
	int hours = RoundToFloor(time / 3600.0);
	int minutes = RoundToFloor((time - (hours * 3600.0)) / 60.0);
	int seconds = time - (hours * 3600) - (minutes * 60);

	char hoursString[4];
	char minutesString[4];
	char secondsString[4];

	if (time >= 3600)
	{
		if (hours < 10) Format(hoursString, sizeof(hoursString), "0%i", hours);
		else Format(hoursString, sizeof(hoursString), "%i", hours);
	}
	if (minutes < 10) Format(minutesString, sizeof(minutesString), "0%i", minutes)
	else Format(minutesString, sizeof(minutesString), "%i", minutes);
	if (seconds < 10) Format(secondsString, sizeof(secondsString), "0%i", seconds);
	else Format(secondsString, sizeof(secondsString), "%i", seconds);

	char timeString[16];
	if (time >= 3600) Format(timeString, sizeof(timeString), "%s:%s:%s", hoursString, minutesString, secondsString);
	else Format(timeString, sizeof(timeString), "%s:%s", minutesString, secondsString);

	strcopy(name, 16, timeString);
	return true;
}

public void EndStoppageTime()
{
	if (matchStoppageTimeStarted)
	{
		KillMatchTimer();

		matchStoppageTimeStarted = false;
		matchStoppageTime = 0;
		matchPeriod++;

		if (matchPeriod <= matchPeriods)
		{
			matchPeriodBreak = true;
			FreezeAll();
			matchTimer = CreateTimer(0.0, MatchPeriodBreakTimer, matchPeriodBreakLength);
		}
		else
		{
			if (matchGoldenGoal && matchScoreCT == matchScoreT)
			{
				matchGoldenGoalActive = true;
				matchToss = GetRandomInt(2, 3);

				FreezeAll();

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}The match ended in a draw and will continue with a golden goal", prefixcolor, prefix, textcolor);
				}

				ServerCommand("mp_restartgame 5");
			}
			else
			{

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player))
					{
						CPrintToChat(player, "{%s}[%s] {%s} %s: %s %i - %i %s", prefixcolor, prefix, textcolor, "Final score", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t);
					}
				}

				LogMessage("Final score: %s %i - %i %s", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t);

				ShowManOfTheMatch();
				MatchReset();
				ServerCommand("mp_restartgame 5");
			}
		}
	}
}

public void KillMatchTimer()
{
	if (matchTimer != null)
	{
		KillTimer(matchTimer);
		matchTimer = null;
	}
}