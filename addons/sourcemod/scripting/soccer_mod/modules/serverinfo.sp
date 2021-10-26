public void ChangeGameDesc()
{
	if (StrEqual(gamevar, "cstrike"))	SteamWorks_SetGameDescription("CS:S Soccer Mod")
	else if (StrEqual(gamevar, "csgo"))		SteamWorks_SetGameDescription("CS:GO Soccer Mod");
}

public void HostName_Change_Status(char type[16])
{
	if (hostnameToggle == 1)
	{
		if (StrEqual(type, "Specced"))
		{
			Format(new_hostname, sizeof(new_hostname), "[PRE-CAP] %s", old_hostname)
			g_hostname.SetString(new_hostname);
		}
		else if (StrEqual(type, "Capfight"))
		{
			Format(new_hostname, sizeof(new_hostname), "[CAPFIGHT] %s", old_hostname)
			g_hostname.SetString(new_hostname);
		}
		else if (StrEqual(type, "Picking"))
		{
			Format(new_hostname, sizeof(new_hostname), "[PICKING] %s", old_hostname)
			g_hostname.SetString(new_hostname);
		}
		else if (StrEqual(type, "Match"))
		{
			hostnameTimer = CreateTimer(0.0, HostName_Change_Timer);
		}
		else if (StrEqual(type, "Periodbreak"))
		{
			KillHostnameTimer();
			Format(new_hostname, sizeof(new_hostname), "[PERIOD BREAK] %s", old_hostname)
			g_hostname.SetString(new_hostname);
		}
		else if (StrEqual(type, "Halftime"))
		{
			KillHostnameTimer();
			Format(new_hostname, sizeof(new_hostname), "[HALFTIME] %s", old_hostname)
			g_hostname.SetString(new_hostname);
		}
		else if (StrEqual(type, "Golden"))
		{
			KillHostnameTimer();
			Format(new_hostname, sizeof(new_hostname), "[GOLDEN GOAL] %s", old_hostname)
			g_hostname.SetString(new_hostname);
		}
		else if (StrEqual(type, "Reset"))
		{
			KillHostnameTimer();
			g_hostname.SetString(old_hostname);
			g_hostname.Close();
		}
	}
	else
	{
		KillHostnameTimer();
		g_hostname.SetString(old_hostname);
		g_hostname.Close();
	}
}

public Action HostName_Change_Timer(Handle timer)
{
	char timeString[16];
	getTimeString(timeString, matchTime);
	char stoppageTimeString[16];
	getTimeString(stoppageTimeString, matchStoppageTime);
	
	if(matchTime <= matchPeriodLength && matchStoppageTime == 0)
	{
		Format(new_hostname, sizeof(new_hostname), "[%s] %s", timeString, old_hostname)
		g_hostname.SetString(new_hostname);
	}
	else if ((matchTime == matchPeriodLength && matchStoppageTime > 0)|| (matchTime == matchPeriodLength*2&& matchStoppageTime > 0))
	{
		Format(new_hostname, sizeof(new_hostname), "[%s + %s] %s", timeString, stoppageTimeString, old_hostname)
		g_hostname.SetString(new_hostname);
	}
	else if (matchTime <= matchPeriodLength*2 && matchStoppageTime == 0)
	{
		Format(new_hostname, sizeof(new_hostname), "[%s] %s", timeString, old_hostname)
		g_hostname.SetString(new_hostname);
	}
	else if (matchTime > matchPeriodLength*matchPeriods)
	{
		Format(new_hostname, sizeof(new_hostname), "[OT %s] %s", timeString, old_hostname)
		g_hostname.SetString(new_hostname);
	}
	
	hostnameTimer = CreateTimer(hostname_update_time, HostName_Change_Timer);
}

public void KillHostnameTimer()
{
	if (hostnameTimer != null)
	{
		KillTimer(hostnameTimer);
		hostnameTimer = null;
	}
}

/*public void AddSoccerTags()
{
	char oldtags[256], newtags[256];
	//char soccertags[64] = "soccer,soccermod,soccer_mod";
	int flags;
	
	ConVar tags = FindConVar("sv_tags");
	flags = GetConVarFlags(tags);
	flags &= ~FCVAR_NOTIFY;
	SetConVarFlags(tags, flags);
	
	tags.GetString(oldtags, sizeof(oldtags));
	//PrintToChatAll(oldtags);
	if(SimpleRegexMatch(oldtags, "soccer\\W", false) == -1)
	{
		Format(newtags, sizeof(newtags), "%s,soccer", oldtags);
		tags.SetString(newtags, false, false);
	}
	if(StrContains(oldtags, "soccermod,", false) == -1)
	{
		Format(newtags, sizeof(newtags), "%s,soccermod", oldtags);
		tags.SetString(newtags, false, false);
	}
	if(StrContains(oldtags, "soccer_mod,", false) == -1)
	{
		Format(newtags, sizeof(newtags), "%s,soccer_mod", oldtags);
		tags.SetString(newtags, false, false);
	}
	
	CloseHandle(tags);
}*/