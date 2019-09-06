// *******************************************************************************************************************
// ************************************************** SETTINGS MENU **************************************************
// *******************************************************************************************************************
public void OpenMenuSettings(int client)
{
	Menu menu = new Menu(MenuHandlerSettings);

	menu.SetTitle("Soccer Mod - Admin - Settings");

	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true)) menu.AddItem("adminset", "Manage Admins");
	menu.AddItem("chatset", "Chat Settings");
	menu.AddItem("maps", "Allowed Maps");
	menu.AddItem("pubmode", "Public Mode");
	menu.AddItem("lockenabled", "Lock Server");

	menu.AddItem("skinsmenu", "Skins");

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
		else if (StrEqual(menuItem, "lockenabled"))
		{
			if(!pwchange) OpenMenuLockSet(client);
			else 
			{
				CPrintToChat(client, "{%s}[%s] {%s}You can't access this menu until the Capmatch started!", prefixcolor, prefix, textcolor);
				OpenMenuSettings(client);
			}
		}
		else if (StrEqual(menuItem, "adminset")) if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true))		OpenMenuAdminSet(client);
		else if (currentMapAllowed)
		{
			if (StrEqual(menuItem, "gk_areas"))		OpenMenuGKAreas(client);
		}
		else
		{
			CPrintToChat(client, "{%s}[%s] {%s}Soccer Mod is not allowed on this map", prefixcolor, prefix, textcolor);
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
	char currentLockSet[64];
	char lockstate[32];
	if(passwordlock == 1) lockstate = "On"
	else if(passwordlock == 0) lockstate = "Off"
	Format(currentLockSet, sizeof(currentLockSet), "Locking: %s | Threshold: %i", lockstate, PWMAXPLAYERS+1);
	Menu menu = new Menu(MenuHandlerLockSet);

	menu.SetTitle("Soccer Mod - Admin - Settings - Lock");

	menu.AddItem("enable", "Enable ServerLock");
	menu.AddItem("disable", "Disable ServerLock");
	menu.AddItem("locknumber", "Player Threshold");
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
			CPrintToChatAll("{%s}[%s] {%s}Server will lock itself", prefixcolor, prefix, textcolor);
			OpenMenuLockSet(client);
		}
		else if (StrEqual(menuItem, "disable"))
		{
			passwordlock = 0;
			UpdateConfigInt("Admin Settings", "soccer_mod_passwordlock", passwordlock);
			CPrintToChatAll("{%s}[%s] {%s}Server won't lock itself", prefixcolor, prefix, textcolor);
			OpenMenuLockSet(client);
		}
		else if (StrEqual(menuItem, "locknumber"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type in the maximum allowed players for a cap, current setting is %i", prefixcolor, prefix, textcolor, PWMAXPLAYERS+1);
			changeSetting[client] = "LockServerNum";
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
			CPrintToChatAll("{%s}[%s] {%s}Publicmode set to Admins only", prefixcolor, prefix, textcolor);
			OpenMenuPubMode(client);
		}
		else if (StrEqual(menuItem, "pub_com"))
		{
			publicmode = 1;
			UpdateConfigInt("Admin Settings", "soccer_mod_pubmode", publicmode);
			CPrintToChatAll("{%s}[%s] {%s}Publicmode set to public !cap and !match", prefixcolor, prefix, textcolor);
			OpenMenuPubMode(client);
		}
		else if (StrEqual(menuItem, "pub_menu"))
		{
			publicmode = 2;
			UpdateConfigInt("Admin Settings", "soccer_mod_pubmode", publicmode);
			CPrintToChatAll("{%s}[%s] {%s}Publicmode set to public menu", prefixcolor, prefix, textcolor);
			OpenMenuPubMode(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}


// ***************************************************************************************************************
// ****************************************** CHAT SETTINGS MENU *************************************************
// ***************************************************************************************************************
public void OpenMenuChat(int client)
{
	char currentChatSet[64], currentChatSet2[64];
	char mvpstate[32];
	if(MVPEnabled == 1) mvpstate = "On"
	else if(MVPEnabled == 0) mvpstate = "Off"
	Format(currentChatSet, sizeof(currentChatSet), "MVP messages: %s | Prefix: [%s]", mvpstate, prefix);
	Format(currentChatSet2, sizeof(currentChatSet2), "Prefix color: %s | Text color: %s", prefixcolor, textcolor);
	Menu menu = new Menu(MenuHandlerChat);

	menu.SetTitle("Soccer Mod - Settings - Chat");

	menu.AddItem("chatstyle", "Chat Style");
	
	menu.AddItem("mvpset", "MVP Messages");
	
	menu.AddItem("deadchatset", "Dead Chat");
	
	menu.AddItem("locknumber", currentChatSet, ITEMDRAW_DISABLED);
	menu.AddItem("locknumber", currentChatSet2, ITEMDRAW_DISABLED);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerChat(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "chatstyle")) 					OpenMenuChatStyle(client);
		else if (StrEqual(menuItem, "mvpset"))					OpenMenuMVPSet(client);
		else if (StrEqual(menuItem, "deadchatset"))				OpenMenuDeadChatSet(client);
	}

	else if (action == MenuAction_Cancel && choice == -6)		OpenMenuSettings(client);
	else if (action == MenuAction_End)							menu.Close();
}

public void OpenMenuChatStyle(int client)
{
	Menu menu = new Menu(MenuHandlerChatStyle);

	menu.SetTitle("Soccer Mod - Settings - Chat Style");

	menu.AddItem("ch_prefix", "Chat Prefix");

	menu.AddItem("prefix_col", "Prefix Color");

	menu.AddItem("text_col", "Text Color");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerChatStyle(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "ch_prefix"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type in your prefix without [] and \" around them, current prefix is %s", prefixcolor, prefix, textcolor, prefix);
			changeSetting[client] = "CustomPrefix";
		}
		else if (StrEqual(menuItem, "prefix_col"))
		{
			OpenMenuColorlist(client);
			CPrintToChat(client, "{%s}[%s] {%s}Type in your desired prefixcolor, current prefixcolor is %s", prefixcolor, prefix, textcolor, prefixcolor);
			changeSetting[client] = "CustomPrefixCol";
		}
		else if (StrEqual(menuItem, "text_col"))
		{
			OpenMenuColorlist(client);
			CPrintToChat(client, "{%s}[%s] {%s}Type in your desired textcolor, current textcolor is %s", prefixcolor, prefix, textcolor, textcolor);
			changeSetting[client] = "TextCol";
		}
	}

	else if (action == MenuAction_Cancel && choice == -6)	   OpenMenuChat(client);
	else if (action == MenuAction_End)						  menu.Close();
}


public void OpenMenuMVPSet(int client)
{
	Menu menu = new Menu(MenuHandlerMVPSet);
	menu.SetTitle("Soccer Mod - Match Settings - MVP Display");

	menu.AddItem("enable", "Enable");

	menu.AddItem("disable", "Disable");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerMVPSet(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "enable"))
		{
			MVPEnabled = 1;
			UpdateConfigInt("Chat Settings", "soccer_mod_mvp", MVPEnabled);
			CPrintToChatAll("{%s}[%s] {%s}MVP messages and stars enabled", prefixcolor, prefix, textcolor);
			OpenMenuMVPSet(client);
		}
		else if (StrEqual(menuItem, "disable"))
		{
			MVPEnabled = 0;
			UpdateConfigInt("Chat Settings", "soccer_mod_mvp", MVPEnabled);
			CPrintToChatAll("{%s}[%s] {%s}MVP messages and stars disabled", prefixcolor, prefix, textcolor);
			OpenMenuMVPSet(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuChat(client);
	else if (action == MenuAction_End)					  menu.Close();
}


public void OpenMenuDeadChatSet(int client)
{
	char currentDeadChatSet[64], currentDeadChatSet2[64], dcstate[32], dcvisstate[32];
	if(DeadChatMode == 1) dcstate = "On";
	else if(DeadChatMode == 0) dcstate = "Off";
	else if(DeadChatMode == 2) dcstate = "Alltalk";
	if(DeadChatVis == 1) dcvisstate = "Teammates";
	else if(DeadChatVis == 0) dcvisstate = "Default";
	else if(DeadChatVis == 2) dcvisstate = "Everyone";
	
	Format(currentDeadChatSet, sizeof(currentDeadChatSet), "DeadChat: %s ", dcstate);
	Format(currentDeadChatSet2, sizeof(currentDeadChatSet2), "Visibility: %s", dcvisstate);
	Menu menu = new Menu(MenuHandlerDeadChatSet);
	menu.SetTitle("Soccer Mod - Match Settings - MVP Display");

	menu.AddItem("enable", "Enable");

	menu.AddItem("alltalk", "Enable if Alltalk On");

	menu.AddItem("disable", "Disable");
	
	menu.AddItem("visibility", "Visibility");
	
	menu.AddItem("locknumber", currentDeadChatSet, ITEMDRAW_DISABLED);
	menu.AddItem("locknumber", currentDeadChatSet2, ITEMDRAW_DISABLED);

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerDeadChatSet(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "enable"))
		{
			DeadChatMode = 1;
			UpdateConfigInt("Chat Settings", "soccer_mod_deadchat_mode", DeadChatMode);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat enabled", prefixcolor, prefix, textcolor);
			OpenMenuDeadChatSet(client);
		}
		else if (StrEqual(menuItem, "disable"))
		{
			DeadChatMode = 0;
			UpdateConfigInt("Chat Settings", "soccer_mod_deadchat_mode", DeadChatMode);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat disabled", prefixcolor, prefix, textcolor);
			OpenMenuDeadChatSet(client);
		}
		else if (StrEqual(menuItem, "alltalk"))
		{
			DeadChatMode = 2;
			UpdateConfigInt("Chat Settings", "soccer_mod_deadchat_mode", DeadChatMode);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat enabled if sv_alltalk = 1", prefixcolor, prefix, textcolor);
			OpenMenuDeadChatSet(client);
		}
		else if (StrEqual(menuItem, "visibility"))
		{
			OpenMenuDeadChatSetVis(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuChat(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuDeadChatSetVis(int client)
{

	Menu menu = new Menu(MenuHandlerDeadChatSetVis);
	menu.SetTitle("Soccer Mod - Match Settings - MVP Display");

	menu.AddItem("default", "Default");

	menu.AddItem("teammates", "All Teammates");

	menu.AddItem("everyone", "Everyone");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerDeadChatSetVis(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[16];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "default"))
		{
			DeadChatVis = 0;
			UpdateConfigInt("Chat Settings", "soccer_mod_deadchat_visibility", DeadChatVis);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat visibility set to default", prefixcolor, prefix, textcolor);
			OpenMenuDeadChatSetVis(client);
		}
		else if (StrEqual(menuItem, "teammates"))
		{
			DeadChatVis = 1;
			UpdateConfigInt("Chat Settings", "soccer_mod_deadchat_visibility", DeadChatVis);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat visibility set to teammates", prefixcolor, prefix, textcolor);
			OpenMenuDeadChatSetVis(client);
		}
		else if (StrEqual(menuItem, "everyone"))
		{
			DeadChatVis = 2;
			UpdateConfigInt("Chat Settings", "soccer_mod_deadchat_visibility", DeadChatVis);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat visibility set to everyone", prefixcolor, prefix, textcolor);
			OpenMenuDeadChatSetVis(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuDeadChatSet(client);
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
		CPrintToChatAll("{%s}[%s] {%s} dist: %fm | x: %f, y: %f, z: %f | x len: %f, y len: %f, z len: %f", prefixcolor, prefix, textcolor, distance, origin[0], origin[1], origin[2], xWidth, yWidth, zWidth);

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

		if (FindStringInArray(allowedMaps, map) > -1) CPrintToChat(client, "{%s}[%s] {%s}%s is already added to the allowed maps list", prefixcolor, prefix, textcolor, map);
		else
		{
			PushArrayString(allowedMaps, map);
			SaveAllowedMaps();

			CPrintToChat(client, "{%s}[%s] {%s}%s added to the allowed maps list", prefixcolor, prefix, textcolor, map);
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
		CPrintToChat(client, "{%s}[%s] {%s}Allowed maps list is empty", prefixcolor, prefix, textcolor);
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

			CPrintToChat(client, "{%s}[%s] {%s}%s removed from the allowed maps list", prefixcolor, prefix, textcolor, map);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}%s is already removed from the allowed maps list", prefixcolor, prefix, textcolor, map);

		OpenMenuMaps(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuMaps(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// ************************************************* CHAT LISTENER ***************************************************
// *******************************************************************************************************************
public void ChatSet(int client, char type[32], char custom_tag[32])
{
	int min = 0;
	int max = 32;
	if (strlen(custom_tag) >= min && strlen(custom_tag) <= max)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

		if (StrEqual(type, "CustomPrefix"))
		{
			prefix = custom_tag;
			UpdateConfig("Chat Settings", "soccer_mod_prefix", prefix);

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the prefix to [%s]", prefixcolor, prefix, textcolor, client, custom_tag);
			}

			LogMessage("%N <%s> has set prefix to %s", client, steamid, custom_tag);
		}
		if (StrEqual(type, "CustomPrefixCol"))
		{
			prefixcolor = custom_tag;
			UpdateConfig("Chat Settings", "soccer_mod_prefixcolor", prefixcolor);

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the prefixcolor to %s", prefixcolor, prefix, textcolor, client, custom_tag);
			}

			LogMessage("%N <%s> has set prefixcolor to %s", client, steamid, custom_tag);
		}
		if (StrEqual(type, "TextCol"))
		{
			textcolor = custom_tag;
			UpdateConfig("Chat Settings", "soccer_mod_textcolor", textcolor);

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the textcolor to %s", prefixcolor, prefix, textcolor, client, custom_tag);
			}

			LogMessage("%N <%s> has set textcolor to %s", client, steamid, custom_tag);
		}
		
		changeSetting[client] = "";
		OpenMenuChatStyle(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Prefix is too long. Please use a prefix with %i to %i characters", prefixcolor, prefix, textcolor, min, max);
}


public void LockSet(int client, char type[32], int intnumber, int min, int max)
{
	if (intnumber >= min && intnumber <= max)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

		if (StrEqual(type, "LockServerNum"))
		{
			PWMAXPLAYERS = (intnumber-1);
			UpdateConfigInt("Admin Settings", "soccer_mod_passwordlock_max", PWMAXPLAYERS+1);

			for (int player = 1; player <= MaxClients; player++)
			{
				if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the number of allowed players in a cap to %i", prefixcolor, prefix, textcolor, client, intnumber);
			}

			LogMessage("%N <%s> has set the max allowed players in the cap to %.3f", client, steamid, intnumber);
		}

		changeSetting[client] = "";
		OpenMenuLockSet(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Type a value between %i and %i", prefixcolor, prefix, textcolor, min, max);
}