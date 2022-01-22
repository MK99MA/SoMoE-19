/*public void CreateDCListFile(bool del)
{
	if (FileExists(DCListKV) && del) DeleteFile(DCListKV);
	if (!FileExists(DCListKV))
	{
		File hFile = OpenFile(DCListKV, "w");
		hFile.Close();
	}
}*/

public void ConnectlistOnPluginStart()
{
	//if (FileExists(DCListKV)) DeleteFile(DCListKV);

	kvConnectlist = new KeyValues("connectlist");
}

public void ConnectlistOnMapStart()
{
	kvConnectlist = new KeyValues("connectlist");
	
	if(FileExists(DCListKV))
	{
		kvConnectlist.ImportFromFile(DCListKV);
		//Delete File
		DeleteFile(DCListKV);
	}
}

public void ConnectlistOnMapEnd()
{
	if (!FileExists(DCListKV))
	{
		File hFile = OpenFile(DCListKV, "w");
		hFile.Close();
	}
	kvConnectlist.ExportToFile(DCListKV);
	kvConnectlist.Close();
}

public void OpenJoinlistPanel(int client)
{
	char line[128];
	int panel_keys = 0;
	int entries = 0;
	int joinnr = 0;
	
	// add clientid to array
	if(lcPanelArray.FindValue(client) == -1)	lcPanelArray.Push(client); 

	//kvConnectlist = new KeyValues("connectlist");
	//kvConnectlist.ImportFromFile(DCListKV);
	
	// Create Panel
	Panel panel = new Panel();
	panel.SetTitle("Last Connected:");
	panel.DrawText("_______________________");
	
	if (kvConnectlist.GotoFirstSubKey())
	{
		entries++;
		while (kvConnectlist.GotoNextKey())
		{
			entries++;
		}
	}
	kvConnectlist.Rewind();
	
	// geh an erste stelle in datei
	// hole Steamid
	char bName[MAX_NAME_LENGTH];
	char timeAgo[32], buffer[32];
	int currTime, connTime, discTime;
		
	kvConnectlist.GotoFirstSubKey();
	kvConnectlist.SavePosition();
	
	for (int i = 1; i <= entries; i++)
	{
		bool bFound = false;
		
		currTime = GetTime();
		
		kvConnectlist.GetSectionName(buffer, sizeof(buffer));
		if(bIsOnServer(buffer))
		{
			kvConnectlist.GetString("name", bName, sizeof(bName), "Player");
			connTime = kvConnectlist.GetNum("connecttime", 0);
			discTime = kvConnectlist.GetNum("disconnecttime", 0);
			bFound = true;
			if(discTime == 0) joinnr++;
			//else if (discTime < currTime-rrchecktime) kvConnectlist.DeleteThis();
		}
		kvConnectlist.GotoNextKey();
		kvConnectlist.SavePosition();
		
		//currTime = GetTime();
		
		currTime = currTime - connTime;
		if (currTime == 0) timeAgo = "just now";
		else if (currTime == 1)	timeAgo = "s ago";
		else if (currTime < 60)	timeAgo = "s ago";
		else if (currTime < 120)
		{
			currTime = currTime / 60;
			timeAgo = "m ago";
		}
		else if (currTime < 3600)
		{
			currTime = currTime / 60;
			timeAgo = "m ago";
		}
		else if (currTime < 7200)
		{
			currTime = currTime / 3600;
			timeAgo = "h ago";
		}
		else if (currTime < 86400)
		{
			currTime = currTime / 3600;
			timeAgo = "h ago";
		}
		else if (currTime < 172800)
		{
			currTime = currTime / 86400;
			timeAgo = "d ago";
		}
		else
		{
			currTime = currTime / 86400;
			timeAgo = "d ago";
		}

		if (StrEqual(timeAgo, "just now")) Format(line, sizeof(line), "[%i] - %s - %s", joinnr, bName,  timeAgo);
		else Format(line, sizeof(line), "[%i] - %s - %i%s", joinnr, bName, currTime, timeAgo);
		// disconnected players not displayed on list
		if(discTime == 0 && bFound) panel.DrawText(line);
		//if(discTime == 0 && bFound) PrintToServer("%s - CLIENT: %i", line, client);
	}
		
	kvConnectlist.Rewind();
	//kvConnectlist.ExportToFile(DCListKV); 
	//kvConnectlist.Close();
	
	panel.DrawText(" ");
	// Create Buttons
	//panel_keys |= (1<<1-1);
	//Format(line, sizeof(line), "1. Refresh");
	//panel.DrawText(line);
	
	panel_keys |= (1<<10-1);
	Format(line, sizeof(line), "0. Close");
	panel.DrawText(line);
	
	panel.SetKeys(panel_keys);
	
	panel.Send(client, JoinlistPanelHandler, MENU_TIME_FOREVER);
	
	delete panel;
}

public int JoinlistPanelHandler(Menu menu, MenuAction action, int client, int key)
{
	if(action == MenuAction_Select)
	{
		if(lcPanelArray.FindValue(client) != -1)		
		{
			lcPanelArray.Erase(lcPanelArray.FindValue(client));
		}
	}
	else
	{
		if(lcPanelArray.FindValue(client) != -1)		
		{
			lcPanelArray.Erase(lcPanelArray.FindValue(client));
		}
	}
	
	return;
}

public bool bIsOnServer(char steamid[32])
{
	char bSteam[32];
	for (int i = 0; i < MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			GetClientAuthId(i, AuthId_Engine, bSteam, sizeof(bSteam));
			if (StrEqual(bSteam, steamid))
			{
				return true;
			}
		}	
	}
	return false;
}

public void LCOnClientConnected(int client)
{
	// someone joins -> add to list
	// time, steamid, name
	
	//kvConnectlist = new KeyValues("connectlist");
	//kvConnectlist.ImportFromFile(DCListKV);
	if (!IsFakeClient(client) && !IsClientSourceTV(client)) // IsValidClient(client) && 
	{
		char bName[MAX_NAME_LENGTH];
		char bSteam[32];
		int connTime, discTime;
		
		connTime = GetTime();
		
		GetClientAuthId(client, AuthId_Engine, bSteam, sizeof(bSteam));
		GetClientName(client, bName, sizeof(bName));
		
		if(kvConnectlist.JumpToKey(bSteam, false))
		{
			kvConnectlist.JumpToKey(bSteam, false)
			int oldclient = kvConnectlist.GetNum("client", 0);
			KillDCListTimer(oldclient)
			kvConnectlist.GoBack();
		}
		// check if entry exists aka rr
		if (!(kvConnectlist.JumpToKey(bSteam, false)))
		{	
			kvConnectlist.JumpToKey(bSteam, true);
			kvConnectlist.SetString("name", bName);
			kvConnectlist.SetNum("connecttime", connTime);
			kvConnectlist.SetNum("disconnecttime", 0);
			kvConnectlist.SetNum("client", client);
			kvConnectlist.GoBack();	
		}
		else
		{	
			kvConnectlist.JumpToKey(bSteam, false);
			discTime = kvConnectlist.GetNum("disconnecttime", -1);
			if (discTime < (connTime-rrchecktime) || discTime == -1) // deletethis & recreate
			{
				kvConnectlist.DeleteThis();
				kvConnectlist.GoBack();
				
				kvConnectlist.JumpToKey(bSteam, true);
				kvConnectlist.SetNum("connecttime", connTime);
			}
			kvConnectlist.SetString("name", bName);
			kvConnectlist.SetNum("disconnecttime", 0);
			kvConnectlist.SetNum("client", client);
			kvConnectlist.GoBack();
		}
	}
	
	kvConnectlist.Rewind();
	//kvConnectlist.ExportToFile(DCListKV); 
	//kvConnectlist.Close();
	
	for (int i = 0; i <= MaxClients; i++)//lcPanelArray.Length; i++)
	{
		if(lcPanelArray.FindValue(i) != -1)		
		{
			if (IsValidClient(i))
			{
				OpenJoinlistPanel(i);
			}
		}
	}
	// "connectlist"
	// {
	// 		"steamid"
	// 		{
	//			"name"				"name"
	// 			"connecttime"		"time"
	//			"discconnecttime"	"time"
	//			"client"			"clientid"
	// 		}
	// }
}

public void LCDisconnect(int client)
{
	//kvConnectlist = new KeyValues("connectlist");
	//kvConnectlist.ImportFromFile(DCListKV);

	char bSteam[32];
	int discTime;
	
	discTime = GetTime();
	
	GetClientAuthId(client, AuthId_Engine, bSteam, sizeof(bSteam));
	
	if (kvConnectlist.JumpToKey(bSteam, false))
	{
		kvConnectlist.JumpToKey(bSteam, false)
		kvConnectlist.SetNum("disconnecttime", discTime);
		kvConnectlist.GoBack();	
	}

	kvConnectlist.Rewind();
	//kvConnectlist.ExportToFile(DCListKV); 
	//kvConnectlist.Close();

	if (lcPanelArray.FindValue(client) != -1)
	{
		lcPanelArray.Erase(lcPanelArray.FindValue(client));
	}
	for (int i = 0; i <= MaxClients; i++)//lcPanelArray.Length; i++)
	{
		if(lcPanelArray.FindValue(i) != -1)		
		{
			if (IsValidClient(i))
			{
				OpenJoinlistPanel(i);
			}
		}
	}
	
	// DataPack for Timer
	Handle pack = CreateDataPack();
	// someone leaves -> start timer
	dclistTimer[client] = CreateTimer(rrchecktime, DCListTimer, pack);
	WritePackString(pack, bSteam);
}

public Action DCListTimer(Handle timer, DataPack pack)
{
	char bSteam[32];
	int discTime;
	ResetPack(pack);
	ReadPackString(pack, bSteam, sizeof(bSteam));
	
	// timer is triggered -> if player not on server remove from list
	//kvConnectlist = new KeyValues("connectlist");
	//kvConnectlist.ImportFromFile(DCListKV);
	
	kvConnectlist.JumpToKey(bSteam, false);
	discTime = kvConnectlist.GetNum("disconnecttime", 0);
	if(discTime != 0)	kvConnectlist.DeleteThis();
	PrintToServer("%s removed from joinlist.", bSteam);
	kvConnectlist.GoBack();
	
	kvConnectlist.Rewind();
	//kvConnectlist.ExportToFile(DCListKV); 
	//kvConnectlist.Close();
	
	//KillDCListTimer()
}

public void KillDCListTimer(int client)
{
	if (dclistTimer[client] != null)
	{
		KillTimer(dclistTimer[client]);
		dclistTimer[client] = null;
	}
}

	/*if(action == MenuAction_Select && key == 1)
	{
		// SPAM PROTECTION
		if(lcPlayerCDTimes[client] == 0 || lcPlayerCDTimes[client] <= ( GetTime() - 10))
		{
			lcPlayerCDTimes[client] = GetTime();
			lcPlayerSpammed[client] = false;
			
			OpenJoinlistPanel(client);
		}
		else if (!lcPlayerSpammed[client])
		{
			CPrintToChat(client, "{%s}[%s] {%s}You can only refresh the list every 10 seconds.", prefixcolor, prefix, textcolor);
			
			lcPlayerSpammed[client] = true;
		}
	}*/


/*for (int i = 0; i <= entries; i++)
	{
		// Array mit SteamIDs aufm Server 
		// wenn sectionName in Array, dann print
	
		if (IsValidClient(i))
		{
			char bName[MAX_NAME_LENGTH];
			char bSteam[32], timeAgo[32], buffer[32];
			int currTime, connTime, discTime;
			
			int counter = 1;
			
			currTime = GetTime();
			
			GetClientAuthId(i, AuthId_Engine, bSteam, sizeof(bSteam));
			//GetClientName(i, bName, sizeof(bName));
			
			kvConnectlist.GotoFirstSubKey()
			kvConnectlist.GetSectionName(buffer, sizeof(buffer));
			if (StrEqual(buffer, bSteam))
			{
				kvConnectlist.GetString("name", bName, sizeof(bName), "Player");
				connTime = kvConnectlist.GetNum("connecttime", 0);
				discTime = kvConnectlist.GetNum("discconnecttime", 0);
				kvConnectlist.GoBack();
			}
			else
			{
				while(kvConnectlist.GotoNextKey())
				{
					counter++;
					kvConnectlist.GetSectionName(buffer, sizeof(buffer));
					if (StrEqual(buffer, bSteam))
					{
						joinnr = counter;
						kvConnectlist.GetString("name", bName, sizeof(bName), "Player");
						connTime = kvConnectlist.GetNum("connecttime", 0);
						discTime = kvConnectlist.GetNum("discconnecttime", 0);
						kvConnectlist.GoBack();
					}
				}
			}
			
			//kvConnectlist.JumpToKey(bSteam, false);
			//kvConnectlist.GetString("name", bName, sizeof(bName), "Player");
			//connTime = kvConnectlist.GetNum("connecttime", 0);
			//discTime = kvConnectlist.GetNum("discconnecttime", 0);
			//kvConnectlist.GoBack();
			
			currTime = currTime - connTime;
			if (currTime == 0) timeAgo = "just now";
			else if (currTime == 1)	timeAgo = "s ago";
			else if (currTime < 60)	timeAgo = "s ago";
			else if (currTime < 120)
			{
				currTime = currTime / 60;
				timeAgo = "m ago";
			}
			else if (currTime < 3600)
			{
				currTime = currTime / 60;
				timeAgo = "m ago";
			}
			else if (currTime < 7200)
			{
				currTime = currTime / 3600;
				timeAgo = "h ago";
			}
			else if (currTime < 86400)
			{
				currTime = currTime / 3600;
				timeAgo = "h ago";
			}
			else if (currTime < 172800)
			{
				currTime = currTime / 86400;
				timeAgo = "d ago";
			}
			else
			{
				currTime = currTime / 86400;
				timeAgo = "d ago";
			}
			
			//joinnr++;
			
			if (StrEqual(timeAgo, "just now")) Format(line, sizeof(line), "[%i] - %s - %s", joinnr, bName,  timeAgo);
			else Format(line, sizeof(line), "[%i] - %s - %i%s", joinnr, bName, currTime, timeAgo);
			// disconnected players not displayed on list
			if(discTime == 0) panel.DrawText(line);
			//if(discTime == 0) PrintToServer(line);
		}
	}*/
	
			/*kvConnectlist.GotoFirstSubKey();
		kvConnectlist.GetSectionName(buffer, sizeof(buffer));
		if(bIsOnServer(buffer))
		{
			joinnr = counter;
			kvConnectlist.GetString("name", bName, sizeof(bName), "Player");
			connTime = kvConnectlist.GetNum("connecttime", 0);
			discTime = kvConnectlist.GetNum("discconnecttime", 0);
			
			//kvConnectlist.GoBack();
		}
		else
		{
			//while(kvConnectlist.GotoNextKey())
			//{
			kvConnectlist.GotoNextKey();
			counter++;
			kvConnectlist.GetSectionName(buffer, sizeof(buffer));
			if (bIsOnServer(buffer))
			{
				joinnr = counter;
				kvConnectlist.GetString("name", bName, sizeof(bName), "Player");
				connTime = kvConnectlist.GetNum("connecttime", 0);
				discTime = kvConnectlist.GetNum("discconnecttime", 0);
				//kvConnectlist.GoBack();
				break;
			}
			//}
		}*/