public void ConfigFunc()
{
	char adminSMFileBackup[PLATFORM_MAX_PATH];
	char adminSMFileBackupOld[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, adminSMFileKV, sizeof(adminSMFileKV), "configs/admins.cfg");
	BuildPath(Path_SM, adminSMFileBackup, sizeof(adminSMFileBackup), "configs/admins.cfg.presoccermod");
	BuildPath(Path_SM, adminSMFileBackupOld, sizeof(adminSMFileBackupOld), "configs/admins.cfg.backup");
	
	if (!(FileExists(adminSMFileBackup)) && !(FileExists(adminSMFileBackupOld))) 
	{
		RenameFile(adminSMFileBackup, adminSMFileKV, false);
		ImportAdminFile();
		ImportFailed();
		ServerCommand("sm_reloadadmins 1");
	}
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
	if (!FileExists(mapDefaults)) CreateMapDefaultsConfig();
	
	if (FileExists(configFileKV)) ReadFromConfig();
}

public void ImportAdminFile()
{
	char adminSMFileBackup[PLATFORM_MAX_PATH];
	char line[255];
	int i = 0;
	int comment = 0;
	bool example = false;
	
	BuildPath(Path_SM, adminSMFileKV, sizeof(adminSMFileKV), "configs/admins.cfg");
	BuildPath(Path_SM, adminSMFileBackup, sizeof(adminSMFileBackup), "configs/admins.cfg.presoccermod");
	
	File hFile = OpenFile(adminSMFileKV, "w");
	File cFile = OpenFile(adminSMFileBackup, "r");
	while (!cFile.EndOfFile())
	{	
		// Reading lines; i = number of lines in File
		if (!ReadFileLine(cFile, line, sizeof(line)))continue;
		else i++;
			
		// Checking for Comment lines; comment = number of comment lines
		if (line[0] == '/' || line[1] == '*' || strlen(line) == 1)
		{
			comment++;
		}
		
		// Check for default example
		if((StrContains(line, "Example:") != -1) && (example == false))
		{
			comment = comment + 6;
			example = true;
		}	
		
		// Write important parts to new file
		if (i > comment)
		{
			WriteFileString(hFile, line, false);
		}
	}
	
	hFile.Close();
	cFile.Close();
}

public void ImportFailed()
{
	File hFile = OpenFile(adminSMFileKV, "r");
	File nFile;

	char info[255];
	char adminSMFileError[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, adminSMFileError, sizeof(adminSMFileError), "configs/admins.cfg.error");
	
	ReadFileLine(hFile, info, sizeof(info));
	hFile.Close();
	
	if (StrContains(info, "Admins") == -1)
	{
		RenameFile(adminSMFileError, adminSMFileKV, false);
		nFile = OpenFile(adminSMFileKV, "w");
	}
	
	nFile.Close();
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
	kvConfig.SetNum("soccer_mod_match_readycheck", 				matchReadyCheck);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Match Info", true);
	kvConfig.SetNum("soccer_mod_period_info",					infoPeriods);
	kvConfig.SetNum("soccer_mod_break_info",					infoBreak);
	kvConfig.SetNum("soccer_mod_golden_info",					infoGolden);
	kvConfig.SetNum("soccer_mod_forfeit_info",					infoForfeit);
	kvConfig.SetNum("soccer_mod_forfeitset_info",				infoForfeitSet);
	kvConfig.SetNum("soccer_mod_matchlog_info",					infoMatchlog);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Forfeit Settings", true);
	kvConfig.SetNum("soccer_mod_forfeitvote",					ForfeitEnabled);
	kvConfig.SetNum("soccer_mod_forfeitscore",					ForfeitScore);
	kvConfig.SetNum("soccer_mod_forfeitpublic",					ForfeitPublic);
	kvConfig.SetNum("soccer_mod_forfeitautospec",				ForfeitAutoSpec);
	kvConfig.SetNum("soccer_mod_forfeitcapmode",				ForfeitCapMode);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Misc Settings", true);
	kvConfig.SetNum("soccer_mod_health_godmode",				healthGodmode);
	kvConfig.SetFloat("soccer_mod_respawn_delay",				respawnDelay);
	kvConfig.SetNum("soccer_mod_blockdj_enable",				djbenabled);
	kvConfig.SetFloat("soccer_mod_blockdj_time",				fJUMP_TIMER);
	kvConfig.SetNum("soccer_mod_kickoffwall", 					KickoffWallSet); 
	kvConfig.SetNum("soccer_mod_damagesounds",					damageSounds);
	kvConfig.SetNum("soccer_mod_dissolver",						dissolveSet);
	kvConfig.SetNum("soccer_mod_joinclass",						joinclassSet);
	kvConfig.SetNum("soccer_mod_hostname", 						hostnameToggle);
	kvConfig.SetFloat("soccer_mod_rrchecktime",					rrchecktime);
	kvConfig.SetNum("soccer_mod_loaddefaults",					defaultSet);
	kvConfig.SetNum("soccer_mod_killfeed",						killfeedSet);
	kvConfig.SetNum("soccer_mod_celebrate", 					celebrateweaponSet);
	kvConfig.SetNum("soccer_mod_first12",						first12Set);
	kvConfig.SetNum("soccer_mod_otcount",						OTCountSet);
	kvConfig.GetNum("soccer_mod_otfinal", 						OTFinalSet);
	kvConfig.SetString("soccer_mod_otsound1", 					OTSound1);
	kvConfig.SetString("soccer_mod_otsound2", 					OTSound2);
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
	kvConfig.SetNum("soccer_mod_ranking_cdtime",					rankingCDTime);
	kvConfig.SetNum("soccer_mod_gksaves_only", 						gksavesSet);
	kvConfig.SetNum("soccer_mod_rankmode", 							rankMode);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Training Settings", true);
	kvConfig.SetString("soccer_mod_training_model_ball",			trainingModelBall);
	kvConfig.SetNum("soccer_mod_training_advpwreq",					AdvTrain_PWReqSet);
	kvConfig.SetString("soccer_mod_training_advpw",					AdvTrain_PW);
	kvConfig.SetFloat("soccer_mod_training_advresettime",			targetResetTime);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Debug Settings", true);
	kvConfig.SetNum("soccer_mod_debug",								debuggingEnabled);
	kvConfig.SetString("soccer_mod_spawnball",						spawnModelBall);
	kvConfig.GoBack();
	
	kvConfig.Rewind();
	kvConfig.ExportToFile(configFileKV);
	kvConfig.Close();
}

public void UpdateConfig(char section[32], char type[50], char value[32])
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

public void UpdateConfigFloat(char section[32], char type[50], float value)
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

public void UpdateConfigModels(char section[32], char type[50], char value[128])
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
	hFile.WriteLine("//Example (without //):");
	hFile.WriteLine("//soccer_mod_downloads_add_dir materials\\models\\player\\soccer_mod");
	hFile.Close();
	
	if (FileExists("cfg/sm_soccermod/soccer_mod_downloads.cfg", false)) AutoExecConfig(false, "soccer_mod_downloads", "sm_soccermod");
}

public void CreateMapDefaultsConfig()
{
	File hFile = OpenFile(mapDefaults, "at");
	hFile.Close();
	
	mapdefaultKV = new KeyValues("Map Defaults");
	mapdefaultKV.ImportFromFile(mapDefaults);
	
	mapdefaultKV.JumpToKey("ka_soccer_xsl_stadium_b1", true);
	mapdefaultKV.SetNum("default_periodlength", 900);
	mapdefaultKV.SetNum("default_breaklength", 5);
	mapdefaultKV.SetNum("default_periods", 2);
	mapdefaultKV.SetNum("default_kickoffwall", 1);
	//mapdefaultKV.JumpToKey("removed sounds", true);
	//mapdefaultKV.SetString("name", "type");
	
	mapdefaultKV.Rewind();
	mapdefaultKV.ExportToFile(mapDefaults);
	mapdefaultKV.Close();
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
	
	kvGKArea.Rewind();
	kvGKArea.ExportToFile(statsKeygroupGoalkeeperAreas);
	kvGKArea.Close();
}

public void CreateMatchlogSettings()
{
	File hFile = OpenFile(matchlogSettingsKV, "w");
	hFile.Close();
	kvMLSettings = new KeyValues("Matchlog Settings");
	kvMLSettings.ImportFromFile(matchlogSettingsKV);
	kvMLSettings.JumpToKey("Days", true);
	kvMLSettings.SetNum("Monday",		0);
	kvMLSettings.SetNum("Tuesday", 		0);
	kvMLSettings.SetNum("Wednesday",	0);
	kvMLSettings.SetNum("Thursday", 	0);
	kvMLSettings.SetNum("Friday", 		0);
	kvMLSettings.SetNum("Saturday", 	0);
	kvMLSettings.SetNum("Sunday",	 	0);
	kvMLSettings.GoBack();
	
	kvMLSettings.JumpToKey("Starttime", true);
	kvMLSettings.SetNum("Hour",			iStarthour);
	kvMLSettings.SetNum("Minute",		iStartmin);
	kvMLSettings.GoBack();
	
	kvMLSettings.JumpToKey("Stoptime", true);
	kvMLSettings.SetNum("Hour",			iStophour);
	kvMLSettings.SetNum("Minute",		iStopmin);
	kvMLSettings.GoBack();
	
	kvMLSettings.Rewind();
	kvMLSettings.ExportToFile(matchlogSettingsKV);
	kvMLSettings.Close();
}

public void UpdateMatchlogSet(char section[32], char type[16], int value)
{
	if(!FileExists(matchlogSettingsKV)) CreateMatchlogSettings();
	kvMLSettings = new KeyValues("Matchlog Settings");
	kvMLSettings.ImportFromFile(matchlogSettingsKV);
	kvMLSettings.JumpToKey(section, true);
	kvMLSettings.SetNum(type, value);
	
	kvMLSettings.Rewind();
	kvMLSettings.ExportToFile(matchlogSettingsKV);
	kvMLSettings.Close();
}

public int ReadMatchlogSet(char section[32], char type[16])
{
	int value;
	if(!FileExists(matchlogSettingsKV)) CreateMatchlogSettings();
	kvMLSettings = new KeyValues("Matchlog Settings");
	kvMLSettings.ImportFromFile(matchlogSettingsKV);
	kvMLSettings.JumpToKey(section, true);
	value = kvMLSettings.GetNum(type, 0);
	
	kvMLSettings.Rewind();
	kvMLSettings.ExportToFile(matchlogSettingsKV);
	kvMLSettings.Close();
	
	return value;
}

public void ReadMatchlogSettings()
{
	kvMLSettings = new KeyValues("Matchlog Settings");
	kvMLSettings.ImportFromFile(matchlogSettingsKV);
	
	kvMLSettings.JumpToKey("Starttime", true);
	iStarthour	= kvMLSettings.GetNum("Hour", 0);
	iStartmin	= kvMLSettings.GetNum("Minute", 0);
	kvMLSettings.GoBack();
	kvMLSettings.JumpToKey("Stoptime", true);
	iStophour	= kvMLSettings.GetNum("Hour", 0);
	iStopmin	= kvMLSettings.GetNum("Minute", 0);
	kvMLSettings.GoBack();
	
	kvMLSettings.Rewind();
	kvMLSettings.ExportToFile(matchlogSettingsKV);
	kvMLSettings.Close();
}

public void SoundSetup()
{
	PrecacheSound("player/suit_sprint.wav");
	//PrecacheSound("weapons/c4/c4_beep1.wav");
	PrecacheSound("buttons/button17.wav");
	if (FileExists("sound/soccermod/endmatch.wav"))		PrecacheSound("soccermod/endmatch.wav");
	if (FileExists("sound/soccermod/halftime.wav"))		PrecacheSound("soccermod/halftime.wav");
	if (FileExists("sound/soccermod/kickoff.wav"))		PrecacheSound("soccermod/kickoff.wav");
	if (FileExists("sound/soccermod/whistle.wav"))		PrecacheSound("soccermod/whistle.wav");
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
	matchReadyCheck			= kvConfig.GetNum("soccer_mod_match_readycheck", 1);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Match Info", true);
	infoPeriods				= kvConfig.GetNum("soccer_mod_period_info", 1);
	infoBreak				= kvConfig.GetNum("soccer_mod_break_info",	1);
	infoGolden				= kvConfig.GetNum("soccer_mod_golden_info", 1);
	infoForfeit				= kvConfig.GetNum("soccer_mod_forfeit_info", 1);
	infoForfeitSet			= kvConfig.GetNum("soccer_mod_forfeitset_info", 0);
	infoMatchlog			= kvConfig.GetNum("soccer_mod_matchlog_info", 0);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Forfeit Settings", true);
	ForfeitEnabled			= kvConfig.GetNum("soccer_mod_forfeitvote", 0);
	ForfeitScore			= kvConfig.GetNum("soccer_mod_forfeitscore", 8);
	ForfeitPublic			= kvConfig.GetNum("soccer_mod_forfeitpublic", 0);
	ForfeitAutoSpec			= kvConfig.GetNum("soccer_mod_forfeitautospec", 0);
	ForfeitCapMode			= kvConfig.GetNum("soccer_mod_forfeitcapmode", 0);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Misc Settings", true);
	healthGodmode			= kvConfig.GetNum("soccer_mod_health_godmode", 1);
	respawnDelay			= kvConfig.GetFloat("soccer_mod_respawn_delay", 10.0);
	djbenabled				= kvConfig.GetNum("soccer_mod_blockdj_enable", 3);
	fJUMP_TIMER				= kvConfig.GetFloat("soccer_mod_blockdj_time", 0.4);
	KickoffWallSet			= kvConfig.GetNum("soccer_mod_kickoffwall", 0);
	damageSounds			= kvConfig.GetNum("soccer_mod_damagesounds", 0);
	dissolveSet				= kvConfig.GetNum("soccer_mod_dissolver", 2);
	joinclassSet			= kvConfig.GetNum("soccer_mod_joinclass", 0);
	hostnameToggle			= kvConfig.GetNum("soccer_mod_hostname", 1);
	rrchecktime				= kvConfig.GetFloat("soccer_mod_rrchecktime",	90.0);
	defaultSet				= kvConfig.GetNum("soccer_mod_loaddefaults", 1);
	killfeedSet				= kvConfig.GetNum("soccer_mod_killfeed", 0);
	celebrateweaponSet		= kvConfig.GetNum("soccer_mod_celebrate", 0);
	first12Set				= kvConfig.GetNum("soccer_mod_first12",	0);
	OTCountSet				= kvConfig.GetNum("soccer_mod_otcount",	1);	
	OTFinalSet				= kvConfig.GetNum("soccer_mod_otfinal", 1);
	kvConfig.GetString("soccer_mod_otsound1", OTSound1, sizeof(OTSound1), "buttons/bell1.wav");
	kvConfig.GetString("soccer_mod_otsound2", OTSound2, sizeof(OTSound2), "ambient/misc/brass_bell_f.wav");
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
	rankingPointsForGoal			= kvConfig.GetNum("soccer_mod_ranking_points_goal", 17);
	rankingPointsForAssist			= kvConfig.GetNum("soccer_mod_ranking_points_assist", 12);
	rankingPointsForOwnGoal			= kvConfig.GetNum("soccer_mod_ranking_points_own_goal", -10);
	rankingPointsForHit				= kvConfig.GetNum("soccer_mod_ranking_points_hit", 1);
	rankingPointsForPass			= kvConfig.GetNum("soccer_mod_ranking_points_pass", 5);
	rankingPointsForInterception	= kvConfig.GetNum("soccer_mod_ranking_points_interception",3);
	rankingPointsForBallLoss		= kvConfig.GetNum("soccer_mod_ranking_points_ball_loss", -3);
	rankingPointsForSave			= kvConfig.GetNum("soccer_mod_ranking_points_save", 6);
	rankingPointsForRoundWon		= kvConfig.GetNum("soccer_mod_ranking_points_round_won", 10);
	rankingPointsForRoundLost		= kvConfig.GetNum("soccer_mod_ranking_points_round_lost", -10);
	rankingPointsForMVP				= kvConfig.GetNum("soccer_mod_ranking_points_mvp", 15);
	rankingPointsForMOTM			= kvConfig.GetNum("soccer_mod_ranking_points_motm", 25);
	rankingCDTime					= kvConfig.GetNum("soccer_mod_ranking_cdtime", 300);
	gksavesSet						= kvConfig.GetNum("soccer_mod_gksaves_only", 0);
	rankMode						= kvConfig.GetNum("soccer_mod_rankmode", 0);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Training Settings", true);
	kvConfig.GetString("soccer_mod_training_model_ball", trainingModelBall, sizeof(trainingModelBall), "models/soccer_mod/ball_2011.mdl");
	AdvTrain_PWReqSet 				= kvConfig.GetNum("soccer_mod_training_advpwreq");
	kvConfig.GetString("soccer_mod_training_advpw",	AdvTrain_PW, sizeof(AdvTrain_PW));
	targetResetTime 				= kvConfig.GetFloat("soccer_mod_training_advresettime",	2.0);
	kvConfig.GoBack();
	
	kvConfig.JumpToKey("Debug Settings", true);
	debuggingEnabled		= kvConfig.GetNum("soccer_mod_debug", 0);
	kvConfig.GetString("soccer_mod_spawnball", spawnModelBall, sizeof(spawnModelBall), "models/soccer_mod/ball_2011.mdl");
	kvConfig.GoBack();
	
	kvConfig.Rewind();
	kvConfig.Close();
}