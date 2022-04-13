// char statsKeygroupRound[PLATFORM_MAX_PATH];
// char statsKeygroupMatch[PLATFORM_MAX_PATH];

// ********************************************************************************************************************
// ************************************************** ENTITY OUTPUTS **************************************************
// ********************************************************************************************************************
public void StatsOnAwakened(int caller, int activator)
{
	int index;
	while ((index = GetEntityIndexByName("gk_area_beam", "env_beam")) != -1) AcceptEntityInput(index, "Kill");
}

public void StatsOnTakeDamage(int ball, int client)
{
	// Handle timer;

	bool save = false;
	bool pass = false;
	bool interception = false;
	bool ball_loss = false;
	float possession;
	
	SetHudTextParams(0.90, 0.01, 30.0, 255, 255, 255, 255);

	char steamid[32];
	GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

	char name[MAX_NAME_LENGTH];
	GetClientName(client, name, sizeof(name));

	int team = GetClientTeam(client);
	if (team == CS_TEAM_T) statsHitsT++;
	else if (team == CS_TEAM_CT) statsHitsCT++;

	// AddPlayerStatInt(name, steamid, "hits", rankingPointsForHit);

	// char table[32] = "soccer_mod_public_stats";
	// if (matchStarted) table = "soccer_mod_match_stats";

	// char queryString[1024];
	// Format(queryString, sizeof(queryString), "UPDATE %s SET hits = (hits + 1), points = (points + %i) WHERE steamid = '%s'", 
	//  table, rankingPointsForHit, steamid);
	// ExecuteQuery(queryString);

	int saverClientid;
	char saverSteamid[32];
	char saverName[MAX_NAME_LENGTH];

	float ballPosition[3];
	GetEntPropVector(ball, Prop_Send, "m_vecOrigin", ballPosition);
	
	int prevhitteam;
	if (statsLastHitId)
	{
		if (IsClientConnected(statsLastHitId)) prevhitteam = GetClientTeam(statsLastHitId);
	}
	if (statsSaver) //CHECK LASTHIT = ENEMYTEAM
	{
		if (IsClientConnected(statsSaver))
		{
			saverClientid = statsSaver;
			GetClientAuthId(statsSaver, AuthId_Engine, saverSteamid, sizeof(saverSteamid));
			GetClientName(statsSaver, saverName, sizeof(saverName));

			if (!(statsCTGKAreaMinX <= ballPosition[0] <= statsCTGKAreaMaxX && 
				statsCTGKAreaMinY <= ballPosition[1] <= statsCTGKAreaMaxY && 
				statsCTGKAreaMinZ <= ballPosition[2] <= statsCTGKAreaMaxZ))
			{
				save = true;
				statsSavesCT++;
				// AddPlayerStatInt(saverName, saverSteamid, "saves", rankingPointsForSave);

				// Format(queryString, sizeof(queryString), "UPDATE %s SET saves = (saves + 1), points = (points + %i) WHERE steamid = '%s'", 
				//  table, rankingPointsForSave, saverSteamid);
				// ExecuteQuery(queryString);

				if (debuggingEnabled > 0) CPrintToChatAll("{%s}[%s] {%s}%N has made a save.", prefixcolor, prefix, textcolor, statsSaver);
				else
				{
					for(int player = 1; player <= MaxClients; player++)
					{
						if(extChatSet[player] == 1 && extChatSave[player] == 1)
						{
							//extChatMode == 0 -> Chat
							if(extChatMode[player] == 0) CPrintToChat(player, "{%s}[%s] %N has made a save.", prefixcolor, prefix, statsSaver);
							//extChatMode == 1 -> Hud
							else 	ShowHudText(player, 8, "%N has made a save.", statsSaver); 
						}
					}
				}
			}
			else if (!(statsTGKAreaMinX <= ballPosition[0] <= statsTGKAreaMaxX && 
				statsTGKAreaMinY <= ballPosition[1] <= statsTGKAreaMaxY && 
				statsTGKAreaMinZ <= ballPosition[2] <= statsTGKAreaMaxZ))
			{
				save = true;
				statsSavesT++;
				// AddPlayerStatInt(saverName, saverSteamid, "saves", rankingPointsForSave);

				// Format(queryString, sizeof(queryString), "UPDATE %s SET saves = (saves + 1), points = (points + %i) WHERE steamid = '%s'", 
				//  table, rankingPointsForSave, saverSteamid);
				// ExecuteQuery(queryString);

				if (debuggingEnabled > 0) CPrintToChatAll("{%s}[%s] {%s}%N has made a save.", prefixcolor, prefix, textcolor, statsSaver);
				else
				{
					for(int player = 1; player <= MaxClients; player++)
					{
						if(extChatSet[player] == 1 && extChatSave[player] == 1)
						{
							//extChatMode == 0 -> Chat
							if(extChatMode[player] == 0) CPrintToChat(player, "{%s}[%s] %N has made a save.", prefixcolor, prefix, statsSaver);
							//extChatMode == 1 -> Hud
							else 	ShowHudText(player, 8, "%N has made a save.", statsSaver); 
						}
					}
				}
			}
		}

		statsSaver = 0;
	}
	// vorheriger hit von einem gegner?
	if (team == CS_TEAM_CT && 
		statsCTGKAreaMinX <= ballPosition[0] <= statsCTGKAreaMaxX && 
		statsCTGKAreaMinY <= ballPosition[1] <= statsCTGKAreaMaxY && 
		statsCTGKAreaMinZ <= ballPosition[2] <= statsCTGKAreaMaxZ)
	{
		if (prevhitteam == CS_TEAM_T) 
		{
			if (gksavesSet == 1 && bCTGoalkeeper)
			{
				if (skinsIsGoalkeeper[client])	statsSaver = client;
			}
			else
			{
				statsSaver = client;
			}		
		}
		if (debuggingEnabled == 1) CPrintToChatAll("{%s}[%s] {%s}%N has knifed the ball in the CT gk area.", prefixcolor, prefix, textcolor, client);
	}
	else if (team == CS_TEAM_T && 
		statsTGKAreaMinX <= ballPosition[0] <= statsTGKAreaMaxX && 
		statsTGKAreaMinY <= ballPosition[1] <= statsTGKAreaMaxY && 
		statsTGKAreaMinZ <= ballPosition[2] <= statsTGKAreaMaxZ)
	{
		if (prevhitteam == CS_TEAM_CT) 
		{
			if (gksavesSet == 1 && bTGoalkeeper)
			{
				if (skinsIsGoalkeeper[client])	statsSaver = client;
			}
			else
			{
				statsSaver = client;
			}		
		}
		if (debuggingEnabled == 1) CPrintToChatAll("{%s}[%s] {%s}%N has knifed the ball in the T gk area.", prefixcolor, prefix, textcolor, client);
	}

	if (client != statsScorerClientid)
	{
		statsAssisterTimestamp = statsScorerTimestamp;
		statsScorerTimestamp = GetGameTime();

		if (statsScorerClientid)
		{
			statsAssisterClientid = statsScorerClientid;
			statsAssisterName = statsScorerName;
			statsAssisterSteamid = statsScorerSteamid;
			statsAssisterTeam = statsScorerTeam;

			// statsScorerClientid = client;
			// statsScorerSteamid = steamid;
			// statsScorerName = name;
			// statsScorerTeam = team;
			// statsScorerClientid = client;
			// GetClientName(client, statsScorerName, sizeof(statsScorerName));
			// statsScorerTeam = GetClientTeam(client);
			// GetClientAuthId(client, AuthId_Engine, statsScorerSteamid, sizeof(statsScorerSteamid));

			possession = statsScorerTimestamp - statsAssisterTimestamp;
			if (statsAssisterTeam == CS_TEAM_T) statsPossessionT += possession;
			else if (statsAssisterTeam == CS_TEAM_CT) statsPossessionCT += possession;
			statsPossessionTotal += possession;
			// AddPlayerStatPossession(statsAssisterSteamid, possession, statsAssisterTeam);
			if (debuggingEnabled == 1) CPrintToChatAll("{%s}[%s] {%s}%s had the ball for %f.", prefixcolor, prefix, textcolor, statsAssisterName, possession);
			/*else
			{
				for(int player = 1; player <= MaxClients; player++)
				{
					if(extChatSet[player] == 1 && extChatPoss[player] == 1)
					{
						//extChatMode == 0 -> Chat
						if(extChatMode[player] == 0) CPrintToChat(player, "{%s}[%s] %s had the ball for %f.", prefixcolor, prefix, statsAssisterName, possession);
						//extChatMode == 1 -> Hud
						else 	ShowHudText(player, 8, "%s had the ball for %f.", statsAssisterName, possession); 
					}
				}
			}*/

			if (team == statsAssisterTeam)
			{
				pass = true;
				if (statsAssisterTeam == CS_TEAM_T) statsPassesT++;
				else if (statsAssisterTeam == CS_TEAM_CT) statsPassesCT++;
				// AddPlayerStatInt(statsAssisterName, statsAssisterSteamid, "passes", rankingPointsForPass);

				// Format(queryString, sizeof(queryString), "UPDATE %s SET passes = (passes + 1), points = (points + %i) WHERE steamid = '%s'", 
				//  table, rankingPointsForPass, statsAssisterSteamid);
				// ExecuteQuery(queryString);

				// if (IsClientInGame(statsAssisterClientid) && IsClientConnected(statsAssisterClientid)) SetPlayerStats(timer, statsAssisterClientid);
				if (debuggingEnabled > 0) CPrintToChatAll("{%s}[%s] {%s}%s has passed the ball to %s.", prefixcolor, prefix, textcolor, statsAssisterName, name);
				else
				{
					for(int player = 1; player <= MaxClients; player++)
					{
						if(extChatSet[player] == 1 && extChatPass[player] == 1)
						{
							//extChatMode == 0 -> Chat
							if(extChatMode[player] == 0) CPrintToChat(player, "{%s}[%s] {%s}%s has passed the ball to %s.", prefixcolor, prefix, textcolor, statsAssisterName, name);
							//extChatMode == 1 -> Hud
							else ShowHudText(player, 8, "%s has passed the ball to %s.", statsAssisterName, name);
						}
					}
				}
			}
			else
			{
				interception = true;
				if (team == CS_TEAM_T) statsInterceptionsT++;
				else if (team == CS_TEAM_CT) statsInterceptionsCT++;
				// AddPlayerStatInt(name, steamid, "interceptions", rankingPointsForInterception);

				// Format(queryString, sizeof(queryString), "UPDATE %s SET interceptions = (interceptions + 1), points = (points + %i) WHERE steamid = '%s'", 
				//  table, rankingPointsForInterception, steamid);
				// ExecuteQuery(queryString);

				if (debuggingEnabled == 1) CPrintToChatAll("{%s}[%s] {%s}%s has intercepted the ball from %s.", prefixcolor, prefix, textcolor, name, statsAssisterName);

				ball_loss = true;
				if (statsAssisterTeam == CS_TEAM_T) statsBallLossesT++;
				else if (statsAssisterTeam == CS_TEAM_CT) statsBallLossesCT++;
				// AddPlayerStatInt(statsAssisterName, statsAssisterSteamid, "ball_losses", rankingPointsForBallLoss);

				// Format(queryString, sizeof(queryString), "UPDATE %s SET ball_losses = (ball_losses + 1), points = (points + %i) WHERE steamid = '%s'", 
				//  table, rankingPointsForBallLoss, statsAssisterSteamid);
				// ExecuteQuery(queryString);

				// if (IsClientInGame(statsAssisterClientid) && IsClientConnected(statsAssisterClientid)) SetPlayerStats(timer, statsAssisterClientid);
				if (debuggingEnabled > 0) CPrintToChatAll("{%s}[%s] {%s}%s has lost the ball to %s.", prefixcolor, prefix, textcolor, statsAssisterName, name);
				else
				{
					for(int player = 1; player <= MaxClients; player++)
					{
						if(extChatSet[player] == 1 && extChatLoss[player] == 1)
						{
							//extChatMode == 0 -> Chat
							if(extChatMode[player] == 0) CPrintToChat(player, "{%s}[%s] %s has lost the ball to %s.", prefixcolor, prefix, statsAssisterName, name);
							//extChatMode == 1 -> Hud
							else ShowHudText(player, 8, "%s has lost the ball to %s.", statsAssisterName, name);
						}
					}
				}
			}
		}
		// else
		// {
		statsScorerClientid = client;
		statsScorerSteamid = steamid;
		statsScorerName = name;
		statsScorerTeam = team;
		// statsScorerClientid = client;
		// GetClientName(client, statsScorerName, sizeof(statsScorerName));
		// statsScorerTeam = GetClientTeam(client);
		// GetClientAuthId(client, AuthId_Engine, statsScorerSteamid, sizeof(statsScorerSteamid));
		// }
	}

	// KeyValues keygroupRound = new KeyValues("roundStatistics");
	// KeyValues keygroupMatch = new KeyValues("matchStatistics");

	// keygroupRound.ImportFromFile(statsKeygroupRound);
	// keygroupMatch.ImportFromFile(statsKeygroupMatch);

	statsKeygroupRound.JumpToKey(steamid, true);
	statsKeygroupMatch.JumpToKey(steamid, true);

	statsKeygroupRound.SetString("name", name);
	statsKeygroupMatch.SetString("name", name);

	int keyValue = statsKeygroupRound.GetNum("hits", 0);
	statsKeygroupRound.SetNum("hits", keyValue + 1);

	keyValue = statsKeygroupMatch.GetNum("hits", 0);
	//keyValue++;
	statsKeygroupMatch.SetNum("hits", keyValue + 1);

	if (StrEqual(gamevar, "csgo")) SetEntProp(client, Prop_Data, "m_iDeaths", statsKeygroupMatch.GetNum("assists", 0));
	//else SetEntProp(client, Prop_Data, "m_iDeaths", statsKeygroupMatch.GetNum("assists", 0));
	int points;
	points += rankingPointsForHit;

	if (interception)
	{
		keyValue = statsKeygroupRound.GetNum("interceptions", 0);
		statsKeygroupRound.SetNum("interceptions", keyValue + 1);

		keyValue = statsKeygroupMatch.GetNum("interceptions", 0);
		statsKeygroupMatch.SetNum("interceptions", keyValue + 1);

		points += rankingPointsForInterception;
	}

	keyValue = statsKeygroupRound.GetNum("points", 0);
	keyValue += points;
	statsKeygroupRound.SetNum("points", keyValue);

	keyValue = statsKeygroupMatch.GetNum("points", 0);
	keyValue += points;
	statsKeygroupMatch.SetNum("points", keyValue);

	if (StrEqual(gamevar, "csgo")) CS_SetClientContributionScore(client, keyValue);
	else SetEntProp(client, Prop_Data, "m_iDeaths", statsKeygroupMatch.GetNum("assists", 0));
	
	statsKeygroupRound.Rewind();
	statsKeygroupMatch.Rewind();

	if (pass || ball_loss || possession)
	{
		points = 0;

		statsKeygroupRound.JumpToKey(statsAssisterSteamid, true);
		statsKeygroupMatch.JumpToKey(statsAssisterSteamid, true);

		statsKeygroupRound.SetString("name", statsAssisterName);
		statsKeygroupMatch.SetString("name", statsAssisterName);

		if (pass)
		{
			keyValue = statsKeygroupRound.GetNum("passes", 0);
			statsKeygroupRound.SetNum("passes", keyValue + 1);

			keyValue = statsKeygroupMatch.GetNum("passes", 0);
			statsKeygroupMatch.SetNum("passes", keyValue + 1);

			points += rankingPointsForPass;
		}

		if (ball_loss)
		{
			keyValue = statsKeygroupRound.GetNum("ball_losses", 0);
			statsKeygroupRound.SetNum("ball_losses", keyValue + 1);

			keyValue = statsKeygroupMatch.GetNum("ball_losses", 0);
			statsKeygroupMatch.SetNum("ball_losses", keyValue + 1);

			points += rankingPointsForBallLoss;
		}

		if (possession)
		{
			float keyValueFloat = statsKeygroupMatch.GetFloat("possession", 0.0);
			statsKeygroupMatch.SetFloat("possession", keyValueFloat + possession);
		}

		keyValue = statsKeygroupRound.GetNum("points", 0);
		keyValue += points;
		statsKeygroupRound.SetNum("points", keyValue);

		keyValue = statsKeygroupMatch.GetNum("points", 0);
		keyValue += points;
		statsKeygroupMatch.SetNum("points", keyValue);

		if (IsClientInGame(statsAssisterClientid) && IsClientConnected(statsAssisterClientid))
		{
			if (StrEqual(gamevar, "csgo")) CS_SetClientContributionScore(statsAssisterClientid, keyValue);
			else SetEntProp(statsAssisterClientid, Prop_Data, "m_iDeaths", statsKeygroupMatch.GetNum("assists", 0));
		}
	}

	statsKeygroupRound.Rewind();
	statsKeygroupMatch.Rewind();

	if (save)
	{
		statsKeygroupRound.JumpToKey(saverSteamid, true);
		statsKeygroupMatch.JumpToKey(saverSteamid, true);

		statsKeygroupRound.SetString("name", saverName);
		statsKeygroupMatch.SetString("name", saverName);

		keyValue = statsKeygroupRound.GetNum("saves", 0);
		statsKeygroupRound.SetNum("saves", keyValue + 1);

		keyValue = statsKeygroupMatch.GetNum("saves", 0);
		statsKeygroupMatch.SetNum("saves", keyValue + 1);

		keyValue = statsKeygroupRound.GetNum("points", 0);
		keyValue += rankingPointsForSave;
		statsKeygroupRound.SetNum("points", keyValue);

		keyValue = statsKeygroupMatch.GetNum("points", 0);
		keyValue += rankingPointsForSave;
		statsKeygroupMatch.SetNum("points", keyValue);

		if (IsClientInGame(saverClientid) && IsClientConnected(saverClientid))
		{
			if (StrEqual(gamevar, "csgo")) CS_SetClientContributionScore(saverClientid, keyValue);
			else SetEntProp(saverClientid, Prop_Data, "m_iDeaths", statsKeygroupMatch.GetNum("assists", 0));
		}
	}

	statsKeygroupRound.Rewind();
	statsKeygroupMatch.Rewind();
	
	statsLastHitId = client;

	// keygroupRound.ExportToFile(statsKeygroupRound);
	// keygroupMatch.ExportToFile(statsKeygroupMatch);
	
	// keygroupRound.Close();
	// keygroupMatch.Close();

	//SetPlayerStats(timer, client);
}


// ************************************************************************************************************
// ************************************************** EVENTS **************************************************
// ************************************************************************************************************
public void StatsOnPluginStart()
{
	//BuildPath(Path_SM, statsKeygroupGoalkeeperAreas, sizeof(statsKeygroupGoalkeeperAreas), "data/soccer_mod_gk_areas.txt");
	// BuildPath(Path_SM, statsKeygroupMatch, sizeof(statsKeygroupMatch), "data/soccer_mod_match_stats.txt");
	// BuildPath(Path_SM, statsKeygroupRound, sizeof(statsKeygroupRound), "data/soccer_mod_round_stats.txt");

	statsKeygroupMatch = new KeyValues("matchStatistics");
	statsKeygroupRound = new KeyValues("roundStatistics");
}

public void StatsOnMapStart()
{
	ResetMatchStats();
	ResetRoundStats();
}

public void StatsEventPlayerSpawn(Event event)
{
	int userid = event.GetInt("userid");
	int client = GetClientOfUserId(userid);

	CreateTimer(0.01, SetPlayerStats, client);
}

public void StatsEventRoundStart(Event event)
{
	ResetRoundStats();

	kvGKArea = new KeyValues("gk_areas");
	kvGKArea.ImportFromFile(statsKeygroupGoalkeeperAreas);

	char mapName[128];
	GetCurrentMap(mapName, sizeof(mapName));

	char bits[3][64];
	ExplodeString(mapName, "/", bits, sizeof(bits), sizeof(bits[]));
	if (bits[2][0]) kvGKArea.JumpToKey(bits[2], false);
	else kvGKArea.JumpToKey(bits[0], false);

	statsCTGKAreaMinX = kvGKArea.GetFloat("ct_min_x", 0.0);
	statsCTGKAreaMinY = kvGKArea.GetFloat("ct_min_y", 0.0);
	statsCTGKAreaMinZ = kvGKArea.GetFloat("ct_min_z", 0.0);
	statsCTGKAreaMaxX = kvGKArea.GetFloat("ct_max_x", 0.0);
	statsCTGKAreaMaxY = kvGKArea.GetFloat("ct_max_y", 0.0);
	statsCTGKAreaMaxZ = kvGKArea.GetFloat("ct_max_z", 0.0);
	if (debuggingEnabled == 1) CPrintToChatAll("{%s}[%s] {%s}CT GK Area: %.1f, %.1f, %.1f, %.1f, %.1f, %.1f", prefixcolor, prefix, textcolor, statsCTGKAreaMinX, statsCTGKAreaMinY, statsCTGKAreaMinZ, 
		statsCTGKAreaMaxX, statsCTGKAreaMaxY, statsCTGKAreaMaxZ);

	statsTGKAreaMinX = kvGKArea.GetFloat("t_min_x", 0.0);
	statsTGKAreaMinY = kvGKArea.GetFloat("t_min_y", 0.0);
	statsTGKAreaMinZ = kvGKArea.GetFloat("t_min_z", 0.0);
	statsTGKAreaMaxX = kvGKArea.GetFloat("t_max_x", 0.0);
	statsTGKAreaMaxY = kvGKArea.GetFloat("t_max_y", 0.0);
	statsTGKAreaMaxZ = kvGKArea.GetFloat("t_max_z", 0.0);
	if (debuggingEnabled == 1) CPrintToChatAll("{%s}[%s] {%s}T GK Area: %.1f, %.1f, %.1f, %.1f, %.1f, %.1f", prefixcolor, prefix, textcolor, statsTGKAreaMinX, statsTGKAreaMinY, statsTGKAreaMinZ, 
		statsTGKAreaMaxX, statsTGKAreaMaxY, statsTGKAreaMaxZ);

	kvGKArea.Close();

	/*if (statsCTGKAreaMinX != 0 && statsCTGKAreaMinY != 0 && statsCTGKAreaMinZ != 0 && statsCTGKAreaMaxX != 0 && statsCTGKAreaMaxY != 0 && statsCTGKAreaMaxZ != 0 && 
		statsTGKAreaMinX != 0 && statsTGKAreaMinY != 0 && statsTGKAreaMinZ != 0 && statsTGKAreaMaxX != 0 && statsTGKAreaMaxY != 0 && statsTGKAreaMaxZ != 0)
	{
		DrawLaser("gk_area_beam", statsCTGKAreaMinX, statsCTGKAreaMinY, statsCTGKAreaMinZ, statsCTGKAreaMaxX, statsCTGKAreaMinY, statsCTGKAreaMinZ, "0 0 255");
		DrawLaser("gk_area_beam", statsCTGKAreaMaxX, statsCTGKAreaMinY, statsCTGKAreaMinZ, statsCTGKAreaMaxX, statsCTGKAreaMaxY, statsCTGKAreaMinZ, "0 0 255");
		DrawLaser("gk_area_beam", statsCTGKAreaMaxX, statsCTGKAreaMaxY, statsCTGKAreaMinZ, statsCTGKAreaMinX, statsCTGKAreaMaxY, statsCTGKAreaMinZ, "0 0 255");
		DrawLaser("gk_area_beam", statsCTGKAreaMinX, statsCTGKAreaMaxY, statsCTGKAreaMinZ, statsCTGKAreaMinX, statsCTGKAreaMinY, statsCTGKAreaMinZ, "0 0 255");
		DrawLaser("gk_area_beam", statsCTGKAreaMinX, statsCTGKAreaMinY, statsCTGKAreaMaxZ, statsCTGKAreaMaxX, statsCTGKAreaMinY, statsCTGKAreaMaxZ, "0 0 255");
		DrawLaser("gk_area_beam", statsCTGKAreaMaxX, statsCTGKAreaMinY, statsCTGKAreaMaxZ, statsCTGKAreaMaxX, statsCTGKAreaMaxY, statsCTGKAreaMaxZ, "0 0 255");
		DrawLaser("gk_area_beam", statsCTGKAreaMaxX, statsCTGKAreaMaxY, statsCTGKAreaMaxZ, statsCTGKAreaMinX, statsCTGKAreaMaxY, statsCTGKAreaMaxZ, "0 0 255");
		DrawLaser("gk_area_beam", statsCTGKAreaMinX, statsCTGKAreaMaxY, statsCTGKAreaMaxZ, statsCTGKAreaMinX, statsCTGKAreaMinY, statsCTGKAreaMaxZ, "0 0 255");
		DrawLaser("gk_area_beam", statsCTGKAreaMinX, statsCTGKAreaMinY, statsCTGKAreaMinZ, statsCTGKAreaMinX, statsCTGKAreaMinY, statsCTGKAreaMaxZ, "0 0 255");
		DrawLaser("gk_area_beam", statsCTGKAreaMaxX, statsCTGKAreaMinY, statsCTGKAreaMinZ, statsCTGKAreaMaxX, statsCTGKAreaMinY, statsCTGKAreaMaxZ, "0 0 255");
		DrawLaser("gk_area_beam", statsCTGKAreaMinX, statsCTGKAreaMaxY, statsCTGKAreaMinZ, statsCTGKAreaMinX, statsCTGKAreaMaxY, statsCTGKAreaMaxZ, "0 0 255");
		DrawLaser("gk_area_beam", statsCTGKAreaMaxX, statsCTGKAreaMaxY, statsCTGKAreaMinZ, statsCTGKAreaMaxX, statsCTGKAreaMaxY, statsCTGKAreaMaxZ, "0 0 255");

		DrawLaser("gk_area_beam", statsTGKAreaMinX, statsTGKAreaMinY, statsTGKAreaMinZ, statsTGKAreaMaxX, statsTGKAreaMinY, statsTGKAreaMinZ, "255 0 0");
		DrawLaser("gk_area_beam", statsTGKAreaMaxX, statsTGKAreaMinY, statsTGKAreaMinZ, statsTGKAreaMaxX, statsTGKAreaMaxY, statsTGKAreaMinZ, "255 0 0");
		DrawLaser("gk_area_beam", statsTGKAreaMaxX, statsTGKAreaMaxY, statsTGKAreaMinZ, statsTGKAreaMinX, statsTGKAreaMaxY, statsTGKAreaMinZ, "255 0 0");
		DrawLaser("gk_area_beam", statsTGKAreaMinX, statsTGKAreaMaxY, statsTGKAreaMinZ, statsTGKAreaMinX, statsTGKAreaMinY, statsTGKAreaMinZ, "255 0 0");
		DrawLaser("gk_area_beam", statsTGKAreaMinX, statsTGKAreaMinY, statsTGKAreaMaxZ, statsTGKAreaMaxX, statsTGKAreaMinY, statsTGKAreaMaxZ, "255 0 0");
		DrawLaser("gk_area_beam", statsTGKAreaMaxX, statsTGKAreaMinY, statsTGKAreaMaxZ, statsTGKAreaMaxX, statsTGKAreaMaxY, statsTGKAreaMaxZ, "255 0 0");
		DrawLaser("gk_area_beam", statsTGKAreaMaxX, statsTGKAreaMaxY, statsTGKAreaMaxZ, statsTGKAreaMinX, statsTGKAreaMaxY, statsTGKAreaMaxZ, "255 0 0");
		DrawLaser("gk_area_beam", statsTGKAreaMinX, statsTGKAreaMaxY, statsTGKAreaMaxZ, statsTGKAreaMinX, statsTGKAreaMinY, statsTGKAreaMaxZ, "255 0 0");
		DrawLaser("gk_area_beam", statsTGKAreaMinX, statsTGKAreaMinY, statsTGKAreaMinZ, statsTGKAreaMinX, statsTGKAreaMinY, statsTGKAreaMaxZ, "255 0 0");
		DrawLaser("gk_area_beam", statsTGKAreaMaxX, statsTGKAreaMinY, statsTGKAreaMinZ, statsTGKAreaMaxX, statsTGKAreaMinY, statsTGKAreaMaxZ, "255 0 0");
		DrawLaser("gk_area_beam", statsTGKAreaMinX, statsTGKAreaMaxY, statsTGKAreaMinZ, statsTGKAreaMinX, statsTGKAreaMaxY, statsTGKAreaMaxZ, "255 0 0");
		DrawLaser("gk_area_beam", statsTGKAreaMaxX, statsTGKAreaMaxY, statsTGKAreaMinZ, statsTGKAreaMaxX, statsTGKAreaMaxY, statsTGKAreaMaxZ, "255 0 0");
	}*/
}

public void StatsEventRoundEnd(Event event)
{
	int winner = event.GetInt("winner");
	// Handle keygroup;
	// char queryString[1024];
	
	if (winner > 1)
	{
		if (statsScorerClientid)
		{
			float possession = GetGameTime() - statsScorerTimestamp;
			AddPlayerStatPossession(statsScorerSteamid, possession, statsScorerTeam);
			if (debuggingEnabled == 1) CPrintToChatAll("{%s}[%s] {%s}%s had the ball for %f", prefixcolor, prefix, textcolor, statsScorerName, possession);

			if (statsScorerTeam == winner)
			{
				if (statsScorerTeam == CS_TEAM_T) statsGoalsT++;
				else if (statsScorerTeam == CS_TEAM_CT) statsGoalsCT++;

				if (statsScorerTeam == CS_TEAM_T)
				{
					statsRoundsLostCT++;
					statsRoundsWonT++;
				}
				else if (statsScorerTeam == CS_TEAM_CT)
				{
					statsRoundsLostT++;
					statsRoundsWonCT++;
				}

				AddPlayerStatInt(statsScorerName, statsScorerSteamid, "goals", rankingPointsForGoal);

				// Format(queryString, sizeof(queryString), "UPDATE %s SET goals = (goals + 1), points = (points + %i) WHERE steamid = '%s'", 
				//  table, rankingPointsForGoal, statsScorerSteamid);
				// ExecuteQuery(queryString);

				for (int client = 1; client <= MaxClients; client++)
				{
					char timeString[16];
					getTimeString(timeString, matchTime);
					
					if (IsClientInGame(client) && IsClientConnected(client))
					{
						if (matchStarted) CPrintToChat(client, "{%s}[%s] {%s}Goal scored by %s at {%s}%s", prefixcolor, prefix, textcolor, statsScorerName, prefixcolor, timeString);
						else CPrintToChat(client, "{%s}[%s] {%s}Goal scored by %s", prefixcolor, prefix, textcolor, statsScorerName);
					}
				}

				if (statsAssisterClientid > 0 && statsAssisterTeam == winner)
				{
					if (statsAssisterTeam == CS_TEAM_T) statsAssistsT++;
					else if (statsAssisterTeam == CS_TEAM_CT) statsAssistsCT++;

					AddPlayerStatInt(statsAssisterName, statsAssisterSteamid, "assists", rankingPointsForAssist);

					// Format(queryString, sizeof(queryString), "UPDATE %s SET assists = (assists + 1), points = (points + %i) WHERE steamid = '%s'", 
					//  table, rankingPointsForAssist, statsAssisterSteamid);
					// ExecuteQuery(queryString);

					for (int client = 1; client <= MaxClients; client++)
					{
						if (IsClientInGame(client) && IsClientConnected(client)) CPrintToChat(client, "{%s}[%s] {%s}Assist given by %s", prefixcolor, prefix, textcolor, statsAssisterName);
					}

					if (matchStarted)
					{
						char timeString[16];
						getTimeString(timeString, matchTime);
						LogMessage("%s | %i - %i | Goal: %s <%s>, Assist: %s <%s>", timeString, matchScoreCT, matchScoreT, 
							statsScorerName, statsScorerSteamid, statsAssisterName, statsAssisterSteamid);
					}
					else LogMessage("%i - %i | Goal: %s <%s>, Assist: %s <%s>", matchScoreCT, matchScoreT, statsScorerName, 
						statsScorerSteamid, statsAssisterName, statsAssisterSteamid);
				}
				else
				{
					if (matchStarted)
					{
						char timeString[16];
						getTimeString(timeString, matchTime);
						LogMessage("%s | %i - %i | Goal: %s <%s>", timeString, matchScoreCT, matchScoreT, statsScorerName, statsScorerSteamid);
					}
					else LogMessage("%i - %i | Goal: %s <%s>", matchScoreCT, matchScoreT, statsScorerName, statsScorerSteamid);
				}
			}
			else
			{
				if (statsScorerTeam == CS_TEAM_T) statsOwnGoalsT++;
				else if (statsScorerTeam == CS_TEAM_CT) statsOwnGoalsCT++;

				if (statsScorerTeam == CS_TEAM_T)
				{
					statsRoundsLostT++;
					statsRoundsWonCT++;
				}
				else if (statsScorerTeam == CS_TEAM_CT)
				{
					statsRoundsLostCT++;
					statsRoundsWonT++;
				}

				AddPlayerStatInt(statsScorerName, statsScorerSteamid, "own_goals", rankingPointsForOwnGoal);

				// Format(queryString, sizeof(queryString), "UPDATE %s SET own_goals = (own_goals + 1), points = (points + %i) WHERE steamid = '%s'", 
				//  table, rankingPointsForOwnGoal, statsScorerSteamid);
				// ExecuteQuery(queryString);
				
				statsAssisterName = "Owngoal";
				
				for (int client = 1; client <= MaxClients; client++)
				{
					char timeString[16];
					getTimeString(timeString, matchTime);
					
					if (IsClientInGame(client) && IsClientConnected(client))
					{
						if (matchStarted) CPrintToChat(client, "{%s}[%s] {%s}Own goal scored by %s at {%s}%s", prefixcolor, prefix, textcolor, statsScorerName, prefixcolor, timeString);
						else CPrintToChat(client, "{%s}[%s] {%s}Own goal scored by %s", prefixcolor, prefix, textcolor, statsScorerName);
					}
				}

				if (matchStarted)
				{
					char timeString[16];
					getTimeString(timeString, matchTime);
					LogMessage("%s | %i - %i | Own goal: %s <%s>", timeString, matchScoreCT, matchScoreT, statsScorerName, statsScorerSteamid);
				}
				else LogMessage("%i - %i | Own goal: %s <%s>", matchScoreCT, matchScoreT, statsScorerName, statsScorerSteamid);
			}

			// keygroup = new KeyValues("matchStatistics");
			// keygroup.ImportFromFile(statsKeygroupMatch);

			for (int client = 1; client <= MaxClients; client++)
			{
				if (IsClientInGame(client) && IsClientConnected(client))
				{
					int team = GetClientTeam(client);
					if (team > 1)
					{
						char steamid[32], name[MAX_NAME_LENGTH];
						GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
						GetClientName(client, name, sizeof(name));

						//statsKeygroupMatch.JumpToKey(steamid, true);

						if (team == winner)
						{
							AddPlayerStatInt(name, steamid, "rounds_won", rankingPointsForRoundWon);
						
							/*int keyValue = statsKeygroupMatch.GetNum("rounds_won", 0);
							statsKeygroupMatch.SetNum("rounds_won", keyValue + 1);
							keyValue = statsKeygroupMatch.GetNum("points", 0);
							statsKeygroupMatch.SetNum("points", keyValue + rankingPointsForRoundWon);*/
							
							// Format(queryString, sizeof(queryString), "UPDATE %s SET rounds_won = (rounds_won + 1), points = (points + %i) WHERE steamid = '%s'", 
							//  table, rankingPointsForRoundWon, steamid);
							// ExecuteQuery(queryString);
						}
						else
						{
							AddPlayerStatInt(name, steamid, "rounds_lost", rankingPointsForRoundLost);
						
							/*int keyValue = statsKeygroupMatch.GetNum("rounds_lost", 0);
							statsKeygroupMatch.SetNum("rounds_lost", keyValue + 1);
							keyValue = statsKeygroupMatch.GetNum("points", 0);
							statsKeygroupMatch.SetNum("points", keyValue + rankingPointsForRoundLost);*/

							// Format(queryString, sizeof(queryString), "UPDATE %s SET rounds_lost = (rounds_lost + 1), points = (points + %i) WHERE steamid = '%s'", 
							//  table, rankingPointsForRoundLost, steamid);
							// ExecuteQuery(queryString);
						}
						
						statsKeygroupMatch.JumpToKey(steamid, true);
						
						int matchtemp = statsKeygroupMatch.GetNum("matches", 0);
						if(matchtemp == 0) statsKeygroupMatch.SetNum("matches", 1);
						
						statsKeygroupMatch.Rewind();
						
					}
				}
			}

			//statsKeygroupMatch.Rewind();
			// keygroup.ExportToFile(statsKeygroupMatch);
			// keygroup.Close();

			for (int client = 1; client <= MaxClients; client++)
			{
				if (IsClientInGame(client) && IsClientConnected(client))
				{
					CreateTimer(0.01, SetPlayerStats, client);
				}
			}

			if (matchlog == 1 && matchStarted)	KVSaveEvent(statsScorerSteamid, statsScorerName, statsAssisterSteamid, statsAssisterName, statsScorerClientid, statsAssisterClientid);
			
			if(MVPEnabled == 1) ShowMVP();

			if (matchStoppageTimeStarted) EndStoppageTime();
		}
	}

	char queryString[1024];
	char table[32] = "soccer_mod_public_stats";
	if (matchStarted) table = "soccer_mod_match_stats";

	//statsKeygroupRound = new KeyValues("roundStatistics");
	//statsKeygroupRound.ExportToFile("cfg/sm_soccermod/temp.txt");
	statsKeygroupRound.GotoFirstSubKey();

	do
	{
		int goals = statsKeygroupRound.GetNum("goals", 0);
		int assists = statsKeygroupRound.GetNum("assists", 0);
		int own_goals = statsKeygroupRound.GetNum("own_goals", 0);
		int rounds_won = statsKeygroupRound.GetNum("rounds_won", 0);
		int rounds_lost = statsKeygroupRound.GetNum("rounds_lost", 0);
		int hits = statsKeygroupRound.GetNum("hits", 0);
		int saves = statsKeygroupRound.GetNum("saves", 0);
		int passes = statsKeygroupRound.GetNum("passes", 0);
		int interceptions = statsKeygroupRound.GetNum("interceptions", 0);
		int ball_losses = statsKeygroupRound.GetNum("ball_losses", 0);
		int points = statsKeygroupRound.GetNum("points", 0);

		// char clanTag[64];
		// CS_GetClientClanTag(client, clanTag, sizeof(clanTag));

		char steamid[32];
		statsKeygroupRound.GetSectionName(steamid, sizeof(steamid));

		if (EnoughPlayers())
		{
			Format(queryString, sizeof(queryString), "UPDATE %s SET goals = (goals + %i), assists = (assists + %i), own_goals = (own_goals + %i), rounds_won = (rounds_won + %i), \
				rounds_lost = (rounds_lost + %i), hits = (hits + %i), saves = (saves + %i), passes = (passes + %i), interceptions = (interceptions + %i), ball_losses = (ball_losses + %i), \
				points = (points + %i) WHERE steamid = '%s'", table, goals, assists, own_goals, rounds_won, rounds_lost, hits, saves, passes, interceptions, ball_losses, points, steamid);
			ExecuteQuery(queryString);
		}
	}
	while (statsKeygroupRound.GotoNextKey());

	statsKeygroupRound.Rewind();
	//statsKeygroupRound.Close();
}

public void StatsEventCSWinPanelMatch(Event event)
{
	ShowManOfTheMatch();
}

// *********************************************************************************************************************
// ************************************************** STATISTICS MENU **************************************************
// *********************************************************************************************************************
public void OpenStatisticsMenu(int client)
{
	Menu menu = new Menu(StatisticsMenuHandler);

	menu.SetTitle("Statistics");

	menu.AddItem("team_ct", "Team CT");

	menu.AddItem("team_t", "Team T");

	menu.AddItem("player", "Player");

	menu.AddItem("round", "Current Round");

	menu.AddItem("map", "Current Match");
	
	menu.AddItem("chat", "Chat Info");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int StatisticsMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		//char langString[64], langString1[64], langString2[64];
		//Format(langString1, sizeof(langString1), "Statistics", client);

		if (StrEqual(menuItem, "team_ct"))
		{
			//Format(langString, sizeof(langString), "Soccer Mod - %s - %s", langString1, langString2);
			OpenTeamStatisticsMenu(client, "Team CT", statsGoalsCT, statsAssistsCT, 
				statsOwnGoalsCT, statsPossessionCT, statsSavesCT, statsPassesCT, statsRoundsWonCT, statsRoundsLostCT, statsInterceptionsCT, statsBallLossesCT, statsHitsCT);
		}
		else if (StrEqual(menuItem, "team_t"))
		{
			//Format(langString, sizeof(langString), "Soccer Mod - %s - %s", langString1, langString2);
			OpenTeamStatisticsMenu(client, "Team T", statsGoalsT, statsAssistsT, 
				statsOwnGoalsT, statsPossessionT, statsSavesT, statsPassesT, statsRoundsWonT, statsRoundsLostT, statsInterceptionsT, statsBallLossesT, statsHitsT);
		}
		else if (StrEqual(menuItem, "player"))			  OpenSelectPlayerStatisticsMenu(client);
		else if (StrEqual(menuItem, "round"))			   OpenRoundStatisticsMenu(client);
		else if (StrEqual(menuItem, "map"))				 OpenMapStatisticsMenu(client);
		else if (StrEqual(menuItem, "chat"))			 OpenChatSettingsMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSoccer(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// **************************************************************************************************************************
// ************************************************** TEAM STATISTICS MENU **************************************************
// **************************************************************************************************************************
public void OpenChatSettingsMenu(int client)
{
	Menu menu = new Menu(ChatSettingsMenuHandler);
	menu.SetTitle("Statistics - Chat Settings");

	char ExtendedChatString[32], ModeString[32], PassString[32], SaveString[32], LossString[32];//, PossString[32];
	if(extChatSet[client] == 0)					ExtendedChatString = "Chat Info: OFF";
	else if (extChatSet[client] == 1)			ExtendedChatString = "Chat Info: ON";
	
	if(extChatMode[client] == 0)				ModeString = "Mode: CHAT";
	else if (extChatMode[client] == 1)			ModeString = "Mode: HUD";
	
	if(extChatPass[client] == 0)				PassString = "Passes: OFF";
	else if (extChatPass[client] == 1)			PassString = "Passes: ON";
	
	if(extChatSave[client] == 0)				SaveString = "Saves: OFF";
	else if (extChatSave[client] == 1)			SaveString = "Saves: ON";
	
	if(extChatLoss[client] == 0)				LossString = "Losses: OFF";
	else if (extChatLoss[client] == 1)			LossString = "Losses: ON";
	
	//if(extChatPoss[client] == 0)				PossString = "Possession: OFF";
	//else if (extChatPoss[client] == 1)			PossString = "Possession: ON";
	
	menu.AddItem("toggle", ExtendedChatString);
	menu.AddItem("mode", ModeString);
	menu.AddItem("passes", PassString);
	menu.AddItem("saves", SaveString);
	menu.AddItem("losses", LossString);
	//menu.AddItem("possession", PossString);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int ChatSettingsMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		if (StrEqual(menuItem, "toggle"))	
		{
			if(extChatSet[client] == 0)		extChatSet[client] = 1;
			else							extChatSet[client] = 0;
		}
		else if (StrEqual(menuItem, "mode"))	
		{
			if(extChatMode[client] == 0)	extChatMode[client] = 1;
			else							extChatMode[client] = 0;
		}
		else if (StrEqual(menuItem, "passes"))	
		{
			if(extChatPass[client] == 0)	extChatPass[client] = 1;
			else							extChatPass[client] = 0;
		}
		else if (StrEqual(menuItem, "saves"))	
		{
			if(extChatSave[client] == 0)	extChatSave[client] = 1;
			else							extChatSave[client] = 0;
		}
		else if (StrEqual(menuItem, "losses"))	
		{
			if(extChatLoss[client] == 0)	extChatLoss[client] = 1;
			else							extChatLoss[client] = 0;
		}
		/*else if (StrEqual(menuItem, "possession"))	
		{
			if(extChatPoss[client] == 0)	extChatPoss[client] = 1;
			else							extChatPoss[client] = 0;
		}*/
		OpenChatSettingsMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenStatisticsMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}


// **************************************************************************************************************************
// ************************************************** TEAM STATISTICS MENU **************************************************
// **************************************************************************************************************************
public void OpenTeamStatisticsMenu
(
	int client, char title[64], int goals, int assists, int ownGoals, float possession, int saves,
	int passes, int roundsWon, int roundsLost, int interceptions, int ballLosses, int hits
)
{
	Menu menu = new Menu(TeamStatisticsMenuHandler);
	menu.SetTitle(title);

	char menuString[32];
	AddStatisticsMenuItem(client, menu, menuString, "Goals",			goals,		  "goals");
	AddStatisticsMenuItem(client, menu, menuString, "Assists",		  assists,		"assists");
	AddStatisticsMenuItem(client, menu, menuString, "Own goals",		ownGoals,	   "own_goals");


	if (statsPossessionTotal > 0)
	{
		int value = RoundToNearest(possession / statsPossessionTotal * 100);
		Format(menuString, sizeof(menuString), "%s: %i%", "Possession", value);
		menu.AddItem("possession", menuString, ITEMDRAW_DISABLED);
	}
	else
	{
		Format(menuString, sizeof(menuString), "%s: 0%", "Possession");
		menu.AddItem("possession", menuString, ITEMDRAW_DISABLED);
	}

	AddStatisticsMenuItem(client, menu, menuString, "Saves",			saves,		  "saves");
	AddStatisticsMenuItem(client, menu, menuString, "Passes",		   passes,		 "passes");
	AddStatisticsMenuItem(client, menu, menuString, "Rounds won",	   roundsWon,	  "rounds_won");
	AddStatisticsMenuItem(client, menu, menuString, "Rounds lost",	  roundsLost,	 "rounds_lost");
	AddStatisticsMenuItem(client, menu, menuString, "Interceptions",	interceptions,  "interceptions");
	AddStatisticsMenuItem(client, menu, menuString, "Ball losses",	  ballLosses,	 "ball_losses");
	AddStatisticsMenuItem(client, menu, menuString, "Hits",			 hits,		   "hits");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int TeamStatisticsMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)						OpenStatisticsMenu(client);
	else if (action == MenuAction_Cancel && choice == -6)   OpenStatisticsMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ****************************************************************************************************************************
// ************************************************** PLAYER STATISTICS MENU **************************************************
// ****************************************************************************************************************************
public void OpenSelectPlayerStatisticsMenu(int client)
{
	Menu menu = new Menu(MenuHandlerSelectPlayerStatistics);

	menu.SetTitle("Soccer Mod - Statistics - Player");

	for (int player = 1; player <= MaxClients; player++)
	{
		if (IsClientInGame(player) && IsClientConnected(player))
		{
			char playerid[8];
			IntToString(player, playerid, sizeof(playerid));

			char playerName[MAX_NAME_LENGTH];
			GetClientName(player, playerName, sizeof(playerName));

			menu.AddItem(playerid, playerName);
		}
	}

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerSelectPlayerStatistics(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[8];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		int target = StringToInt(menuItem);

		if (IsClientInGame(target) && IsClientConnected(target)) OpenPlayerStatisticsMenu(client, target);
		else
		{
			CPrintToChat(client, "{%s}[%s] {%s}Player is no longer on the server", prefixcolor, prefix, textcolor);
			OpenStatisticsMenu(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenStatisticsMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenPlayerStatisticsMenu(int client, int target)
{
	Menu menu = new Menu(MenuHandlerPlayerStatistics);

	menu.SetTitle("Soccer Mod - Statistics - Player");

	char steamid[32];
	GetClientAuthId(target, AuthId_Engine, steamid, sizeof(steamid));

	// Handle keygroup = new KeyValues("matchStatistics");
	// keygroup.ImportFromFile(statsKeygroupMatch);

	statsKeygroupMatch.JumpToKey(steamid, true);

	char playerName[MAX_NAME_LENGTH];
	GetClientName(target, playerName, sizeof(playerName));

	char menuString[32];
	Format(menuString, sizeof(menuString), "%s: %s", "Name", playerName);
	menu.AddItem("name", menuString, ITEMDRAW_DISABLED);

	AddStatisticsMenuItem(client, menu, menuString, "Points",		   statsKeygroupMatch.GetNum("points", 0),		  "points");
	AddStatisticsMenuItem(client, menu, menuString, "Goals",			statsKeygroupMatch.GetNum("goals", 0),		   "goals");
	AddStatisticsMenuItem(client, menu, menuString, "Assists",		  statsKeygroupMatch.GetNum("assists", 0),		 "assists");
	AddStatisticsMenuItem(client, menu, menuString, "Own goals",		statsKeygroupMatch.GetNum("own_goals", 0),	   "own_goals");

	if (statsPossessionTotal > 0)
	{
		int value = RoundToNearest(statsKeygroupMatch.GetFloat("possession", 0.0) / statsPossessionTotal * 100);
		Format(menuString, sizeof(menuString), "%s: %i%", "Possession", value);
		menu.AddItem("possession", menuString, ITEMDRAW_DISABLED);
	}
	else
	{
		Format(menuString, sizeof(menuString), "%s: 0%", "Possession");
		menu.AddItem("possession", menuString, ITEMDRAW_DISABLED);
	}

	AddStatisticsMenuItem(client, menu, menuString, "Saves",			statsKeygroupMatch.GetNum("saves", 0),		   "saves");
	AddStatisticsMenuItem(client, menu, menuString, "Passes",		   statsKeygroupMatch.GetNum("passes", 0),		  "passes");
	AddStatisticsMenuItem(client, menu, menuString, "Rounds won",	   statsKeygroupMatch.GetNum("rounds_won", 0),	  "rounds_won");
	AddStatisticsMenuItem(client, menu, menuString, "Rounds lost",	  statsKeygroupMatch.GetNum("rounds_lost", 0),	 "rounds_lost");
	AddStatisticsMenuItem(client, menu, menuString, "Interceptions",	statsKeygroupMatch.GetNum("interceptions", 0),   "interceptions");
	AddStatisticsMenuItem(client, menu, menuString, "Ball losses",	  statsKeygroupMatch.GetNum("ball_losses", 0),	 "ball_losses");
	AddStatisticsMenuItem(client, menu, menuString, "Hits",			 statsKeygroupMatch.GetNum("hits", 0),			"hits");

	statsKeygroupMatch.Rewind();
	// keygroup.Close();

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerPlayerStatistics(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)						OpenStatisticsMenu(client);
	else if (action == MenuAction_Cancel && choice == -6)   OpenStatisticsMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ***************************************************************************************************************************
// ************************************************** ROUND STATISTICS MENU **************************************************
// ***************************************************************************************************************************
public void OpenRoundStatisticsMenu(int client)
{
	Menu menu = new Menu(RoundStatisticsMenuHandler);

	menu.SetTitle("Soccer Mod - Statistics - Current Round");

	char steamid[32];
	GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

	// KeyValues keygroup = new KeyValues("roundStatistics");
	// keygroup.ExportToFile(statsKeygroupRound);

	statsKeygroupRound.JumpToKey(steamid, true);

	char menuString[32];
	AddStatisticsMenuItem(client, menu, menuString, "Points",		   statsKeygroupRound.GetNum("points", 0),		  "points");
	AddStatisticsMenuItem(client, menu, menuString, "Goals",			statsKeygroupRound.GetNum("goals", 0),		   "goals");
	AddStatisticsMenuItem(client, menu, menuString, "Assists",		  statsKeygroupRound.GetNum("assists", 0),		 "assists");
	AddStatisticsMenuItem(client, menu, menuString, "Own goals",		statsKeygroupRound.GetNum("own_goals", 0),	   "own_goals");
	AddStatisticsMenuItem(client, menu, menuString, "Saves",			statsKeygroupRound.GetNum("saves", 0),		   "saves");
	AddStatisticsMenuItem(client, menu, menuString, "Passes",		   statsKeygroupRound.GetNum("passes", 0),		  "passes");
	AddStatisticsMenuItem(client, menu, menuString, "Interceptions",	statsKeygroupRound.GetNum("interceptions", 0),   "interceptions");
	AddStatisticsMenuItem(client, menu, menuString, "Ball losses",	  statsKeygroupRound.GetNum("ball_losses", 0),	 "ball_losses");
	AddStatisticsMenuItem(client, menu, menuString, "Hits",			 statsKeygroupRound.GetNum("hits", 0),			"hits");

	statsKeygroupRound.Rewind();
	// keygroup.Close();

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int RoundStatisticsMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)						OpenRoundStatisticsMenu(client);
	else if (action == MenuAction_Cancel && choice == -6)   OpenStatisticsMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *************************************************************************************************************************
// ************************************************** MAP STATISTICS MENU **************************************************
// *************************************************************************************************************************
public void OpenMapStatisticsMenu(int client)
{
	Menu menu = new Menu(MapStatisticsMenuHandler);

	menu.SetTitle("Soccer Mod - Statistics - Current Match");

	char steamid[32];
	GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

	// Handle keygroup = new KeyValues("matchStatistics");
	// keygroup.ImportFromFile(statsKeygroupMatch);

	statsKeygroupMatch.JumpToKey(steamid, true);

	char menuString[32];
	AddStatisticsMenuItem(client, menu, menuString, "Points",		   statsKeygroupMatch.GetNum("points", 0),		  "points");
	AddStatisticsMenuItem(client, menu, menuString, "Goals",			statsKeygroupMatch.GetNum("goals", 0),		   "goals");
	AddStatisticsMenuItem(client, menu, menuString, "Assists",		  statsKeygroupMatch.GetNum("assists", 0),		 "assists");
	AddStatisticsMenuItem(client, menu, menuString, "Own goals",		statsKeygroupMatch.GetNum("own_goals", 0),	   "own_goals");


	if (statsPossessionTotal > 0)
	{
		int value = RoundToNearest(statsKeygroupMatch.GetFloat("possession", 0.0) / statsPossessionTotal * 100);
		Format(menuString, sizeof(menuString), "%s: %i%", "Possession", value);
		menu.AddItem("possession", menuString, ITEMDRAW_DISABLED);
	}
	else
	{
		Format(menuString, sizeof(menuString), "%s: 0%", "Possession");
		menu.AddItem("possession", menuString, ITEMDRAW_DISABLED);
	}

	AddStatisticsMenuItem(client, menu, menuString, "Saves",			statsKeygroupMatch.GetNum("saves", 0),		   "saves");
	AddStatisticsMenuItem(client, menu, menuString, "Passes",		   statsKeygroupMatch.GetNum("passes", 0),		  "passes");
	AddStatisticsMenuItem(client, menu, menuString, "Rounds won",	   statsKeygroupMatch.GetNum("rounds_won", 0),	  "rounds_won");
	AddStatisticsMenuItem(client, menu, menuString, "Rounds lost",	  statsKeygroupMatch.GetNum("rounds_lost", 0),	 "rounds_lost");
	AddStatisticsMenuItem(client, menu, menuString, "Interceptions",	statsKeygroupMatch.GetNum("interceptions", 0),   "interceptions");
	AddStatisticsMenuItem(client, menu, menuString, "Ball losses",	  statsKeygroupMatch.GetNum("ball_losses", 0),	 "ball_losses");
	AddStatisticsMenuItem(client, menu, menuString, "Hits",			 statsKeygroupMatch.GetNum("hits", 0),			"hits");

	statsKeygroupMatch.Rewind();
	// keygroup.Close();

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MapStatisticsMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)						OpenMapStatisticsMenu(client);
	else if (action == MenuAction_Cancel && choice == -6)   OpenStatisticsMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ************************************************************************************************************
// ************************************************** TIMERS **************************************************
// ************************************************************************************************************
public Action SetPlayerStats(Handle timer, any client)
{
	if (IsClientInGame(client) && IsClientConnected(client))
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

		// Handle keygroup = new KeyValues("matchStatistics");
		// keygroup.ImportFromFile(statsKeygroupMatch);

		statsKeygroupMatch.JumpToKey(steamid, true);

		SetEntProp(client, Prop_Data, "m_iFrags", statsKeygroupMatch.GetNum("goals", 0));
		SetEntProp(client, Prop_Data, "m_iDeaths", statsKeygroupMatch.GetNum("assists", 0));

		if (MVPEnabled == 1) CS_SetMVPCount(client, statsKeygroupMatch.GetNum("mvpCount", 0));

		statsKeygroupMatch.Rewind();
		// keygroup.Close();
	}
}

// ***************************************************************************************************************
// ************************************************** FUNCTIONS **************************************************
// ***************************************************************************************************************
public void ResetMatchStats()
{
	statsPossessionTotal	= 0.0;
	statsPossessionCT	   = 0.0;
	statsPossessionT		= 0.0;
	statsGoalsCT			= 0;
	statsGoalsT			 = 0;
	statsAssistsCT		  = 0;
	statsAssistsT		   = 0;
	statsOwnGoalsCT		 = 0;
	statsOwnGoalsT		  = 0;
	statsHitsCT			 = 0;
	statsHitsT			  = 0;
	statsPassesCT		   = 0;
	statsPassesT			= 0;
	statsInterceptionsCT	= 0;
	statsInterceptionsT	 = 0;
	statsBallLossesCT	   = 0;
	statsBallLossesT		= 0;
	statsSavesCT			= 0;
	statsSavesT			 = 0;
	statsRoundsWonCT		= 0;
	statsRoundsWonT		 = 0;
	statsRoundsLostCT	   = 0;
	statsRoundsLostT		= 0;

	statsKeygroupMatch.Close();
	statsKeygroupMatch = new KeyValues("matchStatistics");

	statsKeygroupRound.Close();
	statsKeygroupRound = new KeyValues("roundStatistics");
}

public void ResetRoundStats()
{
	statsScorerClientid	 = 0;
	statsScorerName		 = "";
	statsScorerTeam		 = 1;
	statsScorerTimestamp	= GetGameTime();

	statsAssisterClientid   = 0;
	statsAssisterName	   = "";
	statsAssisterTeam	   = 1;
	statsAssisterTimestamp  = GetGameTime();

	statsSaver			  = 0;

	statsKeygroupRound.Close();
	statsKeygroupRound = new KeyValues("roundStatistics");
}

public void AddPlayerStatInt(char name[MAX_NAME_LENGTH], char steamid[32], char stat[16], int points)
{
	// Handle keygroup = new KeyValues("matchStatistics");
	// keygroup.ImportFromFile(statsKeygroupMatch);

	statsKeygroupMatch.JumpToKey(steamid, true);

	int keyValue = statsKeygroupMatch.GetNum(stat, 0);
	statsKeygroupMatch.SetNum(stat, keyValue + 1);

	keyValue = statsKeygroupMatch.GetNum("points", 0);
	statsKeygroupMatch.SetNum("points", keyValue + points);
	statsKeygroupMatch.SetString("name", name);

	statsKeygroupMatch.Rewind();
	// keygroup.ExportToFile(statsKeygroupMatch);
	// keygroup.Close();

	// keygroup = new KeyValues("roundStatistics");
	// keygroup.ExportToFile(statsKeygroupRound);

	statsKeygroupRound.JumpToKey(steamid, true);

	keyValue = statsKeygroupRound.GetNum(stat, 0);
	statsKeygroupRound.SetNum(stat, keyValue + 1);

	keyValue = statsKeygroupRound.GetNum("points", 0);
	statsKeygroupRound.SetNum("points", keyValue + points);
	statsKeygroupRound.SetString("name", name);

	statsKeygroupRound.Rewind();
	// keygroup.ExportToFile(statsKeygroupRound);
	// keygroup.Close();
}

public void AddPlayerStatPossession(char steamid[32], float possession, int team)
{
	if (team == CS_TEAM_T) statsPossessionT += possession;
	else if (team == CS_TEAM_CT) statsPossessionCT += possession;
	statsPossessionTotal += possession;

	// Handle keygroup = new KeyValues("matchStatistics");
	// keygroup.ImportFromFile(statsKeygroupMatch);

	statsKeygroupMatch.JumpToKey(steamid, true);

	float keyValue = statsKeygroupMatch.GetFloat("possession", 0.0);
	statsKeygroupMatch.SetFloat("possession", keyValue + possession);

	statsKeygroupMatch.Rewind();
	// keygroup.ExportToFile(statsKeygroupMatch);
	// keygroup.Close();
}

public void ShowMVP()
{
	int highestScore = 0;
	char roundMVP[MAX_NAME_LENGTH];
	// char steamid[32];
	char steamidMVP[32];
	char queryString[1024];

	// KeyValues keygroup = new KeyValues("roundStatistics");
	// keygroup.ExportToFile(statsKeygroupRound);
	statsKeygroupRound.GotoFirstSubKey();

	// int sizeCT = GetTeamClientCount(3);
	// int sizeT = GetTeamClientCount(2);

	do
	{
		// keygroup.GetSectionName(steamid, sizeof(steamid));

		// if (sizeCT > 1 && sizeT > 1)
		// {
		//  Format(queryString, sizeof(queryString), "UPDATE soccer_mod_players SET money = (money + %i) WHERE steamid = '%s'", keyValue, steamid);
		//  ExecuteQuery(queryString);
		// }

		int keyValue = statsKeygroupRound.GetNum("points", 0);
		if (keyValue > highestScore)
		{
			statsKeygroupRound.GetString("name", roundMVP, sizeof(roundMVP));
			statsKeygroupRound.GetSectionName(steamidMVP, sizeof(steamidMVP));
			highestScore = keyValue;
		}
	}
	while (statsKeygroupRound.GotoNextKey());
	statsKeygroupRound.Rewind();
	// keygroup.Close();

	if (highestScore)
	{
		// keygroup = new KeyValues("matchStatistics");
		// keygroup.ImportFromFile(statsKeygroupMatch);

		statsKeygroupMatch.JumpToKey(steamidMVP, true);

		int keyValue = statsKeygroupMatch.GetNum("mvpCount", 0);
		statsKeygroupMatch.SetNum("mvpCount", keyValue + 1);
		keyValue = statsKeygroupMatch.GetNum("points", 0);
		statsKeygroupMatch.SetNum("points", keyValue + rankingPointsForMVP);

		statsKeygroupMatch.Rewind();
		// keygroup.ExportToFile(statsKeygroupMatch);
		// keygroup.Close();

		char table[32];

		if (matchStarted) table = "soccer_mod_match_stats";
		else table = "soccer_mod_public_stats";

		if (EnoughPlayers())
		{
			Format(queryString, sizeof(queryString), "UPDATE %s SET mvp = (mvp + 1), points = (points + %i) WHERE steamid = '%s'", 
				table, rankingPointsForMVP, steamidMVP);
			ExecuteQuery(queryString);
		}

		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%s was the MVP this round with %i points", prefixcolor, prefix, textcolor, roundMVP, highestScore);
		}

		LogMessage("%s <%s> was the MVP this round with %i points", roundMVP, steamidMVP, highestScore);
	}
	else
	{
		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}MVP: No player scored more than 0 points this round", prefixcolor, prefix, textcolor);
		}
	}
}

public bool EnoughPlayers()
{
	int ctplayers = GetTeamClientCount(3);
	int tplayers = GetTeamClientCount(2);
	
	if(matchStarted)
	{
		if(tplayers >= 5 && ctplayers >= 5) return true;
	}
	else return true;
	
	return false;
}

public void AddMatchStat(char type[8])
{
	char queryString[512];
	int keyValue
	
	statsKeygroupMatch.GotoFirstSubKey();

	if (StrEqual(type, "reset"))
	{
		do
		{
			keyValue = statsKeygroupMatch.GetNum("matches", 0);
			if (keyValue == 1)
			{
				char steamid[32];
				statsKeygroupMatch.GetSectionName(steamid, sizeof(steamid));
				statsKeygroupMatch.SetNum("matches", 0);
			}
		}
		while (statsKeygroupMatch.GotoNextKey());
	}
	else
	{
		do
		{
			keyValue = statsKeygroupMatch.GetNum("matches", 0);
			if (keyValue == 1)
			{
				char steamid[32];
				statsKeygroupMatch.GetSectionName(steamid, sizeof(steamid));
				statsKeygroupMatch.SetNum("matches", 0);
				
				if(EnoughPlayers)
				{
					Format(queryString, sizeof(queryString), "UPDATE soccer_mod_match_stats SET matches = (matches +1) WHERE steamid = '%s'", steamid);
					ExecuteQuery(queryString);
				}
			}
		}
		while (statsKeygroupMatch.GotoNextKey());
	}

	statsKeygroupMatch.Rewind();
}

public void ShowManOfTheMatch()
{
	int highestScore = 0;
	char matchMVP[MAX_NAME_LENGTH];
	char steamidMVP[32]; 

	// Handle keygroup = new KeyValues("matchStatistics");
	// keygroup.ImportFromFile(statsKeygroupMatch);
	statsKeygroupMatch.GotoFirstSubKey();

	do
	{
		int keyValue = statsKeygroupMatch.GetNum("points", 0);
		if (keyValue > highestScore)
		{
			statsKeygroupMatch.GetString("name", matchMVP, sizeof(matchMVP));
			statsKeygroupMatch.GetSectionName(steamidMVP, sizeof(steamidMVP));
			highestScore = keyValue;
		}
	}
	while (statsKeygroupMatch.GotoNextKey());

	statsKeygroupMatch.Rewind();
	// keygroup.Close();

	if (highestScore)
	{
		// keygroup = new KeyValues("matchStatistics");
		// keygroup.ImportFromFile(statsKeygroupMatch);

		statsKeygroupMatch.JumpToKey(steamidMVP, true);

		int keyValue = statsKeygroupMatch.GetNum("motm", 0);
		statsKeygroupMatch.SetNum("motm", keyValue + 1);

		statsKeygroupMatch.Rewind();
		// keygroup.ExportToFile(statsKeygroupMatch);
		// keygroup.Close();

		char table[32];
		char queryString[1024];

		if (matchStarted) table = "soccer_mod_match_stats";
		else table = "soccer_mod_public_stats";

		if (EnoughPlayers())
		{
			Format(queryString, sizeof(queryString), "UPDATE %s SET motm = (motm + 1), points = (points + %i) WHERE steamid = '%s'", 
				table, rankingPointsForMOTM, steamidMVP);
			ExecuteQuery(queryString);
		}

		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}The man of the match was %s with %i points", prefixcolor, prefix, textcolor, matchMVP, highestScore);
		}

		LogMessage("The man of the match was %s <%s> with %i points", matchMVP, steamidMVP, highestScore);
	}
	else
	{
		for (int player = 1; player <= MaxClients; player++)
		{
			if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}MOTM: No player scored more than 0 points this match", prefixcolor, prefix, textcolor);
		}
	}
}

public void ShowTop3(bool final)
{
	int highestScore1 = 0;
	int highestScore2 = 0;
	int highestScore3 = 0;
	int buf1, buf2;
	char htMVP1[MAX_NAME_LENGTH], htMVP2[MAX_NAME_LENGTH], htMVP3[MAX_NAME_LENGTH], buffer1[MAX_NAME_LENGTH], buffer2[MAX_NAME_LENGTH];
	char steamidMVP[32];

	statsKeygroupMatch.GotoFirstSubKey();

	do
	{
		int keyValue = statsKeygroupMatch.GetNum("points", 0);
		
		if (keyValue > highestScore1)
		{
			//check if someone was placed in 1st pos already
			if (!StrEqual(htMVP1, ""))
			{
				//save name & pts in tempvar
				buffer1 = htMVP1;
				buf1 = highestScore1;
			}
			//set new name & pts for MVP1
			statsKeygroupMatch.GetString("name", htMVP1, sizeof(htMVP1));
			statsKeygroupMatch.GetSectionName(steamidMVP, sizeof(steamidMVP));
			highestScore1 = keyValue;
			
			//check if MVP2 already exists
			if (!StrEqual(htMVP2, ""))
			{
				//save name & pts of MVP2 in tempvar
				buffer2 = htMVP2;
				buf2 = highestScore2;
				
				//save former MVP1 in MVP2
				htMVP2 = buffer1;
				highestScore2 = buf1;
			}
			else
			{
				htMVP2 = buffer1;
				highestScore2 = buf1;
			}
			
			//save former MVP2 in MVP3
			htMVP3 = buffer2;
			highestScore3 = buf2;
		}
		else if (keyValue > highestScore2)
		{
			//check if MVP2 already exists
			if (!StrEqual(htMVP2, ""))
			{
				//save name & pts of MVP2 in tempvar
				buffer1 = htMVP2;
				buf1 = highestScore2;
			}
			//set new name & pts for MVP2
			statsKeygroupMatch.GetString("name", htMVP2, sizeof(htMVP2));
			highestScore2 = keyValue;
			
			//save former MVP2 in MVP3
			htMVP3 = buffer1;
			highestScore3 = buf1;
		}
		else if (keyValue > highestScore3)
		{
			//set new name & pts for MVP3
			statsKeygroupMatch.GetString("name", htMVP3, sizeof(htMVP3));
			highestScore3 = keyValue;
		}
	}
	while (statsKeygroupMatch.GotoNextKey());

	statsKeygroupMatch.Rewind();
		
	if (final)
	{
		
		if (highestScore1)
		{
			// keygroup = new KeyValues("matchStatistics");
			// keygroup.ImportFromFile(statsKeygroupMatch);

			statsKeygroupMatch.JumpToKey(steamidMVP, true);

			int keyValue = statsKeygroupMatch.GetNum("motm", 0);
			statsKeygroupMatch.SetNum("motm", keyValue + 1);

			statsKeygroupMatch.Rewind();
			// keygroup.ExportToFile(statsKeygroupMatch);
			// keygroup.Close();

			char table[32];
			char queryString[1024];

			if (matchStarted) table = "soccer_mod_match_stats";
			else table = "soccer_mod_public_stats";

			if (EnoughPlayers())
			{
				Format(queryString, sizeof(queryString), "UPDATE %s SET motm = (motm + 1), points = (points + %i) WHERE steamid = '%s'", 
					table, rankingPointsForMOTM, steamidMVP);
				ExecuteQuery(queryString);
			}
			
			if (StrEqual(htMVP2, "")) htMVP2 = "Noone";
			if (StrEqual(htMVP3, "")) htMVP3 = "Noone";
			
			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}The man of the match was %s with %i points", prefixcolor, prefix, textcolor, htMVP1, highestScore1);
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}In second place was %s following with %i points", prefixcolor, prefix, textcolor, htMVP2, highestScore2);
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%s was in third place with %i points", prefixcolor, prefix, textcolor, htMVP3, highestScore3);
			}	
			if (StrEqual(htMVP2, "Noone")) htMVP2 = "";
			if (StrEqual(htMVP3, "Noone")) htMVP3 = "";

			LogMessage("The man of the match was %s <%s> with %i points", htMVP1, steamidMVP, highestScore1);
		}
		else
		{
			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}MOTM: No player scored more than 0 points this match", prefixcolor, prefix, textcolor);
			}
		}	
	}
	else
	{
		if (highestScore1)
		{
			if (StrEqual(htMVP2, "")) htMVP2 = "Noone";
			if (StrEqual(htMVP3, "")) htMVP3 = "Noone";
			
			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}Currently leading the MVP ranking is %s with %i points", prefixcolor, prefix, textcolor, htMVP1, highestScore1);
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}In second place %s is following with %i points", prefixcolor, prefix, textcolor, htMVP2, highestScore2);
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%s is currently in third place with %i points", prefixcolor, prefix, textcolor, htMVP3, highestScore3);
			}
			
			if (StrEqual(htMVP2, "Noone")) htMVP2 = "";
			if (StrEqual(htMVP3, "Noone")) htMVP3 = "";
		}
		else
		{
			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}MOTM: No player scored more than 0 points so far.", prefixcolor, prefix, textcolor);
			}
		}
	}
	
	

}

public void AddStatisticsMenuItem(int client, Menu menu, char menuString[32], char text[32], int value, char item[32])
{
	Format(menuString, sizeof(menuString), "%s: %i", text, value);
	menu.AddItem(item, menuString, ITEMDRAW_DISABLED);
}