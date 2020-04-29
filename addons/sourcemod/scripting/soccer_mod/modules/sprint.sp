#define CLIENT_SPRINTUSING   (1<<0)
#define CLIENT_SPRINTUNABLE  (1<<1)
#define CLIENT_MESSAGEUSING  (1<<2)
#define CLIENT_ANNOUNCEMENT  (1<<3)

//INCLUDES
#include "soccer_mod\modules\sprint\clientsettings.sp"
#include "soccer_mod\modules\sprint\infopanel.sp"
#include "soccer_mod\modules\sprint\timers.sp"


public void OnPluginEnd()
{
  //Clientprefs
  WriteEveryClientCookie();
  return;
}

public void SprintOnPluginStart()
{
	//Commands
	RegConsoleCmd("sm_sprint", Command_StartSprint, "Starts the sprint.");

	//RegConsoleCmd("sm_sprintinfo", Command_InfoPanel, "Opens the Sprint InfoPanel.");
	floodcheck();
	//Clientprefs
	RegSprintCookie();

	return;
}

public void floodcheck()
{
	char afpath_old[PLATFORM_MAX_PATH], afpath_new[PLATFORM_MAX_PATH];
	antiflood = FindPluginByFile("antiflood.smx");
	BuildPath(Path_SM, afpath_old, sizeof(afpath_old), "plugins/antiflood.smx")
	BuildPath(Path_SM, afpath_new, sizeof(afpath_new), "plugins/disabled/antiflood.smx")
	if (antiflood != INVALID_HANDLE)
	{
		RenameFile(afpath_new, afpath_old, false);
		
		/*File hFile = OpenFile("cfg/server.cfg", "at");
		char sLine[128];
		while (!hFile.EndOfFile() && hFile.ReadLine(sLine, sizeof(sLine)))
		{
			if((StrContains(sLine, "sm_flood_time") == -1))
			{
				WriteFileLine(hFile, "");
				WriteFileLine(hFile, "//Floodcheck: allowed time between messages");
				WriteFileLine(hFile, "sm_flood_time 0");
			}
		}
		hFile.Close();*/
	}
}


public void OnClientConnected(int client)
{
	SetDefaultClientSettings(client);
	return;
}

//public void OnClientDisconnect(int client)
//{
//  WriteClientCookie(client);
//  return;
//}

//Client settings
public void OnClientCookiesCached(int client)
{
	if(IsClientConnected(client))
	{
		ReadClientCookie(client);
	}
	return;
}

public Action Command_StartSprint(int client, int args)
{
	if(bSPRINT_ENABLED && client > 0 && IsClientInGame(client)
	&& IsPlayerAlive(client) && GetClientTeam(client) > 1
	&& !(iCLIENT_STATUS[client] & CLIENT_SPRINTUSING)
	&& !(iCLIENT_STATUS[client] & CLIENT_SPRINTUNABLE))
	{
		if(!showHudPrev[client])
		{
			iCLIENT_STATUS[client] |= CLIENT_SPRINTUSING | CLIENT_SPRINTUNABLE;

			//Set sprint speed
			SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", fSPRINT_SPEED);
			//SetEntProp(client, Prop_Send, "m_ArmorValue", 0.0);
			
			//----

			//Outputs 
			if(iP_SETTINGS[client] & PLAYER_SOUND)
			{
				EmitSoundToClient(client, "player/suit_sprint.wav", SOUND_FROM_PLAYER, SNDCHAN_AUTO,
				SNDLEVEL_NORMAL, SND_NOFLAGS, 0.8);
			}

			if(iP_SETTINGS[client] & PLAYER_MESSAGES)
			{
				CPrintToChat(client, "{%s}[%s] You are using sprint!", prefixcolor, prefix);

				iCLIENT_STATUS[client] |= CLIENT_MESSAGEUSING;
			}

			if (iP_SETTINGS[client] & PLAYER_TIMER)
			{
				if(h_SPRINT_REFILL[client] != INVALID_HANDLE) delete h_SPRINT_REFILL[client];	
				
				float time = fSPRINT_TIME;
				
				DataPack pack = new DataPack();
				h_SPRINT_DURATION[client] = CreateDataTimer(0.1, SprintHud, pack, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE|TIMER_DATA_HNDL_CLOSE);
				pack.WriteCell(client);
				pack.WriteFloat(time);
			}
			//---- 

			h_SPRINT_TIMERS[client] = CreateTimer(fSPRINT_TIME, Timer_SprintEnd, client);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}Can't sprint while editing your settings!", prefixcolor, prefix, textcolor);
	}
	return(Plugin_Handled);
}

public Action SprintHud(Handle timer, DataPack pack)
{
	pack.Reset();
	int client = pack.ReadCell();
	float time = pack.ReadFloat();
	
	char cdBuffer[32];
	SetHudTextParams(x_val[client], y_val[client], 0.1, red_val[client], green_val[client], blue_val[client], 255);
	
	if(time > 0.0)
	{
		Format(cdBuffer, sizeof(cdBuffer), "Sprinting: %.1f ", time);
		ShowHudText(client, 5, cdBuffer); 
		time = time - 0.1;
		
		pack.Reset();
		pack.WriteCell(client);
		pack.WriteFloat(time);
	}
	else if(time == 0.0)
	{
		if(h_SPRINT_DURATION[client] != INVALID_HANDLE)
		{
			delete h_SPRINT_DURATION[client];
		}
		CloseHandle(pack);
		ShowHudText(client, 5, "");	
	}
	
	return;
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
	return;
}

////////////////////////////////////////////////////////////////////////////////
//Default settings
public void SetDefaultClientSettings(int client)
{
	iCLIENT_STATUS[client] = 0;

	//h_SPRINT_TIMERS[client] = INVALID_HANDLE;
	delete h_SPRINT_TIMERS[client];
	h_SPRINT_DURATION[client] = INVALID_HANDLE;
	h_SPRINT_REFILL[client] = INVALID_HANDLE;

	iP_SETTINGS[client] = DEF_SPRINT_COOKIE;

	return;
}

public void SetEveryClientDefaultSettings()
{
	for(int client = 1; client <= MaxClients; client++)
	{
		if(IsClientInGame(client))
		{
			SetDefaultClientSettings(client);
		}
	}
	return;
}

////////////////////////////////////////////////////////////////////////////////
//Reset
public void ResetSprint(int client)
{
	/*if(h_SPRINT_TIMERS[client] != INVALID_HANDLE)
	{
		KillTimer(h_SPRINT_TIMERS[client]);
		h_SPRINT_TIMERS[client] = INVALID_HANDLE;
	}*/

	delete h_SPRINT_TIMERS[client];
	delete h_SPRINT_REFILL[client];
	delete h_SPRINT_DURATION[client];
	
	//Reset sprint speed
	if(GetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue") != 1)
	{
		SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.0);
	}	

	if(iCLIENT_STATUS[client] & CLIENT_SPRINTUSING)
	{
		iCLIENT_STATUS[client] &= ~ CLIENT_SPRINTUSING;
		PrintSprintEndMsgToClient(client);
	}

	return;
}

////////////////////////////////////////////////////////////////////////////////
//Outputs
public void PrintSprintEndMsgToClient(int client)
{
	if(iCLIENT_STATUS[client] & CLIENT_MESSAGEUSING)
	{
		CPrintToChat(client, "{%s}[%s] Sprint has ended", prefixcolor, prefix);
	}
	return;
}

public void PrintSprintCDMsgToClient(int client)
{
	if(iCLIENT_STATUS[client] & CLIENT_MESSAGEUSING)
	{
		CPrintToChat(client, "{%s}[%s] You can use sprint", prefixcolor ,prefix);
		iCLIENT_STATUS[client] &= ~ CLIENT_MESSAGEUSING;
	}
	return;
}

public void SendProgressBarResetToClient(int client)
{
	if(GetEntProp(client, Prop_Send, "m_iProgressBarDuration", 4))
	{
		SetEntProp(client, Prop_Send, "m_iProgressBarDuration", 0);
	}
	return;
}
