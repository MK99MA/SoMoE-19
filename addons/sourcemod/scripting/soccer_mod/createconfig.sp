public void ConfigFunc()
{
	char adminSMFileBackup[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, adminSMFileKV, sizeof(adminSMFileKV), "configs/admins.cfg");
	BuildPath(Path_SM, adminSMFileBackup, sizeof(adminSMFileBackup), "configs/admins.cfg.backup");
	
	if (!FileExists(adminSMFileBackup)) RenameFile(adminSMFileBackup, adminSMFileKV, false);
	if (!FileExists(configFileKV)) CreateSoccerModConfig();
	if (!FileExists(adminFileKV)) CreateAdminConfig();
	if (!FileExists("cfg/sm_soccermod/soccer_mod_downloads.cfg"))
	{
		CreateDownloadFile();
		AutoExecConfig(false, "soccer_mod_downloads", "sm_soccermod");
	}
	else AutoExecConfig(false, "soccer_mod_downloads", "sm_soccermod");
	if (!FileExists(pathCapPositionsFile)) CreateCapPositionsConfig();
	if (!FileExists(skinsKeygroup)) CreateSkinsConfig();
	if (!FileExists(statsKeygroupGoalkeeperAreas)) CreateGKAreaConfig();
	
	if (FileExists(configFileKV)) ReadFromConfig();
}

public void CreateSoccerModConfig()
{
	File hFile = OpenFile(configFileKV, "w");
	hFile.Close();
	kvConfig = new KeyValues("Soccer Mod Config");
	kvConfig.ImportFromFile(configFileKV);
	kvConfig.JumpToKey("Admin Settings", true);
	kvConfig.SetNum("soccer_mod_pubmode", 						publicmode);
	kvConfig.SetNum("soccer_mod_passwordlock", 					passwordlock);
	kvConfig.SetNum("soccer_mod_passwordlock_max", 				PWMAXPLAYERS+1);
	kvConfig.SetFloat("soccer_mod_afk_time",					afk_kicktime);
	kvConfig.SetNum("soccer_mod_afk_menu",						afk_menutime);
	kvConfig.SetNum("soccer_mod_matchlog",						matchlog);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Chat Settings", true);
	kvConfig.SetString("soccer_mod_prefix", 					prefix);
	kvConfig.SetString("soccer_mod_textcolor", 					textcolor);
	kvConfig.SetString("soccer_mod_prefixcolor", 				prefixcolor);
	kvConfig.SetNum("soccer_mod_mvp", 							MVPEnabled);
	kvConfig.SetNum("soccer_mod_deadchat_mode",					DeadChatMode);
	kvConfig.SetNum("soccer_mod_deadchat_visibility",			DeadChatVis);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Match Settings", true);
	kvConfig.SetNum("soccer_mod_match_periods",					matchPeriods);
	kvConfig.SetNum("soccer_mod_match_period_length",			matchPeriodLength);
	kvConfig.SetNum("soccer_mod_match_period_break_length",		matchPeriodBreakLength);
	kvConfig.SetNum("soccer_mod_match_golden_goal",				matchGoldenGoal);
	kvConfig.SetString("soccer_mod_teamnamect", 				custom_name_ct);
	kvConfig.SetString("soccer_mod_teamnamet", 					custom_name_t);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Misc Settings", true);
	kvConfig.SetNum("soccer_mod_health_godmode",				healthGodmode);
	kvConfig.SetFloat("soccer_mod_respawn_delay",				respawnDelay);
	kvConfig.SetNum("soccer_mod_blockdj_enable",				djbenabled);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Sprint Settings", true);
	kvConfig.SetNum("soccer_mod_sprint_enable",					bSPRINT_ENABLED);
	kvConfig.SetFloat("soccer_mod_sprint_speed",				fSPRINT_SPEED);
	kvConfig.SetFloat("soccer_mod_sprint_time",					fSPRINT_TIME);
	kvConfig.SetFloat("soccer_mod_sprint_cooldown",				fSPRINT_COOLDOWN);
	kvConfig.SetNum("soccer_mod_sprint_button",					bSPRINT_BUTTON);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Current Skins", true);
	kvConfig.SetString("soccer_mod_skins_model_ct",				skinsModelCT);
	kvConfig.SetString("soccer_mod_skins_model_t",				skinsModelT);
	kvConfig.SetString("soccer_mod_skins_model_ct_gk",			skinsModelCTGoalkeeper);
	kvConfig.SetString("soccer_mod_skins_model_t_gk",			skinsModelTGoalkeeper);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Stats Settings", true);
	kvConfig.SetNum("soccer_mod_ranking_points_goal",				rankingPointsForGoal);
	kvConfig.SetNum("soccer_mod_ranking_points_assist",				rankingPointsForAssist);
	kvConfig.SetNum("soccer_mod_ranking_points_own_goal",			rankingPointsForOwnGoal);
	kvConfig.SetNum("soccer_mod_ranking_points_hit",				rankingPointsForHit);
	kvConfig.SetNum("soccer_mod_ranking_points_pass",				rankingPointsForPass);
	kvConfig.SetNum("soccer_mod_ranking_points_interception",		rankingPointsForInterception);
	kvConfig.SetNum("soccer_mod_ranking_points_ball_loss",			rankingPointsForBallLoss);
	kvConfig.SetNum("soccer_mod_ranking_points_save",				rankingPointsForSave);
	kvConfig.SetNum("soccer_mod_ranking_points_round_won",			rankingPointsForRoundWon);
	kvConfig.SetNum("soccer_mod_ranking_points_round_lost",			rankingPointsForRoundLost);
	kvConfig.SetNum("soccer_mod_ranking_points_mvp",				rankingPointsForMVP);
	kvConfig.SetNum("soccer_mod_ranking_points_motm",				rankingPointsForMOTM);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Training Settings", true);
	kvConfig.SetString("soccer_mod_training_model_ball",			trainingModelBall);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Debug Settings", true);
	kvConfig.SetNum("soccer_mod_debug",								debuggingEnabled);
	kvConfig.GoBack();
	
	kvConfig.Rewind();
	kvConfig.ExportToFile(configFileKV);
	kvConfig.Close();
}

public void UpdateConfig(char section[32], char type[32], char value[32])
{
	if(!FileExists(configFileKV)) CreateSoccerModConfig();
	kvConfig = new KeyValues("Soccer Mod Config");
	kvConfig.ImportFromFile(configFileKV);
	kvConfig.JumpToKey(section, true);
	kvConfig.SetString(type, value);
	
	kvConfig.Rewind();
	kvConfig.ExportToFile(configFileKV);
	kvConfig.Close();
}

public void UpdateConfigInt(char section[32], char type[50], int value)
{
	if(!FileExists(configFileKV)) CreateSoccerModConfig();
	kvConfig = new KeyValues("Soccer Mod Config");
	kvConfig.ImportFromFile(configFileKV);
	kvConfig.JumpToKey(section, true);
	kvConfig.SetNum(type, value);
	
	kvConfig.Rewind();
	kvConfig.ExportToFile(configFileKV);
	kvConfig.Close();
}

public void UpdateConfigFloat(char section[32], char type[32], float value)
{
	if(!FileExists(configFileKV)) CreateSoccerModConfig();
	kvConfig = new KeyValues("Soccer Mod Config");
	kvConfig.ImportFromFile(configFileKV);
	kvConfig.JumpToKey(section, true);
	kvConfig.SetFloat(type, value);
	
	kvConfig.Rewind();
	kvConfig.ExportToFile(configFileKV);
	kvConfig.Close();
}

public void UpdateConfigModels(char section[32], char type[32], char value[128])
{
	if(!FileExists(configFileKV)) CreateSoccerModConfig();
	kvConfig = new KeyValues("Soccer Mod Config");
	kvConfig.ImportFromFile(configFileKV);
	kvConfig.JumpToKey(section, true);
	kvConfig.SetString(type, value);
	
	kvConfig.Rewind();
	kvConfig.ExportToFile(configFileKV);
	kvConfig.Close();
}

public void CreateDownloadFile()
{
	File hFile = OpenFile("cfg/sm_soccermod/soccer_mod_downloads.cfg", "at");
	hFile.WriteLine("//Adds a directory and all the subdirectories to the downloads - values: path/to/dir");
	hFile.WriteLine("soccer_mod_downloads_add_dir materials\\models\\player\\soccer_mod");
	hFile.WriteLine("soccer_mod_downloads_add_dir models\\player\\soccer_mod");
	hFile.WriteLine("soccer_mod_downloads_add_dir materials\\models\\soccer_mod");
	hFile.WriteLine("soccer_mod_downloads_add_dir models\\soccer_mod");
	hFile.Close();
	
	if (FileExists("cfg/sm_soccermod/soccer_mod_downloads.cfg", false)) AutoExecConfig(false, "soccer_mod_downloads", "sm_soccermod");
}

public void AddSoccerTags()
{
	char oldtags[256], newtags[256];
	//char soccertags[64] = "soccer,soccermod,soccer_mod";
	int flags;
	
	ConVar tags = FindConVar("sv_tags");
	flags = GetConVarFlags(tags);
	flags &= ~FCVAR_NOTIFY;
	SetConVarFlags(tags, flags);
	
	tags.GetString(oldtags, sizeof(oldtags));
	//PrintToChatAll(oldtags);
	if(SimpleRegexMatch(oldtags, "soccer\\W", false) == -1)
	{
		Format(newtags, sizeof(newtags), "%s,soccer", oldtags);
		tags.SetString(newtags, false, false);
	}
	if(StrContains(oldtags, "soccermod,", false) == -1)
	{
		Format(newtags, sizeof(newtags), "%s,soccermod", oldtags);
		tags.SetString(newtags, false, false);
	}
	if(StrContains(oldtags, "soccer_mod,", false) == -1)
	{
		Format(newtags, sizeof(newtags), "%s,soccer_mod", oldtags);
		tags.SetString(newtags, false, false);
	}
	
	CloseHandle(tags);
}

public void CreateAdminConfig()
{
	File hFile = OpenFile(adminFileKV, "w");
	hFile.Close();
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	
	kvAdmins.Rewind();
	kvAdmins.ExportToFile(adminFileKV);
	kvAdmins.Close();
}

public void CreateCapPositionsConfig()
{
	File hFile = OpenFile(pathCapPositionsFile, "at");
	hFile.Close();	
}


public void CreateSkinsConfig()
{
	File hFile = OpenFile(skinsKeygroup, "w");
	hFile.Close();
	kvSkins = new KeyValues("Skins");
	kvSkins.ImportFromFile(skinsKeygroup);
	kvSkins.JumpToKey("Termi", true);
	kvSkins.SetString("CT",			skinsModelCT);
	kvSkins.SetString("T",			skinsModelT);
	kvSkins.SetString("CTGK",		skinsModelCTGoalkeeper);
	kvSkins.SetString("TGK",		skinsModelTGoalkeeper);
	
	kvSkins.Rewind();
	kvSkins.ExportToFile(skinsKeygroup);
	kvSkins.Close();
}

public void CreateGKAreaConfig()
{
	File hFile = OpenFile(statsKeygroupGoalkeeperAreas, "w");
	hFile.Close();
	kvGKArea = new KeyValues("gk_areas");
	kvGKArea.ImportFromFile(statsKeygroupGoalkeeperAreas);
	kvGKArea.JumpToKey("ka_soccer_xsl_stadium_b1", true);
	kvGKArea.SetNum("ct_min_x",		-313);
	kvGKArea.SetNum("ct_max_x",		313);
	kvGKArea.SetNum("ct_min_y",		-1379);
	kvGKArea.SetNum("ct_max_y",		-1188);
	kvGKArea.SetNum("ct_min_z",		0);
	kvGKArea.SetNum("ct_max_z",		120);
	kvGKArea.SetNum("t_min_x",		-313);
	kvGKArea.SetNum("t_max_x",		313);
	kvGKArea.SetNum("t_min_y",		1188);
	kvGKArea.SetNum("t_max_y",		1379);
	kvGKArea.SetNum("t_min_z",		0);
	kvGKArea.SetNum("t_max_z",		120);
	kvGKArea.GoBack();
	
	kvGKArea.JumpToKey("ka_soccer_stadium_2019_b1", true);
	kvGKArea.SetNum("ct_min_x",		-313);
	kvGKArea.SetNum("ct_max_x",		313);
	kvGKArea.SetNum("ct_min_y",		-1379);
	kvGKArea.SetNum("ct_max_y",		-1188);
	kvGKArea.SetNum("ct_min_z",		0);
	kvGKArea.SetNum("ct_max_z",		120);
	kvGKArea.SetNum("t_min_x",		-313);
	kvGKArea.SetNum("t_max_x",		313);
	kvGKArea.SetNum("t_min_y",		1188);
	kvGKArea.SetNum("t_max_y",		1379);
	kvGKArea.SetNum("t_min_z",		0);
	kvGKArea.SetNum("t_max_z",		120);
	
	kvGKArea.Rewind();
	kvGKArea.ExportToFile(statsKeygroupGoalkeeperAreas);
	kvGKArea.Close();
}

public void ReadFromConfig()
{
	kvConfig = new KeyValues("Soccer Mod Config");
	kvConfig.ImportFromFile(configFileKV);
	
	kvConfig.JumpToKey("Admin Settings", false);
	publicmode 				= kvConfig.GetNum("soccer_mod_pubmode", 1);
	passwordlock 			= kvConfig.GetNum("soccer_mod_passwordlock", 1);
	PWMAXPLAYERS			= (kvConfig.GetNum("soccer_mod_passwordlock_max", 13)-1);
	afk_kicktime			= kvConfig.GetFloat("soccer_mod_afk_time", 100.0);
	afk_menutime			= kvConfig.GetNum("soccer_mod_afk_menu", 20);
	matchlog				= kvConfig.GetNum("soccer_mod_matchlog", 0);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Chat Settings", false);
	kvConfig.GetString("soccer_mod_prefix", prefix, sizeof(prefix), "Soccer Mod");
	kvConfig.GetString("soccer_mod_textcolor", textcolor, sizeof(textcolor), "lightgreen");
	kvConfig.GetString("soccer_mod_prefixcolor", prefixcolor, sizeof(prefixcolor), "green");
	MVPEnabled 				= kvConfig.GetNum("soccer_mod_mvp", 1);
	DeadChatMode			= kvConfig.GetNum("soccer_mod_deadchat_mode", 0);
	DeadChatVis				= kvConfig.GetNum("soccer_mod_deadchat_visibility", 0);
	kvConfig.GoBack();

	kvConfig.JumpToKey("Match Settings", true);
	matchPeriods 			= kvConfig.GetNum("soccer_mod_match_periods", 2);
	matchPeriodLength		= kvConfig.GetNum("soccer_mod_match_period_length", 900);
	matchPeriodBreakLength	= kvConfig.GetNum("soccer_mod_match_period_break_length", 60);
	matchGoldenGoal			= kvConfig.GetNum("soccer_mod_match_golden_goal", 1);
	kvConfig.GetString("soccer_mod_teamnamect", custom_name_ct, sizeof(custom_name_ct), "CT");
	kvConfig.GetString("soccer_mod_teamnamet", custom_name_t, sizeof(custom_name_t), "T");
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Misc Settings", true);
	healthGodmode			= kvConfig.GetNum("soccer_mod_health_godmode", 1);
	respawnDelay			= kvConfig.GetFloat("soccer_mod_respawn_delay", 10.0);
	djbenabled				= kvConfig.GetNum("soccer_mod_blockdj_enable", 1);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Sprint Settings", true);
	bSPRINT_ENABLED			= kvConfig.GetNum("soccer_mod_sprint_enable", 1);
	fSPRINT_SPEED			= kvConfig.GetFloat("soccer_mod_sprint_speed", 1.25);
	fSPRINT_TIME			= kvConfig.GetFloat("soccer_mod_sprint_time", 3.0);
	fSPRINT_COOLDOWN		= kvConfig.GetFloat("soccer_mod_sprint_cooldown", 7.5);
	bSPRINT_BUTTON			= kvConfig.GetNum("soccer_mod_sprint_button", 1);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Current Skins", true);
	kvConfig.GetString("soccer_mod_skins_model_ct", skinsModelCT, sizeof(skinsModelCT), "models/player/soccer_mod/termi/2011/away/ct_urban.mdl");
	kvConfig.GetString("soccer_mod_skins_model_t", skinsModelT, sizeof(skinsModelT), "models/player/soccer_mod/termi/2011/home/ct_urban.mdl");
	kvConfig.GetString("soccer_mod_skins_model_ct_gk", skinsModelCTGoalkeeper, sizeof(skinsModelCTGoalkeeper), "models/player/soccer_mod/termi/2011/gkaway/ct_urban.mdl");
	kvConfig.GetString("soccer_mod_skins_model_t_gk", skinsModelTGoalkeeper, sizeof(skinsModelTGoalkeeper), "models/player/soccer_mod/termi/2011/gkhome/ct_urban.mdl");
	PrecacheModel(skinsModelCT);
	PrecacheModel(skinsModelT);
	PrecacheModel(skinsModelCTGoalkeeper);
	PrecacheModel(skinsModelTGoalkeeper);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Stats Settings", true);
	rankingPointsForGoal			= kvConfig.GetNum("soccer_mod_ranking_points_goal", 12);
	rankingPointsForAssist			= kvConfig.GetNum("soccer_mod_ranking_points_assist", 12);
	rankingPointsForOwnGoal			= kvConfig.GetNum("soccer_mod_ranking_points_own_goal", -10);
	rankingPointsForHit				= kvConfig.GetNum("soccer_mod_ranking_points_hit", 1);
	rankingPointsForPass			= kvConfig.GetNum("soccer_mod_ranking_points_pass", 5);
	rankingPointsForInterception	= kvConfig.GetNum("soccer_mod_ranking_points_interception",3);
	rankingPointsForBallLoss		= kvConfig.GetNum("soccer_mod_ranking_points_ball_loss", -3);
	rankingPointsForSave			= kvConfig.GetNum("soccer_mod_ranking_points_save", 10);
	rankingPointsForRoundWon		= kvConfig.GetNum("soccer_mod_ranking_points_round_won", 10);
	rankingPointsForRoundLost		= kvConfig.GetNum("soccer_mod_ranking_points_round_lost", -10);
	rankingPointsForMVP				= kvConfig.GetNum("soccer_mod_ranking_points_mvp", 15);
	rankingPointsForMOTM			= kvConfig.GetNum("soccer_mod_ranking_points_motm", 25);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Training Settings", true);
	kvConfig.GetString("soccer_mod_training_model_ball", trainingModelBall, sizeof(trainingModelBall), "models/soccer_mod/ball_2011.mdl");
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Debug Settings", true);
	debuggingEnabled		= kvConfig.GetNum("soccer_mod_debug", 0);
	kvConfig.GoBack();
	
	kvConfig.Rewind();
	kvConfig.Close();
}