// *******************************************************************************************************************
// ************************************************** GET DATA *******************************************************
// *******************************************************************************************************************

public void KVGetEvent(Menu menu)
{
	char  timeString[16], scoreString[32], scorerString[128], assisterString[128], menuString[128];
	getTimeString(timeString, matchTime);
	Format(scoreString, sizeof(scoreString), "%i:%i", matchScoreCT, matchScoreT);		
	showcards = false;
	
	LeagueMatchKV = new KeyValues("Match Log")
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	char buffer[sizeof(scorerString)];
	char pattern[] =  "([(U:\\d:[\\d]+])";
	Regex regex = CompileRegex(pattern);
	
	LeagueMatchKV.JumpToKey("Scoresheet", false);
	if(LeagueMatchKV.GotoFirstSubKey())
	{	
		
		do
		{
			LeagueMatchKV.GetSectionName(scoreString, sizeof(scoreString));
			LeagueMatchKV.GetString(kvTime, timeString, sizeof(timeString));
			LeagueMatchKV.GetString(kvScorer, scorerString, sizeof(scorerString));
			if (MatchRegex(regex, scorerString) > 0)
			{
				GetRegexSubString(regex, 0, buffer, sizeof(buffer));
				ReplaceString(scorerString, sizeof(scorerString), buffer, "",false);
			}
			LeagueMatchKV.GetString(kvAssister, assisterString, sizeof(assisterString), "No Assist");
			if (MatchRegex(regex, assisterString) > 0)
			{
				GetRegexSubString(regex, 0, buffer, sizeof(buffer));
				ReplaceString(assisterString, sizeof(assisterString), buffer, "",false);
			}
			
			Format(menuString, sizeof(menuString), "[%s] %s G: %s A: %s", timeString, scoreString, scorerString, assisterString);
			
			PushArrayString(logmenuArray, menuString);
			//menu.AddItem(timeString, menuString, ITEMDRAW_DISABLED);
		}
		while (LeagueMatchKV.GotoNextKey());
	}
	LeagueMatchKV.Rewind();
	
	// IF card is given add menu "Card log"
	// add stuff to menuCards (new menu)
	if(LeagueMatchKV.JumpToKey("Cards", false))
	{
		if(LeagueMatchKV.GotoFirstSubKey()) 	showcards = true;
		else showcards = false;
	}
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.Close();
}

public void KVGetCards(Menu menu)
{
	char  timeString[16], cardString2[32], scorerString[128], menuString[128];
	getTimeString(timeString, matchTime);	
	
	LeagueMatchKV = new KeyValues("Match Log")
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	if(LeagueMatchKV.JumpToKey("Cards", false))
	{
		LeagueMatchKV.GotoFirstSubKey();
		
		do
		{
			LeagueMatchKV.GetSectionName(timeString, sizeof(timeString));
			LeagueMatchKV.GetString(kvCard, cardString2, sizeof(cardString2));
			LeagueMatchKV.GetString(kvPlayer, scorerString, sizeof(scorerString));
			
			Format(menuString, sizeof(menuString), "[%s] %s for %s", timeString, cardString2, scorerString);
			menu.AddItem(timeString, menuString, ITEMDRAW_DISABLED);
		}
		while (LeagueMatchKV.GotoNextKey() );
		LeagueMatchKV.GoBack();
	}
	LeagueMatchKV.Rewind();
	LeagueMatchKV.Close();
}

// *******************************************************************************************************************
// ************************************************* REF ACTIONS *****************************************************
// *******************************************************************************************************************

public void KVAddScore()
{
	char timeString[16], scoreString[32];
	getTimeString(timeString, matchTime);
		
	matchScoreCT = CS_GetTeamScore(3);
	matchScoreT = CS_GetTeamScore(2);
	Format(scoreString, sizeof(scoreString), "%i:%i", matchScoreCT, matchScoreT);
	
	LeagueMatchKV = new KeyValues("Match Log");
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	LeagueMatchKV.JumpToKey("Scoresheet", true);
	LeagueMatchKV.JumpToKey(scoreString, true);
	LeagueMatchKV.SetString(kvTime,	timeString);
	LeagueMatchKV.SetString(kvScorer, "Added by Referee");
	LeagueMatchKV.SetString(kvAssister, statsAssisterName);
	LeagueMatchKV.GoBack();
	LeagueMatchKV.GoBack();
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.ExportToFile(matchlogKV);
	LeagueMatchKV.Close();	
}

public void KVRemoveScore()
{
	char timeString[16], scoreString[32];
	getTimeString(timeString, matchTime);
	
	matchScoreCT = CS_GetTeamScore(3);
	matchScoreT = CS_GetTeamScore(2);
	Format(scoreString, sizeof(scoreString), "%i:%i", matchScoreCT, matchScoreT);
	
	LeagueMatchKV = new KeyValues("Match Log");
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	LeagueMatchKV.JumpToKey("Goals", false);
	if(LeagueMatchKV.JumpToKey(scoreString, false))	LeagueMatchKV.DeleteThis();
	LeagueMatchKV.GoBack();
	LeagueMatchKV.GoBack();
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.ExportToFile(matchlogKV);
	LeagueMatchKV.Close();	
}

// *******************************************************************************************************************
// ************************************************* SAVE DATA *******************************************************
// *******************************************************************************************************************

public void KVSaveEvent(char scoreid[32], char scorerName[MAX_NAME_LENGTH], char assistid[32], char assisterName[MAX_NAME_LENGTH], int scorerclient, int assisterclient)
{
	char timeString[16];
	char scoreString[32];
	char scorerString[128], assisterString[128];
	getTimeString(timeString, matchTime);
	Format(scoreString, sizeof(scoreString), "%i:%i", matchScoreCT, matchScoreT);

	LeagueMatchKV = new KeyValues("Match Log");
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	LeagueMatchKV.JumpToKey("Scoresheet", true);
	LeagueMatchKV.JumpToKey(scoreString, true);
	LeagueMatchKV.SetString(kvTime,	timeString);
	Format(scorerString, sizeof(scorerString), "%s %s", scorerName, scoreid);
	LeagueMatchKV.SetString(kvScorer, scorerString);
	if(assisterclient != 0)
	{
		if(GetClientTeam(scorerclient) == GetClientTeam(assisterclient)) 
		{
			if(!StrEqual(assisterName, "Owngoal")) 
			{
				Format(assisterString, sizeof(assisterString), "%s %s", assisterName, assistid); 
				LeagueMatchKV.SetString(kvAssister, assisterString);
			}
			else LeagueMatchKV.SetString(kvAssister, assisterName);
		}
		else 
		{
			if(StrEqual(assisterName, "Owngoal")) 
			{
				assisterclient = 0;
				assistid = "";
				LeagueMatchKV.SetString(kvAssister, assisterName);
			}
			else
			{
				assisterName = "";
				assisterclient = 0;
				assistid = "";
			}
		}
	}
	else if(StrEqual(assisterName, "Owngoal")) LeagueMatchKV.SetString(kvAssister, assisterName);
	
	LeagueMatchKV.GoBack();
	LeagueMatchKV.GoBack();
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.ExportToFile(matchlogKV);
	LeagueMatchKV.Close();
	
	//save overview stuff
	KVSaveOverview(scorerName, assisterName, scoreid, assistid, scorerclient, assisterclient);
}

public void KVSaveCard()
{
	char timeString[16];
	getTimeString(timeString, matchTime);
	
	LeagueMatchKV = new KeyValues("Match Log");
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	LeagueMatchKV.JumpToKey("Cards", true);
	LeagueMatchKV.JumpToKey(timeString, true);
	LeagueMatchKV.SetString(kvCard,	cardString);
	LeagueMatchKV.SetString(kvPlayer, cardReceiver);
	LeagueMatchKV.GoBack();
	LeagueMatchKV.GoBack();
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.ExportToFile(matchlogKV);
	LeagueMatchKV.Close();
}

public void KVSaveOverview(char scorerName[MAX_NAME_LENGTH], char assisterName[MAX_NAME_LENGTH], char scoreid[32], char assistid[32], int scorerclient, int assisterclient)
{
	int goals = 0;
	int assists = 0;
	int owngoals = 0;
	
	LeagueMatchKV = new KeyValues("Match Log");
	//SetEscapeSequences(true) 
	//Sets whether or not the KeyValues parser will read escape sequences. For example, \n would be read as a literal newline. This defaults to false for new KeyValues structures.
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	LeagueMatchKV.JumpToKey("Playerstats", true);
	
	//Create Key if it doesnt exist
	if(!LeagueMatchKV.JumpToKey(scoreid, false))
	{
		LeagueMatchKV.JumpToKey(scoreid, true);
		LeagueMatchKV.SetString(kvName, scorerName);
		LeagueMatchKV.SetNum(kvGoals, 0);
		LeagueMatchKV.SetNum(kvAssists, 0);
		LeagueMatchKV.SetNum(kvOwngoals, 0);
	}
	LeagueMatchKV.GoBack();
	if(!StrEqual(assisterName, "") && !LeagueMatchKV.JumpToKey(assistid, false))
	{
		LeagueMatchKV.JumpToKey(assistid, true);
		LeagueMatchKV.SetString(kvName, assisterName);
		LeagueMatchKV.SetNum(kvGoals, 0);
		LeagueMatchKV.SetNum(kvAssists, 0);
		LeagueMatchKV.SetNum(kvOwngoals, 0);
	}
	
	LeagueMatchKV.GoBack();
	LeagueMatchKV.Rewind();
	
	LeagueMatchKV.JumpToKey("Playerstats", true);
	
	LeagueMatchKV.JumpToKey(scoreid, true);
	if(!StrEqual(assisterName, "Owngoal"))
	{
		goals = LeagueMatchKV.GetNum(kvGoals);
		goals++;
		LeagueMatchKV.SetNum(kvGoals, goals);

		if(!CheckPlayerNames(scorerclient, scorerName)) //if there is no match in the array
		{
			iPlayerNames[scorerclient]++;
			Format(PlayerNames[scorerclient][iPlayerNames[scorerclient]], sizeof(PlayerNames[][]), scorerName); //add the new name to the array
		}
		LeagueMatchKV.SetString("Other Names:", GetNames(scorerclient));
	}
	else
	{
		owngoals = LeagueMatchKV.GetNum(kvOwngoals);
		owngoals++
		LeagueMatchKV.SetNum(kvOwngoals, owngoals);
			
		if(!CheckPlayerNames(scorerclient, scorerName)) //if there is no match in the array
		{
			iPlayerNames[scorerclient]++;
			Format(PlayerNames[scorerclient][iPlayerNames[scorerclient]], sizeof(PlayerNames[][]), scorerName); //add the new name to the array
		}
		LeagueMatchKV.SetString("Other Names:", GetNames(scorerclient));
	}
	LeagueMatchKV.GoBack();
	
	if(!StrEqual(assistid, "") && !StrEqual(assisterName, "Owngoal") && (GetClientTeam(scorerclient) == GetClientTeam(assisterclient)))
	{
		LeagueMatchKV.JumpToKey(assistid,true);

		assists = LeagueMatchKV.GetNum(kvAssists);
		assists++;
		LeagueMatchKV.SetNum(kvAssists, assists);
			
		if(!CheckPlayerNames(assisterclient, assisterName)) //if there is no match in the array
		{
			iPlayerNames[assisterclient]++;
			Format(PlayerNames[assisterclient][iPlayerNames[assisterclient]], sizeof(PlayerNames[][]), assisterName); //add the new name to the array
		}
		LeagueMatchKV.SetString("Other Names:", GetNames(assisterclient));
	}
	LeagueMatchKV.GoBack();
		
	LeagueMatchKV.Rewind();
	LeagueMatchKV.ExportToFile(matchlogKV);
	LeagueMatchKV.Close();
}

static stock bool CheckPlayerNames(int client, const char[] name)
{
    for(int i = 0; i < MAX_NAMES; i++)
    {
        if(StrEqual(name, PlayerNames[client][i])) return true;
    }

    return false;
}

static stock char GetNames(int client)
{
    char output[(MAX_NAME_LENGTH*MAX_NAMES)+1]; //just to make sure the size will be enough
    for(int i = 0; i <= iPlayerNames[client]; i++)
    {
        if(i == 1) Format(output, sizeof(output), "%s", PlayerNames[client][i]);
        else Format(output, sizeof(output), "%s | %s", output, PlayerNames[client][i]);
    }

    return output;
}

// *******************************************************************************************************************
// ************************************************* CREATE LOG ******************************************************
// *******************************************************************************************************************

public void CreateMatchLog(char CTname[32], char Tname[32])
{
	char teamsString[128]
	Format(teamsString, sizeof(teamsString), "%s_vs_%s", CTname, Tname);
	LeagueMatchKV = new KeyValues("Match Log");
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	LeagueMatchKV.JumpToKey(teamsString, true);
	LeagueMatchKV.SetString("CT", CTname);
	LeagueMatchKV.SetString("T", Tname);
	LeagueMatchKV.GoBack();
	LeagueMatchKV.JumpToKey("Scoresheet", true);
	LeagueMatchKV.SetString("0:0", "");
	LeagueMatchKV.GoBack();
	LeagueMatchKV.JumpToKey("Cards", true);
	LeagueMatchKV.SetString("00:00", "");
	LeagueMatchKV.GoBack();
	LeagueMatchKV.JumpToKey("Playerstats", true);
	LeagueMatchKV.SetString("Playername", "");
	LeagueMatchKV.GoBack();
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.ExportToFile(matchlogKV);
	LeagueMatchKV.Close();
}

// *******************************************************************************************************************
// ************************************************* RENAME LOG ******************************************************
// *******************************************************************************************************************

public void RenameMatchLog()
{
	char logpath[PLATFORM_MAX_PATH], stampString[64], teamsString[128];

	LeagueMatchKV = new KeyValues("Match Log");
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	LeagueMatchKV.GotoFirstSubKey();
	LeagueMatchKV.GetSectionName(teamsString, sizeof(teamsString));
	LeagueMatchKV.GoBack();
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.Close();	
	
	FormatTime(stampString, sizeof(stampString), "%d%m%y_%H%M", GetFileTime(matchlogKV, FileTime_LastChange));
	
	int ErrorPos = FindCharInString(teamsString, '|');
	if(ErrorPos != -1) strcopy(teamsString[ErrorPos], sizeof(teamsString) - ErrorPos, teamsString[ErrorPos+1]);
	ErrorPos = FindCharInString(teamsString, '\\');
	if(ErrorPos != -1) strcopy(teamsString[ErrorPos], sizeof(teamsString) - ErrorPos, teamsString[ErrorPos+1]);
	ErrorPos = FindCharInString(teamsString, '/');
	if(ErrorPos != -1) strcopy(teamsString[ErrorPos], sizeof(teamsString) - ErrorPos, teamsString[ErrorPos+1]);
	ErrorPos = FindCharInString(teamsString, ':');
	if(ErrorPos != -1) strcopy(teamsString[ErrorPos], sizeof(teamsString) - ErrorPos, teamsString[ErrorPos+1]);
	ErrorPos = FindCharInString(teamsString, '\"');
	if(ErrorPos != -1) strcopy(teamsString[ErrorPos], sizeof(teamsString) - ErrorPos, teamsString[ErrorPos+1]);
	ErrorPos = FindCharInString(teamsString, '?');
	if(ErrorPos != -1) strcopy(teamsString[ErrorPos], sizeof(teamsString) - ErrorPos, teamsString[ErrorPos+1]);
	ErrorPos = FindCharInString(teamsString, '<');
	if(ErrorPos != -1) strcopy(teamsString[ErrorPos], sizeof(teamsString) - ErrorPos, teamsString[ErrorPos+1]);
	ErrorPos = FindCharInString(teamsString, '>');
	if(ErrorPos != -1) strcopy(teamsString[ErrorPos], sizeof(teamsString) - ErrorPos, teamsString[ErrorPos+1]);
	
	Format(logpath, sizeof(logpath), "cfg/sm_soccermod/logs/match_%s_%s.txt", teamsString, stampString); 
	
	if(FileExists(matchlogKV) && (matchlog == 1)) RenameFile(logpath, matchlogKV, false);

	DeleteFile(matchlogKV, false);
}