// *********************************************************************************************************************
// ************************************************** CLIENT COMMANDS **************************************************
// *********************************************************************************************************************
public void ClientCommandSetGoalkeeperSkin(int client)
{
	int team = GetClientTeam(client);

	if (skinsIsGoalkeeper[client])
	{
		skinsIsGoalkeeper[client] = 0;

		if (team == 2 && FileExists(skinsModelT, true)) SetEntityModel(client, skinsModelT);
		else if (team == 3 && FileExists(skinsModelCT, true)) SetEntityModel(client, skinsModelCT);

		CPrintToChat(client, "{%s}[%s] {%s}Goalkeeper skin disabled", prefixcolor, prefix, textcolor);
	}
	else
	{
		skinsIsGoalkeeper[client] = 1;

		if (team == 2 && FileExists(skinsModelTGoalkeeper, true)) SetEntityModel(client, skinsModelTGoalkeeper);
		else if (team == 3 && FileExists(skinsModelCTGoalkeeper, true)) SetEntityModel(client, skinsModelCTGoalkeeper);

		CPrintToChat(client, "{%s}[%s] {%s}Goalkeeper skin enabled", prefixcolor, prefix, textcolor);
	}
}

// ************************************************************************************************************
// ************************************************** EVENTS **************************************************
// ************************************************************************************************************
public void SkinsOnPluginStart()
{
	if (StrEqual(gamevar, "cstrike"))
	{
		skinsModelCT			= "models/player/soccer_mod/termi/2011/away/ct_urban.mdl";
		skinsModelT			 	= "models/player/soccer_mod/termi/2011/home/ct_urban.mdl";
		skinsModelCTGoalkeeper  = "models/player/soccer_mod/termi/2011/gkaway/ct_urban.mdl";
		skinsModelTGoalkeeper   = "models/player/soccer_mod/termi/2011/gkhome/ct_urban.mdl";
	}
}

public void SkinsOnMapStart()
{
	if (!IsModelPrecached(skinsModelCT))			PrecacheModel(skinsModelCT);
	if (!IsModelPrecached(skinsModelT))			 	PrecacheModel(skinsModelT);
	if (!IsModelPrecached(skinsModelCTGoalkeeper))  PrecacheModel(skinsModelCTGoalkeeper);
	if (!IsModelPrecached(skinsModelTGoalkeeper))   PrecacheModel(skinsModelTGoalkeeper);
}

public void SkinsOnClientPutInServer(int client)
{
	skinsIsGoalkeeper[client] = 0;
}

public void SkinsEventPlayerSpawn(Event event)
{
	int userid = event.GetInt("userid");
	int client = GetClientOfUserId(userid);
	int team = GetClientTeam(client);

	if (team == 2)
	{
		if (skinsIsGoalkeeper[client])
		{
			if (FileExists(skinsModelTGoalkeeper, true))
			{
				SetEntityModel(client, skinsModelTGoalkeeper);
				DispatchKeyValue(client, "skin", skinsModelTGoalkeeperNumber);
			}
		}
		else
		{
			if (FileExists(skinsModelT, true))
			{
				SetEntityModel(client, skinsModelT);
				DispatchKeyValue(client, "skin", skinsModelTNumber);
			}
		}
	}
	else if (team == 3)
	{
		if (skinsIsGoalkeeper[client])
		{
			if (FileExists(skinsModelCTGoalkeeper, true))
			{
				SetEntityModel(client, skinsModelCTGoalkeeper);
				DispatchKeyValue(client, "skin", skinsModelCTGoalkeeperNumber);
			}
		}
		else
		{
			if (FileExists(skinsModelCT, true))
			{
				SetEntityModel(client, skinsModelCT);
				DispatchKeyValue(client, "skin", skinsModelCTNumber);
			}
		}
	}
}

// ***********************************************************************************************************
// ************************************************** MENUS **************************************************
// ***********************************************************************************************************
public void OpenSkinsMenu(int client)
{
	Menu menu = new Menu(SkinsMenuHandler);

	menu.SetTitle("Soccer Mod - Admin - Settings - Skins");

	menu.AddItem("CT", "CT");
	menu.AddItem("T", "T");
	menu.AddItem("CTGK", "CT GK");
	menu.AddItem("TGK", "T GK");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int SkinsMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		OpenSkinsSelectionMenu(client, menuItem);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public void OpenSkinsSelectionMenu(int client, char type[32])
{
	Menu menu;
	if (StrEqual(type, "CT")) menu = new Menu(SkinsCTSelectionMenuHandler);
	else if(StrEqual(type, "T")) menu = new Menu(SkinsTSelectionMenuHandler);
	else if(StrEqual(type, "CTGK")) menu = new Menu(SkinsCTGKSelectionMenuHandler);
	else if(StrEqual(type, "TGK")) menu = new Menu(SkinsTGKSelectionMenuHandler);


	menu.SetTitle("Soccer Mod - Admin - Settings - Skins");

	kvSkins = new KeyValues("skins");
	kvSkins.ImportFromFile(skinsKeygroup);

	kvSkins.GotoFirstSubKey();

	char name[32];
	char path[PLATFORM_MAX_PATH];

	do
	{
		kvSkins.GetSectionName(name, sizeof(name));
		kvSkins.GetString(type, path, sizeof(path));

		menu.AddItem(path, name);
	}
	while (kvSkins.GotoNextKey());

	kvSkins.Rewind();
	kvSkins.Close();

	menu.ExitBackButton = true;
	menu.Display(client, 0);
}

public int SkinsCTSelectionMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[128];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		char number[4] = "0";
		SkinsServerCommandModelCT(menuItem, number);

		OpenSkinsMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenSkinsMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public int SkinsTSelectionMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[128];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		char number[4] = "0";
		SkinsServerCommandModelT(menuItem, number);

		OpenSkinsMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenSkinsMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public int SkinsCTGKSelectionMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[128];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		char number[4] = "0";
		SkinsServerCommandModelCTGoalkeeper(menuItem, number);

		OpenSkinsMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenSkinsMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}

public int SkinsTGKSelectionMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[128];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		char number[4] = "0";
		SkinsServerCommandModelTGoalkeeper(menuItem, number);

		OpenSkinsMenu(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenSkinsMenu(client);
	else if (action == MenuAction_End)					  menu.Close();
}
