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
			CPrintToChat(client, "{%s}[%s] {%s}Type in your prefix without [] and \" around them, !cancel to stop. Current prefix is: {%s}[%s].", prefixcolor, prefix, textcolor, prefixcolor, prefix);
			changeSetting[client] = "CustomPrefix";
		}
		else if (StrEqual(menuItem, "prefix_col"))
		{
			OpenMenuColorlist(client);
			CPrintToChat(client, "{%s}[%s] {%s}Type in your desired prefixcolor, !cancel to stop. Current prefixcolor is: {%s}%s", prefixcolor, prefix, textcolor, prefixcolor, prefixcolor);
			changeSetting[client] = "CustomPrefixCol";
		}
		else if (StrEqual(menuItem, "text_col"))
		{
			OpenMenuColorlist(client);
			CPrintToChat(client, "{%s}[%s] {%s}Type in your desired textcolor, !cancel to stop. Current textcolor is: {%s}%s", prefixcolor, prefix, textcolor, textcolor, textcolor);
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
			CPrintToChatAll("{%s}[%s] {%s}MVP messages and stars enabled.", prefixcolor, prefix, textcolor);
			OpenMenuMVPSet(client);
		}
		else if (StrEqual(menuItem, "disable"))
		{
			MVPEnabled = 0;
			UpdateConfigInt("Chat Settings", "soccer_mod_mvp", MVPEnabled);
			CPrintToChatAll("{%s}[%s] {%s}MVP messages and stars disabled.", prefixcolor, prefix, textcolor);
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
	menu.SetTitle("Soccer Mod - Chat Settings - Deadchat settings");

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
			CPrintToChatAll("{%s}[%s] {%s}Deadchat enabled.", prefixcolor, prefix, textcolor);
			OpenMenuDeadChatSet(client);
		}
		else if (StrEqual(menuItem, "disable"))
		{
			DeadChatMode = 0;
			UpdateConfigInt("Chat Settings", "soccer_mod_deadchat_mode", DeadChatMode);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat disabled.", prefixcolor, prefix, textcolor);
			OpenMenuDeadChatSet(client);
		}
		else if (StrEqual(menuItem, "alltalk"))
		{
			DeadChatMode = 2;
			UpdateConfigInt("Chat Settings", "soccer_mod_deadchat_mode", DeadChatMode);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat enabled if sv_alltalk = 1.", prefixcolor, prefix, textcolor);
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
	menu.SetTitle("Soccer Mod - Chat Settings - Deadchat visibility");

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
			CPrintToChatAll("{%s}[%s] {%s}Deadchat visibility set to default.", prefixcolor, prefix, textcolor);
			OpenMenuDeadChatSetVis(client);
		}
		else if (StrEqual(menuItem, "teammates"))
		{
			DeadChatVis = 1;
			UpdateConfigInt("Chat Settings", "soccer_mod_deadchat_visibility", DeadChatVis);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat visibility set to teammates.", prefixcolor, prefix, textcolor);
			OpenMenuDeadChatSetVis(client);
		}
		else if (StrEqual(menuItem, "everyone"))
		{
			DeadChatVis = 2;
			UpdateConfigInt("Chat Settings", "soccer_mod_deadchat_visibility", DeadChatVis);
			CPrintToChatAll("{%s}[%s] {%s}Deadchat visibility set to everyone.", prefixcolor, prefix, textcolor);
			OpenMenuDeadChatSetVis(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuDeadChatSet(client);
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
			if(!StrEqual(custom_tag, "!cancel"))
			{
				prefix = custom_tag;
				UpdateConfig("Chat Settings", "soccer_mod_prefix", prefix);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the prefix to {%s}[%s].", prefixcolor, prefix, textcolor, client, prefixcolor, custom_tag);
				}

				LogMessage("%N <%s> has set prefix to %s", client, steamid, custom_tag);
			}
			else 
			{
				OpenMenuChatStyle(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		if (StrEqual(type, "CustomPrefixCol"))
		{
			if(!StrEqual(custom_tag, "!cancel"))
			{
				prefixcolor = custom_tag;
				UpdateConfig("Chat Settings", "soccer_mod_prefixcolor", prefixcolor);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the prefixcolor to {%s}%s.", prefixcolor, prefix, textcolor, client, custom_tag, custom_tag);
				}

				LogMessage("%N <%s> has set prefixcolor to %s", client, steamid, custom_tag);
			}
			else 
			{
				OpenMenuChatStyle(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		if (StrEqual(type, "TextCol"))
		{
			if(!StrEqual(custom_tag, "!cancel"))
			{
				textcolor = custom_tag;
				UpdateConfig("Chat Settings", "soccer_mod_textcolor", textcolor);

				for (int player = 1; player <= MaxClients; player++)
				{
					if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N has set the textcolor to {%s}%s.", prefixcolor, prefix, textcolor, client, custom_tag, custom_tag);
				}

				LogMessage("%N <%s> has set textcolor to %s", client, steamid, custom_tag);
			}
			else
			{
				OpenMenuChatStyle(client);
				CPrintToChat(client, "{%s}[%s] {%s}Cancelled changing this value.", prefixcolor, prefix, textcolor);
			}
		}
		
		changeSetting[client] = "";
		OpenMenuChatStyle(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}Prefix is too long. Please use a prefix with %i to %i characters.", prefixcolor, prefix, textcolor, min, max);
}