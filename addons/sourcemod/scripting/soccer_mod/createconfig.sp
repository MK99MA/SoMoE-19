public void ConfigFunc()
{
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
	publicmode 				= kvConfig.GetNum("soccer_mod_pubmode");
	passwordlock 			= kvConfig.GetNum("soccer_mod_passwordlock");
	PWMAXPLAYERS			= (kvConfig.GetNum("soccer_mod_passwordlock_max")-1);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Chat Settings", false);
	kvConfig.GetString("soccer_mod_prefix", prefix, sizeof(prefix));
	kvConfig.GetString("soccer_mod_textcolor", textcolor, sizeof(textcolor));
	kvConfig.GetString("soccer_mod_prefixcolor", prefixcolor, sizeof(prefixcolor));
	MVPEnabled 				= kvConfig.GetNum("soccer_mod_mvp");
	DeadChatMode			= kvConfig.GetNum("soccer_mod_deadchat_mode");
	DeadChatVis				= kvConfig.GetNum("soccer_mod_deadchat_visibility");
	kvConfig.GoBack();

	kvConfig.JumpToKey("Match Settings", true);
	matchPeriods 			= kvConfig.GetNum("soccer_mod_match_periods");
	matchPeriodLength		= kvConfig.GetNum("soccer_mod_match_period_length");
	matchPeriodBreakLength	= kvConfig.GetNum("soccer_mod_match_period_break_length");
	matchGoldenGoal			= kvConfig.GetNum("soccer_mod_match_golden_goal");
	kvConfig.GetString("soccer_mod_teamnamect", custom_name_ct, sizeof(custom_name_ct));
	kvConfig.GetString("soccer_mod_teamnamet", custom_name_t, sizeof(custom_name_ct));
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Misc Settings", true);
	healthGodmode			= kvConfig.GetNum("soccer_mod_health_godmode");
	respawnDelay			= kvConfig.GetFloat("soccer_mod_respawn_delay");
	djbenabled				= kvConfig.GetNum("soccer_mod_blockdj_enable");
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Sprint Settings", true);
	bSPRINT_ENABLED			= kvConfig.GetNum("soccer_mod_sprint_enable");
	fSPRINT_SPEED			= kvConfig.GetFloat("soccer_mod_sprint_speed");
	fSPRINT_TIME			= kvConfig.GetFloat("soccer_mod_sprint_time");
	fSPRINT_COOLDOWN		= kvConfig.GetFloat("soccer_mod_sprint_cooldown");
	bSPRINT_BUTTON			= kvConfig.GetNum("soccer_mod_sprint_button");
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Current Skins", true);
	kvConfig.GetString("soccer_mod_skins_model_ct", skinsModelCT, sizeof(skinsModelCT));
	kvConfig.GetString("soccer_mod_skins_model_t", skinsModelT, sizeof(skinsModelT));
	kvConfig.GetString("soccer_mod_skins_model_ct_gk", skinsModelCTGoalkeeper, sizeof(skinsModelCTGoalkeeper));
	kvConfig.GetString("soccer_mod_skins_model_t_gk", skinsModelTGoalkeeper, sizeof(skinsModelTGoalkeeper));
	PrecacheModel(skinsModelCT);
	PrecacheModel(skinsModelT);
	PrecacheModel(skinsModelCTGoalkeeper);
	PrecacheModel(skinsModelTGoalkeeper);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Stats Settings", true);
	rankingPointsForGoal			= kvConfig.GetNum("soccer_mod_ranking_points_goal");
	rankingPointsForAssist			= kvConfig.GetNum("soccer_mod_ranking_points_assist");
	rankingPointsForOwnGoal			= kvConfig.GetNum("soccer_mod_ranking_points_own_goal");
	rankingPointsForHit				= kvConfig.GetNum("soccer_mod_ranking_points_hit");
	rankingPointsForPass			= kvConfig.GetNum("soccer_mod_ranking_points_pass");
	rankingPointsForInterception	= kvConfig.GetNum("soccer_mod_ranking_points_interception");
	rankingPointsForBallLoss		= kvConfig.GetNum("soccer_mod_ranking_points_ball_loss");
	rankingPointsForSave			= kvConfig.GetNum("soccer_mod_ranking_points_save");
	rankingPointsForRoundWon		= kvConfig.GetNum("soccer_mod_ranking_points_round_won");
	rankingPointsForRoundLost		= kvConfig.GetNum("soccer_mod_ranking_points_round_lost");
	rankingPointsForMVP				= kvConfig.GetNum("soccer_mod_ranking_points_mvp");
	rankingPointsForMOTM			= kvConfig.GetNum("soccer_mod_ranking_points_motm");
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Training Settings", true);
	kvConfig.GetString("soccer_mod_training_model_ball", trainingModelBall, sizeof(trainingModelBall));
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Debug Settings", true);
	debuggingEnabled		= kvConfig.GetNum("soccer_mod_debug");
	kvConfig.GoBack();
	
	kvConfig.Rewind();
	kvConfig.Close();
}