char kvTime[32] = "Time:";
char kvScorer[32] = "Scorer:";
char kvAssister[32] = "Assister:";
char kvCard[32] = "Card:";
char kvPlayer[32] = "Player:";
char kvName[32] = "Name:";
char kvGoals[32] = "Goals:";
char kvAssists[32] = "Assists:";
char kvOwngoals[32] = "Owngoals:";

// *******************************************************************************************************************
// ************************************************** GET DATA *******************************************************
// *******************************************************************************************************************

public void KVGetEvent(Menu menu)
{
	char timeString[16];
	char scoreString[32], scorerString[32], assisterString[32], cardString2[32], menuString[128];
	getTimeString(timeString, matchTime);
	Format(scoreString, sizeof(scoreString), "%i:%i", matchScoreCT, matchScoreT);		
	
	LeagueMatchKV = new KeyValues("Match Log")
	LeagueMatchKV.ImportFromFile(matchlogKV);
	//LeagueMatchKV.GotoFirstSubKey();
	//LeagueMatchKV.GotoNextKey();
	
	LeagueMatchKV.JumpToKey("Scoresheet", false);
	LeagueMatchKV.GotoFirstSubKey();
	
	do
	{
		LeagueMatchKV.GetSectionName(scoreString, sizeof(scoreString));
		LeagueMatchKV.GetString(kvTime, timeString, sizeof(timeString));
		LeagueMatchKV.GetString(kvScorer, scorerString, sizeof(scorerString));
		LeagueMatchKV.GetString(kvAssister, assisterString, sizeof(assisterString), "No Assist");
		
		Format(menuString, sizeof(menuString), "[%s] %s G: %s A: %s", timeString, scoreString, scorerString, assisterString);
		menu.AddItem(timeString, menuString, ITEMDRAW_DISABLED);
	}
	while (LeagueMatchKV.GotoNextKey());
	LeagueMatchKV.Rewind();
	
	// IF card is given
	menu.AddItem("", "###################", ITEMDRAW_DISABLED);
	
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
	getTimeString(timeString, matchTime);
	Format(scoreString, sizeof(scoreString), "%i:%i", matchScoreCT, matchScoreT);

	LeagueMatchKV = new KeyValues("Match Log");
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	LeagueMatchKV.JumpToKey("Scoresheet", true);
	LeagueMatchKV.JumpToKey(scoreString, true);
	LeagueMatchKV.SetString(kvTime,	timeString);
	LeagueMatchKV.SetString(kvScorer, scorerName); //statsScorerName);
	if(GetClientTeam(scorerclient) == GetClientTeam(assisterclient)) LeagueMatchKV.SetString(kvAssister, assisterName); //statsAssisterName);
	LeagueMatchKV.GoBack();
	LeagueMatchKV.GoBack();
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.ExportToFile(matchlogKV);
	LeagueMatchKV.Close();
	
	//save overview stuff
	KVSaveOverview(scorerName, assisterName, scoreid, assistid);
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

public void KVSaveOverview(char scorerName[MAX_NAME_LENGTH], char assisterName[MAX_NAME_LENGTH], char scoreid[32], char assistid[32])
{
	int goals = 0;
	int assists = 0;
	int owngoals = 0;
	char secBuffer[64], nameBuffer[256], nameBuffer2[512];
	
	LeagueMatchKV = new KeyValues("Match Log");
	//SetEscapeSequences(true) Sets whether or not the KeyValues parser will read escape sequences. For example, \n would be read as a literal newline. This defaults to false for new KeyValues structures.
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	LeagueMatchKV.JumpToKey("Playerstats", true);
	
	//Create Key if it doesnt exist
	if(!(StrEqual(assisterName, "Owngoal")))
	{
		if(LeagueMatchKV.JumpToKey(scoreid, true))
		{
			LeagueMatchKV.SetString(kvName, scorerName);
			LeagueMatchKV.SetNum(kvGoals, 0);
			LeagueMatchKV.GoBack();
		}
		if(!StrEqual(assisterName, ""))
		{
			if(LeagueMatchKV.JumpToKey(assistid, true))
			{
				LeagueMatchKV.SetString(kvName, assisterName);
				LeagueMatchKV.SetNum(kvAssists, 0)
				LeagueMatchKV.GoBack();
			}
		}
	}
	else if(StrEqual(assisterName, "Owngoal"))
	{
		if(LeagueMatchKV.JumpToKey(scoreid, true))
		{
			LeagueMatchKV.SetString(kvName, assisterName);
			LeagueMatchKV.SetNum(kvAssists, 0)
			LeagueMatchKV.GoBack();
		}
	}
	LeagueMatchKV.GoBack();
	LeagueMatchKV.Rewind();
	
	LeagueMatchKV.JumpToKey("Playerstats", true);
	LeagueMatchKV.GotoFirstSubKey();	
	do
	{
		LeagueMatchKV.GetSectionName(secBuffer, sizeof(secBuffer));
		
		if(StrEqual(secBuffer, scoreid) && !(StrEqual(assisterName, "Owngoal")))
		{
			goals = LeagueMatchKV.GetNum(kvGoals);
			goals++;
			LeagueMatchKV.SetNum(kvGoals, goals);
			LeagueMatchKV.GetString(kvName, nameBuffer, sizeof(nameBuffer));
			Format (nameBuffer2, sizeof(nameBuffer2), "%s -> %s", nameBuffer, scorerName);
			if (!(StrEqual(nameBuffer, scorerName)))	LeagueMatchKV.SetString(kvName, nameBuffer2);
		}
		else if (StrEqual(secBuffer, assistid) && !(StrEqual(assistid, "")))
		{
			assists = LeagueMatchKV.GetNum(kvAssists);
			assists++;
			LeagueMatchKV.SetNum(kvAssists, assists);
			LeagueMatchKV.GetString(kvName, nameBuffer, sizeof(nameBuffer));
			Format (nameBuffer2, sizeof(nameBuffer2), "%s -> %s", nameBuffer, assisterName);
			if (!(StrEqual(nameBuffer, assisterName)))	LeagueMatchKV.SetString(kvName, nameBuffer2);
		}
		else if (StrEqual(secBuffer, scoreid) && StrEqual(assisterName, "Owngoal"))
		{
			owngoals = LeagueMatchKV.GetNum(kvOwngoals);
			owngoals++
			LeagueMatchKV.SetNum(kvOwngoals, owngoals);
			LeagueMatchKV.GetString(kvName, nameBuffer, sizeof(nameBuffer));
			Format (nameBuffer2, sizeof(nameBuffer2), "%s -> %s", nameBuffer, scorerName);
			if (!(StrEqual(nameBuffer, scorerName)))	LeagueMatchKV.SetString(kvName, nameBuffer2);
		}
	}
	while (LeagueMatchKV.GotoNextKey() );
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.ExportToFile(matchlogKV);
	LeagueMatchKV.Close();
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
	
	FormatTime(stampString, sizeof(stampString), "%d%m%y_%H%M", GetFileTime(matchlogKV, FileTime_LastChange));
	Format(logpath, sizeof(logpath), "cfg/sm_soccermod/logs/match_%s_%s.txt", teamsString, stampString); 
	if(FileExists(matchlogKV) && (matchlog == 1)) RenameFile(logpath, matchlogKV, false);
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.ExportToFile(matchlogKV);
	LeagueMatchKV.Close();
	
	DeleteFile(matchlogKV, false);
}


// *******************************************************************************************************************
// *************************************************** UNUSED ********************************************************
// *******************************************************************************************************************

/*
public void KVSaveOverview()
{
	char scorerName[MAX_NAME_LENGTH], assisterName[MAX_NAME_LENGTH];
	char secBuffer[64];
	
	LeagueMatchKV = new KeyValues("Match Log");
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	LeagueMatchKV.JumpToKey("Playerstats", true);
	LeagueMatchKV.GotoFirstSubKey();
	
	do
	{
		int goals = 0;
		int assists = 0;
		int owngoals = 0;
		LeagueMatchKV.GetSectionName(secBuffer, sizeof(secBuffer));
		LeagueMatchKV.GetString(kvScorer, scorerName, sizeof(scorerName))
		LeagueMatchKV.GetString(kvAssister, assisterName, sizeof(assisterName))
		LeagueMatchKV.Rewind();
		LeagueMatchKV.JumpToKey("Playerstats", true);
		if (LeagueMatchKV.JumpToKey(scorerName, true))
		{
			LeagueMatchKV.JumpToKey(scorerName, true);
			goals = LeagueMatchKV.GetNum("Goals", 0);
			goals++;
			LeagueMatchKV.SetNum("Goals", goals);		
		}
		else if (LeagueMatchKV.JumpToKey(assisterName, true))
		{
			LeagueMatchKV.JumpToKey(assisterName, true);
			assists = LeagueMatchKV.GetNum("Assists", 0);
			assists++;
			LeagueMatchKV.SetNum("Assists", assists);
		}
		else if (LeagueMatchKV.JumpToKey(scorerName, true) && StrEqual(assisterName, "Owngoal"))
		{
			LeagueMatchKV.JumpToKey(scorerName, true);
			owngoals = LeagueMatchKV.GetNum("Owngoals", 0);
			owngoals++;
			LeagueMatchKV.SetNum("Owngoals", owngoals);
		}
		LeagueMatchKV.Rewind();
		LeagueMatchKV.JumpToKey("Playerstats", true);
		LeagueMatchKV.JumpToKey(secBuffer, true);
	}
	while (LeagueMatchKV.GotoNextKey() );
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.ExportToFile(matchlogKV);
	LeagueMatchKV.Close();
}
*/