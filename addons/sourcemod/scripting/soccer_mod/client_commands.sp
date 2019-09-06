public void RegisterClientCommands()
{
	RegConsoleCmd("sm_madmin", AdminCommand, "Opens the Soccer Mod admin menu");
	RegConsoleCmd("sm_menu", ClientCommands, "Opens the Soccer Mod main menu");

	RegConsoleCmd("sm_admins", AdminListCommand, "Shows a list of Online Admins");
	RegConsoleCmd("sm_cap", CapCommand, "Opens the Soccer Mod cap menu");
	RegConsoleCmd("sm_commands", CommandsCommand, "Opens the Soccer Mod commands list");
	RegConsoleCmd("sm_credits", CreditsCommand, "Opens the Soccer Mod credits menu");
	RegConsoleCmd("sm_gk", GkCommand, "Toggle the GK skin");	
	RegConsoleCmd("sm_help", HelpCommand, "Opens the Soccer Mod help menu");
	RegConsoleCmd("sm_info", CreditsCommand, "Opens the Soccer Mod credits menu");	
	RegConsoleCmd("sm_match", MatchCommand, "Opens the Soccer Mod match menu");
	RegConsoleCmd("sm_p", PauseCommand, "Pauses a match");
	RegConsoleCmd("sm_pause", PauseCommand, "Pauses a match");	
	RegConsoleCmd("sm_pick", PickCommand, "Opens the Soccer Mod pick menu");
	RegConsoleCmd("sm_pos", PosCommand, "Opens the Soccer Mod Positions menu");
	RegConsoleCmd("sm_rank", RankCommand, "Opens the Soccer Mod rank menu");	
	RegConsoleCmd("sm_ref", RefCommand, "Opens the Soccer Mod referee menu");
	RegConsoleCmd("sm_rr", rrCommand, "rr the round");
	RegConsoleCmd("sm_start", StartCommand, "Starts a match");
	RegConsoleCmd("sm_stats", StatsCommand, "Opens the Soccer Mod stats menu");
	RegConsoleCmd("sm_stop", StopCommand, "Stops a match");
	RegConsoleCmd("sm_training", TrainingCommand, "Opens the Soccer Mod training menu");
	RegConsoleCmd("sm_unp", UnpauseCommand, "Unpauses a match");
	RegConsoleCmd("sm_unpause", UnpauseCommand, "Unpauses a match");

	RegAdminCmd("sm_addadmin", Command_AddAdmin, ADMFLAG_RCON, "Adds an admin to admins_simple.ini");
	RegAdminCmd("sm_pass", Command_Pass, ADMFLAG_RCON, "Set the sv password");
	RegAdminCmd("sm_tag", Command_GetTag, ADMFLAG_RCON, "Prints your current clantag - Test");

}

// *******************************************************************************************************************
// ************************************************ CLIENT COMMANDS **************************************************
// *******************************************************************************************************************

public Action AdminListCommand(int client, int args)
{
	menuaccessed = false;
	if(publicmode == 2)						CPrintToChat(client, "{%s}[%s] {%s}Publicmode is set to everyone. Try using !menu yourself", prefixcolor, prefix, textcolor);
	else 									OpenMenuOnlineAdmin(client);
}


public Action rrCommand(int client, int args)
{
    if (currentMapAllowed)
    {
        if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client))
        {
            CS_TerminateRound(1.0, CSRoundEnd_Draw);
            for (int player = 1; player <= MaxClients; player++)
            {
                if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has restarted the round", prefixcolor, prefix, textcolor, client);
            }

            char steamid[20];
            GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
            LogMessage("%N <%s> has restarted the round", client, steamid);
        }
        else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
    }
    else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
}

public Action StartCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(publicmode == 0)
		{
			if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client))
			{
				ResetPass();
				MatchStart(client);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
		else if(publicmode == 1 || publicmode == 2)
		{
			ResetPass();
			MatchStart(client);
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action PauseCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(publicmode == 0)
		{
			if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client))
			{
				MatchPause(client);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
		else if(publicmode == 1 || publicmode == 2)
		{
			MatchPause(client);
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action StopCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(publicmode == 0)
		{
			if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client))
			{
				MatchStop(client);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
		else if(publicmode == 1 || publicmode == 2)
		{
			MatchStop(client);
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action UnpauseCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(publicmode == 0)
		{
			if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client))
			{
				MatchUnpause(client);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
		else if(publicmode == 1 || publicmode == 2)
		{
			MatchUnpause(client);
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor); 
	return Plugin_Handled;
}

public Action GkCommand(int client, int args)
{
	if (currentMapAllowed) ClientCommandSetGoalkeeperSkin(client);
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action AdminCommand(int client, int args)
{
	if(publicmode == 0 || publicmode == 1)
	{
		if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client))
		{
			OpenMenuAdmin(client);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
	}
	else if(publicmode == 2)
	{
		OpenMenuAdmin(client);
	}
	return Plugin_Handled;
}

public Action CapCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(publicmode == 0)
		{
			if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client))
			{
				OpenCapMenu(client);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
		else if(publicmode == 2 || publicmode == 1)
		{
			OpenCapMenu(client);
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action MatchCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(publicmode == 0)
		{
			if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client))
			{
				OpenMatchMenu(client);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
		else if(publicmode == 2 || publicmode == 1)
		{
			OpenMatchMenu(client);
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action TrainingCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(publicmode == 0 || publicmode == 1)
		{
			if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client))
			{
				OpenTrainingMenu(client);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
		else if(publicmode == 2)
		{
			OpenTrainingMenu(client);
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action RefCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(publicmode == 0 || publicmode == 1)
		{
			if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client))
			{
				OpenRefereeMenu(client);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
		else if(publicmode == 2)
		{
			OpenRefereeMenu(client);
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action PickCommand(int client, int args)
{
	if (currentMapAllowed) OpenCapPickMenu(client);
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action StatsCommand(int client, int args)
{
	if (currentMapAllowed) OpenStatisticsMenu(client);
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action RankCommand(int client, int args)
{
	if (currentMapAllowed) ClientCommandPublicRanking(client);
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action PosCommand(int client, int args)
{
	if (currentMapAllowed) OpenCapPositionMenu(client);
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action HelpCommand(int client, int args)
{
	OpenMenuHelp(client);
	return Plugin_Handled;
}

public Action CommandsCommand(int client, int args)
{
	OpenMenuCommands(client);
	return Plugin_Handled;
}

public Action CreditsCommand(int client, int args)
{
	OpenMenuCredits(client)
	return Plugin_Handled;
}


// *******************************************************************************************************************
// ************************************************ ADMIN COMMANDS ***************************************************
// *******************************************************************************************************************
public Action Command_RandPass(int client, int args)
{
	char arg[64];
	GetCmdArg(1, arg, sizeof(arg));
	
	RandPass();
	CPrintToChatAll("{%s}[%s] {%s} Random Password set.", prefixcolor, prefix, textcolor);
	
	return Plugin_Handled;
}

public Action Command_GetTag(int client, int args)
{
	char PlayerClanTag[32];
	CS_GetClientClanTag(client, PlayerClanTag, sizeof(PlayerClanTag));
	CPrintToChat(client, "{%s}[%s] {%s} Your clantag is %s", prefixcolor, prefix, textcolor, PlayerClanTag);
	return Plugin_Handled;
}

public Action Command_AddAdmin(int client, int args)
{
	if(args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_addadmin \"<#userid>\" \"<flags>\" \"Clientname\""); // <flags> <password>");
		return Plugin_Handled;
	}

	char szTarget[64];
	char szName[32];
	char szFlags2[32];
	GetCmdArg(1, szTarget, sizeof(szTarget));
	GetCmdArg(2, szFlags2, sizeof(szFlags2));
	GetCmdArg(3, szName, sizeof(szName));

	char szFile[256];
	BuildPath(Path_SM, szFile, sizeof(szFile), "configs/admins_simple.ini");

	Handle hFile = OpenFile(szFile, "at");
	
	WriteFileLine(hFile, "\"%s\" \"%s\"	//%s", szTarget, szFlags2, szName); 
	CPrintToChat(client, "{%s}[%s] {%s} %s added as an admin with the flags %s", prefixcolor, prefix, textcolor, szName, szFlags2);

	CloseHandle(hFile);
	FakeClientCommandEx(client, "sm_reloadadmins");
	
	return Plugin_Handled;
}


public Action ResetPass()
{
	ServerCommand("sm_cvar sv_password %s", def_pass);
	
	return Plugin_Handled;
}

public Action RandPass()
{
	pw.GetString(def_pass, sizeof(def_pass));
	char newpass[32];
	
	for (int x = 1; x <= 26; x++)
	{
		int randomInt = GetRandomInt(0, 63);
		StrCat(newpass, sizeof(newpass), listOfChar[randomInt]);
	}
	
	ServerCommand("sm_cvar sv_password %s", newpass);
	
	return Plugin_Handled;
}

public Action Command_Pass(int client, int args)
{
	char arg[64];
	GetCmdArg(1, arg, sizeof(arg));
	
	ServerCommand("sm_cvar sv_password %s", arg);
	if (args < 1)
	{
		FakeClientCommandEx(client, "sm_cvar sv_password");
		PrintToChat(client, "{%s}[%s]Check your console for the current password", prefixcolor, prefix);
	}
	
	return Plugin_Handled;
}


// *******************************************************************************************************************
// ************************************************* ALT COMMANDS ****************************************************
// *******************************************************************************************************************
public Action ClientCommands(int client, int args)
{
    char cmdArg[32];
    GetCmdArg(1, cmdArg, sizeof(cmdArg));

    if (StrEqual(cmdArg, "admin"))
    {
		if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client))
		{
			OpenMenuAdmin(client);
		}
    }
    else if (StrEqual(cmdArg, "cap"))
    {
        if (currentMapAllowed)
        {
			OpenCapMenu(client);
        }
        else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
    }
    else if (StrEqual(cmdArg, "match"))
    {
        if (currentMapAllowed)
        {
			OpenMatchMenu(client);
        }
        else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
    }
    else if (StrEqual(cmdArg, "training"))
    {
        if (currentMapAllowed)
        {
            if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client)) OpenTrainingMenu(client);
            else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
        }
        else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
    }
    else if (StrEqual(cmdArg, "rr"))
    {
        if (currentMapAllowed)
        {
            if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client))
            {
                // TEMPORARY CODE TO FIND FIX FOR DISSAPPEARING BALL
                //int index = GetEntityIndexByName("ball", "prop_physics");
                //float position[3];
                //GetEntPropVector(index, Prop_Send, "m_vecOrigin", position);
                //LogMessage("Ball position (round restarted): %f, %f, %f", position[0], position[1], position[2]);
                // END TEMPORARY CODE

                CS_TerminateRound(1.0, CSRoundEnd_Draw);

                for (int player = 1; player <= MaxClients; player++)
                {
                    if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has restarted the round", prefixcolor, prefix, textcolor, client);
                }

                char steamid[20];
                GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
                LogMessage("%N <%s> has restarted the round", client, steamid);
            }
            else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
        }
        else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
    }
    else if (StrEqual(cmdArg, "pick"))
    {
        if (currentMapAllowed) OpenCapPickMenu(client);
        else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
    }
    else if (StrEqual(cmdArg, "getview"))
    {
        if (currentMapAllowed)
        {
            if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client))
            {
                float viewCoord[3];
                GetAimOrigin(client, viewCoord);
                CPrintToChat(client, "%s%s X: %f, Y: %f, Z: %f", prefixcolor, prefix, viewCoord[0], viewCoord[1], viewCoord[2]);
            }
            else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
        }
        else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
    }
    else if (StrEqual(cmdArg, "stats"))
    {
        if (currentMapAllowed) OpenStatisticsMenu(client);
        else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
    }
    else if (StrEqual(cmdArg, "rank"))
    {
        if (currentMapAllowed) ClientCommandPublicRanking(client);
        else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
    }
    else if (StrEqual(cmdArg, "gk"))
    {
        if (currentMapAllowed) ClientCommandSetGoalkeeperSkin(client);
        else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
    }
    else if (StrEqual(cmdArg, "pos") || StrEqual(cmdArg, "position"))
    {
        if (currentMapAllowed) OpenCapPositionMenu(client);
        else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
    }
    else if (StrEqual(cmdArg, "help"))                                  OpenMenuHelp(client);
    else if (StrEqual(cmdArg, "commands"))                              OpenMenuCommands(client);
    else if (StrEqual(cmdArg, "credits") || StrEqual(cmdArg, "info"))   OpenMenuCredits(client);
    else OpenMenuSoccer(client);

    return Plugin_Handled;
}