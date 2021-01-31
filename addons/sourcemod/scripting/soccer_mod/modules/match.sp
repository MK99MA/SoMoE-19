
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
	NameReset();
	ForfeitReset();
}

public void MatchEventRoundStart(Event event)
{
	UnfreezeAll();

	if (matchStarted)
	{
		if (matchStart)
		{
			PlaySound("soccermod/kickoff.wav");
			CreateTimer(10.0, matchStartTimer);
		}
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
	NameReset();
	ForfeitReset();
}

// ****************************************************************************************************************
// ************************************************** MATCH MENU **************************************************
// ****************************************************************************************************************
public void OpenMatchMenu(int client)
{
	char currentMatchSet[64], currentMatchSet2[64], currentMatchSet3[64];
	char goldenstate[32], leaguestate[32];

	if(matchGoldenGoal == 1) goldenstate = "On";
	else if(matchGoldenGoal == 0) goldenstate = "Off";
	
	if(matchlog == 1) leaguestate = "Yes";
	else if(matchlog == 0) leaguestate = "No";
	
	Format(currentMatchSet, sizeof(currentMatchSet), "Period length: %i | Break length: %i", matchPeriodLength, matchPeriodBreakLength);
	//Format(currentMatchSet2, sizeof(currentMatchSet2), "Player per Team(max): %i | GoldenGoal: %s", matchMaxPlayers , goldenstate);
	Format(currentMatchSet2, sizeof(currentMatchSet2), "GoldenGoal: %s | Match Log: %s", goldenstate, leaguestate);
	Format(currentMatchSet3, sizeof(currentMatchSet3), "T team name: %s | CT team name: %s", custom_name_t , custom_name_ct);
	Menu menu = new Menu(MatchMenuHandler);

	menu.SetTitle("Soccer Mod - Admin - Match");

	menu.AddItem("start", "Start / Stop");

	menu.AddItem("pause", "Pause / Unpause");

	//if(publicmode == 1 && !((CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) || IsSoccerAdmin(client)))	menu.AddItem("referee", "Referee");
	
	menu.AddItem("settings", "Match Settings");
	
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "match"))
	{
		if(matchlog > 0)	menu.AddItem("log", "Match Log");
	}
	
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
				if(capFightStarted) capFightStarted = false;
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
			UnpauseCheck(client);
			OpenMatchMenu(client);
			}
			else if (!matchPaused)
			{
			MatchPause(client);
			OpenMatchMenu(client);
			}
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
		else if (StrEqual(menuItem, "log"))
		{	 
			if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "match")) OpenMatchLogMenu(client); 
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


// ***********************************************************************************************************************
// ************************************************** MATCHLOG MENU *****************************************************
// ***********************************************************************************************************************
public void OpenMatchLogMenu(int client)
{
	logmenuArray		= CreateArray(128);
	ClearArray(logmenuArray);
	Menu menu = new Menu(MatchLogMenuHandler);

	menu.SetTitle("Match Log (Refreshes every 5 seconds)");
	KVGetEvent(menu);
	char menubuffer[128];
	
	for(int i = GetArraySize(logmenuArray)-1; i >= 0; i--)
	{
		GetArrayString(logmenuArray, i, menubuffer, sizeof(menubuffer));
		
		char buffer[32];
		IntToString(i, buffer, sizeof(buffer)); 
		
		menu.AddItem(buffer, menubuffer, ITEMDRAW_DISABLED);
	}
	
	if(showcards)	menu.AddItem("cardlog", "Card Log");
	if(GetMenuItemCount(menu) == 0) 
	{
		menu.AddItem("emptylog", "Nothing to display", ITEMDRAW_DISABLED);
	}
	if(matchStarted) matchLogRefresh = CreateTimer(5.0, RefreshMatchLog, client);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MatchLogMenuHandler(Menu menu, MenuAction action, int client, int choice)
{	
	if (action == MenuAction_Select)
	{
		ClearTimer(matchLogRefresh);
		OpenMatchLogCards(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   
	{
		ClearTimer(matchLogRefresh);
		OpenMatchMenu(client);
	}	
	else if (action == MenuAction_End)					  
	{
		ClearTimer(matchLogRefresh);
		menu.Close();
	}
}

public void OpenMatchLogCards(int client)
{
	Menu menu = new Menu(MatchLogCardsHandler);

	menu.SetTitle("Match Card Log");
	menu.AddItem("refresh", "Refresh");
	KVGetCards(menu);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MatchLogCardsHandler(Menu menu, MenuAction action, int client, int choice)
{	
	if (action == MenuAction_Select)
	{
		OpenMatchLogCards(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   
	{
		OpenMatchLogMenu(client);
	}	
	else if (action == MenuAction_End)					  
	{
		menu.Close();
	}
}

public Action RefreshMatchLog(Handle timer, int client)
{
	OpenMatchLogMenu(client);
	matchLogRefresh = CreateTimer(5.0, RefreshMatchLog, client);
	
	return;
}

public void SaveLogsOnMatchStart() //Set everything to default
{
    for(int i = 1; i <= MaxClients; i++)
    {
        iPlayerNames[i] = 0;
        for(int k = 0; k < MAX_NAMES; k++) PlayerNames[i][k] = "\0"; //Empty the string;
    }
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
	
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "match")) menu.AddItem("logset", "Match Log settings");
	
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) menu.AddItem("forfeitset", "Forfeit Vote settings");
	
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) menu.AddItem("nameset", "Team Name settings");
	
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) menu.AddItem("matchinfoset", "Match-Info settings");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerMatchSettings(Menu menu, MenuAction action, int client, int choice)
{
	if (!matchStarted)
	{
		if (action == MenuAction_Select)
		{
			char menuItem[16];
			menu.GetItem(choice, menuItem, sizeof(menuItem));

			if (StrEqual(menuItem, "period"))						OpenMenuMatchPeriod(client);
			else if (StrEqual(menuItem, "break"))					OpenMenuMatchBreak(client);
			else if (StrEqual(menuItem, "golden"))				  	OpenMenuMatchGolden(client);
			else if (StrEqual(menuItem, "nameset"))					OpenMenuNameSettings(client);
			else if (StrEqual(menuItem, "forfeitset"))				OpenMenuForfeitSettings(client);
			else if (StrEqual(menuItem, "logset"))					OpenMenuMatchlogSettings(client);
			else if (StrEqual(menuItem, "matchinfoset"))			OpenMenuMatchInfoSet(client);
		}

		else if (action == MenuAction_Cancel && choice == -6)	OpenMatchMenu(client);
		else if (action == MenuAction_End)						  menu.Close();
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Can't change the settings during a match.", prefixcolor, prefix, textcolor);
}

// ************************************** MATCHLOG SETTINGS ************************************************
public void OpenMenuMatchlogSettings(int client)
{
	char matchlogstring[32], starthourstring[32], startminstring[32], stophourstring[32], stopminstring[32];
	if(matchlog == 0)		matchlogstring = "Match Log: OFF"
	else if(matchlog == 1)	matchlogstring = "Match Log: ON"
	else if(matchlog == 2) 	matchlogstring = "Match Log: TIME-BASED"
	
	ReadMatchlogSettings();
	
	Format(starthourstring, sizeof(starthourstring), "Starthour: %i", iStarthour);
	Format(startminstring, sizeof(startminstring), "Startminute: %i", iStartmin);
	Format(stophourstring, sizeof(stophourstring), "Stophour: %i", iStophour);
	Format(stopminstring, sizeof(stopminstring), "Stopminute: %i", iStopmin); 
		
	Menu menu = new Menu(MenuHandlerMatchlogSettings);

	menu.SetTitle("Soccer Mod - Match Log Settings");

	menu.AddItem("toggle", matchlogstring);
	if(matchlog == 2)
	{
		menu.AddItem("setday", "Set days");
		menu.AddItem("starthour", starthourstring);
		menu.AddItem("stophour", stophourstring);
		menu.AddItem("startminute", startminstring);
		menu.AddItem("stopminute", stopminstring);
		if(TimeStatus() == 0) menu.AddItem("status", "Status: OK", ITEMDRAW_DISABLED);
		else if(TimeStatus() == 1) menu.AddItem("status", "Status: OK (Minutes disabled)", ITEMDRAW_DISABLED);
		else if(TimeStatus() == 2) menu.AddItem("status", "Status: OK (Time disabled)", ITEMDRAW_DISABLED);	
		else if(TimeStatus() == 3) menu.AddItem("status", "Status: OK (Constantly active)", ITEMDRAW_DISABLED);		
		else if(TimeStatus() == 4) menu.AddItem("status", "Status: Start > Stop", ITEMDRAW_DISABLED);
		else if(TimeStatus() == 5) menu.AddItem("status", "Status: No days selected", ITEMDRAW_DISABLED);
	}

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerMatchlogSettings(Menu menu, MenuAction action, int client, int choice)
{
	if (!matchStarted)
	{
		if (action == MenuAction_Select)
		{
			char menuItem[16];
			menu.GetItem(choice, menuItem, sizeof(menuItem));

			if (StrEqual(menuItem, "toggle"))		
			{
				if(matchlog == 0)		
				{
					matchlog = 1;
					UpdateConfigInt("Admin Settings", "soccer_mod_matchlog", matchlog);
					CPrintToChat(client, "{%s}[%s] {%s}Match Log enabled!", prefixcolor, prefix, textcolor);
					OpenMenuMatchlogSettings(client);
				}
				else if (matchlog == 1)
				{
					if(!FileExists(matchlogSettingsKV))		CreateMatchlogSettings();
					matchlog = 2;
					UpdateConfigInt("Admin Settings", "soccer_mod_matchlog", matchlog);
					CPrintToChat(client, "{%s}[%s] {%s}Match Log set to time-based!", prefixcolor, prefix, textcolor);
					OpenMenuMatchlogSettings(client);
				}
				else if (matchlog == 2)
				{
					matchlog = 0;
					UpdateConfigInt("Admin Settings", "soccer_mod_matchlog", matchlog);
					CPrintToChat(client, "{%s}[%s] {%s}Match Log disabled!", prefixcolor, prefix, textcolor);
					OpenMenuMatchlogSettings(client);
				}
			}
			else if (StrEqual(menuItem, "setday"))				OpenMenuMatchlogDays(client);
			else if (StrEqual(menuItem, "starthour"))				
			{
				if(iStarthour < 23 && iStarthour != -1)	iStarthour++;
				else if(iStarthour == -1) iStarthour = 0;
				else iStarthour = -1;

				UpdateMatchlogSet("Starttime", "Hour", iStarthour);
				OpenMenuMatchlogSettings(client);
			}
			else if (StrEqual(menuItem, "startminute"))				
			{
				if(iStartmin < 55 && iStartmin != -1) iStartmin = iStartmin+5;
				else if(iStartmin == -1) iStartmin = 0;
				else iStartmin = -1;

				UpdateMatchlogSet("Starttime", "Minute", iStartmin);
				OpenMenuMatchlogSettings(client);
			}
			else if (StrEqual(menuItem, "stophour"))				
			{
				if(iStophour < 23 && iStophour != -1) iStophour++;
				else if(iStophour == -1) iStophour = 0;
				else iStophour = -1;

				UpdateMatchlogSet("Stoptime", "Hour", iStophour);
				OpenMenuMatchlogSettings(client);
			}
			else if (StrEqual(menuItem, "stopminute"))				
			{
				if(iStopmin < 55 && iStopmin != -1) iStopmin = iStopmin+5;
				else if(iStopmin == -1) iStopmin = 0;
				else iStopmin = -1;		
				UpdateMatchlogSet("Stoptime", "Minute", iStopmin);
				OpenMenuMatchlogSettings(client);
			}
		}

		else if (action == MenuAction_Cancel && choice == -6)	OpenMenuMatchSettings(client);
		else if (action == MenuAction_End)						  menu.Close();
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Can't change the settings during a match.", prefixcolor, prefix, textcolor);
}

public void OpenMenuMatchlogDays(int client)
{
	char activatestring[32];
	char dayarray[7][16] = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};

	Menu menu = new Menu(MenuHandlerMatchlogDays);

	menu.SetTitle("Soccer Mod - Match Log Day Settings");
	
	for(int i=0; i <= 6; i++)
	{
		char day[16];
		Format(day, sizeof(day), "%s", dayarray[i]);
	
		if(ReadMatchlogSet("Days", day) == 0) Format(activatestring, sizeof(activatestring), "[  ] %s", day);
		else Format(activatestring, sizeof(activatestring), "[X] %s", day);
		menu.AddItem(day, activatestring);
	}
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerMatchlogDays(Menu menu, MenuAction action, int client, int choice)
{
	if (!matchStarted)
	{
		if (action == MenuAction_Select)
		{
			char menuItem[16];
			menu.GetItem(choice, menuItem, sizeof(menuItem));

			int value;
			if(ReadMatchlogSet("Days", menuItem) == 0)	value = 1;
			else value = 0;
			UpdateMatchlogSet("Days", menuItem,  value);
			OpenMenuMatchlogDays(client)
		}

		else if (action == MenuAction_Cancel && choice == -6)	OpenMenuMatchlogSettings(client);
		else if (action == MenuAction_End)						  menu.Close();
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Can't change the settings during a match.", prefixcolor, prefix, textcolor);
}

public bool TimeEnabledMatchlog()
{
	char hourstring[16], minutestring[16], weekdaystring[16];
	FormatTime(hourstring, sizeof(hourstring), "%H", GetTime());
	FormatTime(minutestring, sizeof(minutestring), "%M", GetTime());
	FormatTime(weekdaystring, sizeof(weekdaystring), "%A", GetTime());
	int currHour = StringToInt(hourstring);
	int currMin = StringToInt(minutestring);
	
	if(ReadMatchlogSet("Days", weekdaystring) == 1) 
	{
		if(iStarthour <= currHour <= iStophour && (iStarthour != -1 && iStophour != -1))
		{
			if(iStartmin != -1 && iStopmin != -1)
			{
				if(iStarthour == currHour)
				{
					if(iStartmin <= currMin)	return true;
					else PrintToServer("%s is not in time-range", minutestring);
				}
				else if(iStophour == currHour)
				{
					if(currMin <= iStopmin) 	return true;
					else PrintToServer("%s is not in time-range", minutestring);
				}
				else return true;
			}
			else return true;
		}
		else if(iStarthour == -1 || iStophour == -1)
		{
			return true;
		}
		else PrintToServer("%s is not in time-range", hourstring);
	}
	else PrintToServer("%s is not in time-range", weekdaystring);
	
	//PrintToChatAll("Hour: %s, Minute: %s, Day: %s", hourstring, minutestring, weekdaystring);
	
	return false;
}

public int TimeStatus()
{
	int statusvalue = 0;
	int iArray[7];
	char dayarray[7][16] = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
	for(int i=0; i <= 6; i++)
	{
		char day[16];
		Format(day, sizeof(day), "%s", dayarray[i]);
	
		iArray[i] = ReadMatchlogSet("Days", day);
	}
	if(iStopmin == -1 || iStartmin == -1) statusvalue = 1;
	if(iStophour == -1 || iStarthour == -1) statusvalue = 2;
	if((iArray[0]+iArray[1]+iArray[2]+iArray[3]+iArray[4]+iArray[5]+iArray[6] == 7) && (iStarthour == -1 || iStophour == -1)) statusvalue = 3;
	if(((iStophour < iStarthour) && (iStophour != -1 && iStarthour != -1)) || ((iStopmin < iStartmin) && (iStopmin != -1 && iStartmin != -1)))	statusvalue = 4;
	if(iArray[0]+iArray[1]+iArray[2]+iArray[3]+iArray[4]+iArray[5]+iArray[6] == 0) statusvalue = 5;

	return statusvalue;
}

// ************************************** MATCHINFO SETTINGS ***********************************************
public void OpenMenuMatchInfoSet(int client)
{
	kvConfig = new KeyValues("Soccer Mod Config");
	kvConfig.ImportFromFile(configFileKV);
	kvConfig.JumpToKey("Match Info", true);
	
	char MIstring[32], MIstring1[32], MIstring2[32];
	
	Menu menu = new Menu(MenuHandlerMatchInfoSettings);
	menu.SetTitle("Soccer Mod - Match Info Settings");	
	
	int keyValue = kvConfig.GetNum("soccer_mod_period_info", 0);
	Format(MIstring1, sizeof(MIstring1), "Halftime length info")
	if(keyValue) Format(MIstring2, sizeof(MIstring2), "Yes")
	else Format(MIstring2, sizeof(MIstring2), "No")
	Format(MIstring, sizeof(MIstring), "%s: %s", MIstring1, MIstring2);
	menu.AddItem("soccer_mod_period_info", 	MIstring);
		
	keyValue = kvConfig.GetNum("soccer_mod_break_info", 0);
	Format(MIstring1, sizeof(MIstring1), "Break length info")
	if(keyValue) Format(MIstring2, sizeof(MIstring2), "Yes")
	else Format(MIstring2, sizeof(MIstring2), "No")
	Format(MIstring, sizeof(MIstring), "%s: %s", MIstring1, MIstring2);
	menu.AddItem("soccer_mod_break_info", MIstring);
	
	keyValue = kvConfig.GetNum("soccer_mod_golden_info", 0);
	Format(MIstring1, sizeof(MIstring1), "Golden goal info")
	if(keyValue) Format(MIstring2, sizeof(MIstring2), "Yes")
	else Format(MIstring2, sizeof(MIstring2), "No")
	Format(MIstring, sizeof(MIstring), "%s: %s", MIstring1, MIstring2);
	menu.AddItem("soccer_mod_golden_info", MIstring);
	
	keyValue = kvConfig.GetNum("soccer_mod_forfeit_info", 0);
	Format(MIstring1, sizeof(MIstring1), "Forfeit vote info")
	if(keyValue) Format(MIstring2, sizeof(MIstring2), "Yes")
	else Format(MIstring2, sizeof(MIstring2), "No")
	Format(MIstring, sizeof(MIstring), "%s: %s", MIstring1, MIstring2);
	menu.AddItem("soccer_mod_forfeit_info", MIstring);
	
	keyValue = kvConfig.GetNum("soccer_mod_forfeitset_info", 0);
	Format(MIstring1, sizeof(MIstring1), "Forfeit vote settings info")
	if(keyValue) Format(MIstring2, sizeof(MIstring2), "Yes")
	else Format(MIstring2, sizeof(MIstring2), "No")
	Format(MIstring, sizeof(MIstring), "%s: %s", MIstring1, MIstring2);	
	menu.AddItem("soccer_mod_forfeitset_info", MIstring);
	
	keyValue = kvConfig.GetNum("soccer_mod_matchlog_info", 0);
	Format(MIstring1, sizeof(MIstring1), "Matchlog info")
	if(keyValue) Format(MIstring2, sizeof(MIstring2), "Yes")
	else Format(MIstring2, sizeof(MIstring2), "No")
	Format(MIstring, sizeof(MIstring), "%s: %s", MIstring1, MIstring2);
	menu.AddItem("soccer_mod_matchlog_info", MIstring);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);	
	
	kvConfig.GoBack();
	
	kvConfig.Rewind();
	kvConfig.Close();
}

public int MenuHandlerMatchInfoSettings(Menu menu, MenuAction action, int client, int choice)
{
	if (!matchStarted)
	{
		if (action == MenuAction_Select)
		{
			char menuItem[32];
			menu.GetItem(choice, menuItem, sizeof(menuItem));
			
			kvConfig = new KeyValues("Soccer Mod Config");
			kvConfig.ImportFromFile(configFileKV);
			kvConfig.JumpToKey("Match Info", true);
			
			int keyValue = kvConfig.GetNum(menuItem, 0);
			if(keyValue) kvConfig.SetNum(menuItem, 0);
			else kvConfig.SetNum(menuItem, 1);
			
			kvConfig.Rewind();
			kvConfig.ExportToFile(configFileKV);
			kvConfig.Close();
			
			MatchInfoFunction();
			OpenMenuMatchInfoSet(client);
		}
		else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMatchSettings(client);
		else if (action == MenuAction_End)					  menu.Close();
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Can't change the settings during a match.", prefixcolor, prefix, textcolor);
}

public void MatchInfoFunction()
{
	kvConfig = new KeyValues("Soccer Mod Config");
	kvConfig.ImportFromFile(configFileKV);
	kvConfig.JumpToKey("Match Info", true);
	infoPeriods				= kvConfig.GetNum("soccer_mod_period_info", 1);
	infoBreak				= kvConfig.GetNum("soccer_mod_break_info",	1);
	infoGolden				= kvConfig.GetNum("soccer_mod_golden_info", 1);
	infoForfeit				= kvConfig.GetNum("soccer_mod_forfeit_info", 1);
	infoForfeitSet			= kvConfig.GetNum("soccer_mod_forfeitset_info", 0);
	infoMatchlog			= kvConfig.GetNum("soccer_mod_matchlog_info", 0);
	kvConfig.GoBack();
	kvConfig.Rewind();
	kvConfig.Close();

	int infonum;	
	infonum = infoPeriods + infoBreak + infoGolden + infoForfeit + infoForfeitSet + infoMatchlog;
	
	infostring1 = "";
	infostring2 = "";
	
	char halftimestate[32];
	char timestamp[32];
	FormatTime(timestamp, sizeof(timestamp), "%M:%S", matchPeriodLength);
	Format(halftimestate, sizeof(halftimestate), "Halftime length: %s Minutes", timestamp);
		
	char breakstate[32];
	Format(breakstate, sizeof(breakstate), "Break length: %i seconds", matchPeriodBreakLength);
		
	char goldenstate[32];
	if(matchGoldenGoal == 1) goldenstate = "Golden Goal: On";
	else if(matchGoldenGoal == 0) goldenstate = "Golden Goal: Off";
		
	char forfeitstate[32];
	if(ForfeitEnabled == 1 && ForfeitCapMode == 0) forfeitstate = "FF vote: Enabled";
	else if(ForfeitEnabled == 0 && ForfeitCapMode == 0) forfeitstate = "FF vote: Disabled";
	else if(ForfeitEnabled == 0 && ForfeitCapMode == 1) forfeitstate = "FF vote: Cap only (Off)"; 
	else if(ForfeitEnabled == 1 && ForfeitCapMode == 1) forfeitstate = "FF vote: Cap only (On)";
		
	char forfeitsetstate[64];
	char forfeitsetstate2[32];
	if(ForfeitAutoSpec == 0)			forfeitsetstate2 = "OFF"
	else if(ForfeitAutoSpec == 1)		forfeitsetstate2 = "ON"
	Format(forfeitsetstate, sizeof(forfeitsetstate), "FF Condition: %i goals | FF Auto-Spec: %s", ForfeitScore, forfeitsetstate2);
		
	char matchlogstate[32];
	if(matchlog == 1) matchlogstate = "Matchlog: On";
	else if(matchlog == 0) matchlogstate = "Matchlog: Off";
		
	if(infonum > 3)
	{
		char info1[128] = "";
		char info2[128] = "";
		if (infoPeriods == 1)		Format(info1, sizeof(info1), "%s %s |", info1, halftimestate);
		if (infoBreak == 1)			Format(info1, sizeof(info1), "%s %s |", info1, breakstate);
		if (infoGolden == 1)		Format(info1, sizeof(info1), "%s %s |", info1, goldenstate);
		if (infoForfeit == 1)		Format(info2, sizeof(info2), "%s %s |", info2, forfeitstate);
		if (infoForfeitSet == 1)	Format(info2, sizeof(info2), "%s %s |", info2, forfeitsetstate);
		if (infoMatchlog == 1)		Format(info2, sizeof(info2), "%s %s |", info2, matchlogstate);
			
		Format(infostring1, sizeof(infostring1), "%s", info1);
		Format(infostring2, sizeof(infostring2), "%s", info2);
	}
	else 
	{
		char info1[256] = "";
		if (infoPeriods == 1)		Format(info1, sizeof(info1), "%s %s |", info1, halftimestate);
		if (infoBreak == 1)			Format(info1, sizeof(info1), "%s %s |", info1, breakstate);
		if (infoGolden == 1)		Format(info1, sizeof(info1), "%s %s |", info1, goldenstate);
		if (infoForfeit == 1)		Format(info1, sizeof(info1), "%s %s |", info1, forfeitstate);
		if (infoForfeitSet == 1)	Format(info1, sizeof(info1), "%s %s |", info1, forfeitsetstate);
		if (infoMatchlog == 1)		Format(info1, sizeof(info1), "%s %s |", info1, matchlogstate);
			
		Format(infostring1, sizeof(infostring1), "%s", info1);
	}	
}

// **************************************** FORFEIT SETTINGS ***********************************************
public void OpenMenuForfeitSettings(int client)
{
	char FFVstring[32], FFVPstring[32], FFVSstring[32], FFVCstring[32];
	char currentCondition[64];
	
	Menu menu = new Menu(MenuHandlerForfeitSettings);

	menu.SetTitle("Soccer Mod - Forfeit Settings");	
	
	if(ForfeitEnabled == 0 && ForfeitCapMode == 0)			FFVstring = "Forfeit Vote: OFF"
	else if(ForfeitEnabled == 1 && ForfeitCapMode == 0)		FFVstring = "Forfeit Vote: ON"
	else if(ForfeitCapMode == 1)							FFVstring = "Forfeit Vote: CAP ONLY"
	
	if(ForfeitPublic == 0)				FFVPstring = "Availability: Admins only"
	else if(ForfeitPublic == 1)			FFVPstring = "Availability: Everyone"
	
	if(ForfeitAutoSpec == 0)			FFVSstring = "Auto-Spec: OFF"
	else if(ForfeitAutoSpec == 1)		FFVSstring = "Auto-Spec: ON"
	
	if(ForfeitCapMode == 0)				FFVCstring = "Cap only mode: OFF"
	else if(ForfeitCapMode == 1)		FFVCstring = "Cap only mode: ON"
	
	Format(currentCondition, sizeof(currentCondition), "Vote Condition: %i goals", ForfeitScore);
	
	if(ForfeitCapMode == 0) menu.AddItem("forfeittoggle", FFVstring); 
	else if(ForfeitCapMode == 1) menu.AddItem("forfeittoggle", FFVstring, ITEMDRAW_DISABLED); 
	menu.AddItem("forfeitgoals", currentCondition);
	menu.AddItem("forfeitpublic", FFVPstring);
	menu.AddItem("forfeitautospec", FFVSstring);
	menu.AddItem("forfeitcapmode", FFVCstring);
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerForfeitSettings(Menu menu, MenuAction action, int client, int choice)
{
	if (!matchStarted)
	{
		if (action == MenuAction_Select)
		{
			char menuItem[16];
			menu.GetItem(choice, menuItem, sizeof(menuItem));
			
			if(StrEqual(menuItem, "forfeittoggle"))	
			{
				if(ForfeitEnabled == 0)		
				{
					ForfeitEnabled = 1;
					UpdateConfigInt("Forfeit Settings", "soccer_mod_forfeitvote", ForfeitEnabled);
					CPrintToChat(client, "{%s}[%s] {%s}Forfeit vote enabled!", prefixcolor, prefix, textcolor);
					OpenMenuForfeitSettings(client);
				}
				else if(ForfeitEnabled == 1)
				{
					ForfeitEnabled = 0;
					UpdateConfigInt("Forfeit Settings", "soccer_mod_forfeitvote", ForfeitEnabled);
					CPrintToChat(client, "{%s}[%s] {%s}Forfeit vote disabled!", prefixcolor, prefix, textcolor);
					OpenMenuForfeitSettings(client);
				}

			}
			else if(StrEqual(menuItem, "forfeitgoals"))
			{
				CPrintToChat(client, "{%s}[%s] {%s}Type in the required difference on the scoreboard to allow a forfeit vote, 0 to stop.", prefixcolor, prefix, textcolor);
				changeSetting[client] = "ForfeitScoreSet"; //ERROR
			}
			else if(StrEqual(menuItem, "forfeitpublic"))
			{
				if(ForfeitPublic == 0)
				{
					ForfeitPublic = 1;
					UpdateConfigInt("Forfeit Settings", "soccer_mod_forfeitpublic", ForfeitPublic);
					CPrintToChat(client, "{%s}[%s] {%s}Everyone can now start the vote if the conditions are met!", prefixcolor, prefix, textcolor);
					OpenMenuForfeitSettings(client);
				}
				else if(ForfeitPublic == 1)
				{
					ForfeitPublic = 0;
					UpdateConfigInt("Forfeit Settings", "soccer_mod_forfeitpublic", ForfeitPublic);
					CPrintToChat(client, "{%s}[%s] {%s}Only Admins can now start the vote if the conditions are met!", prefixcolor, prefix, textcolor);
					OpenMenuForfeitSettings(client);
				}
			}
			else if(StrEqual(menuItem, "forfeitautospec"))
			{
				if(ForfeitAutoSpec == 0)
				{
					ForfeitAutoSpec = 1;
					UpdateConfigInt("Forfeit Settings", "soccer_mod_forfeitautospec", ForfeitAutoSpec);
					CPrintToChat(client, "{%s}[%s] {%s}Everyone will be put to spectator after a successful forfeit vote.", prefixcolor, prefix, textcolor);
					OpenMenuForfeitSettings(client);
				}
				else if(ForfeitAutoSpec == 1)
				{
					ForfeitAutoSpec = 0;
					UpdateConfigInt("Forfeit Settings", "soccer_mod_forfeitautospec", ForfeitAutoSpec);
					CPrintToChat(client, "{%s}[%s] {%s}Disabled auto-spec after a successful forfeit vote.", prefixcolor, prefix, textcolor);
					OpenMenuForfeitSettings(client);
				}
			}
			else if(StrEqual(menuItem, "forfeitcapmode"))
			{
				if(ForfeitCapMode == 0)
				{
					ForfeitCapMode = 1;
					forfeitHelper = ForfeitEnabled;
					ForfeitEnabled = 0;
					UpdateConfigInt("Forfeit Settings", "soccer_mod_forfeitcapmode", ForfeitCapMode);
					UpdateConfigInt("Forfeit Settings", "soccer_mod_forfeitvote", ForfeitEnabled);
					CPrintToChat(client, "{%s}[%s] {%s}Enabled forfeit vote for cap matches only.", prefixcolor, prefix, textcolor);
					OpenMenuForfeitSettings(client);
				}
				else if(ForfeitCapMode == 1)
				{
					ForfeitCapMode = 0;
					ForfeitEnabled = forfeitHelper;
					UpdateConfigInt("Forfeit Settings", "soccer_mod_forfeitcapmode", ForfeitCapMode);
					UpdateConfigInt("Forfeit Settings", "soccer_mod_forfeitvote", ForfeitEnabled);
					CPrintToChat(client, "{%s}[%s] {%s}Disabled forfeit vote for cap matches only.", prefixcolor, prefix, textcolor);
					OpenMenuForfeitSettings(client);
				}
			}
		}
		
		else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMatchSettings(client);
		else if (action == MenuAction_End)					  menu.Close();
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Can't change the settings during a match.", prefixcolor, prefix, textcolor);
}


// ****************************************** NAME SETTINGS ************************************************

public void OpenMenuNameSettings(int client)
{
	Menu menu = new Menu(MenuHandlerNameSettings);

	menu.SetTitle("Soccer Mod - Name Settings");	
	
	menu.AddItem("matchname_t", "[Match] Change Terrorists Name");
	menu.AddItem("matchname_ct", "[Match] Change CTs Name");
	menu.AddItem("name_t_menu", "[Perm] Change Terrorists Name");
	menu.AddItem("name_ct_menu", "[Perm] Change CTs Name");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerNameSettings(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[16];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	
	int playerNumT, playerNumCT;
	
	playerNumT = GetTeamClientCount(2);
	playerNumCT = GetTeamClientCount(3);
	
	if (!matchStarted)
	{
		if (action == MenuAction_Select)
		{
			if (StrEqual(menuItem, "name_t_menu"))	
			{
				teamIndicator = 2;
				OpenMenuTeamName(client);
			}
			else if (StrEqual(menuItem, "name_ct_menu"))
			{
				teamIndicator = 3;
				OpenMenuTeamName(client);
			}
			else if (StrEqual(menuItem, "matchname_t"))
			{
				teamIndicator = 2;
				if (playerNumT == 0)
				{
					CPrintToChat(client, "{%s}[%s] {%s}No targets found", prefixcolor, prefix, textcolor);
					OpenMenuTeamName(client);
				}
				else if(playerNumT == 1)
				{
					for (tagindex = 1; tagindex <= MaxClients; tagindex++)
					{	
						if (IsClientInGame(tagindex) && IsClientConnected(tagindex) && (GetClientTeam(tagindex) == CS_TEAM_T) && !IsFakeClient(tagindex) && !IsClientSourceTV(tagindex))
						{
							CS_GetClientClanTag(tagindex, tagName, sizeof(tagName));
							//PrintCenterTextAll(tagName);
							if(!(strlen(tagName) > 0))
							{
								CPrintToChat(client, "{%s}[%s] {%s}No targets found.", prefixcolor, prefix, textcolor);
								OpenMenuNameSettings(client);
							}
							else OpenMenuTeamNameList(client, "match");
						}
					}
				}
				else if (playerNumT >= 1)	OpenMenuTeamNameList(client, "match");
			}
			else if (StrEqual(menuItem, "matchname_ct"))
			{
				teamIndicator = 3;
				if (playerNumCT == 0)
				{
					CPrintToChat(client, "{%s}[%s] {%s}No targets found", prefixcolor, prefix, textcolor);
					OpenMenuTeamName(client);
				}
				else if(playerNumCT == 1)
				{
					for (tagindex = 1; tagindex <= MaxClients; tagindex++)
					{	
						if (IsClientInGame(tagindex) && IsClientConnected(tagindex) && (GetClientTeam(tagindex) == CS_TEAM_CT) && !IsFakeClient(tagindex) && !IsClientSourceTV(tagindex))
						{
							CS_GetClientClanTag(tagindex, tagName, sizeof(tagName));
							if(!(strlen(tagName) > 0))
							{
								CPrintToChat(client, "{%s}[%s] {%s}No targets found.", prefixcolor, prefix, textcolor);
								OpenMenuNameSettings(client);
							}
							else OpenMenuTeamNameList(client, "match");
						}
					}
				}
				else if (playerNumCT >= 1) OpenMenuTeamNameList(client, "match");
			}
		}
		
		else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMatchSettings(client);
		else if (action == MenuAction_End)					  menu.Close();
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Can't change the settings during a match.", prefixcolor, prefix, textcolor);
}


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
	if(!matchStarted)
	{
		if (action == MenuAction_Select)
		{
			int playerNumT, playerNumCT;
			//tagCount = GetClientCount(true);
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
					for (tagindex = 1; tagindex <= MaxClients; tagindex++)
					{	
						if (IsClientInGame(tagindex) && IsClientConnected(tagindex) && (GetClientTeam(tagindex) == CS_TEAM_T) && !IsFakeClient(tagindex) && !IsClientSourceTV(tagindex))
						{
							CS_GetClientClanTag(tagindex, tagName, sizeof(tagName));
							//PrintCenterTextAll(tagName);
							if(!(strlen(tagName) > 0))
							{
								CPrintToChat(client, "{%s}[%s] {%s}No targets found.", prefixcolor, prefix, textcolor);
								OpenMenuTeamName(client);
							}
							else OpenMenuTeamNameList(client, "perm");
						}
					}
				}
				else if (playerNumT >= 1)	OpenMenuTeamNameList(client, "perm");
			}
			else if (StrEqual(menuItem, "cust_name_t"))
			{
				CPrintToChat(client, "{%s}[%s] {%s}Type in the name of the Terrorists team, !cancel to stop. Current name is {%s}%s.", prefixcolor, prefix, textcolor, prefixcolor, custom_name_t);
				changeSetting[client] = "CustomNameTeamT";
			}
			else if (StrEqual(menuItem, "def_name_t"))
			{
				custom_name_t = "T";
				UpdateConfig("Match Settings", "soccer_mod_teamnamet", custom_name_t);
				CPrintToChatAll("{%s}[%s] {%s}%N has set the name of the Terrorists to T.", prefixcolor, prefix, textcolor, client);
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
					for (tagindex = 1; tagindex <= MaxClients; tagindex++)
					{	
						if (IsClientInGame(tagindex) && IsClientConnected(tagindex) && (GetClientTeam(tagindex) == CS_TEAM_CT) && !IsFakeClient(tagindex) && !IsClientSourceTV(tagindex))
						{
							CS_GetClientClanTag(tagindex, tagName, sizeof(tagName));
							if(!(strlen(tagName) > 0))
							{
								CPrintToChat(client, "{%s}[%s] {%s}No targets found.", prefixcolor, prefix, textcolor);
								OpenMenuTeamName(client);
							}
							else OpenMenuTeamNameList(client, "perm");
						}
					}
				}
				else if (playerNumCT >= 1) OpenMenuTeamNameList(client, "perm");
			}
			else if (StrEqual(menuItem, "cust_name_ct"))
			{
				CPrintToChat(client, "{%s}[%s] {%s}Type in the name of the Counter-Terrorists team, !cancel to stop. Current name is {%s}%s.", prefixcolor, prefix, textcolor, prefixcolor, custom_name_ct);
				changeSetting[client] = "CustomNameTeamCT";
			}
			else if (StrEqual(menuItem, "def_name_ct"))
			{
				custom_name_ct = "CT";
				UpdateConfig("Match Settings", "soccer_mod_teamnamect", custom_name_ct);
				CPrintToChatAll("{%s}[%s] {%s}%N has set the name of the Counter-Terrorists to CT.", prefixcolor, prefix, textcolor, client);
				OpenMenuTeamName(client);
			}
		}
		else if (action == MenuAction_Cancel && choice == -6)   OpenMenuNameSettings(client);
		else if (action == MenuAction_End)					  menu.Close();
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Can't change the settings during a match.", prefixcolor, prefix, textcolor);
}


public void OpenMenuTeamNameList(int client, char type[8])
{
	//tagCount = GetClientCount(true);
	
	Menu menu
	if (StrEqual(type, "perm"))	menu = new Menu(MenuHandlerTeamMenuList);
	else if (StrEqual(type, "match")) menu = new Menu(MenuHandlerTeamMenuList_Match);	

	if(teamIndicator == 2)
	{
		menu.SetTitle("Select Name for T");

		for (tagindex = 1; tagindex <= MaxClients; tagindex++)
		{	
			if (IsClientInGame(tagindex) && IsClientConnected(tagindex) && (GetClientTeam(tagindex) == CS_TEAM_T) && !IsFakeClient(tagindex) && !IsClientSourceTV(tagindex))
			{
				CS_GetClientClanTag(tagindex, tagName, sizeof(tagName))
				if (strlen(tagName) > 0) menu.AddItem(tagName, tagName)
				else menu.AddItem("", "Empty Tag", ITEMDRAW_DISABLED)
			}
		}
	}
	else if(teamIndicator == 3)
	{	
		menu.SetTitle("Select Name for CT");
		for (tagindex = 1; tagindex <= MaxClients; tagindex++)
		{	
			if (IsClientInGame(tagindex) && IsClientConnected(tagindex) && !IsFakeClient(tagindex) && !IsClientSourceTV(tagindex) && (GetClientTeam(tagindex) == CS_TEAM_CT))
			{
				CS_GetClientClanTag(tagindex, tagName, sizeof(tagName))
				if (strlen(tagName) > 0) menu.AddItem(tagName, tagName)
				else menu.AddItem("", "Empty Tag", ITEMDRAW_DISABLED)
			}
		}
	}

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerTeamMenuList(Menu menu, MenuAction action, int client, int choice)
{
	if(!matchStarted)
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

		else if (action == MenuAction_Cancel && choice == -6)   OpenMenuTeamName(client);
		else if (action == MenuAction_End)					  menu.Close();
		tagindex = 1;
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Can't change the settings during a match.", prefixcolor, prefix, textcolor);
}

public int MenuHandlerTeamMenuList_Match(Menu menu, MenuAction action, int client, int choice)
{
	if(!matchStarted)
	{
		if (action == MenuAction_Select)
		{
			if(teamIndicator == 2)
			{
				default_name_t = custom_name_t;
				menu.GetItem(choice, tagName, sizeof(tagName));
				custom_name_t = tagName;
				CPrintToChatAll("{%s}[%s] {%s}%N has set the name of the Terrorists for this match to %s", prefixcolor, prefix, textcolor, client, tagName);
				OpenMenuNameSettings(client);
			}
			else if(teamIndicator == 3)
			{
				default_name_ct = custom_name_ct;
				menu.GetItem(choice, tagName, sizeof(tagName));
				custom_name_ct = tagName;
				CPrintToChatAll("{%s}[%s] {%s}%N has set the name of the Counter-Terrorists for this match to %s", prefixcolor, prefix, textcolor, client, tagName);
				OpenMenuNameSettings(client);
			}
		}

		else if (action == MenuAction_Cancel && choice == -6)   OpenMenuNameSettings(client);
		else if (action == MenuAction_End)					  menu.Close();
		tagindex = 1;
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Can't change the settings during a match.", prefixcolor, prefix, textcolor);
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
	if(!matchStarted)
	{
		if (action == MenuAction_Select)
		{
			char menuItem[16];
			menu.GetItem(choice, menuItem, sizeof(menuItem));

			if (StrEqual(menuItem, "15Mins"))
			{
				matchPeriodLength = 900;
				UpdateConfigInt("Match Settings", "soccer_mod_match_period_length", matchPeriodLength);
				CPrintToChatAll("{%s}[%s] {%s}Period length was set to %i.", prefixcolor, prefix, textcolor, matchPeriodLength);
				OpenMenuMatchSettings(client);
			}
			else if (StrEqual(menuItem, "10Mins"))
			{
				matchPeriodLength = 600;
				UpdateConfigInt("Match Settings", "soccer_mod_match_period_length", matchPeriodLength);
				CPrintToChatAll("{%s}[%s] {%s}Period length was set to: %i.", prefixcolor, prefix, textcolor, matchPeriodLength);
				OpenMenuMatchSettings(client);
			}
			else if (StrEqual(menuItem, "75Mins"))
			{
				matchPeriodLength = 450;
				UpdateConfigInt("Match Settings", "soccer_mod_match_period_length", matchPeriodLength);
				CPrintToChatAll("{%s}[%s] {%s}Period length was set to: %i.", prefixcolor, prefix, textcolor, matchPeriodLength);
				OpenMenuMatchSettings(client);
			}
			else if (StrEqual(menuItem, "Custom"))
			{
				CPrintToChat(client, "{%s}[%s] {%s}Type a value for the period length, 0 to stop. Current value is %i.", prefixcolor, prefix, textcolor, matchPeriodLength);
				changeSetting[client] = "CustomPeriodLength";
			}
		}
		else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMatchSettings(client);
		else if (action == MenuAction_End)					  menu.Close();
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Can't change the settings during a match.", prefixcolor, prefix, textcolor);
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
	if(!matchStarted)
	{
		if (action == MenuAction_Select)
		{
			char menuItem[16];
			menu.GetItem(choice, menuItem, sizeof(menuItem));

			if (StrEqual(menuItem, "FullMin"))
			{
				matchPeriodBreakLength = 60;
				UpdateConfigInt("Match Settings", "soccer_mod_match_period_break_length", matchPeriodBreakLength);
				CPrintToChatAll("{%s}[%s] {%s}Break length was set to: %i.", prefixcolor, prefix, textcolor, matchPeriodBreakLength);
				OpenMenuMatchSettings(client);
			}
			else if (StrEqual(menuItem, "HalfMin"))
			{
				matchPeriodBreakLength = 30;
				UpdateConfigInt("Match Settings", "soccer_mod_match_period_break_length", matchPeriodBreakLength);
				CPrintToChatAll("{%s}[%s] {%s}Break length was set to: %i.", prefixcolor, prefix, textcolor, matchPeriodBreakLength);
				OpenMenuMatchSettings(client);
			}
			else if (StrEqual(menuItem, "QuartMin"))
			{
				matchPeriodBreakLength = 15;
				UpdateConfigInt("Match Settings", "soccer_mod_match_period_break_length", matchPeriodBreakLength);
				CPrintToChatAll("{%s}[%s] {%s}Break length was set to: %i.", prefixcolor, prefix, textcolor, matchPeriodBreakLength);
				OpenMenuMatchSettings(client);
			}
			else if (StrEqual(menuItem, "5Secs"))
			{
				matchPeriodBreakLength = 5;
				UpdateConfigInt("Match Settings", "soccer_mod_match_period_break_length", matchPeriodBreakLength);
				CPrintToChatAll("{%s}[%s] {%s}Break length was set to: %i.", prefixcolor, prefix, textcolor, matchPeriodBreakLength);
				OpenMenuMatchSettings(client);
			}
			else if (StrEqual(menuItem, "Custom"))
			{
				CPrintToChat(client, "{%s}[%s] {%s}Type a value for the break length, 0 to stop. Current value is %i.", prefixcolor, prefix, textcolor, matchPeriodBreakLength);
				changeSetting[client] = "CustomPeriodBreakLength";
			}

		}
		else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMatchSettings(client);
		else if (action == MenuAction_End)					  menu.Close();
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Can't change the settings during a match.", prefixcolor, prefix, textcolor);
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
	if(!matchStarted)
	{
		if (action == MenuAction_Select)
		{
			char menuItem[16];
			menu.GetItem(choice, menuItem, sizeof(menuItem));

			if (StrEqual(menuItem, "EnableGolden"))
			{
				matchGoldenGoal = 1;
				UpdateConfigInt("Match Settings", "soccer_mod_match_golden_goal", matchGoldenGoal);
				CPrintToChat(client, "{%s}[%s] {%s}Golden Goal was enabled.", prefixcolor, prefix, textcolor);
				OpenMenuMatchSettings(client);
			}
			else if (StrEqual(menuItem, "DisableGolden"))
			{
				matchGoldenGoal = 0;
				UpdateConfigInt("Match Settings", "soccer_mod_match_golden_goal", matchGoldenGoal);
				CPrintToChat(client, "{%s}[%s] {%s}Golden Goal was disabled.", prefixcolor, prefix, textcolor);
				OpenMenuMatchSettings(client);
			}

		}
		else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMatchSettings(client);
		else if (action == MenuAction_End)					  menu.Close();
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Can't change the settings during a match.", prefixcolor, prefix, textcolor);
}

// ***********************************************************************************************************************
// ************************************************** COMMAND LISTENERS **************************************************
// ***********************************************************************************************************************
public void MatchSet(int client, char type[32], int intnumber, int min, int max)
{
	if (intnumber >= min && intnumber <= max || intnumber == 0)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

		if (StrEqual(type, "CustomPeriodBreakLength"))
		{
			if(intnumber != 0)
			{
				matchPeriodBreakLength = intnumber;
				UpdateConfigInt("Match Settings", "soccer_mod_match_period_break_length", matchPeriodBreakLength);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the break length to %i.", prefixcolor, prefix, textcolor, client, intnumber);
				}

				LogMessage("%N <%s> has set the break length to %i", client, steamid, intnumber);
				
				changeSetting[client] = "";
				OpenMenuMatchSettings(client);

			}
			else 
			{
				OpenMenuMatchBreak(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		else if (StrEqual(type, "CustomPeriodLength"))
		{
			if(intnumber != 0)
			{
				matchPeriodLength = intnumber;
				UpdateConfigInt("Match Settings", "soccer_mod_match_period_length", matchPeriodLength);
				
				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the match period length to %i.", prefixcolor, prefix, textcolor, client, intnumber);
				}

				LogMessage("%N <%s> has set the period length to %i", client, steamid, intnumber);
				
				changeSetting[client] = "";
				OpenMenuMatchSettings(client);
			}
			else 
			{
				OpenMenuMatchPeriod(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Type a value between %i and %i.", prefixcolor, prefix, textcolor, min, max);
}

public void ForfeitSet(int client, char type[32], int intnumber, int min, int max)
{
	if (intnumber >= min && intnumber <= max || intnumber == 0)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

		if (StrEqual(type, "ForfeitScoreSet"))
		{
			if(intnumber != 0)
			{
				ForfeitScore = intnumber;
				UpdateConfigInt("Forfeit Settings", "soccer_mod_forfeitscore", ForfeitScore);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the forfeit vote condition to %i goals difference.", prefixcolor, prefix, textcolor, client, intnumber);
				}

				LogMessage("%N <%s> has set the forfeit vote condition to %i", client, steamid, intnumber);
			}
			else 
			{
				OpenMenuForfeitSettings(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}

		changeSetting[client] = "";
		OpenMenuForfeitSettings(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Type a value between %i and %i.", prefixcolor, prefix, textcolor, min, max);	
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
			if(!StrEqual(custom_teamname, "!cancel"))
			{
				custom_name_t = custom_teamname;
				UpdateConfig("Match Settings", "soccer_mod_teamnamet", custom_name_t);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the name of the Terrorists to: {%s}%s.", prefixcolor, prefix, textcolor, client, prefixcolor, custom_teamname);
				}

				LogMessage("%N <%s> has set the name of the terrorists to %s", client, steamid, custom_teamname);
			}
			else 
			{
				OpenMenuTeamName(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		if (StrEqual(type, "CustomNameTeamCT"))
		{
			if(!StrEqual(custom_teamname, "!cancel"))
			{
				custom_name_ct = custom_teamname;
				UpdateConfig("Match Settings", "soccer_mod_teamnamect", custom_name_ct);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the name of the Counter-Terrorists to: {%s}%s.", prefixcolor, prefix, textcolor, client, prefixcolor, custom_teamname);
				}

				LogMessage("%N <%s> has set the name of the counter-terrorists to %s", client, steamid, custom_teamname)
			}
			else 
			{
				OpenMenuTeamName(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}

		changeSetting[client] = "";
		OpenMenuTeamName(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Type a value between %i and %i.", prefixcolor, prefix, textcolor, min, max);
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

			float minbounds[3]
			float maxbounds[3]
			if(xorientation)
			{
				float xminbounds[3] = {-2000.0, -1.0, -10.0};
				float xmaxbounds[3] = {2000.0, 1.0, 5000.0};
				
				minbounds = xminbounds;
				maxbounds = xmaxbounds;
			}
			else
			{
				float yminbounds[3] = {-1.0, -2000.0, -10.0};
				float ymaxbounds[3] = {1.0, 2000.0, 5000.0};
				
				minbounds = yminbounds;
				maxbounds = ymaxbounds;
			}
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

	if (matchPeriods > 2) 
	{
		matchTimerMessage = "Period break: ";
		HostName_Change_Status("Periodbreak");
	}
	else 
	{
		matchTimerMessage = "Half time: ";
		HostName_Change_Status("Halftime");
	}
	
	HostName_Change_Status("Halftime");

	char timeString[16];
	getTimeString(timeString, time);
	PrintHintTextToAll("%s %s %i - %i %s | %s", matchTimerMessage, custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString);

	if (time < 1)
	{
		matchPeriodBreak = false;
		matchLastScored = 0;

		ServerCommand("mp_restartgame 1");
		KillMatchTimer();
		
		HostName_Change_Status("Match");

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
	
	HostName_Change_Status("Match");
	
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
		PlaySound("buttons/button17.wav");
	}
	else if (time == 1)
	{
		PrintHintTextToAll("Unpausing in %i second", time);
		PrintCenterTextAll("Unpausing in %i second", time);
		PlaySound("buttons/button17.wav");
	}

	if (time < 1)
	{
		UnfreezeAll();
		PrintCenterTextAll("");
		PlaySound("soccermod/whistle.wav");

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

public Action DelayMatchEnd(Handle timer)
{
	char timeString[16];
	getTimeString(timeString, matchTime);
	
	HostName_Change_Status("Reset");
	
	PlaySound("soccermod/endmatch.wav");

	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player))
		{
			PrintHintText(player, "%s: %s %i - %i %s | %s", "Goal scored", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t, timeString);
			CPrintToChat(player, "{%s}[%s] {%s} %s: %s %i - %i %s", prefixcolor, prefix, textcolor, "Final score", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t);
		}
	}

	LogMessage("Final score: %s %i - %i %s", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t);

	ShowManOfTheMatch();
	MatchReset();
	NameReset();
	ForfeitReset();
	ServerCommand("mp_restartgame 5");
}

// ***************************************************************************************************************
// ************************************************** FUNCTIONS **************************************************
// ***************************************************************************************************************
public void MatchReset()
{
	matchGoldenGoalActive		= false;
	matchStarted				= false;
	matchKickOffTaken			= false;
	matchPaused					= false;
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

public void NameReset()
{
	HostName_Change_Status("Reset");
	
	if (!(StrEqual(default_name_ct, custom_name_ct))) 	
	{
		if(!(StrEqual(default_name_ct, "")))
		{
			custom_name_ct = default_name_ct;
			default_name_ct = "";
		}
	}
	if (!(StrEqual(default_name_t, custom_name_t)))		
	{
		if(!(StrEqual(default_name_t, "")))
		{
			custom_name_t = default_name_t;	
			default_name_t = "";
		}
	}
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
		matchStart = true;
		matchKickOffTaken = true;
		matchToss = GetRandomInt(2, 3);

		MatchInfoFunction();
		int infonum;	
		infonum = infoPeriods + infoBreak + infoGolden + infoForfeit + infoForfeitSet + infoMatchlog;

		if (matchPeriodLength != 900) cdTime = float(matchPeriodLength/2);
		if (ForfeitRRCheck == true) ffRRCheckTimer = CreateTimer(120.0, RRCheckTimer);
				
		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has started a match", prefixcolor, prefix, textcolor, client);
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%s (CT) will face %s (T)", prefixcolor, prefix, textcolor, custom_name_ct, custom_name_t);
			if (IsClientInGame(player) && IsClientConnected(player))
			{
				if((infonum != 0) && (infonum <= 3)) 
				{
					CPrintToChat(player, "{fullred}[MatchInfo] %s", infostring1);
				}
				else if((infonum != 0) && (infonum > 3))
				{
					CPrintToChat(player, "{fullred}[MatchInfo] %s", infostring1);
					CPrintToChat(player, "{fullred}[MatchInfo] %s", infostring2);
				}
			}			
		}

		if(passwordlock == 1 && pwchange == true)
		{
			pwchange = false;		
			AFKKickStop();
			ResetPass();
			CPrintToChatAll("{%s}[%s] {%s}Server password reset to default value.", prefixcolor, prefix, textcolor);
		}
		
		RenameMatchLog();		
		if(matchlog == 1) 
		{
			SaveLogsOnMatchStart();
			CreateMatchLog(custom_name_ct, custom_name_t);
		}
		if(matchlog == 2)
		{
			if(TimeEnabledMatchlog())
			{
				SaveLogsOnMatchStart();
				CreateMatchLog(custom_name_ct, custom_name_t);
			}
		}
		
		HostName_Change_Status("Match");

		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		LogMessage("%N <%s> has started a match", client, steamid);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Match already started.", prefixcolor, prefix, textcolor);
}

public void MatchPause(int client)
{
	if (matchStarted)
	{
		if (!matchPaused)
		{
			pauseRdyTimer = CreateTimer(0.0, pauseReadyTimer);
			
			matchPaused = true;

			PlaySound("soccermod/whistle.wav");

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has paused the match", prefixcolor, prefix, textcolor, client);
			}

			if (!matchPeriodBreak)
			{
				FreezeAll();
				KillMatchTimer();
				matchTimer = CreateTimer(0.0, MatchDisplayTimerMessage);
				
				if(matchReadyCheck == 2 || matchReadyCheck == 1)
				{
					showPanel = true;
					
					for (int i = 1; i <= MaxClients; i++)
					{
						if (IsValidClient(i) && GetClientTeam(i) > 1)		
						{
							pauseplayernum++;
							OpenReadyPanel(i);
							CPrintToChat(i, "{%s}[%s] {%s}Menu missing? Type !rdy to display the menu again.", prefixcolor, prefix, textcolor);
						}
					}
				}
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
			ClearTimer(pauseRdyTimer); //KillPauseReadyTimer();
			CPrintToChatAll("{%s}[%s] {%s}Match was paused for %s minutes", prefixcolor, prefix, textcolor, totalpausetime);
			matchPaused = false;
			showPanel = false;	
			pauseplayernum = 0;
			
			if (!matchPeriodBreak)
			{
				KillMatchTimer();
				matchTimer = CreateTimer(0.0, MatchUnpauseCountdown, 5);				
			}

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has unpaused the match", prefixcolor, prefix, textcolor, client);
			}
			
			if(FileExists(tempReadyFileKV)) DeleteTempFile();
			
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
		if(matchPaused) 
		{
			ClearTimer(pauseRdyTimer); //KillPauseReadyTimer();
			showPanel = false;
		}
		MatchReset();
		NameReset();
		UnfreezeAll();

		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has stopped the match", prefixcolor, prefix, textcolor, client);
		}

		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		LogMessage("%N <%s> has stopped the match", client, steamid);
		
		ForfeitReset();
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
			PlaySound("soccermod/halftime.wav"); 
			
			PrintCenterTextAll("Halftime break");
			
			FreezeAll();
			matchTimer = CreateTimer(0.0, MatchPeriodBreakTimer, matchPeriodBreakLength);
		}
		else
		{
			if (matchGoldenGoal && matchScoreCT == matchScoreT)
			{
				matchGoldenGoalActive = true;
				matchToss = GetRandomInt(2, 3);
				PlaySound("soccermod/halftime.wav");

				FreezeAll();
				
				HostName_Change_Status("Golden");

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}The match ended in a draw and will continue with a golden goal", prefixcolor, prefix, textcolor);
				}

				ServerCommand("mp_restartgame 5");
			}
			else
			{

				PlaySound("soccermod/endmatch.wav");

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player))
					{
						CPrintToChat(player, "{%s}[%s] {%s}%s: %s %i - %i %s", prefixcolor, prefix, textcolor, "Final score", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t);
					}
				}

				LogMessage("Final score: %s %i - %i %s", custom_name_ct, matchScoreCT, matchScoreT, custom_name_t);

				ShowManOfTheMatch();
				MatchReset();
				NameReset();
				ForfeitReset();
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

public Action RRCheckTimer(Handle timer)
{
	ForfeitRRCheck = false;
}

public Action matchStartTimer(Handle timer)
{
	matchStart = false;
}