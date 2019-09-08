public void KVGetEvent(Menu menu)
{
	char timeString[16];
	char scoreString[32], scorerString[32], assisterString[32], menuString[128];
	getTimeString(timeString, matchTime);
	Format(scoreString, sizeof(scoreString), "%i:%i", matchScoreCT, matchScoreT);		
	
	LeagueMatchKV = new KeyValues("Match Log")
	LeagueMatchKV.ImportFromFile(matchlogKV);
	LeagueMatchKV.GotoFirstSubKey();
	LeagueMatchKV.GotoNextKey();
	
	do
	{
		LeagueMatchKV.GetSectionName(scoreString, sizeof(scoreString));
		LeagueMatchKV.GetString("Time", timeString, sizeof(timeString));
		LeagueMatchKV.GetString("Scorer", scorerString, sizeof(scorerString));
		LeagueMatchKV.GetString("Assister", assisterString, sizeof(assisterString), "No Assist");
		
		Format(menuString, sizeof(menuString), "[%s] %s G: %s A: %s", timeString, scoreString, scorerString, assisterString);
		menu.AddItem(timeString, menuString, ITEMDRAW_DISABLED);
	}
	while (LeagueMatchKV.GotoNextKey());
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.Close();
}

public void KVAddScore()
{
	char timeString[16], scoreString[32];
	getTimeString(timeString, matchTime);
	
	matchScoreCT = CS_GetTeamScore(3);
	matchScoreT = CS_GetTeamScore(2);
	Format(scoreString, sizeof(scoreString), "%i:%i", matchScoreCT, matchScoreT);
	
	LeagueMatchKV = new KeyValues("Match Log");
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	LeagueMatchKV.JumpToKey(scoreString, true);
	LeagueMatchKV.SetString("Time",	timeString);
	LeagueMatchKV.SetString("Scorer", "Added by Referee");
	LeagueMatchKV.SetString("Assister", statsAssisterName);
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
	//PrintToChatAll(scoreString);
	
	LeagueMatchKV = new KeyValues("Match Log");
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	if(LeagueMatchKV.JumpToKey(scoreString, false))	LeagueMatchKV.DeleteThis();
	LeagueMatchKV.GoBack();
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.ExportToFile(matchlogKV);
	LeagueMatchKV.Close();	
}

public void KVSaveEvent()
{
	char timeString[16];
	char scoreString[32];
	getTimeString(timeString, matchTime);
	Format(scoreString, sizeof(scoreString), "%i:%i", matchScoreCT, matchScoreT);
	
	//File hFile = OpenFile(matchlogKV, "w");
	//hFile.Close();
	
	LeagueMatchKV = new KeyValues("Match Log");
	LeagueMatchKV.ImportFromFile(matchlogKV);
	
	LeagueMatchKV.JumpToKey(scoreString, true);
	LeagueMatchKV.SetString("Time",	timeString);
	LeagueMatchKV.SetString("Scorer", statsScorerName);
	LeagueMatchKV.SetString("Assister", statsAssisterName);
	LeagueMatchKV.GoBack();
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.ExportToFile(matchlogKV);
	LeagueMatchKV.Close();
}

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
	
	LeagueMatchKV.Rewind();
	LeagueMatchKV.ExportToFile(matchlogKV);
	LeagueMatchKV.Close();
}

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