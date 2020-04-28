#define PLAYER_INITIALIZED   (1<<0)
#define PLAYER_MESSAGES      (1<<1)
#define PLAYER_PROGRESS_BAR  (1<<2)
#define PLAYER_SOUND         (1<<3)
#define PLAYER_TIMER         (1<<4)
#define DEF_SPRINT_COOKIE    PLAYER_MESSAGES|PLAYER_SOUND

public Action RegSprintCookie()
{
	h_SPRINT_COOKIE = RegClientCookie(
		"shortsprint",
		"Sprint settings", CookieAccess_Private);
	h_TIMER_XY_COOKIE = RegClientCookie(
		"timer_xy",
		"Sprinttimer position", CookieAccess_Private);
	h_TIMER_COL_COOKIE = RegClientCookie(
		"timer_col",
		"Sprinttimer color", CookieAccess_Private);
	return;
}

public Action ReadClientCookie(int client)
{
	if(!IsFakeClient(client) && !(iP_SETTINGS[client] & PLAYER_INITIALIZED))
	{
		char sCookie_val[16];
		char sTempArray[3][16];
		char sTempArray2[2][16];

		GetClientCookie(client, h_SPRINT_COOKIE, sCookie_val, sizeof(sCookie_val));
		iP_SETTINGS[client] = StringToInt(sCookie_val) | PLAYER_INITIALIZED;
		
		GetClientCookie(client, h_TIMER_COL_COOKIE, sCookie_val, sizeof(sCookie_val));
		ExplodeString(sCookie_val, ";", sTempArray, sizeof(sTempArray), sizeof(sTempArray[]));
		red_val[client] 	= StringToInt(sTempArray[0]);
		green_val[client]	= StringToInt(sTempArray[1]);
		blue_val[client]	= StringToInt(sTempArray[2]);
		
		GetClientCookie(client, h_TIMER_XY_COOKIE, sCookie_val, sizeof(sCookie_val));
		ExplodeString(sCookie_val, ";", sTempArray2, sizeof(sTempArray2), sizeof(sTempArray2[]));
		x_val[client] 		= StringToFloat(sTempArray2[0]);
		y_val[client] 		= StringToFloat(sTempArray2[1]);

		if(iP_SETTINGS[client] < 2)
		{
			iP_SETTINGS[client] = DEF_SPRINT_COOKIE;
		}
		
		if((red_val[client] == 0) && (green_val[client] == 0) && (blue_val[client] == 0) && (x_val[client] == 0.0) && (y_val[client] == 0.0))
		{
			red_val[client] 	= 255;
			green_val[client]	= 140;
			blue_val[client]	= 0;
			x_val[client]		= 0.8;
			y_val[client]		= 0.8;
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
		
		// Color Cookie
		Format(sCookie_val, sizeof(sCookie_val), "%i;%i;%i", red_val[client], green_val[client], blue_val[client]);
		SetClientCookie(client, h_TIMER_COL_COOKIE, sCookie_val);
		
		// Position Cookie
		Format(sCookie_val, sizeof(sCookie_val), "%f;%f", x_val[client], y_val[client]);
		SetClientCookie(client, h_TIMER_XY_COOKIE, sCookie_val);
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