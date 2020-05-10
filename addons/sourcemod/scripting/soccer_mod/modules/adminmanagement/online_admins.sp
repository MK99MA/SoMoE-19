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
	
	if(menuaccessed[client] == true) menu.ExitBackButton = true;
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
			else if (IsSoccerAdmin(clientindex, "menu"))
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
			if (IsSoccerAdmin(clientindex, "menu"))
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