#define PLAYER_INITIALIZED   (1<<0)
#define PLAYER_MESSAGES      (1<<1)
#define PLAYER_PROGRESS_BAR  (1<<2)
#define PLAYER_SOUND         (1<<3)
#define PLAYER_ARMOR         (1<<4)
#define DEF_SPRINT_COOKIE    PLAYER_MESSAGES|PLAYER_SOUND

Handle h_SPRINT_COOKIE 		= INVALID_HANDLE;
char iP_SETTINGS[MAXPLAYERS+1];

public Action RegSprintCookie()
{
	h_SPRINT_COOKIE = RegClientCookie(
		"shortsprint",
		"Sprint settings", CookieAccess_Private);
	return;
}

public Action ReadClientCookie(int client)
{
	if(!IsFakeClient(client) && !(iP_SETTINGS[client] & PLAYER_INITIALIZED))
	{
		char sCookie_val[16];

		GetClientCookie(client, h_SPRINT_COOKIE, sCookie_val, sizeof(sCookie_val));
		iP_SETTINGS[client] = StringToInt(sCookie_val) | PLAYER_INITIALIZED;

		if(iP_SETTINGS[client] < 2)
		{
			iP_SETTINGS[client] = DEF_SPRINT_COOKIE;
		}
	}
	return;
}

public Action ReadEveryClientCookie()
{
	for(int iClient = 1; iClient <= MaxClients; iClient++)
	{
		if(IsClientConnected(iClient) && AreClientCookiesCached(iClient))
		{
			ReadClientCookie(iClient);
		}
	}
	return;
}

public Action WriteClientCookie(int client)
{
	if(!IsFakeClient(client) && (iP_SETTINGS[client] & PLAYER_INITIALIZED))
	{
		char sCookie_val[16];
		IntToString(iP_SETTINGS[client], sCookie_val, sizeof(sCookie_val));

		SetClientCookie(client, h_SPRINT_COOKIE, sCookie_val);
	}
	return;
}

public Action WriteEveryClientCookie()
{
	for(int iClient = 1; iClient <= MaxClients; iClient++)
	{
		if(IsClientConnected(iClient))
		{
			WriteClientCookie(iClient);
		}
	}
	return;
}