// *******************************************************************************************************************
// ************************************************ PROMOTE ADMINS ***************************************************
// *******************************************************************************************************************
public void OpenMenuEditAdmin(int client)
{
	Menu menu = new Menu(MenuHandlerEditAdmin);
	menu.SetTitle("Edit Admin");
	
	menu.AddItem("editSM", "Edit SM Admin");
	menu.AddItem("editSoccer", "Edit Soccer Admin");
	menu.AddItem("blank", "###########################", ITEMDRAW_DISABLED);
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
			promoteoredit = 0;
			OpenMenuEditSoccerAdmin(client);
		}
		else if (StrEqual(menuItem, "editSoccer"))
		{
			promoteoredit = 1;
			OpenMenuEditSoccerAdmin(client);
		}
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuAdminSet(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *************************************************** ADMINLISTS **************************************************** 

public void OpenMenuEditList(int client)
{
	char name[64];
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
			kvSMAdmins.GetSectionName(name, sizeof(name));
			kvSMAdmins.GetString("identity", SteamID, sizeof(SteamID)); 
			
			menu.AddItem(SteamID, name);
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
	char menuItem[20];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	if (action == MenuAction_Select)
	{
		SteamID = menuItem;
		addoredit = 1;
		OpenMenuAddAdminValues(client);
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuEditAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenMenuEditSoccerAdmin(int client)
{
	char temp_SteamID[20], name[64];
	Menu menu = new Menu(MenuHandlerEditSoccerAdmin);
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
		do
		{
			kvAdmins.GetSectionName(temp_SteamID, sizeof(temp_SteamID));
			kvAdmins.GetString("name", name, sizeof(name));
			
			if(!GetAdminFlag(FindAdminByIdentity("steam", temp_SteamID), Admin_Generic)) menu.AddItem(temp_SteamID, name);
			else menu.AddItem(temp_SteamID, name, ITEMDRAW_DISABLED);
		}
		while (kvAdmins.GotoNextKey());
	}
	
	kvAdmins.Rewind();
	kvAdmins.Close();	
		
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);	
}

public int MenuHandlerEditSoccerAdmin(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[20];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	if (action == MenuAction_Select)
	{
		SteamID = menuItem;
	
		if(promoteoredit == 0)		OpenMenuPromoteAdminFlags(client);
		else if(promoteoredit == 1)	
		{
			addoredit = 1;
			OpenMenuSoccerAdminModules(client);
		}
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuEditAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// *************************************************** PROMOTE SELECTION ****************************************************

public void OpenMenuPromoteAdminFlags(int client)
{
	char name[50];
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	
	kvAdmins.JumpToKey(SteamID, false);
	kvAdmins.GetString("name", name, sizeof(name));
	
	kvAdmins.Rewind();
	kvAdmins.Close();
	
	clientName = name;
	
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
	else if (action == MenuAction_Cancel && choice == -6)  OpenMenuEditAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}