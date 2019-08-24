int debuggingEnabled		= 0;
char databaseConfig[64]		= "storage-local";
float phys_timescale		= 1.0;
int phys_pushscale			= 900;
int MVPEnabled				= 1;
int DeadChatMode			= 0;
int DeadChatVis				= 0;

public void RegisterServerCommands()
{
	RegServerCmd(
		"soccer_mod_debug",
		ServerCommands,
		"Enables or disables debugging messages - values: 0/1, default: 0"
	);
	RegServerCmd(
		"soccer_mod_downloads_add_dir",
		ServerCommands,
		"Adds a directory and all the subdirectories to the downloads - values: path/to/dir"
	);
	RegServerCmd(
		"soccer_mod_database_config",
		ServerCommands,
		"Sets which database config should be used - default: storage-local"
	);
	RegServerCmd(
		"soccer_mod_prop_value",
		ServerCommands,
		"Sets a property value of an entity - [entity name] [value name] [value]"
	);
	RegServerCmd(
		"soccer_mod_prop_value_float",
		ServerCommands,
		"Sets a float property value of an entity - [entity name] [value name] [value]"
	);
	RegServerCmd(
		"soccer_mod_pushscale",
		ServerCommands,
		"Sets the physics pushscale - default: 900"
	);
	RegServerCmd(
		"soccer_mod_timescale",
		ServerCommands,
		"Sets the physics timescale - default: 1.0"
	);
	RegServerCmd(
		"soccer_mod_passwordlock",
		ServerCommands,
		"Changes the Serverpassword when a cap starts and certain conditions are met - default: 1"
	);
	RegServerCmd(
		"soccer_mod_passwordlock_max",
		ServerCommands,
		"Changes the theshold for the ServerLock - default: 11"
	);
	RegServerCmd(
		"soccer_mod_mvp",
		ServerCommands,
		"Enables the MVP system - default: 1"
	);
	RegServerCmd(
		"soccer_mod_pubmode",
		ServerCommands,
		"Changes the menu accessmode (0 only admins, 1 public cap and match, 2 public menu) - default: 1"
	);
	RegServerCmd(
		"soccer_mod_prefix",
		ServerCommands,
		"Changes the Chatprefix - default: [Soccer Mod]"
	);
	RegServerCmd(
		"soccer_mod_textcolor",
		ServerCommands,
		"Changes the textcolor for all related messages - default: lightgreen"
	);
	RegServerCmd(
		"soccer_mod_prefixcolor",
		ServerCommands,
		"Changes the prefixtcolor for all related messages  - default: green"
	);
	RegServerCmd(
		"soccer_mod_deadchat_mode",
		ServerCommands,
		"Changes if deadchat is enabled  - default: 0"
	);
	RegServerCmd(
		"soccer_mod_deadchat_visibility",
		ServerCommands,
		"Changes who can see which messages of the dead  - default: 0"
	);

	RegisterServerCVarsBlockDJ();
	RegisterServerCommandsHealth();
	RegisterServerCommandsMatch();
	RegisterServerCommandsRanking();
	RegisterServerCommandsRespawn();
	RegisterServerCommandsSkins();
	RegisterServerCommandsSprint();
	RegisterServerCommandsTraining();
}

public Action ServerCommands(int args)
{
	char serverCommand[50], cmdArg1[32], cmdArg2[32], cmdArg3[32];
	GetCmdArg(0, serverCommand, sizeof(serverCommand));
	GetCmdArg(1, cmdArg1, sizeof(cmdArg1));
	GetCmdArg(2, cmdArg2, sizeof(cmdArg2));
	GetCmdArg(3, cmdArg3, sizeof(cmdArg3));

	if (StrEqual(serverCommand, "soccer_mod_debug"))
	{
		if (StringToInt(cmdArg1))
		{
			debuggingEnabled = 1;
			UpdateConfigInt("Debug Settings", "soccer_mod_debug", debuggingEnabled);
			PrintToServer("[%s] Debugging enabled", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Debugging enabled", prefixcolor, prefix, textcolor);
		}
		else
		{
			debuggingEnabled = 0;
			UpdateConfigInt("Debug Settings", "soccer_mod_debug", debuggingEnabled);
			PrintToServer("[%s] Debugging disabled", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Debugging disabled", prefixcolor, prefix, textcolor);
		}
	}
	else if (StrEqual(serverCommand, "soccer_mod_downloads_add_dir"))
	{
		char path[PLATFORM_MAX_PATH];
		GetCmdArgString(path, sizeof(path));

		AddDirToDownloads(path);
	}
	else if (StrEqual(serverCommand, "soccer_mod_database_config"))
	{
		databaseConfig = cmdArg1;
		PrintToServer("[%s] Database config set to %s", prefix, cmdArg1);
		CPrintToChatAll("{%s}[%s] {%s}Database config set to %s", prefixcolor, prefix, textcolor, cmdArg1);

		if (db != INVALID_HANDLE) db.Close();
		ConnectToDatabase();
	}
	else if (StrEqual(serverCommand, "soccer_mod_prop_value") || StrEqual(serverCommand, "soccer_mod_prop_value_float"))
	{
		int entity = GetEntityIndexByName(cmdArg1, "prop_physics");

		if (entity != -1)
		{
			if (StrEqual(serverCommand, "soccer_mod_prop_value")) DispatchKeyValue(entity, cmdArg2, cmdArg3);
			else if (StrEqual(serverCommand, "soccer_mod_prop_value_float")) DispatchKeyValueFloat(entity, cmdArg2, StringToFloat(cmdArg3));

			//if (!IsModelPrecached(cmdArg3)) PrecacheModel(cmdArg3);
			//SetEntityModel(entity, cmdArg3);

			PrintToServer("[%s] Prop value %s of entity %s set to %s", prefix, cmdArg2, cmdArg1, cmdArg3);
			CPrintToChatAll("{%s}[%s] {%s}Prop value %s of entity %s set to %s", prefixcolor, prefix, textcolor, cmdArg2, cmdArg1, cmdArg3);
		}
		else
		{
			PrintToServer("[%s] No entity found with name %s", prefix, cmdArg1);
			CPrintToChatAll("{%s}[%s] {%s}No entity found with name %s", prefixcolor, prefix, textcolor, cmdArg1);
		}
	}
	else if (StrEqual(serverCommand, "soccer_mod_pushscale"))
	{
		int value = StringToInt(cmdArg1);
		SetCvarInt("phys_pushscale", value);

		phys_pushscale = value;
		PrintToServer("[%s] Pushscale set to %i", prefix, value);
		CPrintToChatAll("{%s}[%s] {%s}Pushscale set to %i", prefixcolor, prefix, textcolor, value);
	}
	else if (StrEqual(serverCommand, "soccer_mod_timescale"))
	{
		float value = StringToFloat(cmdArg1);
		SetCvarFloat("phys_timescale", value);

		phys_timescale = value;
		PrintToServer("[%s] Timescale set to %f", prefix, value);
		CPrintToChatAll("{%s}[%s] {%s}Timescale set to %f", prefixcolor, prefix, textcolor, value);
	}
	else if (StrEqual(serverCommand, "soccer_mod_passwordlock"))
	{
		if (StringToInt(cmdArg1))
		{
			passwordlock = 1;
			UpdateConfigInt("Admin Settings", "soccer_mod_passwordlock", passwordlock);
			PrintToServer("[%s] Locking enabled", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Locking enabled", prefixcolor, prefix, textcolor);
		}
		else
		{
			passwordlock = 0;
			UpdateConfigInt("Admin Settings", "soccer_mod_passwordlock", passwordlock);
			PrintToServer("[%s] Locking disabled", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Locking disabled", prefixcolor, prefix, textcolor);
		}
	}
	else if (StrEqual(serverCommand, "soccer_mod_passwordlock_max"))
	{
		int value = StringToInt(cmdArg1);

		PWMAXPLAYERS = (value-1);
		UpdateConfigInt("Admin Settings", "soccer_mod_passwordlock_max", PWMAXPLAYERS);
		PrintToServer("[%s] Server will lock itself after %i players", prefix, value);
		CPrintToChatAll("{%s}[%s] {%s}Server will lock itself after %i players", prefixcolor, prefix, textcolor, value);
	}
	else if (StrEqual(serverCommand, "soccer_mod_mvp"))
	{
		if (StringToInt(cmdArg1))
		{
			MVPEnabled = 1;
			UpdateConfigInt("Admin Settings", "soccer_mod_mvp", MVPEnabled);
			PrintToServer("[%s] MVP System enabled", prefix);
			CPrintToChatAll("{%s}[%s] {%s}MVP System enabled", prefixcolor, prefix, textcolor);
		}
		else
		{
			MVPEnabled = 0;
			UpdateConfigInt("Admin Settings", "soccer_mod_mvp", MVPEnabled);
			PrintToServer("[%s] MVP System disabled", prefix);
			CPrintToChatAll("{%s}[%s] {%s}MVP System disabled", prefixcolor, prefix, textcolor);
		}
	}
	else if (StrEqual(serverCommand, "soccer_mod_pubmode"))
	{
		int value = StringToInt(cmdArg1);

		publicmode = value;
		UpdateConfigInt("Admin Settings", "soccer_mod_pubmode", publicmode);
		if(value == 0)
		{
			PrintToServer("[%s] Publicmode set to Admins only", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Publicmode set to Admins only", prefixcolor, prefix, textcolor);
		}
		else if(value == 1)
		{
			PrintToServer("[%s] Publicmode set to public !cap and !match", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Publicmode set to public !cap and !match", prefixcolor, prefix, textcolor);
		}
		else if(value == 2)
		{
			PrintToServer("[%s] Publicmode set to public menu", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Publicmode set to public menu", prefixcolor, prefix, textcolor);
		}
		else if(value >= 3)
		{
			PrintToServer("0 - Admins only; 1 - Public !cap and !match; 2 - public menu access");
		}
	}
	else if (StrEqual(serverCommand, "soccer_mod_prefix"))
	{
		prefix = cmdArg1
		UpdateConfig("Chat Settings", "soccer_mod_prefix", cmdArg1);
		PrintToServer("[%s] is the new prefix", prefix);
		CPrintToChatAll("{%s}[%s] {%s}is the new prefix", prefixcolor, prefix, textcolor);
	}
	else if (StrEqual(serverCommand, "soccer_mod_textcolor"))
	{
		textcolor = cmdArg1
		UpdateConfig("Chat Settings", "soccer_mod_textcolor", cmdArg1);
		PrintToServer("[%s] is the new textcolor", textcolor);
		CPrintToChatAll("{%s}[%s] {%s} This is the new textcolor", prefixcolor, prefix, textcolor);
	}
	else if (StrEqual(serverCommand, "soccer_mod_prefixcolor"))
	{
		prefixcolor = cmdArg1
		UpdateConfig("Chat Settings", "soccer_mod_prefixcolor", cmdArg1);
		PrintToServer("[%s] is the new prefixcolor", prefixcolor);
		CPrintToChatAll("{%s}[%s] {%s}This is the new prefixcolor", prefixcolor, prefix, prefixcolor);
	}
	else if (StrEqual(serverCommand, "soccer_mod_deadchat_mode"))
	{
		int value = StringToInt(cmdArg1);
		UpdateConfigInt("Chat Settings", "soccer_mod_deadchat_mode", DeadChatMode);
		if(value == 0)
		{
			PrintToServer("[%s] Deadchat disabled", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat disabled", prefixcolor, prefix, textcolor);
		}
		else if(value == 1)
		{
			PrintToServer("[%s] Deadchat enabled", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat enabled", prefixcolor, prefix, textcolor);
		}
		else if(value == 2)
		{
			PrintToServer("[%s] Deadchat enabled if sv_alltalk = 1", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat enabled if sv_alltalk = 1", prefixcolor, prefix, textcolor);
		}
		else if(value >= 3)
		{
			PrintToServer("0 - Deadchat disabled; 1 - Deadchat enabled; 2 - Enabled if alltalk = 1");
		}
	}
	else if (StrEqual(serverCommand, "soccer_mod_deadchat_visibility"))
	{
		int value = StringToInt(cmdArg1);
		UpdateConfigInt("Chat Settings", "soccer_mod_deadchat_visibility", DeadChatVis);
		if(value == 0)
		{
			PrintToServer("[%s] Deadchat visibility set to default", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat visibility set to default", prefixcolor, prefix, textcolor);
		}
		else if(value == 1)
		{
			PrintToServer("[%s] Deadchat visibility set to teammates", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat visibility set to teammates", prefixcolor, prefix, textcolor);
		}
		else if(value == 2)
		{
			PrintToServer("[%s] Deadchat visibility set to everyone", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat visibility set to everyone", prefixcolor, prefix, textcolor);
		}
		else if(value >= 3)
		{
			PrintToServer("0 - Default Deadchat visibility; 1 - Deadchat visible for teammates; 2 - Deadchat visible for everyone");
		}
	}

	return Plugin_Handled;
}

// **************************************************************************************************************
// ************************************************** INCLUDES **************************************************
// **************************************************************************************************************
#include "soccer_mod\server_commands\health.sp"
#include "soccer_mod\server_commands\match.sp"
#include "soccer_mod\server_commands\ranking.sp"
#include "soccer_mod\server_commands\respawn.sp"
#include "soccer_mod\server_commands\skins.sp"
#include "soccer_mod\server_commands\sprint.sp"
#include "soccer_mod\server_commands\training.sp"