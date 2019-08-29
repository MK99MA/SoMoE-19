// *******************************************************************************************************************
// ************************************************ ADMIN MANAGEMENT *************************************************
// *******************************************************************************************************************
bool adminRemoved;
char SteamID[20];
char clientName[50];
char szFlags[32];
char szTarget2[64];
int playerCount = 0;
int playerindex = 1;
int adminmode;
int addoredit;


public void OpenMenuAdminSet(int client)
{
	playerCount = GetClientCount(true);
	
	Menu menu = new Menu(MenuHandlerAdminSet);
	menu.SetTitle("Manage Admins");

	menu.AddItem("AddAdmin", "Add Admin");
	menu.AddItem("PromoteAdmin", "Promote Admin");
	menu.AddItem("RemoveAdmin", "Remove SoccerMod Admin");
	menu.AddItem("SoccerAdminList", "Soccermod Admin List");
	menu.AddItem("SourceAdminList", "Sourcemod Admin List");
	menu.AddItem("OnlineAdmin", "Online Admins");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAdminSet(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[32];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	
	if (action == MenuAction_Select)
	{
		if (StrEqual(menuItem, "AddAdmin"))
		{
			OpenMenuAddAdmin(client);
		}
		if (StrEqual(menuItem, "PromoteAdmin"))
		{
			OpenMenuPromoteAdmin(client);
		}
		if (StrEqual(menuItem, "RemoveAdmin"))
		{
			OpenMenuRemoveAdmin(client);
		}
		else if (StrEqual(menuItem, "SourceAdminList"))
		{
			OpenMenuAdminListSourceMod(client);
		}
		else if (StrEqual(menuItem, "SoccerAdminList"))
		{
			OpenMenuAdminListSoccerMod(client);
		}
		else if (StrEqual(menuItem, "OnlineAdmin"))
		{
			menuaccessed = true;
			OpenMenuOnlineAdmin(client);
		}
	}	
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// *************************************************** ADD ADMINS ****************************************************
// *******************************************************************************************************************

public void OpenMenuAddAdmin(int client)
{
	playerCount = GetClientCount(true);
	char userid[64];
	
	Menu menu = new Menu(MenuHandlerAddAdmin);
	menu.SetTitle("Player List");

	for (playerindex = 1; playerindex <= playerCount; playerindex++)
	{
		if (IsClientInGame(playerindex) && IsClientConnected(playerindex) && !IsFakeClient(playerindex) && !IsClientSourceTV(playerindex))
		{
			GetClientName(playerindex, clientName, sizeof(clientName));
			//GetClientAuthId(playerindex, AuthId_Engine, SteamID, sizeof(SteamID));
			IntToString(GetClientUserId(playerindex), userid, sizeof(userid));
			AddMenuItem(menu, userid, clientName);
		}
	}
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAddAdmin(Menu menu, MenuAction action, int client, int choice)
{
	char userid[64];
	int userindex2;
	menu.GetItem(choice, userid, sizeof(userid));
	if (action == MenuAction_Select)
	{
		int userindex = StringToInt(userid);
		userindex2 = GetClientOfUserId(userindex);
		GetClientName(userindex2, clientName, sizeof(clientName));
		//PrintToChatAll(clientName);
		GetClientAuthId(userindex2, AuthId_Engine, SteamID, sizeof(SteamID))
		//PrintToChatAll(SteamID);
		AdminId ID = GetUserAdmin(userindex2);
		if(ID != INVALID_ADMIN_ID)
		{
			playerindex = 1;
			CPrintToChat(client, "{%s}[%s] {%s}%s is already SourceMod Admin.", prefixcolor, prefix, textcolor, clientName);
			OpenMenuAddAdmin(client);
		}
		else if(IsSoccerAdmin(userindex2))
		{
			playerindex = 1;
			CPrintToChat(client, "{%s}[%s] {%s}%s is already SoccerMod Admin.", prefixcolor, prefix, textcolor, clientName);
			OpenMenuAddAdmin(client);
		}
		else 
		{
			OpenMenuAddAdminFlags(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminSet(client);
	else if (action == MenuAction_End)					  menu.Close();
	playerindex = 1;
}

public void OpenMenuAddAdminFlags(int client)
{
	Menu menu = new Menu(MenuHandlerAddAdminFlags);
	menu.SetTitle("Add %s as:", clientName);

	menu.AddItem("addadminfull", "Sourcemod: Root Admin");
	menu.AddItem("addadminsoccer", "Soccer Mod Admin");
	menu.AddItem("addadmincustom", "Sourcemod: Custom Flags");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAddAdminFlags(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[32];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	
	if (action == MenuAction_Select)
	{
		if (StrEqual(menuItem, "addadminfull"))
		{
			addoredit = 0;
			OpenMenuWarning(client);
		}
		else if (StrEqual(menuItem, "addadminsoccer"))
		{
			adminmode = 1;
			AddSoccerAdminMenuFunc(client);
		}
		else if (StrEqual(menuItem, "addadmincustom"))
		{
			adminmode = 2;
			AddAdminMenuFunc(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6) 	OpenMenuAddAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuFlagInfo(int client)
{
	Menu menu = new Menu(MenuHandlerFlagInfo);
	menu.SetTitle("Available Flags");
	
	menu.AddItem("inputformat", "Example: 50:abcejk", ITEMDRAW_DISABLED);
	menu.AddItem("immunity", "Immunity: 0 - 99", ITEMDRAW_DISABLED);
	menu.AddItem("a_flag", "[a] - reservation", ITEMDRAW_DISABLED);
	menu.AddItem("b_flag", "[b] - generic (soccermod)", ITEMDRAW_DISABLED);
	menu.AddItem("c_flag", "[c] - kick", ITEMDRAW_DISABLED);
	menu.AddItem("d_flag", "[d] - ban", ITEMDRAW_DISABLED);
	menu.AddItem("e_flag", "[e] - unban", ITEMDRAW_DISABLED);
	menu.AddItem("f_flag", "[f] - slay", ITEMDRAW_DISABLED);
	menu.AddItem("g_flag", "[g] - changemap", ITEMDRAW_DISABLED);
	menu.AddItem("h_flag", "[h] - cvars", ITEMDRAW_DISABLED);
	menu.AddItem("i_flag", "[i] - config", ITEMDRAW_DISABLED);
	menu.AddItem("j_flag", "[j] - chat", ITEMDRAW_DISABLED);
	menu.AddItem("k_flag", "[k] - vote", ITEMDRAW_DISABLED);
	menu.AddItem("l_flag", "[l] - password", ITEMDRAW_DISABLED);
	menu.AddItem("m_flag", "[m] - rcon", ITEMDRAW_DISABLED);
	menu.AddItem("n_flag", "[n] - cheats", ITEMDRAW_DISABLED);
	menu.AddItem("z_flag", "[z] - root", ITEMDRAW_DISABLED);
	
	
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerFlagInfo(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// ************************************************ PROMOTE ADMINS ***************************************************
// *******************************************************************************************************************

public void OpenMenuPromoteAdmin(int client)
{
	Menu menu = new Menu(MenuHandlerPromoteAdmin);
	menu.SetTitle("SoccerMod Admin List");
	
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	
	if (kvAdmins.GotoFirstSubKey() == false) 
	{
		CPrintToChat(client, "{%s}[%s] {%s} No Soccermod Admins found", prefixcolor, prefix, textcolor)
		OpenMenuAdminSet(client);
		
		kvAdmins.Rewind();
		kvAdmins.ExportToFile(adminFileKV);
		kvAdmins.Close();	
	}
	else
	{
		kvAdmins.GotoFirstSubKey();
		
		do
		{
			kvAdmins.GetSectionName(SteamID, sizeof(SteamID));
			kvAdmins.GetString("name", clientName, sizeof(clientName));
			
			menu.AddItem(clientName, clientName);
		}
		while (kvAdmins.GotoNextKey());
	}
	
	kvAdmins.Rewind();
	kvAdmins.ExportToFile(adminFileKV);
	kvAdmins.Close();	
		
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);	
}

public int MenuHandlerPromoteAdmin(Menu menu, MenuAction action, int client, int choice)
{
	menu.GetItem(choice, clientName, sizeof(clientName));
	if (action == MenuAction_Select)
	{
		OpenMenuPromoteAdminFlags(client);
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminSet(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuPromoteAdminFlags(int client)
{
	Menu menu = new Menu(MenuHandlerPromoteAdminFlags);
	menu.SetTitle("Promote %s to:", clientName);

	menu.AddItem("addadminfull", "Sourcemod: Root Admin");
	menu.AddItem("addadmincustom", "Sourcemod: Custom Flags");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerPromoteAdminFlags(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[32];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	
	if (action == MenuAction_Select)
	{
		if (StrEqual(menuItem, "addadminfull"))
		{
			addoredit = 1;
			OpenMenuWarning(client);
		}
		else if (StrEqual(menuItem, "addadmincustom"))
		{
			adminmode = 2;
			RemoveSoccerAdminMenuFunc(client);
			AddAdminMenuFunc(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)  OpenMenuPromoteAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// ************************************************* REMOVE ADMINS ***************************************************
// *******************************************************************************************************************
public void OpenMenuRemoveAdmin(int client)
{
	Menu menu = new Menu(MenuHandlerRemoveAdmin);
	menu.SetTitle("SoccerMod Admin List");
	
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	
	if (kvAdmins.GotoFirstSubKey() == false) 
	{
		CPrintToChat(client, "{%s}[%s] {%s} No Soccermod Admins found", prefixcolor, prefix, textcolor)
		OpenMenuAdminSet(client);
		
		kvAdmins.Rewind();
		kvAdmins.ExportToFile(adminFileKV);
		kvAdmins.Close();	
	}
	else
	{
		kvAdmins.GotoFirstSubKey();
		
		do
		{
			kvAdmins.GetSectionName(SteamID, sizeof(SteamID));
			kvAdmins.GetString("name", clientName, sizeof(clientName));
			
			menu.AddItem(SteamID, clientName);
		}
		while (kvAdmins.GotoNextKey());
	}
	
	kvAdmins.Rewind();
	kvAdmins.ExportToFile(adminFileKV);
	kvAdmins.Close();	
		
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);	
}

public int MenuHandlerRemoveAdmin(Menu menu, MenuAction action, int client, int choice)
{
	adminRemoved = false;
	menu.GetItem(choice, clientName, sizeof(clientName));
	if (action == MenuAction_Select)
	{
		RemoveSoccerAdminMenuFunc(client);
		adminRemoved = true;
		CPrintToChat(client, "{%s}[%s] {%s} %s was removed from the SoccerMod Adminlist", prefixcolor, prefix, textcolor, clientName);
		OpenMenuAdminSet(client);
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminSet(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// **************************************************** WARNING ******************************************************
// *******************************************************************************************************************

public void OpenMenuWarning(int client)
{
	Menu menu 
	if (addoredit == 0) menu = new Menu(MenuHandlerAddWarning);
	else if (addoredit == 1) menu = new Menu(MenuHandlerPromoteWarning);
	menu.SetTitle("ATTENTION");
	
	char warning[128];
	Format(warning, sizeof(warning), "Are you sure you want to grant %s ROOT ADMIN access?", clientName);
	
	menu.AddItem("", warning, ITEMDRAW_DISABLED);
	menu.AddItem("", "ROOT ADMIN allows the user to add Admins or to remove SoccerMod Admins!", ITEMDRAW_DISABLED);
	menu.AddItem("Yes", "Yes");
	menu.AddItem("No", "No");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);	
}

public int MenuHandlerAddWarning(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[32];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	
	if (action == MenuAction_Select)
	{
		if (StrEqual(menuItem, "Yes"))
		{
			adminmode = 0;
			AddAdminMenuFunc(client);
		}
		else if (StrEqual(menuItem, "No"))
		{
			OpenMenuAddAdminFlags(client);
		}
	}		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAddAdminFlags(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public int MenuHandlerPromoteWarning(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[32];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	
	if (action == MenuAction_Select)
	{
		if (StrEqual(menuItem, "Yes"))
		{
			adminmode = 0;
			RemoveSoccerAdminMenuFunc(client)
			AddAdminMenuFunc(client);
		}
		else if (StrEqual(menuItem, "No"))
		{
			OpenMenuPromoteAdminFlags(client);
		}
	}		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuPromoteAdminFlags(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// ************************************************** ADMIN LIST *****************************************************
// *******************************************************************************************************************

public void OpenMenuAdminListSourceMod(int client)
{
	char sLine[128];
	char szFile[256];
	File hFile;
	//char regexLine[128] = "^.\\[.:\\d:[0-9]+\\].\\s.[0-9]+:[a-zA-Z]+.";
	
	Menu menu = new Menu(MenuHandlerAdminlistSourceMod);
	menu.SetTitle("Sourcemod Admin List");

	BuildPath(Path_SM, szFile, sizeof(szFile), "configs/admins_simple.ini");
	
	hFile = OpenFile(szFile, "r");
	
	while (!hFile.EndOfFile() && hFile.ReadLine(sLine, sizeof(sLine)))
	{
		if(!(StrContains(sLine, "\"[U:") == -1))
		{
			menu.AddItem(SteamID, sLine, ITEMDRAW_DISABLED);
		}
	}
	hFile.Close();
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAdminlistSourceMod(Menu menu, MenuAction action, int client, int choice)
{
	menu.GetItem(choice, SteamID, sizeof(SteamID));
	if (action == MenuAction_Select)
	{
		//Auswahl -> Add admin flags -> EditAdminMenuFunc
		OpenMenuAddAdminFlags(client);
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminSet(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuAdminListSoccerMod(int client)
{
	Menu menu = new Menu(MenuHandlerAdminlistSoccerMod);
	menu.SetTitle("Soccermod Admin List");
	
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	
	if (kvAdmins.GotoFirstSubKey() == false) 
	{
		CPrintToChat(client, "{%s}[%s] {%s} No Soccermod Admins found", prefixcolor, prefix, textcolor)
		OpenMenuAdminSet(client);
		
		kvAdmins.Rewind();
		kvAdmins.ExportToFile(adminFileKV);
		kvAdmins.Close();	
	}
	else
	{
		kvAdmins.GotoFirstSubKey();
		
		do
		{
			kvAdmins.GetSectionName(SteamID, sizeof(SteamID));
			kvAdmins.GetString("name", clientName, sizeof(clientName));
			
			menu.AddItem(SteamID, clientName, ITEMDRAW_DISABLED);
		}
		while (kvAdmins.GotoNextKey());
	}
	
	kvAdmins.Rewind();
	kvAdmins.ExportToFile(adminFileKV);
	kvAdmins.Close();	
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAdminlistSoccerMod(Menu menu, MenuAction action, int client, int choice)
{
	menu.GetItem(choice, SteamID, sizeof(SteamID));
	if (action == MenuAction_Select)
	{
		//Auswahl -> Add admin flags -> EditAdminMenuFunc
		OpenMenuAddAdminFlags(client);
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminSet(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// ************************************************** ONLINE LIST ****************************************************
// *******************************************************************************************************************

public void OpenMenuOnlineAdmin(int client)
{
	playerCount = GetClientCount(true);
	bool onserver = false;
	
	Menu menu = new Menu(MenuHandlerOnlineAdminSourceMod);
	menu.SetTitle("Online Admins");

	for (playerindex = 1; playerindex <= playerCount; playerindex++)
	{
		if (IsClientInGame(playerindex) && IsClientConnected(playerindex) && !IsFakeClient(playerindex) && !IsClientSourceTV(playerindex))
		{
			if (adminRemoved)	RemoveAllMenuItems(menu);
			AdminId ID = GetUserAdmin(playerindex);
			if(ID != INVALID_ADMIN_ID)
			{
				char AdminName[64];
				GetClientName(playerindex, AdminName, sizeof(AdminName));
				menu.AddItem(AdminName, AdminName, ITEMDRAW_DISABLED);
				if(!onserver) onserver = true;
			}
			else if (IsSoccerAdmin)
			{
				char AdminName[64];
				GetClientName(playerindex, AdminName, sizeof(AdminName));
				menu.AddItem(AdminName, AdminName, ITEMDRAW_DISABLED);
				if(!onserver) onserver = true;
			}
		}
	}
	if(!onserver) menu.AddItem("", "No Admins on the server");
	
	if(menuaccessed == true) menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerOnlineAdminSourceMod(Menu menu, MenuAction action, int client, int choice)
{
	menu.GetItem(choice, clientName, sizeof(clientName));
	if (action == MenuAction_Select)
	{
		PrintToChatAll("bla");
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminSet(client);
	else if (action == MenuAction_End)					  menu.Close();
}



// *******************************************************************************************************************
// *************************************************** FUNCTIONS *****************************************************
// *******************************************************************************************************************
public bool IsSoccerAdmin(int client)
{
	char buffer[32];
	bool check = false;
	GetClientAuthId(client, AuthId_Engine, SteamID, sizeof(SteamID))
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	kvAdmins.GotoFirstSubKey();
	
	do
	{
		kvAdmins.GetSectionName(buffer, sizeof(buffer));
		if (StrEqual(buffer, SteamID)) check = true;
	}
	while (kvAdmins.GotoNextKey());
	
	kvAdmins.Rewind();
	kvAdmins.ExportToFile(adminFileKV);
	kvAdmins.Close();	
	
	if(check) return true;
	else return false;
}

public void AddAdminMenuFunc(int client)
{
	szTarget2 = SteamID;
	
	char szFile[256];
	BuildPath(Path_SM, szFile, sizeof(szFile), "configs/admins_simple.ini");

	File hFile = OpenFile(szFile, "at");
	
	if(adminmode == 2)
	{
		OpenMenuFlagInfo(client);
		CPrintToChat(client, "{%s}[%s] {%s}Enter the desired flags, remember to include flag 'b' for soccermod rights.", prefixcolor, prefix, textcolor);
		changeSetting[client] = "CustFlag";
	}
	else if (adminmode == 0)
	{
		WriteFileLine(hFile, "\"%s\" \"99:z\"	//%s", szTarget2, clientName);
		CPrintToChat(client, "{%s}[%s] {%s}%s was added as a Full Admin.", prefixcolor, prefix, textcolor, clientName);
		OpenMenuAddAdmin(client);
	}

	hFile.Close();
	FakeClientCommandEx(client, "sm_reloadadmins");
}

public void AddSoccerAdminMenuFunc(int client)
{
	szTarget2 = SteamID;
	
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	
	kvAdmins.JumpToKey(szTarget2, true);
	kvAdmins.SetString("name", clientName);	
	
	kvAdmins.Rewind();
	kvAdmins.ExportToFile(adminFileKV);
	kvAdmins.Close();	
	
	CPrintToChat(client, "{%s}[%s] {%s}%s was added as a Soccer Mod Admin.", prefixcolor, prefix, textcolor, clientName);
	OpenMenuAddAdmin(client);
}

public void RemoveSoccerAdminMenuFunc(int client)
{	
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	
	kvAdmins.JumpToKey(SteamID);	
	kvAdmins.DeleteThis();
	
	kvAdmins.Rewind();
	kvAdmins.ExportToFile(adminFileKV);
	kvAdmins.Close();		
}

// *******************************************************************************************************************
// ************************************************* CHAT LISTENER ***************************************************
// *******************************************************************************************************************

public void CustomFlagListener(int client, char type[32], char custom_flag[32])
{
	int min = 0;
	int max = 40;
	if (strlen(custom_flag) >= min && strlen(custom_flag) <= max)
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		szTarget2 = SteamID;
	
		char szFile[256];
		BuildPath(Path_SM, szFile, sizeof(szFile), "configs/admins_simple.ini");

		Handle hFile = OpenFile(szFile, "at");

		if (StrEqual(type, "CustFlag"))
		{
			szFlags = custom_flag;
		
			WriteFileLine(hFile, "\"%s\" \"%s\"	// %s", szTarget2, szFlags, clientName);
			CPrintToChat(client, "{%s}[%s] {%s}%s was added with the flags of %s.", prefixcolor, prefix, textcolor, clientName, szFlags);

			CloseHandle(hFile);

			changeSetting[client] = "";
			OpenMenuAddAdmin(client);
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}List of flags is too long. Please use a shorter combination with %i to %i characters", prefixcolor, prefix, textcolor, min, max);
}
