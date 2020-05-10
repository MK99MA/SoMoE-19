// *******************************************************************************************************************
// *************************************************** ADD ADMINS ****************************************************
// *******************************************************************************************************************
// *************************************************** PLAYERLIST **************************************************** 

public void OpenMenuAddAdmin(int client)
{
	char userid[64], playerName[64];
	
	Menu menu = new Menu(MenuHandlerAddAdmin);
	menu.SetTitle("Add Admin: Player List");

	for (playerindex = 1; playerindex <= MaxClients; playerindex++)
	{
		if (IsClientInGame(playerindex) && IsClientConnected(playerindex) && !IsFakeClient(playerindex) && !IsClientSourceTV(playerindex))
		{
			GetClientName(playerindex, playerName, sizeof(playerName));
			//GetClientAuthId(playerindex, AuthId_Engine, SteamID, sizeof(SteamID)); 
			IntToString(GetClientUserId(playerindex), userid, sizeof(userid));
			AddMenuItem(menu, userid, playerName);
		}
	}
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAddAdmin(Menu menu, MenuAction action, int client, int choice)
{
	char userid[64];
	int userindex;
	menu.GetItem(choice, userid, sizeof(userid));
	if (action == MenuAction_Select)
	{
		//int userindex = StringToInt(userid); 
		userindex = GetClientOfUserId(StringToInt(userid));
		GetClientName(userindex, clientName, sizeof(clientName));
		GetClientAuthId(userindex, AuthId_Engine, SteamID, sizeof(SteamID))
		if(!CheckCommandAccess(userindex, "generic_admin", ADMFLAG_GENERIC) && !IsSoccerAdmin(userindex, "menu"))	OpenMenuAddAdminType(client);
		else 
		{
			CPrintToChat(client, "{%s}[%s] {%s}Player is already Admin.", prefixcolor, prefix, textcolor);
			OpenMenuAddAdmin(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminSet(client);
	else if (action == MenuAction_End)					  menu.Close();
	playerindex = 1;
}

// *************************************************** TYPE SELECTION ****************************************************

public void OpenMenuAddAdminType(int client)
{
	Menu menu = new Menu(MenuHandlerAddAdminType);
	menu.SetTitle("Add %s as:", clientName);

	menu.AddItem("addadmin", "Source Mod Admin");
	menu.AddItem("addadminsoccer", "Soccer Mod Admin");
	menu.AddItem("", "No further ingame editing:", ITEMDRAW_DISABLED);
	menu.AddItem("addadminsimplefull", "Admins_simple.ini: Root Admin");
	menu.AddItem("addadminsimplecustom", "Admins_simple.ini: Custom Flags");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAddAdminType(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[32];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	
	if (action == MenuAction_Select)
	{
		if (StrEqual(menuItem, "addadminsimplefull"))
		{
			addoredit = 0;
			OpenMenuWarning(client);
		}
		else if (StrEqual(menuItem, "addadminsoccer"))
		{
			addoredit = 0;
			adminmode = 1;
			AddSoccerAdminMenuFunc(client);
			OpenMenuSoccerAdminModules(client);
		}
		else if (StrEqual(menuItem, "addadminsimplecustom"))
		{
			adminmode = 2;
			AddAdminSimpleMenuFunc(client);
		}
		else if (StrEqual(menuItem, "addadmin"))
		{
			addoredit = 0;
			CPrintToChat(client, "{%s}[%s] {%s}%s added as an admin", prefixcolor, prefix, textcolor, clientName);
			OpenMenuAddAdminValues(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6) 	OpenMenuAddAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}