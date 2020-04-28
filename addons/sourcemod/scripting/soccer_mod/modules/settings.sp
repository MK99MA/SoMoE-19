// *******************************************************************************************************************
// ************************************************** SETTINGS MENU **************************************************
// *******************************************************************************************************************
public void OpenMenuSettings(int client)
{
	Menu menu = new Menu(MenuHandlerSettings);

	menu.SetTitle("Soccer Mod - Admin - Settings");

	char ReadyString[32], DamageString[32], PubString[32];
	if(matchReadyCheck == 0)			ReadyString = "Ready Check: OFF";
	else if (matchReadyCheck == 1)		ReadyString = "Ready Check: AUTO";
	else if (matchReadyCheck == 2)		ReadyString = "Ready Check: ON USE";
	
	if(damageSounds == 0)				DamageString = "Damage Sound: OFF";
	else if(damageSounds == 1)			DamageString = "Damage Sound: ON";
	
	if(publicmode == 0)					PubString = "Public Mode: Admins";
	else if(publicmode == 1)			PubString = "Public Mode: !Cap / !Match";
	else if(publicmode == 2)			PubString = "Public Mode: Free for All";
		
	Handle shoutplugin = FindPluginByFile("shout.smx");	

	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true)) menu.AddItem("adminset", "Manage Admins");
	menu.AddItem("chatset", "Chat Settings");
	menu.AddItem("maps", "Allowed Maps");
	menu.AddItem("pubmode", PubString);
	menu.AddItem("ready", ReadyString);
	menu.AddItem("damagesound", DamageString);
	menu.AddItem("skinsmenu", "Skins");
	if (shoutplugin != INVALID_HANDLE)
	{
		if(CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC, true)) menu.AddItem("shoutplug", "Shout Plugin");
	}
	menu.AddItem("lockenabled", "Lock Server");

	if (debuggingEnabled) menu.AddItem("gk_areas", "Set gk area's");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerSettings(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "maps"))					OpenMenuMaps(client);
		else if (StrEqual(menuItem, "chatset"))			OpenMenuChat(client);
		else if (StrEqual(menuItem, "pubmode"))			OpenMenuPubMode(client);
		else if (StrEqual(menuItem, "skinsmenu"))		OpenSkinsMenu(client);
		else if (StrEqual(menuItem, "shoutplug"))		FakeClientCommandEx(client, "sm_shoutset");
		else if (StrEqual(menuItem, "ready"))
		{
			if(matchReadyCheck < 2) 
			{
				matchReadyCheck++;
				UpdateConfigInt("Match Settings", "soccer_mod_match_readycheck", matchReadyCheck);
				OpenMenuSettings(client);
			}
			else 
			{
				matchReadyCheck = 0;
				UpdateConfigInt("Match Settings", "soccer_mod_match_readycheck", matchReadyCheck);
				OpenMenuSettings(client);
			}
		}
		else if(StrEqual(menuItem, "lockenabled"))
		{
			if(!pwchange) OpenMenuLockSet(client);
			else 
			{
				CPrintToChat(client, "{%s}[%s] {%s}You can't access this menu until the capmatch started!", prefixcolor, prefix, textcolor);
				OpenMenuSettings(client);
			}
		}
		else if(StrEqual(menuItem, "damagesound")) 
		{
			if(damageSounds == 0)
			{
				damageSounds = 1;
				UpdateConfigInt("", "", damageSounds);
				OpenMenuSettings(client);
			}
			else if(damageSounds >0)
			{
				damageSounds = 0;
				UpdateConfigInt("", "", damageSounds);
				OpenMenuSettings(client);
			}
		}
		else if(StrEqual(menuItem, "adminset")) if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true))		OpenMenuAdminSet(client);
		else if(currentMapAllowed)
		{
			if(StrEqual(menuItem, "gk_areas"))		OpenMenuGKAreas(client);
		}
		else
		{
			CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map.", prefixcolor, prefix, textcolor);
			OpenMenuSettings(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// ************************************************** LOCKSET MENU ***************************************************
// *******************************************************************************************************************
public void OpenMenuLockSet(int client)
{
	char currentLockSet[64], CaptchaTimer[64], MenuTimer[64];
	char lockstate[32];
	
	if(passwordlock == 1) lockstate = "On"
	else if(passwordlock == 0) lockstate = "Off"
		
	Format(currentLockSet, sizeof(currentLockSet), "Locking: %s | Threshold: %i", lockstate, PWMAXPLAYERS+1);
	Format(CaptchaTimer, sizeof(CaptchaTimer), "Captcha Timer: %f", afk_kicktime);
	Format(MenuTimer, sizeof(MenuTimer), "Captchamenu Timer: %i", afk_menutime);
	
	Menu menu = new Menu(MenuHandlerLockSet);

	menu.SetTitle("Soccer Mod - Admin - Settings - Lock");

	menu.AddItem("enable", "Enable ServerLock");
	menu.AddItem("disable", "Disable ServerLock");
	menu.AddItem("locknumber", "Player Threshold");
	menu.AddItem("afktime", CaptchaTimer);
	menu.AddItem("menutime", MenuTimer);
	menu.AddItem("locknumber", currentLockSet, ITEMDRAW_DISABLED);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerLockSet(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "enable"))
		{
			passwordlock = 1;
			UpdateConfigInt("Admin Settings", "soccer_mod_passwordlock", passwordlock);
			CPrintToChatAll("{%s}[%s] {%s}Server will lock itself.", prefixcolor, prefix, textcolor);
			OpenMenuLockSet(client);
		}
		else if (StrEqual(menuItem, "disable"))
		{
			passwordlock = 0;
			UpdateConfigInt("Admin Settings", "soccer_mod_passwordlock", passwordlock);
			CPrintToChatAll("{%s}[%s] {%s}Server will not lock itself.", prefixcolor, prefix, textcolor);
			OpenMenuLockSet(client);
		}
		else if (StrEqual(menuItem, "locknumber"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type in the maximum allowed players for a cap, 0 to stop. Current setting is %i.", prefixcolor, prefix, textcolor, PWMAXPLAYERS+1);
			changeSetting[client] = "LockServerNum";
		}
		else if (StrEqual(menuItem, "afktime"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type in the amount of seconds before the captcha appears, 0 to stop. Current setting is %f.", prefixcolor, prefix, textcolor, afk_kicktime);
			changeSetting[client] = "CaptchaNum";
		}
		else if (StrEqual(menuItem, "menutime"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type in the amount of seconds a player has to solve the captcha, 0 to stop. Current setting is %i.", prefixcolor, prefix, textcolor, afk_menutime);
			changeSetting[client] = "MenuNum";
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// ************************************************** PUBMODE MENU ***************************************************
// *******************************************************************************************************************
public void OpenMenuPubMode(int client)
{
	Menu menu = new Menu(MenuHandlerPubMode);

	menu.SetTitle("Soccer Mod - Admin - Settings - PubMode");

	menu.AddItem("adm_only", "Admin access only");
	menu.AddItem("pub_com", "Public !cap and !match");
	menu.AddItem("pub_menu", "Public !menu");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerPubMode(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		if (StrEqual(menuItem, "adm_only"))
		{
			publicmode = 0;
			UpdateConfigInt("Admin Settings", "soccer_mod_pubmode", publicmode);
			CPrintToChatAll("{%s}[%s] {%s}Publicmode set to admins only.", prefixcolor, prefix, textcolor);
			OpenMenuPubMode(client);
		}
		else if (StrEqual(menuItem, "pub_com"))
		{
			publicmode = 1;
			UpdateConfigInt("Admin Settings", "soccer_mod_pubmode", publicmode);
			CPrintToChatAll("{%s}[%s] {%s}Publicmode set to public !cap and !match.", prefixcolor, prefix, textcolor);
			OpenMenuPubMode(client);
		}
		else if (StrEqual(menuItem, "pub_menu"))
		{
			publicmode = 2;
			UpdateConfigInt("Admin Settings", "soccer_mod_pubmode", publicmode);
			CPrintToChatAll("{%s}[%s] {%s}Publicmode set to public menu.", prefixcolor, prefix, textcolor);
			OpenMenuPubMode(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ************************************************** TEST **************************************************
public void OpenMenuGKAreas(int client)
{
	Menu menu = new Menu(MenuHandlerGKAreas);
	menu.SetTitle("Soccer Mod - Admin - Settings - GK area's");

	int index;
	char entityName[64];

	while ((index = FindEntityByClassname(index, "trigger_once")) != INVALID_ENT_REFERENCE)
	{
		char playerIndex[8];
		IntToString(index, playerIndex, sizeof(playerIndex));
		GetEntPropString(index, Prop_Data, "m_iName", entityName, sizeof(entityName));
		menu.AddItem(playerIndex, entityName);
	}

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerGKAreas(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char chosenMenuItem[32];
		menu.GetItem(choice, chosenMenuItem, sizeof(chosenMenuItem));
		int index = StringToInt(chosenMenuItem);

		float start[3];
		float end[3];
		float origin[3];
		GetEntPropVector(index, Prop_Data, "m_vecMins", start);
		GetEntPropVector(index, Prop_Data, "m_vecMaxs", end);
		GetEntPropVector(index, Prop_Data, "m_vecOrigin", origin);

		float xWidth;
		float yWidth;
		float zWidth;
		xWidth = end[0] - start[0];
		yWidth = end[1] - start[1];
		zWidth = end[2] - start[2];

		float ballPosition[3];
		int ball = GetEntityIndexByName("ball", "prop_physics");
		GetEntPropVector(ball, Prop_Send, "m_vecOrigin", ballPosition);

		float deltaX;
		float deltaY;
		float deltaZ;
		deltaX = origin[0] - ballPosition[0];
		deltaY = origin[1] - ballPosition[1];
		deltaZ = origin[2] - ballPosition[2];

		float distance;
		// IN YARDS
		// distance = SquareRoot((deltaX * deltaX) + (deltaY * deltaY) + (deltaZ * deltaZ)) / 36.0;
		// IN METERS
		distance = SquareRoot((deltaX * deltaX) + (deltaY * deltaY) + (deltaZ * deltaZ)) * 0.0254;
		CPrintToChatAll("{%s}[%s] {%s}dist: %fm | x: %f, y: %f, z: %f | x len: %f, y len: %f, z len: %f", prefixcolor, prefix, textcolor, distance, origin[0], origin[1], origin[2], xWidth, yWidth, zWidth);

		int beam;
		while ((beam = GetEntityIndexByName("gk_area_beam", "env_beam")) != -1) AcceptEntityInput(beam, "Kill");
		DrawLaser("gk_area_beam", origin[0], origin[1], origin[2], origin[0] + 200.0, origin[1], origin[2], "0 0 255");

		OpenMenuGKAreas(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}
// ************************************************** END TEST **************************************************

// ***************************************************************************************************************
// ************************************************** MAPS MENU **************************************************
// ***************************************************************************************************************
public void OpenMenuMaps(int client)
{
	Menu menu = new Menu(MenuHandlerMaps);

	menu.SetTitle("Soccer mod - Admin - Settings - Allowed Maps");

	menu.AddItem("add", "Add Map");

	menu.AddItem("remove", "Remove Map");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerMaps(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "add"))					  OpenMenuMapsAdd(client);
		else if (StrEqual(menuItem, "remove"))			  OpenMenuMapsRemove(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ******************************************************************************************************************
// ************************************************** ADD MAP MENU **************************************************
// ******************************************************************************************************************
public void OpenMenuMapsAdd(int client)
{
	Menu menu = new Menu(MenuHandlerMapsAdd);

	menu.SetTitle("Soccer mod - Admin - Settings - Allowed Maps - Add");

	OpenMapsDirectory("maps", menu);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerMapsAdd(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char map[128];
		menu.GetItem(choice, map, sizeof(map));

		if (FindStringInArray(allowedMaps, map) > -1) CPrintToChat(client, "{%s}[%s] {%s}%s is already added to the allowed maps list.", prefixcolor, prefix, textcolor, map);
		else
		{
			PushArrayString(allowedMaps, map);
			SaveAllowedMaps();

			CPrintToChat(client, "{%s}[%s] {%s}%s added to the allowed maps list.", prefixcolor, prefix, textcolor, map);
		}

		OpenMenuMaps(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMaps(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *********************************************************************************************************************
// ************************************************** REMOVE MAP MENU **************************************************
// *********************************************************************************************************************
public void OpenMenuMapsRemove(int client)
{
	File file = OpenFile(allowedMapsConfigFile, "r");

	if (file != null)
	{
		Menu menu = new Menu(MenuHandlerMapsRemove);

		menu.SetTitle("Soccer Mod - Admin - Settings - Allowed Maps - Remove");

		char map[128];
		int length;

		while (!file.EndOfFile() && file.ReadLine(map, sizeof(map)))
		{
			length = strlen(map);
			if (map[length - 1] == '\n') map[--length] = '\0';

			if (map[0] != '/' && map[1] != '/' && map[0]) menu.AddItem(map, map);
		}

		file.Close();
		menu.ExitBackButton = true;
		menu.Display(client, MENU_TIME_FOREVER);
	}
	else
	{
		CPrintToChat(client, "{%s}[%s] {%s}Allowed maps list is empty.", prefixcolor, prefix, textcolor);
		OpenMenuMaps(client);
	}
}

public int MenuHandlerMapsRemove(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char map[128];
		menu.GetItem(choice, map, sizeof(map));

		if (FindStringInArray(allowedMaps, map) > -1)
		{
			int index = FindStringInArray(allowedMaps, map);
			RemoveFromArray(allowedMaps, index);
			SaveAllowedMaps();
			LoadAllowedMaps();

			CPrintToChat(client, "{%s}[%s] {%s}%s removed from the allowed maps list.", prefixcolor, prefix, textcolor, map);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}%s is already removed from the allowed maps list.", prefixcolor, prefix, textcolor, map);

		OpenMenuMaps(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMaps(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// ************************************************* CHAT LISTENER ***************************************************
// *******************************************************************************************************************

public void LockSet(int client, char type[32], int intnumber, int min, int max)
{
	//int min = 0;
	//int max = 20, max2 = 600, max3 = 120;
	if (intnumber >= min && intnumber <= max || intnumber == 0)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

		if (StrEqual(type, "LockServerNum"))
		{
			if(intnumber != 0)
			{
				PWMAXPLAYERS = (intnumber-1);
				UpdateConfigInt("Admin Settings", "soccer_mod_passwordlock_max", PWMAXPLAYERS+1);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the number of allowed players in a cap to %i.", prefixcolor, prefix, textcolor, client, intnumber);
				}

				LogMessage("%N <%s> has set the max allowed players in the cap to %i", client, steamid, intnumber);
			}
			else 
			{
				OpenMenuLockSet(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		if (StrEqual(type, "CaptchaNum"))
		{
			if(intnumber != 0)
			{
				afk_kicktime = float(intnumber);
				UpdateConfigFloat("Admin Settings", "soccer_mod_afk_time", afk_kicktime);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the allowed AFK time to %i seconds.", prefixcolor, prefix, textcolor, client, intnumber);
				}

				LogMessage("%N <%s> has set the allowed AFK time to %i seconds.", client, steamid, intnumber);
			}
			else 
			{
				OpenMenuLockSet(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}		
		if (StrEqual(type, "MenuNum"))
		{
			if(intnumber != 0)
			{
				afk_menutime = intnumber;
				UpdateConfigInt("Admin Settings", "soccer_mod_afk_menu", afk_menutime);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the captcha solve time to %i seconds.", prefixcolor, prefix, textcolor, client, intnumber);
				}

				LogMessage("%N <%s> has set the captcha solve time to %i seconds.", client, steamid, intnumber);
			}
			else 
			{
				OpenMenuLockSet(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		
		changeSetting[client] = "";
		OpenMenuLockSet(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Type a value between %i and %i", prefixcolor, prefix, textcolor, min, max);
}