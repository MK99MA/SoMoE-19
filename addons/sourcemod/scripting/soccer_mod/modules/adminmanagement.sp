// *******************************************************************************************************************
// ************************************************ ADMIN MANAGEMENT *************************************************
// *******************************************************************************************************************
bool adminRemoved;

char adminFlags[64];
char adminGroup[64];
char adminImmunity[64];
char adminName[64];
char adminSteamID[64];
char clientName[50];
char group[32];
char SteamID[20];
char szFlags[32];
char szTarget2[64];

int addoredit;
int adminmode;
int playerindex = 1;



// *******************************************************************************************************************
// *************************************************** ADMIN MENU ****************************************************
// *******************************************************************************************************************

public void OpenMenuAdminSet(int client)
{	
	Menu menu = new Menu(MenuHandlerAdminSet);
	menu.SetTitle("Manage Admins");

	menu.AddItem("AddAdmin", "Add Admin");
	menu.AddItem("EditAdmin", "Edit Admin");
	menu.AddItem("RemoveAdmin", "Remove Admin");
	menu.AddItem("AdminLists", "Admin Lists");
	menu.AddItem("OnlineLists", "Online Lists");
	
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
		if (StrEqual(menuItem, "EditAdmin"))
		{
			OpenMenuEditAdmin(client);
		}
		if (StrEqual(menuItem, "RemoveAdmin"))
		{
			OpenMenuRemoveAdmin(client);
		}
		else if (StrEqual(menuItem, "AdminLists"))
		{
			OpenMenuAdminLists(client);
		}
		else if (StrEqual(menuItem, "OnlineLists"))
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
// *************************************************** PLAYERLIST ****************************************************

public void OpenMenuAddAdmin(int client)
{
	char userid[64];
	
	Menu menu = new Menu(MenuHandlerAddAdmin);
	menu.SetTitle("Add Admin: Player List");

	for (playerindex = 1; playerindex <= MaxClients; playerindex++)
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
		//AdminId ID = GetUserAdmin(userindex2);
		/*if(ID != INVALID_ADMIN_ID)
		{
			playerindex = 1;
			char targetName[50]
			targetName = clientName;
			if(IsSMAdmin(SteamID)) CPrintToChat(client, "{%s}[%s] {%s}%s(%s) is already Sourcemod admin.", prefixcolor, prefix, textcolor, targetName, clientName);
			else CPrintToChat(client, "{%s}[%s] {%s}%s is already admin (%s in: admins_simple.ini).", prefixcolor, prefix, textcolor, clientName, SteamID);
			OpenMenuAddAdmin(client);
		}
		else if(IsSoccerAdmin(userindex2))
		{
			playerindex = 1;
			CPrintToChat(client, "{%s}[%s] {%s}%s is already Soccer Mod admin.", prefixcolor, prefix, textcolor, clientName);
			OpenMenuAddAdmin(client);
		}
		else 
		{
			OpenMenuAddAdminType(client);
		}*/
		OpenMenuAddAdminType(client);
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
			adminmode = 1;
			AddSoccerAdminMenuFunc(client);
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

// *************************************************** ADMIN VALUES ****************************************************

public void OpenMenuAddAdminValues(int client)
{
	char nameString[256], steamidString[256], flagString[32], immunityString[32], groupString[128];
	
	if (!IsSMAdmin(SteamID))
	{
		AddAdminFunc(SteamID);
		ReadAdminFile();
	}
	else if (IsSMAdmin(SteamID)) ReadAdminFile();
	
	Format(nameString, sizeof(nameString), "Name: %s", adminName);
	Format(steamidString, sizeof(steamidString), "SteamID: %s",SteamID);
	Format(flagString, sizeof(flagString), "Flags: %s", adminFlags);
	Format(immunityString, sizeof(immunityString), "Immunity: %s", adminImmunity);
	Format(groupString, sizeof(groupString), "Group: %s", adminGroup);
	
	Menu menu = new Menu(MenuHandlerAddAdminValues);
	menu.SetTitle("Properties of %s", adminName);
	
	menu.AddItem("sm_name", nameString);
	menu.AddItem("sm_flag", flagString);
	menu.AddItem("sm_immunity", immunityString);
	menu.AddItem("sm_group", groupString);
	menu.AddItem("sm_id", steamidString, ITEMDRAW_DISABLED);
	menu.AddItem("", "-------------------", ITEMDRAW_DISABLED);
	menu.AddItem("confirm", "Reload Admins & Return");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAddAdminValues(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[32];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	
	if (action == MenuAction_Select)
	{
		if (StrEqual(menuItem, "sm_name"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type in the new name for %s, !cancel to stop.", prefixcolor, prefix, textcolor, adminName);
			changeSetting[client] = "AdminNameValue";
		}
		else if (StrEqual(menuItem, "sm_flag"))
		{
			OpenMenuFlagInfo(client, 0);
			CPrintToChat(client, "{%s}[%s] {%s}Type in the desired flags (see menu) for %s, !cancel to stop.", prefixcolor, prefix, textcolor, adminName);
			changeSetting[client] = "AdminFlagsValue";
		}
		else if (StrEqual(menuItem, "sm_immunity"))
		{
			CPrintToChat(client, "{%s}[%s] {%s}Type in the desired immunity (0-99) for %s, !cancel to stop.", prefixcolor, prefix, textcolor, adminName);
			changeSetting[client] = "AdminImmunityValue";
		}
		else if (StrEqual(menuItem, "sm_group"))
		{
			OpenMenuGroupList(client);
		}
		else if (StrEqual(menuItem, "confirm"))
		{
			FakeClientCommandEx(client, "sm_reloadadmins");
			ResetAdminValues();
			OpenMenuAdminSet(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)
	{
		if (addoredit == 1) OpenMenuEditList(client);
		else if(addoredit == 0) OpenMenuAddAdminType(client);
		else if(addoredit == 2) OpenMenuPromoteAdminFlags(client);
	}
	else if (action == MenuAction_End)					  menu.Close();
}

// *************************************************** GROUPLIST ****************************************************

public void OpenMenuGroupList(int client)
{
	Menu menu = new Menu(MenuHandlerGroupList);
	menu.SetTitle("Available Groups:");
	
	int length = groupArray.Length;
	for  (int i = 0; i < length; i++)
	{
		groupArray.GetString(i, group, sizeof(group));
		if ((StrContains(group, "immunity") == -1 && StrContains(group, "flags") == -1 && StrContains(group, "Groups") == -1 && StrContains(group, "allow") == -1 && StrContains(group, "deny") == -1 && StrContains(group, "}") == -1))
		{
			menu.AddItem(group, group);
		}
	}
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerGroupList(Menu menu, MenuAction action, int client, int choice)
{
	menu.GetItem(choice, group, sizeof(group));
	
	if (action == MenuAction_Select)
	{
		char buffer[64];
		buffer = group;
		UpdateAdmin(adminName, "group", buffer, 1);	
		CPrintToChat(client, "{%s}[%s] {%s}Updated Group to %s", prefixcolor, prefix, textcolor, buffer);
		OpenMenuAddAdminValues(client);
	}
	else if (action == MenuAction_Cancel && choice == -6) 	OpenMenuAddAdminValues(client);
	else if (action == MenuAction_End)					  menu.Close();
}


// *******************************************************************************************************************
// ************************************************ PROMOTE ADMINS ***************************************************
// *******************************************************************************************************************
public void OpenMenuEditAdmin(int client)
{
	Menu menu = new Menu(MenuHandlerEditAdmin);
	menu.SetTitle("Edit Admin");
	
	menu.AddItem("editSM", "Edit SM Admin");
	menu.AddItem("promote", "Promote Soccer Admin");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);	
}

public int MenuHandlerEditAdmin(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[32];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	
	if (action == MenuAction_Select)
	{
		if (StrEqual(menuItem, "editSM"))
		{
			OpenMenuEditList(client);
		}
		else if (StrEqual(menuItem, "promote"))
		{
			OpenMenuPromoteAdmin(client);
		}
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminSet(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *************************************************** ADMINLISTS ****************************************************

public void OpenMenuEditList(int client)
{
	Menu menu = new Menu(MenuHandlerEditList);
	menu.SetTitle("Admins.cfg Admin List");
	
	kvSMAdmins = new KeyValues("Admins");
	kvSMAdmins.ImportFromFile(adminSMFileKV);
	
	if (kvSMAdmins.GotoFirstSubKey() == false) 
	{
		CPrintToChat(client, "{%s}[%s] {%s}No admins found in admins.cfg", prefixcolor, prefix, textcolor)
		OpenMenuEditAdmin(client);
		
		kvSMAdmins.Rewind();
		kvSMAdmins.Close();	
	}
	else
	{
		kvSMAdmins.GotoFirstSubKey();
		
		do
		{
			kvSMAdmins.GetSectionName(clientName, sizeof(clientName));
			kvSMAdmins.GetString("identity", SteamID, sizeof(SteamID));
			
			menu.AddItem(clientName, clientName);
		}
		while (kvSMAdmins.GotoNextKey());
	}
	
	kvSMAdmins.Rewind();
	kvSMAdmins.Close();	
		
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);	
}

public int MenuHandlerEditList(Menu menu, MenuAction action, int client, int choice)
{
	menu.GetItem(choice, clientName, sizeof(clientName));
	if (action == MenuAction_Select)
	{
		addoredit = 1;
		OpenMenuAddAdminValues(client);
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuEditAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuPromoteAdmin(int client)
{
	Menu menu = new Menu(MenuHandlerPromoteAdmin);
	menu.SetTitle("Soccer Mod Admin List");
	
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	
	if (kvAdmins.GotoFirstSubKey() == false) 
	{
		CPrintToChat(client, "{%s}[%s] {%s}No Soccer Mod admins found", prefixcolor, prefix, textcolor)
		OpenMenuEditAdmin(client);
		
		kvAdmins.Rewind();
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
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuEditAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *************************************************** PROMOTE SELECTION ****************************************************

public void OpenMenuPromoteAdminFlags(int client)
{
	Menu menu = new Menu(MenuHandlerPromoteAdminFlags);
	menu.SetTitle("Promote %s to:", clientName);

	menu.AddItem("addadminsm", "admins.cfg");
	menu.AddItem("", "No further ingame editing:", ITEMDRAW_DISABLED);
	menu.AddItem("addadminfull", "Admins_simple: Root Admin");
	menu.AddItem("addadmincustom", "Admins_simple: Custom Flags");
	
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
			AddAdminSimpleMenuFunc(client);
		}
		else if(StrEqual(menuItem, "addadminsm"))
		{
			RemoveSoccerAdminMenuFunc(client);
			addoredit = 2;
			OpenMenuAddAdminValues(client)
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
	menu.SetTitle("Remove Admin");
	
	menu.AddItem("removeSM", "Remove SM Admin");
	menu.AddItem("removeSoccer", "Remove Soccer Admin");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);	
}

public int MenuHandlerRemoveAdmin(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[32];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	
	if (action == MenuAction_Select)
	{
		if (StrEqual(menuItem, "removeSM"))
		{
			OpenMenuRemoveSMAdmin(client);
		}
		else if (StrEqual(menuItem, "removeSoccer"))
		{
			OpenMenuRemoveSoccerAdmin(client);
		}
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminSet(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *************************************************** ADMINLISTS ****************************************************

public void OpenMenuRemoveSMAdmin(int client)
{
	Menu menu = new Menu(MenuHandlerRemoveSMAdmin);
	menu.SetTitle("Admins.cfg Admin List");
	
	kvSMAdmins = new KeyValues("Admins");
	kvSMAdmins.ImportFromFile(adminSMFileKV);
	
	if (kvSMAdmins.GotoFirstSubKey() == false) 
	{
		CPrintToChat(client, "{%s}[%s] {%s}No admins found in admins.cfg", prefixcolor, prefix, textcolor)
		OpenMenuRemoveAdmin(client);
		
		kvSMAdmins.Rewind();
		kvSMAdmins.Close();	
	}
	else
	{
		kvSMAdmins.GotoFirstSubKey();
		
		do
		{
			kvSMAdmins.GetSectionName(clientName, sizeof(clientName));
			kvSMAdmins.GetString("identity", SteamID, sizeof(SteamID));
			
			menu.AddItem(clientName, clientName);
		}
		while (kvSMAdmins.GotoNextKey());
	}
	
	kvSMAdmins.Rewind();
	kvSMAdmins.Close();	
		
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);	
}

public int MenuHandlerRemoveSMAdmin(Menu menu, MenuAction action, int client, int choice)
{
	menu.GetItem(choice, clientName, sizeof(clientName));
	if (action == MenuAction_Select)
	{
		RemoveSMAdminMenuFunc(clientName);
		FakeClientCommandEx(client, "sm_reloadadmins");
		adminRemoved = true;
		CPrintToChat(client, "{%s}[%s] {%s}%s was removed from the Sourcemod adminlist", prefixcolor, prefix, textcolor, clientName);
		OpenMenuRemoveAdmin(client);
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuRemoveAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuRemoveSoccerAdmin(int client)
{
	Menu menu = new Menu(MenuHandlerRemoveSoccerAdmin);
	menu.SetTitle("Soccer Mod Admin List");
	
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	
	if (kvAdmins.GotoFirstSubKey() == false) 
	{
		CPrintToChat(client, "{%s}[%s] {%s}No Soccer Mod admins found", prefixcolor, prefix, textcolor)
		OpenMenuRemoveAdmin(client);
		
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

public int MenuHandlerRemoveSoccerAdmin(Menu menu, MenuAction action, int client, int choice)
{
	adminRemoved = false;
	menu.GetItem(choice, SteamID, sizeof(SteamID));
	if (action == MenuAction_Select)
	{
		RemoveSoccerAdminMenuFunc(client);
		adminRemoved = true;
		CPrintToChat(client, "{%s}[%s] {%s}%s was removed from the Soccer Mod adminlist", prefixcolor, prefix, textcolor, clientName);
		OpenMenuRemoveAdmin(client);
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuRemoveAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// ************************************************** ADMIN LIST *****************************************************
// *******************************************************************************************************************
public void OpenMenuAdminLists(int client)
{
	Menu menu = new Menu(MenuHandlerAdminLists);
	menu.SetTitle("Admin Lists");
	
	menu.AddItem("Soccerlist", "Soccer Mod List");
	menu.AddItem("SMlist", "Admins.cfg List");
	menu.AddItem("Simplelist", "Admins_simple.ini List");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);	
}

public int MenuHandlerAdminLists(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[32];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	
	if (action == MenuAction_Select)
	{
		if (StrEqual(menuItem, "Soccerlist"))
		{
			OpenMenuAdminListSoccerMod(client);
		}
		else if (StrEqual(menuItem, "SMlist"))
		{
			OpenMenuAdminListSM(client);
		}
		else if (StrEqual(menuItem, "Simplelist"))
		{
			OpenMenuAdminListSimple(client);
		}
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminSet(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *************************************************** SM LIST ******************************************************

public void OpenMenuAdminListSM(int client)
{
	Menu menu = new Menu(MenuHandlerAdminlistSM);
	menu.SetTitle("Admins.cfg Admin List");
	
	kvSMAdmins = new KeyValues("Admins");
	kvSMAdmins.ImportFromFile(adminSMFileKV);
	
	if (kvSMAdmins.GotoFirstSubKey() == false) 
	{
		CPrintToChat(client, "{%s}[%s] {%s}No admins found in admins.cfg", prefixcolor, prefix, textcolor)
		OpenMenuAdminLists(client);
		
		kvSMAdmins.Rewind();
		kvSMAdmins.Close();	
	}
	else
	{
		kvSMAdmins.GotoFirstSubKey();
		
		do
		{
			kvSMAdmins.GetSectionName(clientName, sizeof(clientName));
			kvSMAdmins.GetString("identity", SteamID, sizeof(SteamID));
			
			menu.AddItem(clientName, clientName, ITEMDRAW_DISABLED);
		}
		while (kvSMAdmins.GotoNextKey());
	}
	
	kvSMAdmins.Rewind();
	kvSMAdmins.Close();	
		
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);	
}

public int MenuHandlerAdminlistSM(Menu menu, MenuAction action, int client, int choice)
{
	menu.GetItem(choice, SteamID, sizeof(SteamID));
	if (action == MenuAction_Select)
	{
		CPrintToChat(client, "How?");
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminLists(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ************************************************** SIMPLE LIST *****************************************************

public void OpenMenuAdminListSimple(int client)
{
	char sLine[128];
	char szFile[256];
	File hFile;
	//char regexLine[128] = "^.\\[.:\\d:[0-9]+\\].\\s.[0-9]+:[a-zA-Z]+.";
	
	Menu menu = new Menu(MenuHandlerAdminlistSimple);
	menu.SetTitle("Admins_simple List");

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
	
	if(GetMenuItemCount(menu) == 0)
	{
		menu.AddItem(SteamID, "No admins found", ITEMDRAW_DISABLED);
		//CPrintToChat(client, "{%s}[%s] {%s}No admins found", prefixcolor, prefix, textcolor);
		//OpenMenuAdminLists(client);
	}
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAdminlistSimple(Menu menu, MenuAction action, int client, int choice)
{
	menu.GetItem(choice, SteamID, sizeof(SteamID));
	if (action == MenuAction_Select)
	{
		CPrintToChat(client, "How?");
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminLists(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ************************************************** SOCCER LIST *****************************************************

public void OpenMenuAdminListSoccerMod(int client)
{
	Menu menu = new Menu(MenuHandlerAdminlistSoccerMod);
	menu.SetTitle("Soccer Mod Admin List");
	
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	
	if (kvAdmins.GotoFirstSubKey() == false) 
	{
		CPrintToChat(client, "{%s}[%s] {%s}No Soccer Mod admins found", prefixcolor, prefix, textcolor);
		OpenMenuAdminLists(client);
		
		kvAdmins.Rewind();
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
	kvAdmins.Close();	
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerAdminlistSoccerMod(Menu menu, MenuAction action, int client, int choice)
{
	menu.GetItem(choice, SteamID, sizeof(SteamID));
	if (action == MenuAction_Select)
	{
		CPrintToChat(client, "How?");
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminLists(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// ************************************************** ONLINE LIST ****************************************************
// *******************************************************************************************************************

public void OpenMenuOnlineAdmin(int client)
{
	Menu menu = new Menu(MenuHandlerOnlineAdmin);
	menu.SetTitle("Online Admin lists");
	
	menu.AddItem("Adminonline", "Admin Online List");
	menu.AddItem("SMonline", "Sourcemod Online List");
	menu.AddItem("Socceronline", "Soccer Online List");
	
	if(menuaccessed == true) menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerOnlineAdmin(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[32];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	
	if (action == MenuAction_Select)
	{
		if (StrEqual(menuItem, "SMonline"))
		{
			OpenMenuOnlineAdminSourcemod(client);
		}
		else if (StrEqual(menuItem, "Socceronline"))
		{
			OpenMenuOnlineSoccerAdmin(client);
		}
		else if (StrEqual(menuItem, "Adminonline"))
		{
			OpenMenuOnlineAdminAll(client);
		}
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminSet(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuOnlineAdminAll(int client)
{
	//bool onserver = false;
	int onlinecount = 0;
	
	Menu menu = new Menu(MenuHandlerOnlineAdminAll);
	menu.SetTitle("Online Admins");

	for (int clientindex = 1; clientindex <= MaxClients; clientindex++)
	{
		if (IsClientInGame(clientindex))
		{
			if (adminRemoved)	RemoveAllMenuItems(menu);
			if(GetUserAdmin(clientindex) != INVALID_ADMIN_ID)
			{
				char AdminName[64];
				GetClientName(clientindex, AdminName, sizeof(AdminName));
				menu.AddItem(AdminName, AdminName, ITEMDRAW_DISABLED);
				onlinecount++;
				//if(!onserver) onserver = true;
			}
			else if (IsSoccerAdmin(clientindex))
			{
				char AdminName[64];
				GetClientName(clientindex, AdminName, sizeof(AdminName));
				menu.AddItem(AdminName, AdminName, ITEMDRAW_DISABLED);
				onlinecount++;
				//if(!onserver) onserver = true;
			}
		}
	}
	if(onlinecount == 0) menu.AddItem("", "No Admins on the server", ITEMDRAW_DISABLED);
	//if(!onserver) menu.AddItem("", "No Sourcemod Admins on the server", ITEMDRAW_DISABLED);
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerOnlineAdminAll(Menu menu, MenuAction action, int client, int choice)
{
	menu.GetItem(choice, clientName, sizeof(clientName));
	if (action == MenuAction_Select)
	{
		PrintToChatAll("bla");
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuOnlineAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}


public void OpenMenuOnlineAdminSourcemod(int client)
{
	//bool onserver = false;
	int onlinecount = 0;
	
	Menu menu = new Menu(MenuHandlerOnlineAdminSourcemod);
	menu.SetTitle("Online Admins");

	for (int clientindex = 1; clientindex <= MaxClients; clientindex++)
	{
		if (IsClientInGame(clientindex))
		{
			if (adminRemoved)	RemoveAllMenuItems(menu);
			if(GetUserAdmin(clientindex) != INVALID_ADMIN_ID)
			{
				char AdminName[64];
				GetClientName(clientindex, AdminName, sizeof(AdminName));
				menu.AddItem(AdminName, AdminName, ITEMDRAW_DISABLED);
				onlinecount++;
				//if(!onserver) onserver = true;
			}
		}
	}
	if(onlinecount == 0) menu.AddItem("", "No Sourcemod Admins on the server", ITEMDRAW_DISABLED);
	//if(!onserver) menu.AddItem("", "No Sourcemod Admins on the server", ITEMDRAW_DISABLED);
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerOnlineAdminSourcemod(Menu menu, MenuAction action, int client, int choice)
{
	menu.GetItem(choice, clientName, sizeof(clientName));
	if (action == MenuAction_Select)
	{
		PrintToChatAll("bla");
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuOnlineAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuOnlineSoccerAdmin(int client)
{
	//bool onserver = false;
	int onlinecount = 0;
	
	Menu menu = new Menu(MenuHandlerOnlineAdminSoccermod);
	menu.SetTitle("Online Soccer Admins");

	for (int clientindex = 1; clientindex <= MaxClients; clientindex++)
	{
		if (IsClientInGame(clientindex))
		{
			if (IsSoccerAdmin(clientindex))
			{
				char AdminName[64];
				GetClientName(clientindex, AdminName, sizeof(AdminName));
				menu.AddItem(AdminName, AdminName, ITEMDRAW_DISABLED);
				onlinecount++;
				//if(!onserver) onserver = true;
			}
		}
	}
	if(onlinecount == 0) menu.AddItem("", "No Soccermod Admins on the server", ITEMDRAW_DISABLED);
	//if(!onserver) menu.AddItem("", "No Soccermod Admins on the server", ITEMDRAW_DISABLED);
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerOnlineAdminSoccermod(Menu menu, MenuAction action, int client, int choice)
{
	menu.GetItem(choice, clientName, sizeof(clientName));
	if (action == MenuAction_Select)
	{
		PrintToChatAll("bla");
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuOnlineAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *******************************************************************************************************************
// *************************************************** FUNCTIONS *****************************************************
// *******************************************************************************************************************
// ************************************************** CHECK FUNCS ****************************************************
public bool IsSoccerAdmin(int client)
{
	char buffer[32];
	bool check = false;
	GetClientAuthId(client, AuthId_Engine, SteamID, sizeof(SteamID))
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	if(kvAdmins.GotoFirstSubKey())
	{
		do
		{
			kvAdmins.GetSectionName(buffer, sizeof(buffer));
			if (StrEqual(buffer, SteamID)) check = true;
		}
		while (kvAdmins.GotoNextKey());
	}
	else return false;
	
	kvAdmins.Rewind();
	kvAdmins.Close();	
	
	if(check) return true;
	else return false;
}

public bool IsSMAdmin(char SteamIDbuffer[20])
{
	char buffer[32];
	bool check = false;
	kvSMAdmins = new KeyValues("Admins");
	kvSMAdmins.ImportFromFile(adminSMFileKV);
	if(kvSMAdmins.GotoFirstSubKey())
	{
		do
		{
			kvSMAdmins.GetString("identity", buffer, sizeof(buffer), "undefined");
			if (StrEqual(buffer, SteamIDbuffer))
			{
				kvSMAdmins.GetSectionName(clientName, sizeof(clientName));
				check = true;
			}
		}
		while (kvSMAdmins.GotoNextKey());
	}
	else return false;
	
	kvSMAdmins.Rewind();
	kvSMAdmins.Close();	
	
	if(check) return true;
	else return false;
}

public void ParseAdminGroups(ArrayList array)
{
	char line[128];
	char pattern[] =  "(\"[\\w ]+\")"		//"(\"[a-zA-Z0-9\s]+\"|\"[a-zA-Z0-9_]+\")"  ; //ANPASSEN
	Regex regex = CompileRegex(pattern);
	
	BuildPath(Path_SM, adminGroupFileKV, sizeof(adminGroupFileKV), "configs/admin_groups.cfg");

	File hFile = OpenFile(adminGroupFileKV, "r");

	while (ReadFileLine(hFile, line, sizeof(line)) && !hFile.EndOfFile())
	{
		if (MatchRegex(regex, line) > 0 && StrContains(line, "*") == -1) 
		{
			TrimString(line);
			StripQuotes(line);
			array.PushString(line);
		}
	}
	
	hFile.Close();
}

public bool IsGroupDefined(char groupName[64])
{
	if ((FindStringInArray(groupArray, groupName) == -1) || (StrEqual(groupName, "flags") || StrEqual(groupName, "immunity")))
	{
		return false;
	}
	else return true;
}

// ************************************************ ADMINS.CFG FUNC **************************************************

public void ReadAdminFile()
{
	kvSMAdmins = new KeyValues("Admins")
	kvSMAdmins.ImportFromFile(adminSMFileKV);
	kvSMAdmins.GotoFirstSubKey()
	
	do
	{
		kvSMAdmins.GetString("identity", adminSteamID, sizeof(adminSteamID), "Not set");
		if (StrEqual(adminSteamID, SteamID))
		{		
			kvSMAdmins.GetSectionName(adminName, sizeof(adminName));
			kvSMAdmins.GetString("flags", adminFlags, sizeof(adminFlags), "Not set");
			kvSMAdmins.GetString("immunity", adminImmunity, sizeof(adminImmunity), "Not set");
			kvSMAdmins.GetString("group", adminGroup, sizeof(adminGroup), "Not set");
		}
	}
	while (kvSMAdmins.GotoNextKey());
	
	kvSMAdmins.Rewind();
	kvSMAdmins.Close();
}

public void AddAdminFunc(char SteamIDbuffer[20])
{
	kvSMAdmins = new KeyValues("Admins")
	kvSMAdmins.ImportFromFile(adminSMFileKV);
	
	adminFlags = "Not Set";
	adminGroup = "Not Set";
	adminImmunity = "0";
	kvSMAdmins.JumpToKey(clientName, true);
	adminName = clientName;
	kvSMAdmins.SetString("auth", "steam");
	kvSMAdmins.SetString("identity", SteamID);
	kvSMAdmins.SetString("flags", adminFlags);
	kvSMAdmins.SetString("immunity", adminImmunity);
	kvSMAdmins.SetString("group", adminGroup);
	
	kvSMAdmins.Rewind();
	kvSMAdmins.ExportToFile(adminSMFileKV);
	kvSMAdmins.Close();	
}

public void UpdateAdmin(char section[64], char type[32], char value[64], int mode)
{
	kvSMAdmins = new KeyValues("Admins")
	kvSMAdmins.ImportFromFile(adminSMFileKV);
	
	kvSMAdmins.JumpToKey(section, false);
	if(mode == 0)	kvSMAdmins.SetSectionName(value);
	else if (mode == 1)	kvSMAdmins.SetString(type, value);
	
	kvSMAdmins.Rewind();
	kvSMAdmins.ExportToFile(adminSMFileKV);
	kvSMAdmins.Close();
}

public void RemoveSMAdminMenuFunc(char section[50])
{
	kvSMAdmins = new KeyValues("Admins");
	kvSMAdmins.ImportFromFile(adminSMFileKV);
	
	kvSMAdmins.JumpToKey(section, false);	
	kvSMAdmins.DeleteThis();
	
	kvSMAdmins.Rewind();
	kvSMAdmins.ExportToFile(adminSMFileKV);
	kvSMAdmins.Close();
}

// ************************************************ ADMINS_SIMPLE FUNC *************************************************

public void AddAdminSimpleMenuFunc(int client)
{
	szTarget2 = SteamID;
	
	char szFile[256];
	BuildPath(Path_SM, szFile, sizeof(szFile), "configs/admins_simple.ini");

	File hFile = OpenFile(szFile, "at");
	
	if(adminmode == 2)
	{
		OpenMenuFlagInfo(client, 1);
		CPrintToChat(client, "{%s}[%s] {%s}Enter the desired flags, remember to include flag 'b' for Soccer Mod rights. !cancel to stop.", prefixcolor, prefix, textcolor);
		changeSetting[client] = "CustFlag";
	}
	else if (adminmode == 0)
	{
		WriteFileLine(hFile, "\"%s\" \"99:z\"	//%s", szTarget2, clientName);
		CPrintToChat(client, "{%s}[%s] {%s}%s was added with root access.", prefixcolor, prefix, textcolor, clientName);
		if(addoredit == 0) OpenMenuAddAdmin(client);
		else OpenMenuPromoteAdmin(client)
	}

	hFile.Close();
	FakeClientCommandEx(client, "sm_reloadadmins");
}

// ************************************************* SOCCERMOD FUNC ***************************************************

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
	
	CPrintToChat(client, "{%s}[%s] {%s}%s was added as a Soccer Mod admin.", prefixcolor, prefix, textcolor, clientName);
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

public void AdminSetListener(int client, char type[32], char admin_value[64], int min, int max)
{
	if (strlen(admin_value) >= min && strlen(admin_value) <= max)
	{
		if (StrEqual(type, "AdminNameValue"))
		{
			if(!StrEqual(admin_value, "!cancel"))
			{
				UpdateAdmin(adminName, "", admin_value, 0);
				
				CPrintToChat(client, "{%s}[%s] {%s}Updated name to %s", prefixcolor, prefix, textcolor, admin_value);
			}
			else 
			{
				OpenMenuAddAdminValues(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		if (StrEqual(type, "AdminFlagsValue"))
		{
			if(!StrEqual(admin_value, "!cancel"))
			{
				UpdateAdmin(adminName, "flags", admin_value, 1);

				CPrintToChat(client, "{%s}[%s] {%s}Updated flags to %s", prefixcolor, prefix, textcolor, admin_value);
			}
			else 
			{
				OpenMenuAddAdminValues(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		if (StrEqual(type, "AdminImmunityValue"))
		{
			if(!StrEqual(admin_value, "!cancel"))
			{
				int buffer = StringToInt(admin_value);
				if(buffer <= 99)
				{
					UpdateAdmin(adminName, "immunity", admin_value, 1);
					
					CPrintToChat(client, "{%s}[%s] {%s}Updated immunity to %s", prefixcolor, prefix, textcolor, admin_value);
				}
				else CPrintToChat(client, "{%s}[%s] {%s}Please choose a value between 0 and 99.", prefixcolor, prefix, textcolor);
			}
			else 
			{
				OpenMenuAddAdminValues(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}

		changeSetting[client] = "";
		OpenMenuAddAdminValues(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Type a value between %i and %i.", prefixcolor, prefix, textcolor, min, max);
}


public void CustomFlagListener(int client, char type[32], char custom_flag[32])
{
	int min = 0;
	int max = 40;
	if (strlen(custom_flag) >= min && strlen(custom_flag) <= max)
	{
		//char steamid[32];
		//GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		GetClientName(client, clientName, sizeof(clientName));
		szTarget2 = SteamID;
	
		char szFile[256];
		BuildPath(Path_SM, szFile, sizeof(szFile), "configs/admins_simple.ini");

		Handle hFile = OpenFile(szFile, "at");

		if (StrEqual(type, "CustFlag"))
		{
			if(!StrEqual(custom_flag, "!cancel"))
			{
				szFlags = custom_flag;
			
				WriteFileLine(hFile, "\"%s\" \"%s\"	// %s", szTarget2, szFlags, clientName);
				CPrintToChat(client, "{%s}[%s] {%s}%s was added with the flags of %s.", prefixcolor, prefix, textcolor, clientName, szFlags);

				CloseHandle(hFile);

				changeSetting[client] = "";
				OpenMenuAdminSet(client);
			}
			else 
			{
				OpenMenuAdminSet(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
	}
	else CPrintToChat(client, "{%s}[%s] {%s}List of flags is too long. Please use a shorter combination with %i to %i characters", prefixcolor, prefix, textcolor, min, max);
}

// *******************************************************************************************************************
// ********************************************** WARNING & FLAGLIST *************************************************
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
	menu.AddItem("", "ROOT ADMIN allows the user to add, edit or remove admins!", ITEMDRAW_DISABLED);
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
			AddAdminSimpleMenuFunc(client);
		}
		else if (StrEqual(menuItem, "No"))
		{
			OpenMenuAddAdminType(client);
		}
	}		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAddAdminType(client);
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
			AddAdminSimpleMenuFunc(client);
		}
		else if (StrEqual(menuItem, "No"))
		{
			OpenMenuPromoteAdminFlags(client);
		}
	}		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuPromoteAdminFlags(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuFlagInfo(int client, int mode)
{
	Menu menu = new Menu(MenuHandlerFlagInfo);
	menu.SetTitle("Available Flags");
	
	if (mode == 0)
	{
		menu.AddItem("inputformat", "Example: abcejk", ITEMDRAW_DISABLED);
	}
	if (mode == 1)
	{
		menu.AddItem("inputformat", "Example: 50:abcejk", ITEMDRAW_DISABLED);
		menu.AddItem("immunity", "Immunity: 0 - 99", ITEMDRAW_DISABLED);
	}
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
	menu.AddItem("m_flag", "[m] - rcon (adminmanagement)", ITEMDRAW_DISABLED);
	menu.AddItem("n_flag", "[n] - cheats", ITEMDRAW_DISABLED);
	menu.AddItem("z_flag", "[z] - root", ITEMDRAW_DISABLED);
	
	
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerFlagInfo(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_End)					  menu.Close();
}

public void ResetAdminValues()
{
	adminName = "";
	adminSteamID = "";
	adminImmunity = "";
	adminFlags = "";
	adminGroup = "";
}