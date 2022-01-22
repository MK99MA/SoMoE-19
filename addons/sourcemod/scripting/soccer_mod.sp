// **************************************************************************************************************
// ************************************************** DEFINES ***************************************************
// ************************************************************************************************************** 
#define PLUGIN_VERSION "1.3.2"
#define UPDATE_URL "https://raw.githubusercontent.com/MK99MA/SoMoE-19/master/addons/sourcemod/updatefile.txt"
#define MAX_NAMES 10
#define MAXCONES_DYN 15
#define MAXCONES_STA 15
#define CLIENT_SHOUTCD  (1<<1)

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
#include <advanced_motd>
#include <clientprefs>
#undef REQUIRE_PLUGIN
#include <updater>
#undef REQUIRE_EXTENSIONS
#include <SteamWorks>

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
#include "soccer_mod\modules\kickoffwall.sp"
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
#include "soccer_mod\modules\serverinfo.sp"
#include "soccer_mod\modules\joinlist.sp"
#include "soccer_mod\modules\mapdefaults.sp"
#include "soccer_mod\modules\gkareas.sp"
#include "soccer_mod\modules\training_adv.sp"
#include "soccer_mod\modules\shout.sp"
#include "soccer_mod\modules\grassreplacer.sp"

#include "soccer_mod\fixes\join_team.sp"
#include "soccer_mod\fixes\radio_commands.sp"
#include "soccer_mod\fixes\remove_knives.sp"

// *****************************************************************************************************************
// ************************************************** PLUGIN INFO **************************************************
// *****************************************************************************************************************
public Plugin myinfo =
{
	name		 = "SoMoE-19",
	author		 = "Marco Boogers & Arturo",
	description	 = "A plugin for soccer servers",
	version		 = PLUGIN_VERSION,
	url			 = "https://github.com/MK99MA/soccermod-2019edit"
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

	
	GetGameFolderName(gamevar, sizeof(gamevar));

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
	HookEntityOutput("trigger_multiple", "OnStartTouch", OnStartTouch);
	HookEntityOutput("trigger_multiple", "OnEndTouch", 	 OnEndTouch);
	HookEntityOutput("func_physbox",	"OnDamaged",		OnTakeDamage);
	HookEntityOutput("prop_physics",	"OnTakeDamage",	 OnTakeDamage);

	HookEvent("cs_win_panel_match",	 EventCSWinPanelMatch);
	HookEvent("player_death",		   EventPlayerDeath);
	HookEvent("player_death",			Event_PlayerDeath_Pre, EventHookMode_Pre);
	HookEvent("player_hurt",			EventPlayerHurt);
	HookEvent("player_spawn",		   EventPlayerSpawn);
	HookEvent("player_team",			EventPlayerTeam);
	HookEvent("player_jump", 			EventPlayerJump);
	HookEvent("round_start",			EventRoundStart);
	HookEvent("round_end",			  EventRoundEnd);
	
	TextMsg  = GetUserMessageId("TextMsg");
	HookUserMessage(TextMsg,			EventUserMessage, true);
	
	AddTempEntHook("Player Decal", Player_Decal);

	if (StrEqual(gamevar, "cstrike")) HookUserMessage(GetUserMessageId("VGUIMenu"), HookMsg, true);
	//LoadTranslations("soccer_mod.phrases.txt");
	
	ConnectToDatabase();
	LoadAllowedMaps();
	ConfigFunc();
	//CreateDCListFile(true);
	LoadConfigSoccer();
	LoadConfigPublic();
	RegisterClientCommands();
	RegisterServerCommands();

	CapOnPluginStart();
	DeadChatOnPluginStart();
	MatchOnPluginStart();
	RefereeOnPluginStart();
	SkinsOnPluginStart();
	SprintOnPluginStart();
	StatsOnPluginStart();
	TrainingOnPluginStart();
	ConnectlistOnPluginStart();
	ShoutOnPluginStart();
	ReplacerOnPluginStart();

	LoadJoinTeamFix();
	LoadRadioCommandsFix();
	AddDownloads();
}

public void OnPluginEnd()
{
	//Clientprefs
	WriteEveryClientCookie();
	return;
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

public Action HookMsg(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	static char txt[16];
	txt[0] = 0;
	BfReadString(msg, txt, sizeof(txt));
	if (joinclassSet == 0)
	{
		if(txt[0] == 'c' && txt[1] == 'l' && txt[2] == 'a' && txt[3] == 's' && txt[4] == 's' && txt[5] == '_')
		{
			FakeClientCommandEx(players[0], "joinclass %d", txt[6] == 't' ? 1 : 5);
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

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
			TrainingCannonSet(client, "fire_rate", number, 0.1, 10.0);
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
			PersonalTrainingCannonSet(client, "fire_rate", number, 0.1, 10.0);
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
		else if (StrEqual(changeSetting[client], "CustomRankCD"))
		{
			CDSet(client, "CustomRankCD", intnumber, 0, 3600);
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
		else if (StrEqual(changeSetting[client], "AdvTrainingPW"))
		{
			AdvTrainSet(client, "AdvTrainingPW", custom_tag);
			return Plugin_Handled;			
		}		
		else if (StrEqual(changeSetting[client], "AdvTrainingPWInput"))
		{
			AdvTrainSet(client, "AdvTrainingPWInput", custom_tag);
			return Plugin_Handled;			
		}	
		else if (StrEqual(changeSetting[client], "AdvTrainingTime"))
		{
			AdvTrainSetFloat(client, "AdvTrainingTime", number);
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
		else if (StrEqual(changeSetting[client], "CustomName"))
		{
			ShoutNameSet(client, "CustomShoutName", admin_value, 3, 64);
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
		
		if (StrEqual(callerClassname, "trigger_multiple")) 
		{
			if(StrEqual(callerName, "soccer_mod_training_targettrigger_2")) //T
			{
				TargetOnStartTouch(caller, activator, CS_TEAM_T);
			}
			if(StrEqual(callerName, "soccer_mod_training_targettrigger_3")) //CT
			{
				TargetOnStartTouch(caller, activator, CS_TEAM_CT);
			}
			
			for(int i = 0; i < MaxClients; i++)
			{
				if (IsValidClient(i))
				{
					char plateName[64], canName[64];
					Format(canName, sizeof(canName), "soccer_mod_training_cantrigger_%i", i);
					Format(plateName, sizeof(plateName), "soccer_mod_training_platetrigger_%i", i);
					
					if (StrEqual(callerClassname, "trigger_multiple") && StrEqual(callerName, canName))
					{
						PropOnStartTouch(caller, activator, i, canName, "can");
					}
					if (StrEqual(callerClassname, "trigger_multiple") && StrEqual(callerName, plateName))
					{
						PropOnStartTouch(caller, activator, i, plateName, "plate");
					}
				}
			}
		}
		
		if(StrEqual(callerClassname, "trigger_once") && ((StrContains(callerName, "soccer_mod_training_targettrigger_2_") != -1) || (StrContains(callerName, "soccer_mod_training_targettrigger_3_") != -1)))
		{
			if(StrContains(callerName, "soccer_mod_training_targettrigger_2_") != -1) //T
			{
				TargetOnStartTouch(caller, activator, CS_TEAM_T);
			}
			if(StrContains(callerName, "soccer_mod_training_targettrigger_3_") != -1) //CT
			{
				TargetOnStartTouch(caller, activator, CS_TEAM_CT);
			}
		}
	}
}

public void OnEndTouch(char[] output, int caller, int activator, float delay)
{
	char callerClassname[64];
	GetEntityClassname(caller, callerClassname, sizeof(callerClassname));

	char callerName[64];
	GetEntPropString(caller, Prop_Data, "m_iName", callerName, sizeof(callerName));
	
	for(int i = 0; i < MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			char plateName[64], canName[64];
			Format(canName, sizeof(canName), "soccer_mod_training_cantrigger_%i", i);
			Format(plateName, sizeof(plateName), "soccer_mod_training_platetrigger_%i", i);
			
			if (StrEqual(callerClassname, "trigger_multiple") && StrEqual(callerName, canName))
			{
				PropOnEndTouch(caller, activator, i, canName, "can");
			}
			if (StrEqual(callerClassname, "trigger_multiple") && StrEqual(callerName, plateName))
			{
				PropOnEndTouch(caller, activator, i, plateName, "plate");
			}
		}
	}
}

public void OnTakeDamage(char[] output, int caller, int activator, float delay)
{
	if (currentMapAllowed)
	{
		PrintEntityOutput(output, caller, activator);
		
		char callerClassname[64];
		GetEntityClassname(caller, callerClassname, sizeof(callerClassname));
		// DispatchKeyValue(caller, "physdamagescale", "-1");

		if (activator >= 1 && activator <= MaxClients && !roundEnded && !StrEqual(callerClassname, "prop_dynamic"))
		{
			StatsOnTakeDamage(caller, activator);
		}
		
		if(trainingModeEnabled && (StrEqual(callerClassname, "func_physbox") || StrEqual(callerClassname, "prop_physics")))
		{
			if(autoToggle[0])
			{
				//caller = ball
				if(lastTargetBallId[0] == caller)
				{
					if(!hitHelper[0])
					{
						if (trainingCannonTimer == null && pers_trainingCannonTimer[activator] == null)
						{
							hitHelper[0] = true;
							DataPack pack = new DataPack();
							trainingBallResetTimer[0] = CreateDataTimer(targetResetTime, AutoResetBall, pack);
							WritePackCell(pack, CS_TEAM_T);
							WritePackCell(pack, caller);
						}
					}
				}
			}
			if(autoToggle[1])
			{
				if(lastTargetBallId[1] == caller)
				{
					if(!hitHelper[1])
					{
						if (trainingCannonTimer == null && pers_trainingCannonTimer[activator] == null)
						{
							hitHelper[1] = true;
							DataPack pack = new DataPack();
							trainingBallResetTimer[1] = CreateDataTimer(targetResetTime, AutoResetBall, pack);
							WritePackCell(pack, CS_TEAM_CT);
							WritePackCell(pack, caller);
						}
					}
				}
			}
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
	//AddSoccerTags();
	
	//GetFieldOrientation();	
	
	// Set Defaults if existing
	if(defaultSet == 1) SetDefaultValues(0);
	
	// Get hostname
	g_hostname = FindConVar("hostname");
	g_hostname.GetString(old_hostname, 250);
	
	if (GetExtensionFileStatus("SteamWorks.ext") > 0)
	{
		ChangeGameDesc();
	}
}

public void OnMapStart()
{
	g_BeamSprite = PrecacheModel("materials/sprites/laser.vmt", true);
	g_HaloSprite = PrecacheModel("materials/sprites/halo01.vmt", true);
	
	if(FileExists("addons/sourcemod/plugins/shout.smx"))
	{
		ServerCommand("sm plugins unload shout");
		RenameFile("addons/sourcemod/plugins/disabled/shout.smx", "addons/sourcemod/plugins/shout.smx");
	}
	
	//Create missing ConfigFiles and/or read them
	if (!FileExists(configFileKV) || !FileExists(adminFileKV) || !FileExists("cfg/sm_soccermod/soccer_mod_downloads.cfg") || !FileExists(allowedMapsConfigFile) || !FileExists(statsKeygroupGoalkeeperAreas) || !FileExists(skinsKeygroup) || !FileExists(pathCapPositionsFile) || !FileExists(mapDefaults))
	{
		ConfigFunc();
		ReadFromConfig();
	}
	else 
	{
		ReadFromConfig();
	}
	if (FileExists(tempReadyFileKV)) DeleteTempFile();
	
	if(!FileExists(shoutConfigFile))		ShoutCreateConfig();
	if(!FileExists(shoutSetFile))			ShoutCreateSettings();
	
	ShoutReadSettings();
	ShoutReadConfig();
	
	ReadMatchlogSettings();
	//CreateDCListFile(false);
	
	//Get the server password from server.cfg
	GetDefaultPassword(defaultpw, sizeof(defaultpw));
		
	//Get the available Admin Groups from admin_groups.cfg
	groupArray = CreateArray(8);
	ParseAdminGroups(groupArray);
	
	//lcPanel Array
	lcPanelArray = CreateArray(MAXPLAYERS+1);
	lcPanelArray.Clear();
	
	LoadAllowedMaps();
	currentMapAllowed = IsCurrentMapAllowed();

	GetFieldOrientation();

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
	}
	//else LoadConfigNonSoccer();
	
	g_hostname = FindConVar("hostname");
	g_hostname.GetString(old_hostname, 250);

	MatchOnMapStart();
	SkinsOnMapStart();
	StatsOnMapStart();
	TrainingOnMapStart();
	PersonalTrainingOnMapStart();
	ReplacerOnMapStart();
	ConnectlistOnMapStart();

	//shoutset
	for (int player = 1; player <= MaxClients; player++)
	{
		if(GetClientMenu(player) != MenuSource_None )	CancelClientMenu(player,true);
		ShoutSetDefaultClientSettings(player);
	}
	
	// Kill possibly running ForfeitTimer
	ForfeitReset();
}

public void OnMapEnd()
{
	ConnectlistOnMapEnd();
	
	ClearArray(adt_decal_id);
	ClearArray(adt_decal_position);
}

public void OnAllPluginsLoaded()
{
	AddDownloads();
	/*AddDirToDownloads("sound/soccermod");
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
	}*/
}

public void OnGameFrame()
{
	if(bSPRINT_BUTTON)
	{
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && (GetClientButtons(i) & IN_USE))
			{
				if(!showHudPrev[i])	Command_StartSprint(i, 0);
			}
		}
	}
	
	//JumpReset
	if(djbenabled == 2)
	{
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && g_bJump[i])
			{
				if (GetGameTime() > jump_time[i] + fJUMP_TIMER)
				{
					//PrintToChatAll("reset %.1f", GetGameTime());
					g_bJump[i] = false;
					jump_time[i] = 0.0;
				}
				else if(GetEntityFlags(i) & FL_ONGROUND)
				{
					// reset if true
					//PrintToChatAll("groundreset");
					g_bJump[i] = false;
					jump_time[i] = 0.0;
				}
			}
		}
	}
	else if (djbenabled == 3)
	{
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && jump_time[i] > 0.0)
			{
				/*if (GetGameTime() == jump_time[i]) 
				{
					//PrintToChatAll("Block");
					g_bJump[i] = true;
				}*/
				// how long should the block last?
				if (GetGameTime() > jump_time[i] + 0.20) //was 0.05 not working?
				{
					g_bJump[i] = false;
					jump_time[i] = 0.0;
				}
				else if(GetEntityFlags(i) & FL_ONGROUND)
				{
					// reset if true
					//PrintToChatAll("groundreset");
					g_bJump[i] = false;
					jump_time[i] = 0.0;
				}
			}
		}
	}
	return;
}

public void OnClientConnected(int client)
{	
	SetDefaultClientSettings(client);
	ShoutOnClientConnected(client);
	return;
}

public void OnClientPostAdminCheck(int client) 
{
	ReplacerOnClientPostAdminCheck(client); 
}

public void OnClientAuthorized(int client)
{	
	LCOnClientConnected(client);
	return;
}

public void OnClientPutInServer(int client)
{
	changeSetting[client] = "";
	
	rankingPlayerCDTimes[client] = 0;
	rankingPlayerSpammed[client] = false;

	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamageArmor);
	
	DatabaseCheckPlayer(client);

	RespawnOnClientPutInServer(client);
	SkinsOnClientPutInServer(client);
	//SprintOnClientPutInServer(client);
	AFKKickOnClientPutInServer(client);
	
	//LCOnClientConnected(client);

	ReadPersonalCannonSettings(client);
	RadioCommandsOnClientPutInServer(client);
	if((pwchange == true) && (GetClientCount() == PWMAXPLAYERS+1) && (passwordlock == 1))
	{
		CPrintToChatAll("{%s}[%s] {%s}Threshold hit. Locking server again", prefixcolor, prefix, textcolor);
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

public Action cmd_jointeam(int client, const char[] command, int iArgs)
{
	char arg[4];
	int team = 0;
	if(StrEqual(command, "jointeam"))
	{
		GetCmdArg(1, arg, sizeof(arg));
		team = StringToInt(arg);
	}


	if(FileExists(tempReadyFileKV))
	{
		
		if((StrEqual(command, "jointeam") && team == 1) || StrEqual(command, "spectate"))
		{
			char bSteam[32];
			GetClientAuthId(client, AuthId_Engine, bSteam, sizeof(bSteam));
				
			kvTemp = new KeyValues("Ready Check");
			kvTemp.ImportFromFile(tempReadyFileKV);
			
			kvTemp.JumpToKey(bSteam, false);
			kvTemp.DeleteThis();
			
			kvTemp.Rewind();
			kvTemp.ExportToFile(tempReadyFileKV);
			kvTemp.Close();
			
			if(GetClientMenu(client) != MenuSource_None)
			{
				CancelClientMenu(client,false);
				InternalShowMenu(client, "\10", 1); 
			} 
		}
		else if(team > 1)
		{
			if(startplayers != 6 && startplayers != 12) startplayers++;
		}
	}
	if(trainingModeEnabled)
	{
		if(StrEqual(command, "jointeam"))
		{
			GetCmdArg(1, arg, sizeof(arg));
			team = StringToInt(arg);
		}
		if(StrEqual(arg, "") || StrEqual(arg, "3") || StrEqual(arg, "ct"))
		{
			CPrintToChat(client,"{%s}[%s] {%s}Training mode enabled. Joining the CT team is blocked.", prefixcolor, prefix, textcolor);
			return Plugin_Stop;
		}
	}
	if((first12Set == 1) && CapPrep)
	{
		if(team == 2 || team == 3)
		{
			char steamid[32]
			GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		
			if (ImportJoinNumber(steamid) > 12) CPrintToChatAll("{%s}[%s] {%s}NOTICE: %N joined on position %i.", prefixcolor, prefix, textcolor, client, ImportJoinNumber(steamid));
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

//Client settings
public void OnClientCookiesCached(int client)
{
	if(IsClientConnected(client))
	{
		ReadClientCookie(client);
	}
	return;
}

public void OnClientDisconnect(int client)
{
	DatabaseCheckPlayer(client);

	RespawnOnClientDisconnect(client);
	TrainingOnClientDisconnect(client);
	
	GKSkinOnClientDisconnect(client);

	RadioCommandsOnClientDisconnect(client);
	SavePersonalCannonSettings(client);
	ReadyCheckOnClientDisconnect(client);
	WriteClientCookie(client);
	
	LCDisconnect(client);
	JumpDisconnect(client);
}

public void OnClientDisconnect_Post(int client)
{
	rankingPlayerCDTimes[client] = 0;
	rankingPlayerSpammed[client] = false;
	
	accessgranted[client] = false;

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
	
	if(GetClientCount() == 0 && !matchStarted)
	{
		HostName_Change_Status("Reset");
		if(trainingModeEnabled) trainingModeEnabled = false;
	}
	
	if(GetClientCount() == 0 && CapPrep)
	{
		CapPrep = false;
	}
	
	ResetTrainingIndex(client);
	pers_hoopIndex[client] = -1;
	pers_canIndex[client] = -1;
	pers_plateIndex[client] = -1;
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
		int client = GetClientOfUserId(GetEventInt(event, "userid"));
		ResetSprint(client);
		PrintSprintCDMsgToClient(client);
		iCLIENT_STATUS[client] &= ~ CLIENT_SPRINTUNABLE;
		if(matchStarted && matchPaused)
		{	
			delayedFreezeTimer[client] = CreateTimer(0.1, DelayFreezePlayer, client);
		}
	}
}

public Action EventPlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
	if (currentMapAllowed)
	{
		RespawnEventPlayer(event);
		GKSkinEventPlayer(event);
	}
}

public Action EventPlayerHurt(Event event, const char[] name, bool dontBroadcast)
{
	if (currentMapAllowed)
	{
		HealthEventPlayerHurt(event);
	}
}

public Action Event_PlayerDeath_Pre(Event event, const char[] name, bool dontBroadcast) 
{
	if (killfeedSet == 0 && !capFightStarted)	event.BroadcastDisabled = true;
	
	return Plugin_Continue;
} 


public Action EventPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	if (currentMapAllowed)
	{
		CapEventPlayerDeath(event);
		RespawnEventPlayer(event); 
		//Sprint
		int client = GetClientOfUserId(GetEventInt(event, "userid"));
		ResetSprint(client);
		
		if(dissolveSet == 2) CreateTimer(0.0, Dissolve, client);
		else if(dissolveSet == 1) CreateTimer(5.0, Dissolve, client);
	}
}

public Action EventRoundStart(Event event, const char[] name, bool dontBroadcast)
{
	currentMapAllowed = IsCurrentMapAllowed();

	if (currentMapAllowed)
	{
		roundEnded = false;
		goalScored = false;
		ResetAdvTrainingStates();
		
		Handle hConvar;
		hConvar = FindConVar("mp_friendlyfire");
		if (hConvar == INVALID_HANDLE)	return Plugin_Continue;
		changeConvar(hConvar, "mp_friendlyfire", "0")
		
		SetDefaultValues(1);

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
	
	return Plugin_Continue;
}

public Action EventRoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	if (currentMapAllowed)
	{
		roundEnded = true;

		CapEventRoundEnd(event);
		MatchEventRoundEnd(event);
		StatsEventRoundEnd(event);
		
		if(celebrateweaponSet == 1 && !capFightStarted)
		{
			GiveCelebrationWeapons();
		}
	}
	
	return Plugin_Continue;
}

public Action Player_Decal(const char[] name, const int[] clients, int count, float delay)
{
	int client = TE_ReadNum("m_nPlayer");
	
	TE_ReadVector("m_vecOrigin", sprayVector[client]);
	
	GetClientName(client, sprayName[client], 64);
	GetClientAuthId(client, AuthId_Engine, sprayID[client], 32);
	
	//PrintToChatAll("Spray by %s (%s)", sprayName[client], sprayID[client]);
}

public Action EventUserMessage(UserMsg msg_id, Handle msg, const int[] players, int playersNum, bool reliable, bool init)
{
	char usermessage[256];
	BfReadString(msg, usermessage, sizeof(usermessage));
	if(StrContains(usermessage, "teammate_attack") != -1)
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
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
	//SetCvarInt("sv_client_min_interp_ratio",	-1);
	//SetCvarInt("sv_client_max_interp_ratio",	1);

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
		if (IsClientInGame(client) && IsClientConnected(client)) 
		{
			if(GetEntityMoveType(client) != MOVETYPE_OBSERVER)	SetEntityMoveType(client, MOVETYPE_NONE); // && IsPlayerAlive(client)) SetEntityMoveType(client, MOVETYPE_NONE);
		}
	}
}

public void UnfreezeAll()
{
	SetCvarFloat("phys_timescale", phys_timescale);
	SetCvarInt("phys_pushscale", phys_pushscale);

	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client) && IsClientConnected(client))
		{
			if(GetEntityMoveType(client) == MOVETYPE_NONE) SetEntityMoveType(client, MOVETYPE_WALK);// && IsPlayerAlive(client)) SetEntityMoveType(client, MOVETYPE_WALK);
		}
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

int GetClientAimTargetEx(int client, float pos[3]) {
	
	if (client < 1) {
		return -1;
	}
	
	float vAngles[3];
	float vOrigin[3];
	
	GetClientEyePosition(client, vOrigin);
	GetClientEyeAngles(client, vAngles);
	
	Handle trace = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_ALL, RayType_Infinite, TraceEntityFilterPlayer);
	
	if (TR_DidHit(trace)) {
		
		TR_GetEndPosition(pos, trace);
		int entity = TR_GetEntityIndex(trace);
		CloseHandle(trace);
		
		return entity;
	}
	
	CloseHandle(trace);
	
	return -1;
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

// *********************************************** VALIDATION ********************************************************

stock bool IsValidClient(int client, bool bAlive = false)
{
	return (client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && !IsClientSourceTV(client));
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
	ResetPack(pack);
	char command[64];
	ReadPackString(pack, command, sizeof(command));
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

// ************************************************************************************************************
// *************************************************** MISC ***************************************************
// ************************************************************************************************************

public void AddDownloads()
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


stock int changeConvar(Handle hConvar, char[] strCvarName, char[] strValue)
{
	int flags;
	flags = GetCommandFlags(strCvarName);
	SetCommandFlags(strCvarName, 0);
	
	if ( StrContains(strValue, "$$")==0 )
		ReplaceStringEx(strValue, 512, "$$", "$");
	else if ( StrContains(strValue, "$")==0 )
	{
		ReplaceStringEx(strValue, 512, "$", "");
		Handle newCvar = FindConVar(strValue);
		if (newCvar == INVALID_HANDLE)
		{
			return 0;
		}
		GetConVarString(newCvar, strValue, 512);
		SetConVarString(hConvar, strValue, true);
		SetCommandFlags(strCvarName, flags);
		return 2;
	}
	
	SetConVarString(hConvar, strValue, true);
	SetCommandFlags(strCvarName, flags);
	return 1;
}