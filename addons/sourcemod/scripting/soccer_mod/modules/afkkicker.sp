// *******************************************************************************************************************
// ************************************************** AFK MAIN *******************************************************
// *******************************************************************************************************************

public void AFKKickOnClientPutInServer(int client)
{
	afk_Position[client] = view_as<float>({0.0, 0.0, 0.0});
	afk_Angles[client] = view_as<float>({0.0, 0.0, 0.0});
	afk_Buttons[client] = 0;
	afk_Matches[client] = 0;
	
	if(pwchange == true && passwordlock == 1)
	{
		// get client pos and view on join
		if(IsValidClient(client, true))
		{
			GetClientAbsOrigin(client, afk_Position[client]);
			GetClientEyeAngles(client, afk_Angles[client]);

			afk_Buttons[client] = GetClientButtons(client);
			afk_Matches[client] = 0;
		}
	}
}

// ************************************************** START *********************************************************

public void AFKKick()
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsValidClient(i, true))
		{
			// do for every client
			AFKGetStartActions(i);
			// start client timer
			afk_Timer[i] = CreateTimer(afk_kicktime, Timer_AFKCheck, i, TIMER_REPEAT);
		}
	}
}

// ************************************************** STOP **********************************************************

public void AFKKickStop()
{
	CPrintToChatAll("{%s}[%s] {%s}AFK Kick disabled.", prefixcolor, prefix, textcolor);

	for(int i = 1; i <= MaxClients; i++)
	{
		if (afk_Timer[i] != null)
		{
			KillAFKTimer(i);
		}
	}
}

// *******************************************************************************************************************
// ************************************************** FUNCTIONS ******************************************************
// *******************************************************************************************************************

public void AFKGetStartActions(int client)
{
	// get pos & view for a client
	GetClientAbsOrigin(client, afk_Position[client]);
	GetClientEyeAngles(client, afk_Angles[client]);

	afk_Buttons[client] = GetClientButtons(client);
	afk_Matches[client] = 0;
}

/*public Action AFKKickOnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon)
{
	int LastButtons[MAXPLAYERS+1];
	if (LastButtons[client] == buttons)
	{
		KillAFKTimer(client);
		afk_Timer[client] = CreateTimer(afk_kicktime, Timer_AFKCheck, client, TIMER_REPEAT);
	}
	LastButtons[client] = buttons;
	
	//return Plugin_Continue;
}*/

// *********************************************** KILL TIMER ********************************************************

public void KillAFKTimer(int client)
{
	// remove clienttimer
	if (afk_Timer[client] != INVALID_HANDLE) 
	{ 
		KillTimer(afk_Timer[client]); 
	} 
	afk_Timer[client] = INVALID_HANDLE; 
	//delete afk_Timer[client];
	//afk_Timer[client] = null;
}

// *********************************************** NUKE PLAYER *******************************************************

public void NukeClient(int client, bool bLog, int iMatches, const char[] sLog)
{
	if(IsValidClient(client))
	{
		KickClient(client, "You were kicked for being AFK or failed to solve the captcha");
	}
}

// ************************************************ COMPARE **********************************************************

stock bool bVectorsEqual(float[3] v1, float[3] v2)
{
	return (v1[0] == v2[0] && v1[1] == v2[1] && v1[2] == v2[2]);
}

// *******************************************************************************************************************
// ************************************************** AFK TIMER ******************************************************
// *******************************************************************************************************************

public Action Timer_AFKCheck(Handle Timer, any client)
{
	if (pwchange == false)
	{
		delete afk_Timer[client];
		afk_Timer[client] = null;
		return Plugin_Stop;
	}

	if(IsValidClient(client, true))
	{
		if(!(CheckCommandAccess(client, "afk-kicker-immunity", ADMFLAG_RCON) || CheckCommandAccess(client, "admflag_reservation", ADMFLAG_RESERVATION)))
		{
		
			float fPosition[3];
			GetClientAbsOrigin(client, fPosition);

			float fAngles[3];
			GetClientEyeAngles(client, fAngles);

			int iButtons = GetClientButtons(client);

			int iMatches = 0;

			if(bVectorsEqual(fPosition, afk_Position[client]))
			{
				iMatches++;
			}

			if(bVectorsEqual(fAngles, afk_Angles[client]))
			{
				iMatches++;
			}

			if(iButtons == afk_Buttons[client])
			{
				iMatches++;
			}

			afk_Matches[client] = iMatches;

			// if no movement
			if(iMatches >= 2)
			{
				PopupAFKMenu(client, afk_menutime);
				KillAFKTimer(client);
				return Plugin_Stop;
			}
			else AFKGetStartActions(client);	// get new pos & view
		}
	}
	
	return Plugin_Continue;
	//return Plugin_Handled;
	//return Plugin_Stop;
}

// *******************************************************************************************************************
// ************************************************** AFK MENU *******************************************************
// *******************************************************************************************************************

public void PopupAFKMenu(int client, int time)
{
	Menu m = new Menu(MenuHandler_AFKVerification);

	m.SetTitle("[AFK Kicker] Are you there?");

	AddKickItemsToMenu(m, GetRandomInt(1, 4));
	m.AddItem("stay", "Yes - Don't kick me!");
	AddKickItemsToMenu(m, GetRandomInt(2, 3));

	m.ExitButton = false;

	m.Display(client, time);
}

public int MenuHandler_AFKVerification(Menu m, MenuAction a, int p1, int p2)
{
	switch(a)
	{
		case MenuAction_Select:
		{
			char buffer[8];
			m.GetItem(p2, buffer, 8);

			if(StrEqual(buffer, "stay"))
			{
				PrintHintText(p1, "AFK verification completed!\nYou will not get kicked.");
				// restart client timer after success
				afk_Timer[p1] = CreateTimer(afk_kicktime, Timer_AFKCheck, p1, TIMER_REPEAT);
			}

			else
			{
				NukeClient(p1, true, afk_Matches[p1], "(Wrong captcha)");
				//delete kicked client timer
				KillAFKTimer(p1);
			}
		}

		case MenuAction_Cancel:
		{
			// no response
			if(p2 == MenuCancel_Timeout)
			{
				NukeClient(p1, true, afk_Matches[p1], "(You were kicked for being AFK)");
				//delete kicked client timer
				KillAFKTimer(p1);
			}
		}

		case MenuAction_End:
		{
			delete m;
		}

	}

	return 0;
}

public void AddKickItemsToMenu(Menu m, int amount)
{
	char sJunk[16];

	for(int i = 1; i <= amount; i++)
	{
		GetRandomString(sJunk, 16);

		m.AddItem("kick", sJunk);
	}
}

// *******************************************************************************************************************
// ************************************************** UTILITY ********************************************************
// *******************************************************************************************************************

public void GetRandomString(char[] buffer, int size)
{
	int random;
	int len;
	size--;

	int length = 16;
	char chrs[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234556789";

	if(chrs[0] != '\0')
	{
		len = strlen(chrs) - 1;
	}

	int n = 0;

	while(n < length && n < size)
	{
		if(chrs[0] == '\0')
		{
			random = GetRandomInt(33, 126);
			buffer[n] = random;
		}

		else
		{
			random = GetRandomInt(0, len);
			buffer[n] = chrs[random];
		}

		n++;
	}

	buffer[length] = '\0';
}