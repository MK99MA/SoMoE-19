public void ReadycheckOnMapStart()
{
	kvTemp = new KeyValues("Ready Check");
}

public void OpenReadyPanel(int client)
{
	// Create temp File if it doesn't exist (default)
	/*if (!FileExists(tempReadyFileKV)) 
	{
		File tFile = OpenFile(tempReadyFileKV, "w");
		tFile.Close();
		
		GetStartPlayers();
	}*/
	GetStartPlayers();
	
	int playernum = 0;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 3))
		{
			playernum++;
		}
	}
	
	int panel_keys = 0;
	char bLine[256];
	
	//kvTemp = new KeyValues("Ready Check");
	//kvTemp.ImportFromFile(tempReadyFileKV);
	
	// Create Panel
	Panel panel = new Panel();
	if(matchReadyCheck == 1)	panel.SetTitle("Unpause Ready Check: AUTO");
	else if(matchReadyCheck == 2)	panel.SetTitle("Unpause Ready Check: MANUAL");
	panel.DrawText("_______________________");
	if (matchReadyCheck == 1) Format(bLine, sizeof(bLine), "Players: (%i / %i) ready", readydisplay, startplayers);
	else if (matchReadyCheck == 2) Format(bLine, sizeof(bLine), "Players: (%i / %i) ready", readydisplay, playernum);
	panel.DrawText(bLine);
	panel.DrawText(" ");
	
	// List all Players in the teams and get their status
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 3))
		{
			char bName[MAX_NAME_LENGTH];
			char bSteam[32];
			char bState[32];
			
			GetClientAuthId(i, AuthId_Engine, bSteam, sizeof(bSteam));
			GetClientName(i, bName, sizeof(bName));
			
			// Get state from file
			if(!kvTemp.JumpToKey(bSteam, false))
			{
				kvTemp.JumpToKey(bSteam, true);
				kvTemp.SetString("Status", "Not Ready");
				kvTemp.GoBack();
			}

			kvTemp.GetString("Status", bState, sizeof(bState), "Not Ready");
			kvTemp.GoBack();
			
			Format(bLine, sizeof(bLine), "[%s] - %s", bState, bName);
			panel.DrawText(bLine);
		}	
	}
	
	kvTemp.Rewind();
	//kvTemp.ExportToFile(tempReadyFileKV);
	//kvTemp.Close();
	
	panel.DrawText(" ");
	panel.DrawText("_______________________");
	
	// Create Buttons
	char sItem_display[2][32] = {"Ready",
	"Not Ready"};

	for(int i = 1; i <= 2; i++)
	{
		panel_keys |= (1<<i-1);
		Format(bLine, sizeof(bLine), "->%i. %s", i, sItem_display[(i-1)]);
		panel.DrawText(bLine);
	}
	
	//panel.DrawText(" ");
	//panel_keys |= (1<<10-1);
	//Format(bLine, sizeof(bLine), "0. Back");
	//panel.DrawText(bLine);

	if(showPanel) panel.SetKeys(panel_keys);
	
	panel.Send(client, ReadyCheckPanelHandler, MENU_TIME_FOREVER);
 
	delete panel;
}

public int ReadyCheckPanelHandler(Menu menu, MenuAction action, int client, int key)
{
	//kvTemp = new KeyValues("Ready Check");
	//kvTemp.ImportFromFile(tempReadyFileKV);
	
	char bName[MAX_NAME_LENGTH];
	GetClientName(client, bName, sizeof(bName))
	
	char bSteam[32];
	GetClientAuthId(client, AuthId_Engine, bSteam, sizeof(bSteam))
	
	int currentTime = GetTime();
	if (cooldownTime[client] != -1 && cooldownTime[client] > currentTime)
	{
		//if(cdMessage[client]) CPrintToChat(client,"{%s}[%s] {%s}Please don't spam.", prefixcolor, prefix, textcolor);
		//cdMessage[client] = false;
		OpenReadyPanel(client);
	}
	else
	{
		//if(cooldownTime[client] < currentTime) 		cdMessage[client] = false;
		if(showPanel)
		{
			if (action == MenuAction_Select)
			{		
				if(key == 1)
				{
					vState = "Ready";
				
					// Save state to file
					kvTemp.JumpToKey(bSteam, true)
					kvTemp.SetString("Status", vState);
					kvTemp.GoBack();
				
					kvTemp.Rewind();
					//kvTemp.ExportToFile(tempReadyFileKV);
					//kvTemp.Close();
				}
				else if(key == 2)
				{
					vState = "Not Ready";
				
					kvTemp.JumpToKey(bSteam, true);
					kvTemp.SetString("status", vState);
					kvTemp.GoBack();

					kvTemp.Rewind();
					//kvTemp.ExportToFile(tempReadyFileKV);
					//kvTemp.Close();
				}
				
				//cdMessage[client] = true;
				cooldownTime[client] = currentTime + 3;
				RefreshPanel();
			}
		}
	}
}

public void RefreshPanel()
{
	if(matchReadyCheck == 1)
	{
		if (AreAllReady())
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 3))
				{
					OpenReadyPanel(i);
					if(GetClientMenu(i) != MenuSource_None)
					{
						CancelClientMenu(i, false);
						InternalShowMenu(i, "\10", 1); 
					}
				}
			}
			showPanel = false;
			CPrintToChatAll("{%s}[%s] {%s}All Players ready... Match will resume.", prefixcolor, prefix, textcolor);
			//DeleteTempFile();
			recreateTempKV();
			MatchUnpause(0);
		}				
		else if(showPanel) 
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 3))
				{
					OpenReadyPanel(i);
				}
			}
		}
	}
	else if(matchReadyCheck == 2) 
	{
		AreAllReady();
		if(showPanel) 
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 3))
				{
					OpenReadyPanel(i);
				}
			}
		}
	}
}

public bool AreAllReady()
{
	//kvTemp = new KeyValues("Ready Check");
	//kvTemp.ImportFromFile(tempReadyFileKV);

	int ready = 0;
	int notready = 0;
	int playernum = 0;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 3))
		{
			playernum++;
		}
	}
	
	if(kvTemp.GotoFirstSubKey())
	{
		do
		{
			char buffer[32];
			kvTemp.GetString("Status", buffer, sizeof(buffer), "Not Ready");
			if (StrEqual(buffer, "Not Ready")) 
			{
				notready++;
			}
			else if (StrEqual(buffer, "Ready"))
			{
				ready++;
			}
		}
		while (kvTemp.GotoNextKey());
	}

	kvTemp.Rewind();
	//kvTemp.Close();
	
	//PrintToChatAll("ready: %i | notready: %i | check: %i | players: %i | start: %i", ready, notready, ready-notready,  playernum, startplayers);
	
	readydisplay = ready;
	
	if(matchReadyCheck == 2)
	{
		if(ready == playernum)	return true;
		else return false;
	}
	else if(matchReadyCheck == 1)
	{
		if(playernum == startplayers)
		{
			if(ready == startplayers)	return true;
			else return false;
		}
		else return false;
	}
	else return false;
}

public void UnpauseCheck(int client)
{
	if(matchReadyCheck == 2)
	{
		if (AreAllReady()) 
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
					//CancelClientMenu(i,true);
				}
			}
			showPanel = false;
			//DeleteTempFile();
			recreateTempKV();
			if (tempUnpause)
			{
				matchReadyCheck = 1;
				tempUnpause = false;
			} 
			
			CPrintToChatAll("{%s}[%s] {%s}All Players ready... Match will resume.", prefixcolor,  prefix, textcolor);
			MatchUnpause(client);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}Not everyone is ready!", prefixcolor, prefix, textcolor);
	}
	else if (matchReadyCheck == 0) MatchUnpause(client);
	else if (matchReadyCheck == 1) CPrintToChat(client, "{%s}[%s] {%s} Match will resume automatically if everyone is ready.", prefixcolor, prefix, textcolor);
}

public void ReadyCheckOnClientDisconnect(int client)
{
	if(FileExists(tempReadyFileKV))
	{
		char bSteam[32];
		GetClientAuthId(client, AuthId_Engine, bSteam, sizeof(bSteam));
		
		//kvTemp = new KeyValues("Ready Check");
		//kvTemp.ImportFromFile(tempReadyFileKV);
		
		kvTemp.JumpToKey(bSteam, false);
		kvTemp.DeleteThis();
		
		kvTemp.Rewind();
		//kvTemp.ExportToFile(tempReadyFileKV);
		//kvTemp.Close();
	}
}

public Action pauseReadyTimer(Handle timer, any time)
{
	char timestamp[32];
	FormatTime(timestamp, sizeof(timestamp), "%M:%S", time);
	
	totalpausetime = timestamp;
	
	int newplayernum;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && GetClientTeam(i) > 1)
		{
			//if(GetEntityMoveType(i) == MOVETYPE_WALK)	SetEntityMoveType(i, MOVETYPE_NONE);
			newplayernum++;
		}
	}	
	
	if(newplayernum != pauseplayernum)
	{
		RefreshPanel();
		pauseplayernum = newplayernum;
	}
	
	PrintCenterTextAll("Pause Time: %s", timestamp);
	if(time == 300 && matchReadyCheck == 1)
	{
		matchReadyCheck = 2;
		tempUnpause = true;
		CPrintToChatAll("{%s}[%s] {%s}Manual Unpausing is enabled now.", prefixcolor, prefix, textcolor);
		RefreshPanel();
	}
	
	if(!matchStopPauseTimer)	pauseRdyTimer = CreateTimer(1.0, pauseReadyTimer, time+1);
}

public void GetStartPlayers()
{
	startplayers = 0;
	//readydisplay = 0;
	
	if(GetTeamClientCount(2) == GetTeamClientCount(3))
	{
		startplayers = GetTeamClientCount(2) + GetTeamClientCount(3);
	}
	else if(GetTeamClientCount(2) != GetTeamClientCount(3))
	{
		if((GetTeamClientCount(2) == 6 && (GetTeamClientCount(3) == 5 || GetTeamClientCount(3) == 7)) || (GetTeamClientCount(3) == 6 && (GetTeamClientCount(2) == 5 || GetTeamClientCount(2) == 7)))
		{
			startplayers = 12;
		}
		else if((GetTeamClientCount(2) == 3 && (GetTeamClientCount(3) == 2 || GetTeamClientCount(3) == 4)) || (GetTeamClientCount(3) == 3 && (GetTeamClientCount(2) == 2 || GetTeamClientCount(2) == 4)))
		{
			startplayers = 6;
		}
		else
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && (GetClientTeam(i) == 2 || GetClientTeam(i) == 3)) startplayers++;
			}
		}
	}
}

public void recreateTempKV()
{
	kvTemp.Close();
	kvTemp = new KeyValues("Ready Check");
}

/*public void DeleteTempFile()
{
	DeleteFile(tempReadyFileKV);
}*/

public void KillPauseReadyTimer()
{
	if(pauseRdyTimer != null)
	{
		KillTimer(pauseRdyTimer);
		pauseRdyTimer = null;
	}
}