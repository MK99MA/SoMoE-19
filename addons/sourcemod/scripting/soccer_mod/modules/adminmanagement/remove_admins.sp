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
	char name[64], info[128];
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
		do
		{
			kvAdmins.GetSectionName(SteamID, sizeof(SteamID));
			kvAdmins.GetString("name", name, sizeof(name));
			Format(info, sizeof(info), "%s,|,%s", SteamID, name);

			menu.AddItem(info, name);
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
	char menuItem[128], name[64];
	adminRemoved = false;
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	if (action == MenuAction_Select)
	{
		char infoarray[2][128];
		char splitter[16] = ",|,";
		ExplodeString(menuItem, splitter, infoarray, sizeof(infoarray), sizeof(infoarray[]))
		strcopy(SteamID, sizeof(SteamID), infoarray[0]);
		strcopy(name, sizeof(name), infoarray[1]);
		RemoveSoccerAdminMenuFunc(client);
		adminRemoved = true;
		CPrintToChat(client, "{%s}[%s] {%s}Admin %s was removed from the Soccer Mod adminlist", prefixcolor, prefix, textcolor, name);
		OpenMenuRemoveAdmin(client);
	}
		
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuRemoveAdmin(client);
	else if (action == MenuAction_End)					  menu.Close();
}