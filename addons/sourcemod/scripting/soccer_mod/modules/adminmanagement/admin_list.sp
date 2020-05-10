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
