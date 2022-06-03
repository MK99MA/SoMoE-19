public void RegisterClientCommands()
{
	RegConsoleCmd("sm_madmin", AdminCommand, "Opens the Soccer Mod admin menu");
	RegConsoleCmd("sm_menu", ClientCommands, "Opens the Soccer Mod main menu");
	RegConsoleCmd("sm_rdy", rdyCommand, "Opens the ReadyCheck Panel");

	RegConsoleCmd("sm_admins", AdminListCommand, "Shows a list of Online Admins");
	RegConsoleCmd("sm_cap", CapCommand, "Opens the Soccer Mod cap menu");
	RegConsoleCmd("sm_commands", CommandsCommand, "Opens the Soccer Mod commands list");
	RegConsoleCmd("sm_credits", CreditsCommand, "Opens the Soccer Mod credits menu");
	RegConsoleCmd("sm_forfeit", Command_Forfeit, "Starts a forfeit vote");
	RegConsoleCmd("sm_gk", GkCommand, "Toggle the GK skin");	
	RegConsoleCmd("sm_help", HelpCommand, "Opens the Soccer Mod help menu");
	RegConsoleCmd("sm_info", CreditsCommand, "Opens the Soccer Mod credits menu");
	RegConsoleCmd("sm_lc", JoinlistCommand, "Opens the Soccer Mod joinlist");
	RegConsoleCmd("sm_late", JoinlistCommand, "Opens the Soccer Mod joinlist");
	RegConsoleCmd("sm_maprr", MaprrCommand, "Quickly rr the map");
	RegConsoleCmd("sm_match", MatchCommand, "Opens the Soccer Mod match menu");
	RegConsoleCmd("sm_matchrr", MatchRRCommand, "Restart the match");
	RegConsoleCmd("sm_p", PauseCommand, "Pauses a match");
	RegConsoleCmd("sm_pause", PauseCommand, "Pauses a match");	
	RegConsoleCmd("sm_pick", PickCommand, "Opens the Soccer Mod pick menu");
	RegConsoleCmd("sm_pos", PosCommand, "Opens the Soccer Mod Positions menu"); 
	RegConsoleCmd("sm_prank", PRankCommand, "Displays your public rank in the chat");
	RegConsoleCmd("sm_profile", ProfileCommand, "Display Steamprofile of the target");
	RegConsoleCmd("sm_rank", RankCommand, "Displays your match rank in the chat");	
	RegConsoleCmd("sm_ref", RefCommand, "Opens the Soccer Mod referee menu");
	RegConsoleCmd("sm_rr", rrCommand, "rr the round");
	RegConsoleCmd("sm_shout", ShoutMenu, "Opens the Shout list");
	RegConsoleCmd("sm_spec", SpecCommand, "Puts all players to Spectator");
	RegConsoleCmd("sm_start", StartCommand, "Starts a match");
	RegConsoleCmd("sm_stats", StatsCommand, "Opens the Soccer Mod stats menu");
	RegConsoleCmd("sm_stop", StopCommand, "Stops a match");
	RegConsoleCmd("sm_training", TrainingCommand, "Opens the Soccer Mod training menu");
	RegConsoleCmd("sm_unp", UnpauseCommand, "Unpauses a match");
	RegConsoleCmd("sm_up", UnpauseCommand, "Unpauses a match");
	RegConsoleCmd("sm_unpause", UnpauseCommand, "Unpauses a match");

	RegAdminCmd("sm_addadmin", Command_AddAdmin, ADMFLAG_RCON, "[RCONFLAG]Adds an admin to admins_simple.ini");
	RegAdminCmd("sm_aim", Command_AimPos, ADMFLAG_RCON, "[RCONFLAG]Prints the position you're looking at to the chat.");
	RegAdminCmd("sm_dpass", Command_DefPass, ADMFLAG_RCON, "[RCONFLAG]Reset the sv password");
	RegAdminCmd("sm_forcerdy", Command_ForceRdy, ADMFLAG_RCON, "[RCONFLAG]Forces Ready state for every player");
	RegAdminCmd("sm_forceunp", Command_ForceUnpause, ADMFLAG_RCON, "[RCONFLAG]Forces the match to unpause");
	RegAdminCmd("sm_gksetup", Command_GKSetup, ADMFLAG_RCON, "[RCONFLAG]Menu to setup gk areas.");
	RegAdminCmd("sm_jumptime", Command_JumpTime, ADMFLAG_ROOT, "[RCONFLAG]Change time for how long ducking is blocked after jumping.");
	RegAdminCmd("sm_pass", Command_Pass, ADMFLAG_RCON, "[RCONFLAG]Set the sv password");
	RegAdminCmd("sm_rpass", Command_RandPass, ADMFLAG_RCON, "[RCONFLAG]Set a random server password");
	RegAdminCmd("sm_soccerset", Command_SoccerSet, ADMFLAG_GENERIC, "[GENERICFLAG]Shortcut to the Settings menu");
	RegAdminCmd("sm_spray", Command_RemoveSpray, ADMFLAG_GENERIC, "[GENERICFLAG]Remove the spray you're looking at");
	RegAdminCmd("sm_tag", Command_GetTag, ADMFLAG_RCON, "[RCONFLAG] Prints your current clantag - Test");
	RegAdminCmd("sm_ungk", Command_UnGK, ADMFLAG_GENERIC, "[GENERICFLAG]Remove the gk skin from your target");
	RegAdminCmd("sm_timetest", Command_TimeTest, ADMFLAG_RCON, "[RCONFLAG]Check if matchlog would be created if a match is started now");
	RegAdminCmd("sm_walls", Command_WallRemove, ADMFLAG_GENERIC, "[GENERICFLAG]Removes Kickoff walls forcefully.");
	RegAdminCmd("sm_wiperanks", Command_WipeRanks, ADMFLAG_RCON, "[RCONFLAG]Wipes the given ranking table");
	RegAdminCmd("sm_shoutset", ShoutSettings, ADMFLAG_GENERIC, "Opens the Shout settings menu");
	
	//RegAdminCmd("sm_test", Command_Test, ADMFLAG_RCON, "[RCONFLAG]Test command");
	//RegAdminCmd("sm_ball", Command_Test, ADMFLAG_RCON, "[RCONFLAG]Test command");
}

// *******************************************************************************************************************
// ************************************************ CLIENT COMMANDS **************************************************
// *******************************************************************************************************************
public Action ProfileCommand(int client, int args)
{
	if(args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_profile <user>");
		return Plugin_Handled;
	}

	char username[128];
	GetCmdArg(1, username, sizeof(username));
	TrimString(username);
	StripQuotes(username);
	
	int iTarget = FindTarget(client, username, true, false);
	
	if(iTarget == -1) return Plugin_Handled;
	
	char steamID[32];
	GetClientAuthId(iTarget, AuthId_Steam2, steamID, sizeof(steamID));
	DisplayProfileTo(client, steamID);
	
	return Plugin_Handled;
}


public Action JoinlistCommand(int client, int args)
{
	OpenJoinlistPanel(client);
	
	return Plugin_Handled;
}

public Action SpecCommand(int client, int args)
{
	
	if(args > 0)
	{
		char username[128];
		GetCmdArg(1, username, sizeof(username));
		TrimString(username);
		StripQuotes(username);
		
		if(StrEqual(username, "all"))
		{
			//Put all to spec
			if((CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) || IsSoccerAdmin(client, "cap") || (publicmode == 2) || (publicmode == 1))
			{
				CapPutAllToSpec(client);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
		else if(StrEqual(username, "me"))
		{
			//Put user to spec
			ChangeClientTeam(client, 1);
		}
		else
		{
			if((CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC)) || IsSoccerAdmin(client, "cap") || (publicmode == 2) || (publicmode == 1))
			{
				//Put target to spec
				int iTarget = FindTarget(client, username, true, false);
		
				if(iTarget == -1) return Plugin_Handled;
				
				if (IsClientInGame(iTarget) && IsClientConnected(iTarget))
				{
					if (GetClientTeam(iTarget) != 1)
					{
						ChangeClientTeam(iTarget, 1);
					}
					else CPrintToChat(client, "{%s}[%s] {%s}Player is already in spectator", prefixcolor, prefix, textcolor);
				}
				else CPrintToChat(client, "{%s}[%s] {%s}Player is no longer on the server", prefixcolor, prefix, textcolor);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
	}
	else
	{
		//Info
		CPrintToChat(client, "{%s}[%s] {%s}Missing argument. Use '!spec all' to spec everyone or '!spec me' to spec yourself.", prefixcolor, prefix, textcolor);
		CPrintToChat(client, "{%s}[%s] {%s}You can also provide the part of a username to spec your target (e.g. '!spec art').", prefixcolor, prefix, textcolor);
	}
	
	return Plugin_Handled;
}

public Action rdyCommand(int client, int args)
{
	if (FileExists(tempReadyFileKV)) 
	{
		OpenReadyPanel(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}No Readycheck running.", prefixcolor, prefix, textcolor);
	
	return Plugin_Handled;
}

public Action ClientCommands(int client, int args)
{
	OpenMenuSoccer(client);

	return Plugin_Handled;
}

public Action Command_Forfeit(int client, int args)
{	
	if (IsValidClient(client) && GetClientTeam(client) != 1)	
	{
		if(matchStarted)
		{
			if ((ForfeitEnabled == 1 && ForfeitCapMode == 1) || (ForfeitEnabled == 1 && ForfeitCapMode == 0)) 
			{
				if (4 <= ForfeitScore <= 15)
				{
					ffTScore = CS_GetTeamScore(2); // T score
					ffCTScore = CS_GetTeamScore(3); // CT score
					if ((ffTScore-ffCTScore >= ForfeitScore) || (ffCTScore-ffTScore >= ForfeitScore))
					{
						if (!ffActive)
						{
							if (ffcounter < 3)
							{
								iHelp = 0;
								
								if (ForfeitPublic == 1)
								{	
									// Prevent multiple uses at once & +1 votecount
									ffActive = true;
									ffcounter++;
									
									for (int i = 1; i <= MaxClients; i++)
									{
										if (IsValidClient(i) && GetClientTeam(i) != 1)
										{
											iHelp++;
										}	
									}
									
									ForfeitVoteMenu();
										
									// Start CD Timer
									forfeitTimer = CreateTimer(1.0, ForfeitCDTimer, _, TIMER_REPEAT); //1 sec timer
								}
								else if (ForfeitPublic == 0)
								{
									if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "match"))
									{
										// Prevent multiple uses at once & +1 votecount
										ffActive = true;
										ffcounter++;
										
										for (int i = 1; i <= MaxClients; i++)
										{
											if (IsValidClient(i) && GetClientTeam(i) != 1)
											{
												iHelp++;
											}	
										}
										
										ForfeitVoteMenu();
					
										// Start CD Timer
										forfeitTimer = CreateTimer(1.0, ForfeitCDTimer, _, TIMER_REPEAT);
									}
									else CPrintToChat(client, "{%s}[%s] {%s}The forfeit vote can only be started by an admin.", prefixcolor, prefix, textcolor);
								}
							}
							else CPrintToChat(client, "{%s}[%s] {%s}You can only start up to 3 Forfeit votes per match.", prefixcolor, prefix, textcolor);
						}
						else CPrintToChat(client, "{%s}[%s] {%s}Forfeit vote is on cooldown! Try again in %.0f seconds.", prefixcolor, prefix, textcolor, cdTime);
					}
					else CPrintToChat(client, "{%s}[%s] {%s}A forfeit vote is only possible if a team is leading by %i goals!", prefixcolor, prefix, textcolor, ForfeitScore);
				}
				else CPrintToChat(client, "{%s}[%s] {%s}Forfeit vote condition has to be between 4 and 15 goals.", prefixcolor, prefix, textcolor);
			}
			else if(ForfeitEnabled == 0) CPrintToChat(client, "{%s}[%s] {%s}The forfeit vote is disabled for this match.", prefixcolor, prefix, textcolor);
			else if(ForfeitEnabled == 0 && ForfeitCapMode == 1) CPrintToChat(client, "{%s}[%s] {%s}Forfeit vote is only allowed for cap matches.", prefixcolor, prefix, textcolor);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}You can't forfeit without starting a match.", prefixcolor, prefix, textcolor);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}You can't start a forfeit vote as a spectator.", prefixcolor, prefix, textcolor);
	
	return Plugin_Handled;
}


public Action AdminListCommand(int client, int args)
{
	menuaccessed[client] = false;
	if(publicmode == 2)						CPrintToChat(client, "{%s}[%s] {%s}Publicmode set - !menu is freely accessable by everyone", prefixcolor, prefix, textcolor);
	else 									OpenMenuOnlineAdmin(client);
	
	return Plugin_Handled;
}

public Action MaprrCommand(int client, int args)
{
	char command[128], map[128];
	GetCurrentMap(map, sizeof(map));
	Format(command, sizeof(command), "changelevel %s", map);
	
	if(!matchStarted)
	{
		if(publicmode == 0)
		{
			if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "mapchange"))
			{
				Handle pack;
				CreateDataTimer(2.0, DelayedServerCommand, pack);
				WritePackString(pack, command);
				
				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has reloaded the map", prefixcolor, prefix, textcolor, client, map);
				}
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
		else if(publicmode == 1 || publicmode == 2)
		{
			Handle pack;
			CreateDataTimer(2.0, DelayedServerCommand, pack);
			WritePackString(pack, command);
			
			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has reloaded the map", prefixcolor, prefix, textcolor, client, map);
			}
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}You can't reload the map during a match", prefixcolor, prefix, textcolor);
	
	for (int player = 1; player <= MaxClients; player++)
	{
		if(GetClientMenu(player) != MenuSource_None )	
		{
			CancelClientMenu(player,false);
			InternalShowMenu(player, "\10", 1);
		}
	}
	
	return Plugin_Handled;
}

public Action rrCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "match"))
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
	return Plugin_Handled;
}

public Action MatchRRCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(publicmode == 1 || publicmode == 2 || (publicmode == 0 && (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "match"))))
		{
			if(matchStarted)
			{
				MatchStop(client);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}No match started!", prefixcolor, prefix, textcolor); 
			
			if (!matchStarted)
			{
				ServerCommand("mp_restartgame 1");
			
				FreezeAll();
				MatchReset();
				LoadConfigMatch();
				ResetMatchStats();

				matchStarted = true;
				matchStart = true;
				matchKickOffTaken = true;
				matchToss = GetRandomInt(2, 3);
				
				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has restarted the match", prefixcolor, prefix, textcolor, client);
				}
				
				RenameMatchLog();		
				if(matchlog == 1) 
				{
					SaveLogsOnMatchStart();
					CreateMatchLog(custom_name_ct, custom_name_t);
				}
				if(matchlog == 2)
				{
					if(TimeEnabledMatchlog())
					{
						SaveLogsOnMatchStart();
						CreateMatchLog(custom_name_ct, custom_name_t);
					}
				}
				
				HostName_Change_Status("Match");
			}
		}
		else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	
	return Plugin_Handled;
}

public Action StartCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(!matchStarted)
		{
			if(publicmode == 1 || publicmode == 2 || (publicmode == 0 && (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "match"))))
			{
				MatchStart(client);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}Match already started!", prefixcolor, prefix, textcolor); 
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	
	return Plugin_Handled;
}

public Action PauseCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(!matchPaused)
		{
			if(publicmode == 1 || publicmode == 2 || (publicmode == 0 && (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "match"))))
			{	
				MatchPause(client);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}Match already paused!", prefixcolor, prefix, textcolor); 
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action StopCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(matchStarted)
		{
			if(publicmode == 1 || publicmode == 2 || (publicmode == 0 && (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "match"))))
			{
				MatchStop(client);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}No match started!", prefixcolor, prefix, textcolor); 
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	
	if (FileExists(tempReadyFileKV)) 
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 3))
			{
				if(GetClientMenu(i) != MenuSource_None )
				{
					CancelClientMenu(i,false);
					InternalShowMenu(i, "\10", 1); 
					//DeleteTempFile();
				} 
			}
		}
	}
	
	return Plugin_Handled;
}

public Action UnpauseCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(matchStarted)
		{
			if(matchPaused)
			{
				if(publicmode == 1 || publicmode == 2 || (publicmode == 0 && (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "match"))))
				{
					UnpauseCheck(client);
				}
				else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}Match is not paused!", prefixcolor, prefix, textcolor); 
		}
		else CPrintToChat(client, "{%s}[%s] {%s}No match started!", prefixcolor, prefix, textcolor); 
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
	if(publicmode == 1 || publicmode == 2 || (publicmode == 0 && (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "menu"))))
	{
		OpenMenuAdmin(client);
	}
	return Plugin_Handled;
}

public Action CapCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(publicmode == 1 || publicmode == 2 || (publicmode == 0 && (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "cap"))))
		{
			OpenCapMenu(client);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action MatchCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(publicmode == 1 || publicmode == 2 || (publicmode == 0 && (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "match"))))
		{
			OpenMatchMenu(client);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action TrainingCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(publicmode == 2 || ((publicmode == 0 || publicmode == 1) && (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "training"))))
		{
			OpenTrainingMenu(client);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action RefCommand(int client, int args)
{
	if (currentMapAllowed)
	{
		if(publicmode == 1 || publicmode == 2 || (publicmode == 0 && (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC) || IsSoccerAdmin(client, "referee"))))
		{
			OpenRefereeMenu(client);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command", prefixcolor, prefix, textcolor);
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
	if (currentMapAllowed) 
	{
		if(rankingPlayerCDTimes[client] == 0 || rankingPlayerCDTimes[client] <= ( GetTime() - rankingCDTime))
		{
			rankingPlayerCDTimes[client] = GetTime();
			
			rankingPlayerSpammed[client] = false;
			ClientCommandMatchRanking(client);
		}
		else if (!rankingPlayerSpammed[client])
		{
			CPrintToChat(client, "{%s}[%s] {%s}You are not allowed to use this command in the next %d seconds.", prefixcolor, prefix, textcolor, rankingCDTime - (GetTime() - rankingPlayerCDTimes[client]));
			
			rankingPlayerSpammed[client] = true;
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action PRankCommand(int client, int args)
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

public Action Command_AimPos(int client, int args)
{
	float pos[3];
	if (GetClientAimTargetEx(client, pos) >= 0) 
	{
		CReplyToCommand(client, "{%s}[%s] {%s}Position you are aiming at: {%s}%.6f, %.6f, %.6f", prefixcolor, prefix, textcolor, prefixcolor, pos[0], pos[1], pos[2]);
	}

	return Plugin_Handled;
}

public Action Command_GKSetup(int client, int args)
{
	OpenGKAreaPanel(client);
	
	return Plugin_Handled;
}

public Action Command_WipeRanks(int client, int args)
{
	if(args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_wiperanks match OR public");
		return Plugin_Handled;
	}

	char table[64];
	GetCmdArg(1, table, sizeof(table));

	if (StrEqual(table, "match") || StrEqual(table,"public"))
	{
		if(StrEqual(table, "match"))
		{
			WipeStatsTable("soccer_mod_match_stats");
			CPrintToChat(client, "{%s}[%s] Match rankings have been wiped.", prefixcolor, prefix); 
		}
		if(StrEqual(table,"public"))
		{
			WipeStatsTable("soccer_mod_public_stats");
			CPrintToChat(client, "{%s}[%s] Public rankings have been wiped.", prefixcolor, prefix);
		}
	}
	else
	{
		ReplyToCommand(client, "[SM] Usage: sm_wiperanks match OR public");
		return Plugin_Handled;
	}
	
	return Plugin_Handled;
}

public Action Command_SoccerSet(int client, int args)
{
	OpenMenuSettings(client)
	return Plugin_Handled;
}

public Action Command_ForceUnpause(int client, int args)
{
	if (matchPaused)
	{
		if(matchReadyCheck > 0)
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 3))
				{
					if(GetClientMenu(i) != MenuSource_None)
					{
						CancelClientMenu(i,false);
						InternalShowMenu(i, "\10", 1); 
					} 
				}
			}
			showPanel = false;
			//DeleteTempFile();
			if (tempUnpause)
			{
				matchReadyCheck = 1;
				tempUnpause = false;
			} 
			
			CPrintToChatAll("{%s}[%s] {%s}Forced to unpause.", prefixcolor,  prefix, textcolor);
			MatchUnpause(client);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}ReadyCheck not running!", prefixcolor, prefix, textcolor); 
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Match not Paused!", prefixcolor, prefix, textcolor); 
	
	return Plugin_Handled;
}

public Action Command_ForceRdy(int client, int args)
{
	if (matchPaused)
	{
		if(matchReadyCheck > 0)
		{
			//kvTemp = new KeyValues("Ready Check");
			//kvTemp.ImportFromFile(tempReadyFileKV);
			
			kvTemp.GotoFirstSubKey()
			do
			{
				char buffer[32];
				kvTemp.GetString("Status", buffer, sizeof(buffer), "Not Ready");
				if(StrEqual(buffer, "Not Ready"))
				{
					kvTemp.SetString("Status", "Ready");
				}
			}
			while (kvTemp.GotoNextKey());
			
			kvTemp.Rewind();
			//kvTemp.ExportToFile(tempReadyFileKV);
			//kvTemp.Close();

			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 3))
				{
					CPrintToChat(i,"{%s}[%s] {%s}State forced to Ready.", prefixcolor, prefix, textcolor);
				}
			}
			RefreshPanel();	
		}
		else CPrintToChat(client, "{%s}[%s] {%s}ReadyCheck not running!", prefixcolor, prefix, textcolor); 
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Match not Paused!", prefixcolor, prefix, textcolor); 
	
	return Plugin_Handled;
}

public Action Command_DefPass(int client, int args)
{
	if (bRandPass)
	{
		bRandPass = false;
		ResetPass();
		CPrintToChatAll("{%s}[%s] {%s}Password reset.", prefixcolor, prefix, textcolor);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Already using default password.", prefixcolor, prefix, textcolor);
	
	return Plugin_Handled;
}

public Action Command_RandPass(int client, int args)
{
	RandPass();
	bRandPass = true;
	CPrintToChatAll("{%s}[%s] {%s}Random password set.", prefixcolor, prefix, textcolor);
	
	return Plugin_Handled;
}

public Action Command_GetTag(int client, int args)
{
	char PlayerClanTag[32];
	CS_GetClientClanTag(client, PlayerClanTag, sizeof(PlayerClanTag));
	CPrintToChat(client, "{%s}[%s] {%s}Your clantag is %s", prefixcolor, prefix, textcolor, PlayerClanTag);
	//AddSoccerTags();
	
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
	CPrintToChat(client, "{%s}[%s] {%s}%s added as an admin with the flags %s", prefixcolor, prefix, textcolor, szName, szFlags2);

	CloseHandle(hFile);
	FakeClientCommandEx(client, "sm_reloadadmins");
	
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
		CPrintToChat(client, "{%s}[%s] Check your console for the current password", prefixcolor, prefix);
	}
	
	return Plugin_Handled;
}

public Action Command_TimeTest(int client, int args)
{
	if(TimeEnabledMatchlog()) PrintToChat(client, "Matchlog-Creation Test successful");
	else PrintToChat(client, "Matchlog-Creation Test failed");
	
	return Plugin_Handled;
}

public Action Command_JumpTime(int client, int args)
{
	char arg[64];
	GetCmdArg(1, arg, sizeof(arg));
	
	if (StringToFloat(arg) > 0.0)
	{
		fJUMP_TIMER = StringToFloat(arg)
		UpdateConfigFloat("Misc Settings", "soccer_mod_blockdj_time", fJUMP_TIMER);
		PrintToChat(client, "Jumptimer set to %1.f", fJUMP_TIMER);
	}
	else PrintToChat(client, "Not a valid value.");
	
	return Plugin_Handled;
}

public Action Command_RemoveSpray(int client, int args) 
{
	if (!IsValidClient(client))
		return Plugin_Handled;

	float vecPos[3];

	if (GetClientEyeEndLocation(client, vecPos)) 
	{
		float remPos[3];
		//char szAdminName[32];
		//GetClientName(client, szAdminName, 31);
		
		GetClientAbsOrigin(client, remPos);

	 	for (int i = 1; i <= MaxClients; i++) 
		{
			if (GetVectorDistance(mapBallStartPosition, sprayVector[i]) <= 10.0)
			{
				remPos[0] = mapBallStartPosition[0];
				remPos[1] = mapBallStartPosition[1];
				remPos[2] = mapBallStartPosition[2];
			}
		
			if (GetVectorDistance(remPos, sprayVector[i]) <= 200.0)//vecPos <= 300.0) 
			{
				float vecEndPos[3];
				
				vecEndPos[0] = remPos[0];
				vecEndPos[1] = remPos[1];
				vecEndPos[2] = remPos[2]-100.0;

				SprayDecal(i, 0, vecEndPos);

				sprayVector[i][0] = remPos[0];
				sprayVector[i][1] = remPos[1]+500.0;
				sprayVector[i][2] = remPos[2]-500.0;

				if (IsValidClient(i)) CPrintToChat(client, "{%s}[%s] Spray By %s (%s) removed.", prefixcolor, prefix, sprayName[i], sprayID[i]);
				else CPrintToChat(client, "{%s}[%s] Owner of the spray already left.", prefixcolor, prefix);

				return Plugin_Handled;
			}
		}
	}
	
	CPrintToChat(client, "{%s}[%s] No Spray found", prefixcolor, prefix);

	return Plugin_Handled;
}

public Action Command_UnGK(int client, int args)
{	
	if (currentMapAllowed)
	{
		if (args < 1)
		{
			ReplyToCommand(client, "[SM] Usage: sm_ungk <#userid|name>");
			return Plugin_Handled;
		}
		
		char arg1[32];
		
		GetCmdArg(1, arg1, sizeof(arg1));
		
		if (StrEqual(arg1, "t") || StrEqual(arg1, "ct"))
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i)) 
				{
					int team = GetClientTeam(i);
					int argteam;
					if (StrEqual(arg1, "t"))	argteam = 2;
					else if (StrEqual(arg1, "ct")) argteam = 3;
					
					if (argteam == team)
					{
						if (skinsIsGoalkeeper[i] == 1)
						{
							skinsIsGoalkeeper[i] = 0;
							if (argteam == 2)
							{
								SetEntityModel(i, skinsModelT);
								bTGoalkeeper = false;
							}
							else if (argteam == 3)
							{
								SetEntityModel(i, skinsModelCT);
								bCTGoalkeeper = false;
							}
							
							CPrintToChat(i, "{%s}[%s] {%s}Your gk skin was removed by an admin.", prefixcolor, prefix, textcolor);
							CPrintToChat(client, "{%s}[%s] {%s}GK skin of %N removed.", prefixcolor, prefix, textcolor, i);
						}
					}
				}
			}
		}
		else
		{
			int target = FindTarget(client, arg1);
			if (!(StrEqual(arg1, "t")) && !(StrEqual(arg1, "ct")))
			{
				if (target == -1)
				{
					CPrintToChat(client, "{%s}[%s] {%s}Target not found.", prefixcolor, prefix, textcolor);
					return Plugin_Handled;
				}
			}
		
			char name[MAX_NAME_LENGTH];
			GetClientName(target, name, sizeof(name));
			
			int team = GetClientTeam(target);

			if (skinsIsGoalkeeper[target])
			{
				skinsIsGoalkeeper[target] = 0;

				if (team == 2 && FileExists(skinsModelT, true))
				{
					SetEntityModel(target, skinsModelT);
					bTGoalkeeper = false;
				}
				else if (team == 3 && FileExists(skinsModelCT, true))
				{
					SetEntityModel(target, skinsModelCT);
					bCTGoalkeeper = false;
				}
				
				CPrintToChat(target, "{%s}[%s] {%s}Your gk skin was removed by an admin.", prefixcolor, prefix, textcolor);
				CPrintToChat(client, "{%s}[%s] {%s}GK skin of %N removed.", prefixcolor, prefix, textcolor, target);
			}
			else
			{
				CPrintToChat(client, "{%s}[%s] {%s}%N is not currently using a gk skin.", prefixcolor, prefix, textcolor, target);
				return Plugin_Handled;
			}
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	return Plugin_Handled;
}

public Action Command_WallRemove(int client, int args)
{
	if (currentMapAllowed)
	{
		if(KickoffWallSet == 1) 
		{
			KillWalls();
			CPrintToChatAll("{%s}[%s] {%s}Kickoff walls have been removed by %N.", prefixcolor, prefix, textcolor, client);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}Kickoff walls are not currently enabled.", prefixcolor, prefix, textcolor);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
	
	return Plugin_Handled;
}

// *******************************************************************************************************************
// *********************************************** UTILITY FUNCTIONS *************************************************
// *******************************************************************************************************************

// ************************************************ SPRAY FUNCTIONS *************************************************
public void SprayDecal(int client, int entIndex, float vecPos[3]) 
{
	if (!IsValidClient(client))
		return;

	TE_Start("Player Decal");
	TE_WriteVector("m_vecOrigin", vecPos);
	TE_WriteNum("m_nEntity", entIndex);
	TE_WriteNum("m_nPlayer", client);
	TE_SendToAll();
}

public bool ValidSpray(int entity, int contentsMask)
{
	return entity > MaxClients;
}

public bool GetClientEyeEndLocation(int client, float vector[3])
{
	if(!IsValidClient(client))
	{
		return false;
	}
	
	float vOrigin[3];
	float vAngles[3];

	GetClientEyePosition(client, vOrigin);
	GetClientEyeAngles(client, vAngles);

	Handle hTraceRay = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_SHOT, RayType_Infinite, ValidSpray);

	if(TR_DidHit(hTraceRay))
	{
		TR_GetEndPosition(vector, hTraceRay);
		//DrawLaser("gk_area_beam", vOrigin[0], vOrigin[1], vOrigin[2], vector[0], vector[1], vector[2], "255 255 255");
		CloseHandle(hTraceRay);
		
		return true;
	}

	CloseHandle(hTraceRay);
	
	return false;
}

// CD Timer
public Action ForfeitCDTimer(Handle timer)
{
	if(cdTime <= 0)
	{
		ffActive = false;
	
		//if ((ffTScore-ffCTScore >= ForfeitScore) || (ffCTScore-ffTScore>= ForfeitScore))  //CPrintToChatAll("{%s}[%s]A new Forfeit vote is possible now.", prefixcolor, prefix)
		
		KillTimer(forfeitTimer);
		cdTime = float(matchPeriodLength/2);

	}
	
	cdTime--;
	
	return Plugin_Continue;
}

//DelayedffAbort Timer
public Action DelayedffAbort(Handle timer)
{
	// Countdown
	if(abortTime >= 1.0)	
	{
		PrintCenterTextAll("Aborting in: %.0f", abortTime);
		PlaySound("buttons/button17.wav");
	}
	
	if(abortTime == 0.0)
	{
		// Stop the DelayTimer
		KillTimer(ffDelayTimer);
		
		// Give some information
		PrintCenterTextAll("");
		PrintHintTextToAll("");
		PlaySound("soccermod/endmatch.wav");
		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) 
			{
				CPrintToChat(player, "{%s}[%s] {%s}The match was stopped by forfeit vote.", prefixcolor, prefix, textcolor);
			}
		}
		
		//Stop the Match
		if(matchPaused) 	UnfreezeAll();
		MatchReset();
		ForfeitReset();
		abortTime++;
		
		if(ForfeitAutoSpec == 1) 
		{
			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player))
				{
					CPrintToChat(player, "{%s}[%s] {%s}Put everyone to spectator.", prefixcolor, prefix, textcolor);
					if (GetClientTeam(player) != 1) ChangeClientTeam(player, 1);
				}
			}
		}
		
		
	}
	
	abortTime--;
	
	return Plugin_Continue;
}

public void ForfeitReset()
{
	// Reset Forfeitstuff
	cdTime = 0.0;
	ffActive = false;
	abortTime = 5.0;
	ffcounter = 0;

	// Set ForfeitEnabled to 0 for capmode only and no RR
	if(ForfeitCapMode == 1 && !ForfeitRRCheck) 
	{
		ForfeitEnabled = 0;
		UpdateConfigInt("Forfeit Settings", "soccer_mod_forfeitvote", ForfeitEnabled);
	}
	// Kill RR Check timer
	if(ffRRCheckTimer != null)
	{
		//KillTimer(ffRRCheckTimer);
		ffRRCheckTimer = null;
	}
}

// VoteMenu
public int Handle_ForfeitVoteMenu(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		/* This is called after VoteEnd */
		delete menu;
	}
}
 
// Handling the results 
public void Handle_VoteResults(Menu menu, int num_votes, int num_clients, const int[][] client_info, int num_items, const int[][] item_info)
{
	char item[65];
	float result;
	int yesVotes = 0;
	
	// item_info[0][VOTEINFO_ITEM_INDEX] = Sieger
	menu.GetItem(item_info[0][VOTEINFO_ITEM_INDEX], item, sizeof(item));
	if(StrEqual(item, "Yes", false))
	{
		yesVotes = item_info[0][VOTEINFO_ITEM_VOTES];
	}
	else 
	{
		yesVotes = item_info[1][VOTEINFO_ITEM_VOTES];
	}
	
	result = (float(yesVotes)/float(num_votes))*100;
	
	if (result > 66.0)
	{
		if(!matchPaused || !matchPeriodBreak)		FreezeAll();
		CPrintToChatAll("{%s}[%s] %.2f\% out of %i votes were Yes. Aborting the match in %.0f seconds.", prefixcolor, prefix, result, num_votes, abortTime);
		
		// Create small delay prior abort
		ffDelayTimer = CreateTimer(1.0, DelayedffAbort, _, TIMER_REPEAT);
	}
	else CPrintToChatAll("{%s}[%s] %.2f\% out of %i votes were Yes. Match will continue. Try again in %.0f seconds.", prefixcolor, prefix, result, num_votes, cdTime);
	
	if(num_votes == 0) CPrintToChatAll("{%s}[%s] {%s}No votes were casted. Match will continue.", prefixcolor, prefix, textcolor);
}

void ForfeitVoteMenu()
{
	if (IsVoteInProgress())
	{
		return;
	}
 
	Menu menu = new Menu(Handle_ForfeitVoteMenu);
	menu.VoteResultCallback = Handle_VoteResults;
	menu.SetTitle("Abort this match?");
	menu.AddItem("yes", "Yes");
	menu.AddItem("no", "No");
	menu.ExitButton = false;
	DisplayVoteMenuToTeam(menu, 60, 1);
}

stock bool DisplayVoteMenuToTeam(Handle menu, int iTime, int iTeam)
{
	int iTotal;
	int[] iPlayers = new int[MaxClients];

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || GetClientTeam(i) == iTeam)
		{
			continue;
		}

		if(iTotal <= iHelp)
		{
			iPlayers[iTotal++] = i;
		}
	}

	return VoteMenu(menu, iPlayers, iTotal, 30, 0);
}

// *********************************************** PASSWORD FUNCTIONS ************************************************

public void GetDefaultPassword(char buffer[256], int buffersize)
{
	File hFile = OpenFile("cfg/server.cfg", "rt");
	char cfgBuffer[256];
	
	while (!IsEndOfFile(hFile) && (ReadFileLine(hFile, cfgBuffer, sizeof(cfgBuffer))))
	{
		if (StrContains(cfgBuffer, "sv_password") != -1)
		{
			ReplaceString(cfgBuffer, sizeof(cfgBuffer), "sv_password", "", false);
			StripQuotes(cfgBuffer);
			buffer = cfgBuffer;
		}
	}
	
	hFile.Close();
}

public void ResetPass()
{
	ServerCommand("sm_cvar sv_password %s", defaultpw); //def_pass);
}

public void RandPass()
{
	int flags;
	
	ConVar pwflags = FindConVar("sv_password");
	flags = GetConVarFlags(pwflags);
	flags &= ~FCVAR_NOTIFY;
	SetConVarFlags(pwflags, flags);

	//pw.GetString(def_pass, sizeof(def_pass));
	char newpass[32];
	
	GetRandomString(newpass, 26);
	
	pwflags.SetString(newpass, false, false);
	//ServerCommand("sm_cvar sv_password %s", newpass);
	
	//return Plugin_Handled;
}

// *********************************************** PROFILE FUNCTIONS ************************************************

public void DisplayProfileTo(int client, char[] steamid)
{
	char szLink[128];
	char szCommunityID[18];

	GetCommunityIDString(steamid, szCommunityID, sizeof(szCommunityID)); 
	Format(szLink, sizeof(szLink), "http://steamcommunity.com/profiles/%s", szCommunityID);
	
	if (client)
	{
		//ShowMOTDPanel(iClient, "Steam Profile", szLink, MOTDPANEL_TYPE_URL);
		AdvMOTD_ShowMOTDPanel(client, "Steam Profile", szLink, MOTDPANEL_TYPE_URL, true, false, true);
	}
	else
	{
		PrintToServer("%s", szLink);
	}
}

stock bool GetCommunityIDString(char[] steamID, char[] CommunityID, int CommunityIDSize) 
{ 
	char SteamIDParts[3][11]; 
	char Identifier[] = "76561197960265728"; 

	if ((CommunityIDSize < 1) || (ExplodeString(steamID, ":", SteamIDParts, sizeof(SteamIDParts), sizeof(SteamIDParts[])) != 3)) 
	{ 
		CommunityID[0] = '\0'; 
		return false; 
	} 

	int Current, CarryOver = (SteamIDParts[1][0] == '1'); 
	for (int i = (CommunityIDSize - 2), j = (strlen(SteamIDParts[2]) - 1), k = (strlen(Identifier) - 1); i >= 0; i--, j--, k--) 
	{ 
		Current = (j >= 0 ? (2 * (SteamIDParts[2][j] - '0')) : 0) + CarryOver + (k >= 0 ? ((Identifier[k] - '0') * 1) : 0); 
		CarryOver = Current / 10; 
		CommunityID[i] = (Current % 10) + '0'; 
	} 

	CommunityID[CommunityIDSize - 1] = '\0'; 
	return true; 
}

/*public Action Command_Test(int client, int args)
{
	char model[128] = "models/soccer_mod/brazuca_test.mdl";

	if (FileExists(model, true))
	{
		char entityName[32];
		Format(entityName, sizeof(entityName), "soccer_mod_ball_%i", client);

		int index;
		bool ballSpawned = false;	

		while ((index = FindEntityByClassname(index, "prop_physics")) != INVALID_ENT_REFERENCE)
		{
			char entPropString[32];
			GetEntPropString(index, Prop_Data, "m_iName", entPropString, sizeof(entPropString));

			if (StrEqual(entPropString, entityName))
			{
				ballSpawned = true;
				AcceptEntityInput(index, "Kill");
			}
		}

		if (!ballSpawned)
		{
			index = CreateEntityByName("prop_physics");
			if (index)
			{
				if (!IsModelPrecached(model)) PrecacheModel(model);

				DispatchKeyValue(index, "targetname", entityName);
				DispatchKeyValue(index, "model", model);

				float aimPosition[3];
				GetAimOrigin(client, aimPosition);
				DispatchKeyValueVector(index, "origin", aimPosition);

				DispatchSpawn(index);
			}
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Cant spawn model %s", prefixcolor, prefix, textcolor, model);
	
	return Plugin_Handled;
}*/

/*public Action Command_Test(int client, int args)
{	
	float radius;
	
	char map[128];
	GetCurrentMap(map, sizeof(map));
	if(StrEqual(map, "ka_soccer_xsl_stadium_b1"))	radius = 252.5;
	else if(StrEqual(map, "ka_xsl_indoorcup"))		radius = 150.0;
	else if(StrEqual(map, "ka_parkhead"))			radius = 350.0;
		
	CreateInvisWallCircle("wallcircle", CS_TEAM_T, radius);
	
	return Plugin_Handled;
}*/