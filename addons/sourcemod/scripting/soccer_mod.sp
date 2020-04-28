// **************************************************************************************************************
// ************************************************** DEFINES ***************************************************
// **************************************************************************************************************
#define PLUGIN_VERSION "1.1.1"
#define UPDATE_URL "https://raw.githubusercontent.com/MK99MA/soccermod-2019edit/master/addons/sourcemod/updatefile.txt"
#define MAX_NAMES 10

// **************************************************************************************************************
// ************************************************** INCLUDES **************************************************
// **************************************************************************************************************
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <sdkhooks>
#include <cstrike>
#include <regex>
#include <morecolors>
#include <clientprefs>
#undef REQUIRE_PLUGIN
#include <updater>

#pragma newdecls required

#include "soccer_mod\globals.sp"
#include "soccer_mod\server_commands.sp"
#include "soccer_mod\client_commands.sp"
#include "soccer_mod\colormenu.sp"
#include "soccer_mod\database.sp"
#include "soccer_mod\menus.sp"
#include "soccer_mod\createconfig.sp"

#include "soccer_mod\modules\adminmanagement.sp"
#include "soccer_mod\modules\afkkicker.sp"
#include "soccer_mod\modules\cap.sp"
#include "soccer_mod\modules\deadchat.sp"
#include "soccer_mod\modules\duckjumpblock.sp"
#include "soccer_mod\modules\health.sp"
#include "soccer_mod\modules\readycheck.sp"
#include "soccer_mod\modules\match.sp"
#include "soccer_mod\modules\ranking.sp"
#include "soccer_mod\modules\referee.sp"
#include "soccer_mod\modules\respawn.sp"
#include "soccer_mod\modules\settings.sp"
#include "soccer_mod\modules\chatset.sp"
#include "soccer_mod\modules\skins.sp"
#include "soccer_mod\modules\sprint.sp"
#include "soccer_mod\modules\sounds.sp"
#include "soccer_mod\modules\stats.sp"
#include "soccer_mod\modules\training.sp"
#include "soccer_mod\modules\training_personalcannon.sp"
#include "soccer_mod\modules\savelogs.sp"

#include "soccer_mod\fixes\join_team.sp"
#include "soccer_mod\fixes\radio_commands.sp"
#include "soccer_mod\fixes\remove_knives.sp"

// *****************************************************************************************************************
// ************************************************** PLUGIN INFO **************************************************
// *****************************************************************************************************************
public Plugin myinfo =
{
	name			= "Soccer Mod Edit",
	author		  = "Marco Boogers & Arturo",
	description	 = "A plugin for soccer servers",
	version		 = PLUGIN_VERSION,
	url			 = "http://steamcommunity.com/groups/soccer_mod"
};

// ******************************************************************************************************************
// ************************************************** PLUGIN START **************************************************
// ******************************************************************************************************************
public void OnPluginStart()
{
	CreateConVar("soccer_mod_version", PLUGIN_VERSION, "Soccer Mod version", FCVAR_NOTIFY| FCVAR_DONTRECORD);
	
	// Updater******************************************
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin(UPDATE_URL)
	}
	//**************************************************
	
	if (!DirExists("cfg/sm_soccermod"))			CreateDirectory("cfg/sm_soccermod", 511, false);
	if (!DirExists("cfg/sm_soccermod/logs"))	CreateDirectory("cfg/sm_soccermod/logs", 511, false);

	
	//GetGameFolderName(gamevar, sizeof(gamevar));

	AddCommandListener(SayCommandListener, "say");
	AddCommandListener(SayCommandListener, "say2");
	AddCommandListener(SayCommandListener, "say_team");
	AddCommandListener(cmd_jointeam, "jointeam");
	AddCommandListener(cmd_jointeam, "spectate");
	AddAmbientSoundHook(AmbientSHook);
	AddNormalSoundHook(sound_hook);

	HookEntityOutput("func_physbox",	"OnAwakened",	   OnAwakened);
	HookEntityOutput("prop_physics",	"OnAwakened",	   OnAwakened);
	HookEntityOutput("trigger_hurt",	"OnStartTouch",	 OnStartTouch);
	HookEntityOutput("trigger_once",	"OnStartTouch",	 OnStartTouch);
	HookEntityOutput("func_physbox",	"OnDamaged",		OnTakeDamage);
	HookEntityOutput("prop_physics",	"OnTakeDamage",	 OnTakeDamage);

	HookEvent("cs_win_panel_match",	 EventCSWinPanelMatch);
	HookEvent("player_death",		   EventPlayerDeath);
	HookEvent("player_hurt",			EventPlayerHurt);
	HookEvent("player_spawn",		   EventPlayerSpawn);
	HookEvent("player_team",			EventPlayerTeam);
	HookEvent("round_start",			EventRoundStart);
	HookEvent("round_end",			  EventRoundEnd);

	//LoadTranslations("soccer_mod.phrases.txt");
	
	//pw = FindConVar("sv_password");

	ConnectToDatabase();
	LoadAllowedMaps();
	if (StrEqual(gamevar, "cstrike")) trainingModelBall = "models/soccer_mod/ball_2011.mdl";
	ConfigFunc();
	LoadConfigSoccer();
	LoadConfigPublic();
	RegisterClientCommands();
	RegisterServerCommands();

	CapOnPluginStart();
	DeadChatOnPluginStart()
	RefereeOnPluginStart();
	SkinsOnPluginStart();
	SprintOnPluginStart();
	StatsOnPluginStart();
	TrainingOnPluginStart();

	LoadJoinTeamFix();
	LoadRadioCommandsFix();
}

// Updater******************************************
public void OnLibraryAdded(const char []name)
{
	if (StrEqual(name, "updater"))
	{
		Updater_AddPlugin(UPDATE_URL);
	}
}
//**************************************************

// ***********************************************************************************************************************
// ************************************************** COMMAND LISTENERS **************************************************
// ***********************************************************************************************************************
public Action SayCommandListener(int client, char[] command, int argc)
{
	if (currentMapAllowed)
	{
		char cmdArg1[32];
		GetCmdArg(1, cmdArg1, sizeof(cmdArg1));

		float number = StringToFloat(cmdArg1);
		int intnumber = StringToInt(cmdArg1);
		char custom_tag[32];
		char custom_flag[32];
		char custom_teamname[32];
		char admin_value[64];
		
		custom_tag = cmdArg1;
		custom_flag = cmdArg1;
		custom_teamname = cmdArg1;
		admin_value = cmdArg1;

		if (StrEqual(changeSetting[client], "randomness"))
		{
			TrainingCannonSet(client, "randomness", number, 0.0, 500.0);
			return Plugin_Handled;
		}
		else if (StrEqual(changeSetting[client], "fire_rate"))
		{
			TrainingCannonSet(client, "fire_rate", number, 0.5, 10.0);
			return Plugin_Handled;
		}
		else if (StrEqual(changeSetting[client], "power"))
		{
			TrainingCannonSet(client, "power", number, 0.001, 10000.0);
			return Plugin_Handled;
		}
		else if (StrEqual(changeSetting[client], "pers_randomness"))
		{
			PersonalTrainingCannonSet(client, "randomness", number, 0.0, 500.0);
			return Plugin_Handled;
		}
		else if (StrEqual(changeSetting[client], "pers_fire_rate"))
		{
			PersonalTrainingCannonSet(client, "fire_rate", number, 0.5, 10.0);
			return Plugin_Handled;
		}
		else if (StrEqual(changeSetting[client], "pers_power"))
		{
			PersonalTrainingCannonSet(client, "power", number, 0.001, 10000.0);
			return Plugin_Handled;
		}
		else if (StrEqual(changeSetting[client], "CustomMaxPlayers"))
		{
			MatchSet(client, "CustomMaxPlayers", intnumber, 2, 12);
			return Plugin_Handled;
		}
		else if (StrEqual(changeSetting[client], "CustomPeriodLength"))
		{
			MatchSet(client, "CustomPeriodLength", intnumber, 10, 1800);
			return Plugin_Handled;			
		}
		else if (StrEqual(changeSetting[client], "CustomPeriodBreakLength"))
		{
			MatchSet(client, "CustomPeriodBreakLength", intnumber, 5, 60);
			return Plugin_Handled;			
		}		
		else if (StrEqual(changeSetting[client], "ForfeitScoreSet"))
		{
			ForfeitSet(client, "ForfeitScoreSet", intnumber, 4, 16);
			return Plugin_Handled;			
		}
		else if (StrEqual(changeSetting[client], "CustomPrefix"))
		{
			ChatSet(client, "CustomPrefix", custom_tag);
			return Plugin_Handled;			
		}
		else if (StrEqual(changeSetting[client], "CustomPrefixCol"))
		{
			ChatSet(client, "CustomPrefixCol", custom_tag);
			return Plugin_Handled;			
		}
		else if (StrEqual(changeSetting[client], "TextCol"))
		{
			ChatSet(client, "TextCol", custom_tag);
			return Plugin_Handled;			
		}	
		else if (StrEqual(changeSetting[client], "LockServerNum"))
		{
			LockSet(client, "LockServerNum", intnumber, 4, 20);
			return Plugin_Handled;			
		}	
		else if (StrEqual(changeSetting[client], "CustomNameTeamT"))
		{
			NameSet(client, "CustomNameTeamT", custom_teamname);
			return Plugin_Handled;			
		}	
		else if (StrEqual(changeSetting[client], "CustomNameTeamCT"))
		{
			NameSet(client, "CustomNameTeamCT", custom_teamname);
			return Plugin_Handled;			
		}
		else if (StrEqual(changeSetting[client], "CustFlag"))
		{
			CustomFlagListener(client, "CustFlag", custom_flag);
			return Plugin_Handled;			
		}
		else if (StrEqual(changeSetting[client], "CaptchaNum"))
		{
			LockSet(client, "CaptchaNum", intnumber, 30, 600);
			return Plugin_Handled;			
		}	
		else if (StrEqual(changeSetting[client], "MenuNum"))
		{
			LockSet(client, "MenuNum", intnumber, 10, 60);
			return Plugin_Handled;			
		}
		else if (StrEqual(changeSetting[client], "AdminNameValue"))
		{
			AdminSetListener(client, "AdminNameValue", admin_value, 0, 50);
			return Plugin_Handled;
		}
		else if (StrEqual(changeSetting[client], "AdminFlagsValue"))
		{
			AdminSetListener(client, "AdminFlagsValue", admin_value, 0, 32);
			return Plugin_Handled;
		}
		else if (StrEqual(changeSetting[client], "AdminImmunityValue"))
		{
			AdminSetListener(client, "AdminImmunityValue", admin_value, 0, 2);
			return Plugin_Handled;
		}
	}

	return Plugin_Continue;
}

// ********************************************************************************************************************
// ************************************************** ENTITY OUTPUTS **************************************************
// ********************************************************************************************************************
public void OnAwakened(char[] output, int caller, int activator, float delay)
{
	if (currentMapAllowed)
	{
		PrintEntityOutput(output, caller, activator);

		MatchOnAwakened(caller, activator);
		StatsOnAwakened(caller, activator);
	}
}

public void OnStartTouch(char[] output, int caller, int activator, float delay)
{
	if (currentMapAllowed)
	{
		PrintEntityOutput(output, caller, activator);

		char callerClassname[64];
		GetEntityClassname(caller, callerClassname, sizeof(callerClassname));

		char callerName[64];
		GetEntPropString(caller, Prop_Data, "m_iName", callerName, sizeof(callerName));

		if (StrEqual(gamevar, "csgo") && StrEqual(callerClassname, "trigger_once") && (StrEqual(callerName, "goal_ct") || StrEqual(callerName, "goal_t")))
		{
			int gameRoundEndIndex = 0;
			bool gameRoundEndExists = false;

			while ((gameRoundEndIndex = FindEntityByClassname(gameRoundEndIndex, "game_round_end")) != INVALID_ENT_REFERENCE) gameRoundEndExists = true;

			if (!gameRoundEndExists)
			{
				int roundEndIndex = CreateEntityByName("game_round_end");
				DispatchSpawn(roundEndIndex);

				SetVariantString("5.0");
				if (StrEqual(callerName, "goal_t")) AcceptEntityInput(roundEndIndex, "EndRound_CounterTerroristsWin");
				else if (StrEqual(callerName, "goal_ct")) AcceptEntityInput(roundEndIndex, "EndRound_TerroristsWin");
			}
		}
		else if (activator >= 1 && activator <= MaxClients && StrEqual(callerClassname, "trigger_hurt") && !goalScored)
		{
			goalScored = true;

			HealthOnStartTouch(caller, activator);
		}

		if (StrEqual(callerClassname, "trigger_once") && StrEqual(callerName, "end_stoppage_time"))
		{
			MatchOnStartTouch(caller, activator);
		}
	}
}

public void OnTakeDamage(char[] output, int caller, int activator, float delay)
{
	if (currentMapAllowed)
	{
		PrintEntityOutput(output, caller, activator);

		// DispatchKeyValue(caller, "physdamagescale", "-1");

		if (activator >= 1 && activator <= MaxClients && !roundEnded)
		{
			StatsOnTakeDamage(caller, activator);
		}
	}
}

// ************************************************************************************************************
// ************************************************** EVENTS **************************************************
// ************************************************************************************************************
public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	bLATE_LOAD = late;
	
	return APLRes_Success;
}

public void OnConfigsExecuted()
{
	//After every Config was executed change the tags to include soccer tags
	AddSoccerTags();
}

public void OnMapStart()
{
	//Create missing ConfigFiles and/or read them
	if (!FileExists(configFileKV) || !FileExists(adminFileKV) || !FileExists("cfg/sm_soccermod/soccer_mod_downloads.cfg") || !FileExists(allowedMapsConfigFile) || !FileExists(statsKeygroupGoalkeeperAreas) || !FileExists(skinsKeygroup) || !FileExists(pathCapPositionsFile))
	{
		ConfigFunc();
		ReadFromConfig();
	}
	else 
	{
		ReadFromConfig();
	}
	if (FileExists(tempReadyFileKV)) DeleteTempFile();
	ReadMatchlogSettings();
	
	//Get the server password from server.cfg
	GetDefaultPassword(defaultpw, sizeof(defaultpw));
	
	//Get the available Admin Groups from admin_groups.cfg
	groupArray = CreateArray(8);
	ParseAdminGroups(groupArray);
	
	LoadAllowedMaps();
	currentMapAllowed = IsCurrentMapAllowed();
	
	if (currentMapAllowed)
	{
		LoadConfigSoccer();
		LoadConfigPublic();
		SoundSetup();
		if(bLATE_LOAD)
		{
			SetEveryClientDefaultSettings();
			//Clientprefs
			ReadEveryClientCookie();
		}
		bLATE_LOAD = false;

		return;
	}
	else LoadConfigNonSoccer();

	MatchOnMapStart();
	SkinsOnMapStart();
	StatsOnMapStart();
	TrainingOnMapStart();
	PersonalTrainingOnMapStart();
	
	// Kill possibly running ForfeitTimer
	ForfeitReset();
}

public void OnAllPluginsLoaded()
{
	AddDirToDownloads("sound/soccermod");
	AddDirToDownloads("materials/models/soccer_mod");
	AddDirToDownloads("models/soccer_mod");
	
	if (StrEqual(gamevar, "cstrike"))
	{
		AddDirToDownloads("materials/models/player/soccer_mod/termi/2011");
		AddDirToDownloads("models/player/soccer_mod/termi/2011");
	}
	else
	{
		AddDirToDownloads("materials/models/player/soccermod");
		AddDirToDownloads("models/player/soccermod");
	}
}

public void OnClientPutInServer(int client)
{
	changeSetting[client] = "";

	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamageArmor);
	
	DatabaseCheckPlayer(client);

	RespawnOnClientPutInServer(client);
	SkinsOnClientPutInServer(client);
	//SprintOnClientPutInServer(client);
	AFKKickOnClientPutInServer(client);

	ReadPersonalCannonSettings(client);
	RadioCommandsOnClientPutInServer(client);
	if((pwchange == true) && (GetClientCount() == PWMAXPLAYERS+1) && (passwordlock == 1))
	{
		CPrintToChatAll("{%s}[%s] Threshold hit. Locking server again");
		RandPass();
	}
}

public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs)
{
	char cString[512]
	strcopy(cString, sizeof(cString), sArgs);
	StripQuotes (cString);
		
	if((cString[0] == '!') || (cString[0] == '/'))
	{
		for(int i = 1; i <= strlen(cString); i++)
		{
			if(IsCharUpper(cString[i])) 
			{
				cString[i] = CharToLower(cString[i]);
				FakeClientCommand(client, "say %s", cString);
				return Plugin_Handled;
			}
		}
	}
	
	return Plugin_Continue;
}

public Action OnTakeDamageArmor(int victim, int& attacker, int& inflictor, float& damage, int& damagetype)
{
	if(!capFightStarted)
	{
		char sEntity[64], sEntity2[64];
		GetEdictClassname(inflictor, sEntity, sizeof(sEntity));
		GetEdictClassname(inflictor, sEntity2, sizeof(sEntity2));
		
		if(StrEqual(sEntity, "func_physbox", false) || StrEqual(sEntity, "prop_physics", false) || StrEqual(sEntity2, "func_physbox", false) || StrEqual(sEntity2, "prop_physics", false))
		{
			damage = 0.0;
			return Plugin_Changed;
		}
	}
	
	return Plugin_Continue;
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon)
{
	DJBOnPlayerRunCmd(client, buttons, impulse, vel, angles, weapon);
	//if((passwordlock == 1) && (pwchange == true))	AFKKickOnPlayerRunCmd(client, buttons, impulse, vel, angles, weapon);
}

public void OnClientDisconnect(int client)
{
	DatabaseCheckPlayer(client);

	RespawnOnClientDisconnect(client);

	RadioCommandsOnClientDisconnect(client);
	SavePersonalCannonSettings(client);
	ReadyCheckOnClientDisconnect(client);
	WriteClientCookie(client);
}

public void OnClientDisconnect_Post(int client)
{
	if((pwchange == true) && (passwordlock == 1) && (GetClientCount() == PWMAXPLAYERS))
	{
		CPrintToChatAll("{%s}[%s]A player left, reverting password to default", prefixcolor, prefix);
		ResetPass();
	}
	else if ((pwchange == true) && (passwordlock == 1) && (GetClientCount() == 0))
	{
		AFKKickStop();
		pwchange = false;
	}
}

public Action EventCSWinPanelMatch(Event event, const char[] name, bool dontBroadcast)
{
	if (currentMapAllowed)
	{
		MatchEventCSWinPanelMatch(event);
		StatsEventCSWinPanelMatch(event);
	}
}

public Action EventPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	if (currentMapAllowed)
	{
		HealthEventPlayerSpawn(event);
		RefereeEventPlayerSpawn(event);
		SkinsEventPlayerSpawn(event);
		StatsEventPlayerSpawn(event);
		
		RemoveKnivesEventPlayerSpawn(event);
		//Sprint
		char iClient = GetClientOfUserId(GetEventInt(event, "userid"));
		ResetSprint(iClient);
		PrintSprintCDMsgToClient(iClient);
		iCLIENT_STATUS[iClient] &= ~ CLIENT_SPRINTUNABLE;
	}
}

public Action EventPlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
	if (currentMapAllowed)
	{
		RespawnEventPlayer(event);
	}
}

public Action EventPlayerHurt(Event event, const char[] name, bool dontBroadcast)
{
	if (currentMapAllowed)
	{
		HealthEventPlayerHurt(event);
	}
}

public Action EventPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	if (currentMapAllowed)
	{
		CapEventPlayerDeath(event);
		RespawnEventPlayer(event);
		//Sprint
		char iClient = GetClientOfUserId(GetEventInt(event, "userid"));
		ResetSprint(iClient);
	}
}

public Action EventRoundStart(Event event, const char[] name, bool dontBroadcast)
{
	currentMapAllowed = IsCurrentMapAllowed();

	if (currentMapAllowed)
	{
		roundEnded = false;
		goalScored = false;

		if (!matchStarted)
		{
			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) 
				{
					if(publicmode == 0) CPrintToChat(player,"{%s}[%s] {%s}Type {%s}!menu {%s}for more information", prefixcolor, prefix, textcolor, prefixcolor, textcolor);
					else if(publicmode == 1) CPrintToChat(player,"{%s}[%s] {%s}Public access of {%s}!cap / !match; !menu {%s}for more information",prefixcolor, prefix, textcolor, prefixcolor, textcolor);
					else if(publicmode == 2) CPrintToChat(player,"{%s}[%s] {%s}Public access of {%s}!menu {%s}enabled, feel free to use all of its features", prefixcolor, prefix, textcolor, prefixcolor, textcolor);
				}
			}
		}
				
		MatchEventRoundStart(event);
		StatsEventRoundStart(event);
		TrainingEventRoundStart(event);
		PersonalTrainingEventRoundStart(event);
	}
}

public Action EventRoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	if (currentMapAllowed)
	{
		roundEnded = true;

		CapEventRoundEnd(event);
		MatchEventRoundEnd(event);
		StatsEventRoundEnd(event);
	}
}


// ******************************************************************************************************************
// ************************************************** ALLOWED MAPS **************************************************
// ******************************************************************************************************************
public void LoadAllowedMaps()
{
	File file = OpenFile(allowedMapsConfigFile, "r");
	allowedMaps = CreateArray(128);

	if (file != null)
	{
		char map[128];
		int length;

		while (!file.EndOfFile() && file.ReadLine(map, sizeof(map)))
		{
			length = strlen(map);
			if (map[length - 1] == '\n') map[--length] = '\0';

			if (map[0] != '/' && map[1] != '/' && map[0]) PushArrayString(allowedMaps, map);
		}

		file.Close();
	}
	else CreateAllowedMapsFile();
}

public void CreateAllowedMapsFile()
{
	File file = OpenFile(allowedMapsConfigFile, "w");
	
	if (StrEqual(gamevar, "cstrike"))
	{
		PushArrayString(allowedMaps, "ka_soccer_xsl_stadium_b1");
		if (FileExists("maps/ka_soccer_stadium_2019_b1.bsp")) PushArrayString(allowedMaps, "ka_soccer_stadium_2019_b1");
		file.WriteLine("ka_soccer_xsl_stadium_b1");
		if (FileExists("maps/ka_soccer_stadium_2019_b1.bsp")) file.WriteLine("ka_soccer_stadium_2019_b1");
	}
	else
	{
		PushArrayString(allowedMaps, "ka_xsl_stadium_b1");
		file.WriteLine("ka_xsl_stadium_b1");
	}

	file.Close();
}

public bool IsCurrentMapAllowed()
{
	char map[128];
	GetCurrentMap(map, sizeof(map));
	if (FindStringInArray(allowedMaps, map) > -1) return true;
	return false;
}

public void SaveAllowedMaps()
{
	int i;
	File file = OpenFile(allowedMapsConfigFile, "w");

	if (file != null)
	{
		while (i < GetArraySize(allowedMaps))
		{
			char map[128];
			GetArrayString(allowedMaps, i, map, sizeof(map));
			file.WriteLine(map);
			i++;
		}

		file.Close();
	}
}

public void OpenMapsDirectory(char path[PLATFORM_MAX_PATH], Menu menu)
{
	Handle dir = OpenDirectory(path);
	if (dir != INVALID_HANDLE)
	{
		FileType type;
		char filename[PLATFORM_MAX_PATH];

		while (ReadDirEntry(dir, filename, sizeof(filename), type))
		{
			if (!StrEqual(filename, ".") && !StrEqual(filename, ".."))
			{
				char full[PLATFORM_MAX_PATH];
				Format(full, sizeof(full), "%s/%s", path, filename);

				if (type == FileType_File)
				{
					int replaced = ReplaceString(filename, sizeof(filename), ".bsp", "");
					Format(full, sizeof(full), "%s/%s", path, filename);
					ReplaceString(full, sizeof(full), "maps/", "");
					if (FindStringInArray(allowedMaps, full) < 0 && replaced && IsMapValid(full)) menu.AddItem(full, full);
				}
				else if (type == FileType_Directory) OpenMapsDirectory(full, menu);
			}
		}

		dir.Close();
	}
}

// *******************************************************************************************************************
// ************************************************** SERVER CONFIG **************************************************
// *******************************************************************************************************************
public void LoadConfigSoccer()
{
	if (StrEqual(gamevar, "csgo"))
	{
		SetCvarInt("cs_enable_player_physics_box",	 1);
		SetCvarInt("mp_do_warmup_period",			  0);
		SetCvarInt("mp_halftime",					  0);
		SetCvarInt("mp_playercashawards",			  0);
		SetCvarInt("mp_solid_teammates",			   1);
		SetCvarInt("mp_teamcashawards",				0);
		SetCvarInt("weapon_reticle_knife_show",		1);
	}

	SetCvarInt("mp_freezetime",				 0);
	SetCvarInt("mp_roundtime",				  60);
	SetCvarInt("phys_pushscale",				phys_pushscale);
	SetCvarFloat("phys_timescale",			  phys_timescale);
	//SetCvarInt("sv_client_min_interp_ratio",	0);
	//SetCvarInt("sv_client_max_interp_ratio",	0);

	if (FileExists("cfg/soccer.cfg", false)) ServerCommand("exec soccer");
}

public void LoadConfigNonSoccer()
{
	if (StrEqual(gamevar, "csgo"))
	{
		SetCvarInt("cs_enable_player_physics_box",	 0);
		SetCvarInt("mp_do_warmup_period",			  1);
		SetCvarInt("mp_halftime",					  1);
		SetCvarInt("mp_playercashawards",			  1);
		SetCvarInt("mp_solid_teammates",			   1);
		SetCvarInt("mp_teamcashawards",				1);
		SetCvarInt("weapon_reticle_knife_show",		1);
	}

	SetCvarInt("mp_freezetime",				 5);
	SetCvarInt("mp_roundtime",				  3);
	SetCvarInt("phys_pushscale",				1);
	SetCvarFloat("phys_timescale",			  1.0);
	SetCvarInt("sv_client_min_interp_ratio",	-1);
	SetCvarInt("sv_client_max_interp_ratio",	1);

	if (FileExists("cfg/non_soccer.cfg", false)) ServerCommand("exec non_soccer");
}

public void LoadConfigPublic()
{
	if (StrEqual(gamevar, "csgo"))
	{
		SetCvarInt("mp_match_can_clinch", 1);
	}

	SetCvarInt("mp_maxrounds", 0);

	if (FileExists("cfg/soccer_public.cfg", false)) ServerCommand("exec soccer_public");
}

public void LoadConfigMatch()
{
	if (StrEqual(gamevar, "csgo"))
	{
		SetCvarInt("mp_match_can_clinch", 0);
	}

	SetCvarInt("mp_maxrounds", 0);

	if (FileExists("cfg/soccer_match.cfg", false)) ServerCommand("exec soccer_match");
}

public void SetCvarInt(char[] cvarName, int value)
{
	Handle cvar;
	cvar = FindConVar(cvarName);

	if (cvar != INVALID_HANDLE)
	{
		int flags = GetConVarFlags(cvar);

		if (flags & FCVAR_NOTIFY)
		{
			flags &= ~FCVAR_NOTIFY;
			SetConVarFlags(cvar, flags);
		}

		SetConVarInt(cvar, value);

		if (flags & FCVAR_NOTIFY)
		{
			flags |= FCVAR_NOTIFY;
			SetConVarFlags(cvar, flags);
		}
	}
}

public void SetCvarFloat(char[] cvarName, float value)
{
	Handle cvar;
	cvar = FindConVar(cvarName);

	if (cvar != INVALID_HANDLE)
	{
		int flags = GetConVarFlags(cvar);

		if (flags & FCVAR_NOTIFY)
		{
			flags &= ~FCVAR_NOTIFY;
			SetConVarFlags(cvar, flags);
		}

		SetConVarFloat(cvar, value);

		if (flags & FCVAR_NOTIFY)
		{
			flags |= FCVAR_NOTIFY;
			SetConVarFlags(cvar, flags);
		}
	}
}

// ***************************************************************************************************************
// ************************************************** DOWNLOADS **************************************************
// ***************************************************************************************************************
public void AddDirToDownloads(char path[PLATFORM_MAX_PATH])
{
	Handle dir = OpenDirectory(path);

	if (dir != INVALID_HANDLE)
	{
		char filename[PLATFORM_MAX_PATH];
		FileType type;
		char full[PLATFORM_MAX_PATH];

		while (ReadDirEntry(dir, filename, sizeof(filename), type))
		{
			if (!StrEqual(filename, ".") && !StrEqual(filename, ".."))
			{
				Format(full, sizeof(full), "%s/%s", path, filename);
				
				if (type == FileType_File) AddFileToDownloadsTable(full);
				else if (type == FileType_Directory) AddDirToDownloads(full);
			}
		}

		dir.Close();
	}
	else PrintToServer("[%s] Can't add folder %s to the downloads", prefix, path);
}

// ************************************************************************************************************
// ************************************************** FREEZE **************************************************
// ************************************************************************************************************
public void FreezeAll()
{
	SetCvarFloat("phys_timescale", 0.0);
	SetCvarInt("phys_pushscale", 1);

	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client) && IsClientConnected(client)) SetEntityMoveType(client, MOVETYPE_NONE); // && IsPlayerAlive(client)) SetEntityMoveType(client, MOVETYPE_NONE);
	}
}

public void UnfreezeAll()
{
	SetCvarFloat("phys_timescale", phys_timescale);
	SetCvarInt("phys_pushscale", phys_pushscale);

	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client) && IsClientConnected(client)) SetEntityMoveType(client, MOVETYPE_WALK);// && IsPlayerAlive(client)) SetEntityMoveType(client, MOVETYPE_WALK);
	}
}

// **************************************************************************************************************
// ************************************************** ENTITIES **************************************************
// **************************************************************************************************************
stock int GetEntityIndexByName(char[] name, char[] classname)
{
	int index = -1;
	char entityName[64];

	while ((index = FindEntityByClassname(index, classname)) != INVALID_ENT_REFERENCE)
	{
		GetEntPropString(index, Prop_Data, "m_iName", entityName, sizeof(entityName));
		if (StrEqual(entityName, name)) return index;
	}

	return -1;
}

// *************************************************************************************************************
// ************************************************** GET AIM **************************************************
// *************************************************************************************************************
stock bool GetAimOrigin(int client, float aimOrigin[3])
{
	float eyeAngles[3], eyePosition[3];
	GetClientEyeAngles(client, eyeAngles);
	GetClientEyePosition(client, eyePosition);

	Handle traceRay = TR_TraceRayFilterEx(eyePosition, eyeAngles, MASK_SHOT, RayType_Infinite, TraceEntityFilterPlayer);

	if (TR_DidHit(traceRay))
	{
		TR_GetEndPosition(aimOrigin, traceRay);
		traceRay.Close();
		return true;
	}

	traceRay.Close();
	return false;
}

public bool TraceEntityFilterPlayer(int entity, int contentsMask) 
{
	return entity > MaxClients;
}

// ****************************************************************************************************************
// ************************************************** DRAW LASER **************************************************
// ****************************************************************************************************************
stock bool DrawLaser(char[] name, float startX, float startY, float startZ, float endX, float endY, float endZ, char[] color)
{
	int index = CreateEntityByName("env_beam");

	if (index != -1)
	{
		float start[3];
		start[0] = startX;
		start[1] = startY;
		start[2] = startZ;

		float end[3];
		end[0] = endX;
		end[1] = endY;
		end[2] = endZ;

		if (!IsModelPrecached("materials/sprites/laserbeam.vmt")) PrecacheModel("materials/sprites/laserbeam.vmt");

		DispatchKeyValue(index, "targetname", name);
		DispatchKeyValue(index, "spawnflags", "1");
		DispatchKeyValue(index, "texture", "sprites/laserbeam.spr");
		DispatchKeyValue(index, "life", "0");
		DispatchKeyValue(index, "BoltWidth", "2.5");
		DispatchKeyValue(index, "rendercolor", color);
		DispatchKeyValue(index, "renderamt", "255");
		SetEntityModel(index, "sprites/laserbeam.vmt");
		TeleportEntity(index, start, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(index);
		SetEntPropVector(index, Prop_Data, "m_vecEndPos", end);
		AcceptEntityInput(index, "TurnOn");

		return true;
	}

	return false;
}

// ***************************************************************************************************************
// ************************************************** DEBUGGING **************************************************
// ***************************************************************************************************************
public void PrintEntityOutput(char[] output, int caller, int activator)
{
	if (debuggingEnabled)
	{
		char callerClassname[64];
		GetEntityClassname(caller, callerClassname, sizeof(callerClassname));

		char activatorClassname[64];
		GetEntityClassname(activator, activatorClassname, sizeof(activatorClassname));

		char callerName[64];
		if (StrEqual(callerClassname, "player")) GetClientName(caller, callerName, sizeof(callerName));
		else GetEntPropString(caller, Prop_Data, "m_iName", callerName, sizeof(callerName));

		char activatorName[64];
		if (StrEqual(activatorClassname, "player")) GetClientName(activator, activatorName, sizeof(activatorName));
		else GetEntPropString(activator, Prop_Data, "m_iName", activatorName, sizeof(activatorName));

		PrintToChatAll("[%s] %s - Caller: %s (%i) (%s), Activator: %s (%i) (%s)", prefix, output, callerName, caller, callerClassname, activatorName, activator, activatorClassname);
	}
}

// ************************************************************************************************************
// ************************************************** TIMERS **************************************************
// ************************************************************************************************************
public Action DelayedServerCommand(Handle timer, DataPack pack)
{
	pack.Reset();
	char command[64];
	pack.ReadString(command, sizeof(command));
	ServerCommand(command);
}

public void ClearTimer(Handle timer)
{
	if (timer != null)
	{
		KillTimer(timer);
		timer = null;
	}
}