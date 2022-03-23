// ******************************************************************************************************************
// ****************************************************** MENU ******************************************************
// ******************************************************************************************************************

public void OpenMenuShout(int client, bool menutrue)
{
	Menu menu = new Menu(MenuHandlerShoutList);
	menu.SetTitle("[   Available Shouts   ]");
	
	kvConfigShout = new KeyValues("Shout List");
	kvConfigShout.ImportFromFile(shoutConfigFile);
	
	if (kvConfigShout.GotoFirstSubKey() == false) 
	{
		CPrintToChat(client, "{%s}[%s] {%s}No Shouts found", prefixcolor, prefix, textcolor);
		if(menutrue)	OpenMenuSoccer(client);
	}
	else
	{
		kvConfigShout.GotoFirstSubKey();
		
		do
		{
			char shoutName[64]
			kvConfigShout.GetSectionName(shoutName, sizeof(shoutName));
			
			menu.AddItem(shoutName, shoutName);
		}
		while (kvConfigShout.GotoNextKey());
	}
	
	kvConfigShout.Rewind();
	kvConfigShout.Close();	
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutList(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[64];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		int iVolume, iPitch;
		
		kvConfigShout = new KeyValues("Shout List");
		kvConfigShout.ImportFromFile(shoutConfigFile);
		kvConfigShout.JumpToKey(menuItem);
		
		char sound[PLATFORM_MAX_PATH]
		kvConfigShout.GetString("path", sound, sizeof(sound), "soccermod/shout/godlike.mp3")
		iVolume = kvConfigShout.GetNum("volume", shoutVolume);
		iPitch	= kvConfigShout.GetNum("pitch", shoutPitch);
	
		ShoutPlaySound(client, sound, menuItem, iVolume, iPitch);
		
		kvConfigShout.Rewind();
		kvConfigShout.Close();	
		
		DisplayMenuAtItem(menu, client, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSoccer(client);
	else if (action == MenuAction_Cancel && choice == -3) 	menu.Close();
}

// ******************************************************************************************************************
// **************************************************** SETTINGS ****************************************************
// ******************************************************************************************************************

public void OpenMenuShoutSet(int client)
{
	Menu menu = new Menu(MenuHandlerShoutSet);
	menu.SetTitle("Shout Settings");
	
	char cdstring[64], volstring[64], pitchstring[64], commandstring[64], modestring[64], radiusstring[64];
	
	Format(cdstring, sizeof(cdstring), "Cooldown: %i", shoutCD);
	Format(volstring, sizeof(volstring), "Volume: %i", shoutVolume);
	Format(pitchstring, sizeof(pitchstring), "Pitch: %i", shoutPitch);
	if(shoutCommand == 0)commandstring = "Commands: OFF";
	else if (shoutCommand == 1) commandstring = "Commands: ON";
	if(shoutMode == 0)modestring = "Mode: Ambient";
	else if (shoutMode == 1) modestring = "Mode: Everyone";
	else if (shoutMode == 2) modestring = "Mode: Team";
	else if (shoutMode == 3) modestring = "Mode: Radius";
	else if (shoutMode == 4) modestring = "Mode: Radius(Team)";
	else if (shoutMode == -1) modestring = "Shouts Disabled";
	Format(radiusstring, sizeof(radiusstring), "Radius: %i", shoutRadius);
	
	menu.AddItem("mode", modestring);
	menu.AddItem("cd", cdstring);
	menu.AddItem("vol", volstring);
	menu.AddItem("pitch", pitchstring);
	if(shoutMode == 2 || shoutMode == 3) menu.AddItem("radius", radiusstring);
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true)) menu.AddItem("cmd", commandstring);
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true))	menu.AddItem("manage", "Shout Manager");
	
	menu.AddItem("help", "Help / Credits");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutSet(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[64];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		if (StrEqual(menuItem, "cd"))				OpenMenuShoutCD(client);
		else if (StrEqual(menuItem, "vol"))			OpenMenuShoutVol(client);
		else if (StrEqual(menuItem, "pitch"))		OpenMenuShoutPitch(client);
		else if (StrEqual(menuItem, "radius"))		OpenMenuShoutRadius(client);
		else if (StrEqual(menuItem, "cmd"))	
		{	
			if(shoutCommand == 0)
			{
				shoutCommand = 1;
				ShoutUpdateSettingsInt("commands", shoutCommand);
				CPrintToChat(client, "{%s}[%s] {%s}Individual Commands enabled. Requires Mapchange to take effect!", prefixcolor, prefix, textcolor);
				OpenMenuShoutSet(client);
			}
			else if(shoutCommand == 1)
			{
				shoutCommand = 0;
				ShoutUpdateSettingsInt("commands", shoutCommand);
				CPrintToChat(client, "{%s}[%s] {%s}Individual Commands disabled. Requires Mapchange to take effect!", prefixcolor, prefix, textcolor);
				OpenMenuShoutSet(client);
			}
		}
		else if (StrEqual(menuItem, "mode"))	
		{	
			if(shoutMode == 0)
			{
				shoutMode = 1;
				if(shoutCD == 1)
				{
					shoutCD = 0;
					ShoutUpdateSettingsInt("cooldown", shoutCD);
				}
				ShoutUpdateSettingsInt("mode", shoutMode);
				OpenMenuShoutSet(client);
			}
			else if(shoutMode == 1)
			{
				shoutMode = 2;
				if(shoutCD == 1)
				{
					shoutCD = 0;
					ShoutUpdateSettingsInt("cooldown", shoutCD);
				}
				ShoutUpdateSettingsInt("mode", shoutMode);
				OpenMenuShoutSet(client);
			}
			else if(shoutMode == 2)
			{
				shoutMode = 3;
				if(shoutCD == 1)
				{
					shoutCD = 0;
					ShoutUpdateSettingsInt("cooldown", shoutCD);
				}
				ShoutUpdateSettingsInt("mode", shoutMode);
				OpenMenuShoutSet(client);
			}
			else if(shoutMode == 3)
			{
				shoutMode = 4;
				if(shoutCD == 1)
				{
					shoutCD = 0;
					ShoutUpdateSettingsInt("cooldown", shoutCD);
				}
				ShoutUpdateSettingsInt("mode", shoutMode);
				OpenMenuShoutSet(client);
			}
			else if(shoutMode == 4)
			{
				shoutMode = -1;
				ShoutUpdateSettingsInt("mode", shoutMode);
				OpenMenuShoutSet(client);
			}
			else if(shoutMode == -1)
			{
				shoutMode = 0;
				if(shoutCD == 0)
				{
					shoutCD = 1;
					ShoutUpdateSettingsInt("cooldown", shoutCD);
				}
				ShoutUpdateSettingsInt("mode", shoutMode);
				OpenMenuShoutSet(client);
			}
		}
		else if (StrEqual(menuItem, "manage"))		OpenMenuShoutManager(client);
		else if (StrEqual(menuItem, "help"))		OpenMenuShoutHelp(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)  	OpenMenuSettings(client);
	else if (action == MenuAction_End)					 	menu.Close();
}

// ******************************************************************************************************************
// **************************************************** RADIUS ******************************************************
// ******************************************************************************************************************

public void OpenMenuShoutRadius(int client)
{
	Menu menu = new Menu(MenuHandlerShoutRadius);
	char title[32];
	Format(title, sizeof(title), "Shout Radius: [%i]", shoutRadius);
	menu.SetTitle(title);
	
	menu.AddItem("400", "400 (Default)");
	menu.AddItem("+10", "+10");
	menu.AddItem("+5", "+5");
	menu.AddItem("-10", "-10");
	menu.AddItem("-5", "-5");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutRadius(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[64];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		if(StrEqual(menuItem, "400")) shoutRadius = 400;
		else if (StrEqual(menuItem, "+10")) shoutRadius = shoutRadius + 10;
		else if (StrEqual(menuItem, "-10")) shoutRadius = shoutRadius - 10;
		else if (StrEqual(menuItem, "+5")) shoutRadius = shoutRadius + 5;
		else if (StrEqual(menuItem, "-5")) shoutRadius = shoutRadius - 5;

		if(shoutRadius < 0) 
		{
			shoutRadius = 0;
			CPrintToChat(client, "{%s}[%s] {%s}Radius can't be lower than 0!", prefixcolor, prefix, textcolor);
		}

		ShoutUpdateSettingsInt("radius", shoutRadius);
		
		char title[32];
		Format(title, sizeof(title), "Shout Radius: [%i]", shoutRadius);
		menu.SetTitle(title);
		DisplayMenuAtItem(menu, client, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
	}
	else if (action == MenuAction_Cancel && choice == -6)   
	{
		OpenMenuShoutSet(client);	
		CPrintToChat(client, "{%s}[%s] {%s}Radius set to %i", prefixcolor, prefix, textcolor, shoutRadius);
	}
}

// ******************************************************************************************************************
// **************************************************** COOLDOWN ****************************************************
// ******************************************************************************************************************

public void OpenMenuShoutCD(int client)
{
	Menu menu = new Menu(MenuHandlerShoutCD);
	char title[32];
	Format(title, sizeof(title), "Shout Cooldown: [%i]", shoutCD);
	menu.SetTitle(title);
	
	menu.AddItem("0", "0");
	menu.AddItem("+1", "+1");
	menu.AddItem("+5", "+5");
	menu.AddItem("-1", "-1");
	menu.AddItem("-5", "-5");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutCD(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[64];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		if(StrEqual(menuItem, "0")) shoutCD = 0;
		else if (StrEqual(menuItem, "+1")) shoutCD = shoutCD + 1;
		else if (StrEqual(menuItem, "+5")) shoutCD = shoutCD + 5;
		else if (StrEqual(menuItem, "-1")) shoutCD = shoutCD - 1;
		else if (StrEqual(menuItem, "-5")) shoutCD = shoutCD - 5;
		
		if(shoutCD < 0) 
		{
			shoutCD = 0;
			CPrintToChat(client, "{%s}[%s] {%s}Cooldown can't be lower than 0!", prefixcolor, prefix, textcolor);
		}
		
		ShoutUpdateSettingsInt("cooldown", shoutCD);
		
		char title[32];
		Format(title, sizeof(title), "Shout Cooldown: [%i]", shoutCD);
		menu.SetTitle(title);
		DisplayMenuAtItem(menu, client, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
	}
	else if (action == MenuAction_Cancel && choice == -6)   
	{
		OpenMenuShoutSet(client);
		CPrintToChat(client, "{%s}[%s] {%s}Cooldown set to %i", prefixcolor, prefix, textcolor, shoutCD);
	}
}

// ******************************************************************************************************************
// ***************************************************** VOLUME *****************************************************
// ******************************************************************************************************************
public void OpenMenuShoutVol(int client)
{
	Menu menu = new Menu(MenuHandlerShoutVol);
	char title[32];
	Format(title, sizeof(title), "Shout Volume: [%i%]", shoutVolume);
	menu.SetTitle(title);
	
	menu.AddItem("volup", "Volume up (+10)");
	menu.AddItem("voldown", "Volume down (-10)");
	menu.AddItem("volup2", "Volume up (+50)");
	menu.AddItem("voldown2", "Volume down (-50)");
	menu.AddItem("500", "500% (Max)");
	menu.AddItem("100", "100% (Default)");
	menu.AddItem("0", "0% (Off)");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutVol(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[64];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		if(StrEqual(menuItem, "0")) shoutVolume = 0;
		else if (StrEqual(menuItem, "100")) shoutVolume = 100;
		else if (StrEqual(menuItem, "500")) shoutVolume = 500;
		else if (StrEqual(menuItem, "volup2")) shoutVolume = shoutVolume+50;
		else if (StrEqual(menuItem, "voldown2"))	shoutVolume = shoutVolume-50;
		else if (StrEqual(menuItem, "volup")) shoutVolume = shoutVolume+10;
		else if (StrEqual(menuItem, "voldown"))	shoutVolume = shoutVolume-10;
		
		if(shoutVolume > 500) 
		{
			shoutVolume = 500;
			CPrintToChat(client, "{%s}[%s] {%s}Volume can't be higher than 500!", prefixcolor, prefix, textcolor);
		}
		else if(shoutVolume < 0) 
		{
			shoutVolume = 0;
			CPrintToChat(client, "{%s}[%s] {%s}Volume can't be lower than 0!", prefixcolor, prefix, textcolor);
		}
		
		ShoutUpdateSettingsInt("volume", shoutVolume);
		
		char title[32];
		Format(title, sizeof(title), "Shout Volume: [%i]", shoutVolume);
		menu.SetTitle(title);
		DisplayMenuAtItem(menu, client, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
	}
	else if (action == MenuAction_Cancel && choice == -6)   
	{
		OpenMenuShoutSet(client);
		CPrintToChat(client, "{%s}[%s] {%s}Volume set to %i%", prefixcolor, prefix, textcolor, shoutVolume);
	}
}

// ******************************************************************************************************************
// ***************************************************** PITCH ******************************************************
// ******************************************************************************************************************

public void OpenMenuShoutPitch(int client)
{
	Menu menu = new Menu(MenuHandlerShoutPitch);
	char title[32];
	Format(title, sizeof(title), "Shout Pitch: [%i]", shoutPitch);
	menu.SetTitle(title);
	
	menu.AddItem("100", "100 (Default)");
	menu.AddItem("+5", "+5");
	menu.AddItem("-5", "-5");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutPitch(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[64];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		if(StrEqual(menuItem, "100")) shoutPitch = 100;
		else if (StrEqual(menuItem, "+5")) shoutPitch = shoutPitch + 5;
		else if (StrEqual(menuItem, "-5")) shoutPitch = shoutPitch - 5;

		if(shoutPitch > 255) 
		{
			shoutPitch = 255;
			CPrintToChat(client, "{%s}[%s] {%s}Pitch can't be higher than 255!", prefixcolor, prefix, textcolor);
		}
		else if(shoutPitch < 0) 
		{
			shoutPitch = 0;
			CPrintToChat(client, "{%s}[%s] {%s}Pitch can't be lower than 0!", prefixcolor, prefix, textcolor);
		}

		ShoutUpdateSettingsInt("pitch", shoutPitch);
		
		char title[32];
		Format(title, sizeof(title), "Shout Pitch: [%i]", shoutPitch);
		menu.SetTitle(title);
		DisplayMenuAtItem(menu, client, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
	}
	else if (action == MenuAction_Cancel && choice == -6)   
	{
		OpenMenuShoutSet(client);	
		CPrintToChat(client, "{%s}[%s] {%s}Pitch set to %i", prefixcolor, prefix, textcolor, shoutPitch);
	}
}

// ******************************************************************************************************************
// **************************************************** MANAGER *****************************************************
// ******************************************************************************************************************

public void OpenMenuShoutManager(int client)
{
	Menu menu = new Menu(MenuHandlerShoutManager);
	menu.SetTitle("Shout Manager");
	
	menu.AddItem("add", "Add Shouts");
	menu.AddItem("rescan", "Scan shout folder");
	menu.AddItem("edit", "Edit Shouts");
	menu.AddItem("remove", "Remove Shouts");
	menu.AddItem("list", "List Shouts");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutManager(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[64];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		if (StrEqual(menuItem, "add"))	
		{
			EmptyArrays(fileArray, nameArray);
			GetSounds("sound");
			OpenMenuShoutAdd(client);
		}
		else if (StrEqual(menuItem, "rescan"))
		{
			EmptyArrays(fileArray, nameArray);
			ShoutCreateConfig();
			OpenMenuShoutManager(client)
			CPrintToChat(client, "{%s}[%s] {%s}Rescanned shout folder", prefixcolor, prefix, textcolor);
		}
		else if (StrEqual(menuItem, "edit"))
		{
			OpenMenuShoutEdit(client);
		}
		else if (StrEqual(menuItem, "remove"))
		{
			EmptyArrays(fileArray_Added, nameArray_Added);
			ShoutList();
			OpenMenuShoutRemove(client);
		}
		else if (StrEqual(menuItem, "list"))			
		{
			EmptyArrays(fileArray_Added, nameArray_Added);
			ShoutList();
			OpenMenuShoutPathList(client);
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuShoutSet(client);
}

// ******************************************************************************************************************
// ************************************************** ADD SHOUTS ****************************************************

public void OpenMenuShoutAdd(int client)
{
	Menu menu = new Menu(MenuHandlerShoutAdd);
	menu.SetTitle("Add Shouts");
	
	char filebuffer[PLATFORM_MAX_PATH], namebuffer[64];
	
	for(int i = 0; i < GetArraySize(nameArray); i++)
	{
		GetArrayString(fileArray, i, filebuffer, sizeof(filebuffer));
		GetArrayString(nameArray, i, namebuffer, sizeof(namebuffer));
		
		char buffer[32];
		IntToString(i, buffer, sizeof(buffer)); 
		
		menu.AddItem(buffer, namebuffer);
	}
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutAdd(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[64];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		char filebuffer[PLATFORM_MAX_PATH], namebuffer[64];
		int ArrayPos = StringToInt(menuItem);
		GetArrayString(fileArray, ArrayPos, filebuffer, sizeof(filebuffer));
		GetArrayString(nameArray, ArrayPos, namebuffer, sizeof(namebuffer));
		
		if(!NameTaken(namebuffer))
		{
			ReplaceString(filebuffer, sizeof(filebuffer), "sound/", "",false);
			
			kvConfigShout = new KeyValues("Shout List");
			kvConfigShout.ImportFromFile(shoutConfigFile);
		
			kvConfigShout.JumpToKey(namebuffer, true);
			kvConfigShout.SetString("path", 					filebuffer);
			kvConfigShout.GoBack();

			kvConfigShout.Rewind();
			kvConfigShout.ExportToFile(shoutConfigFile);
			kvConfigShout.Close();
			
			RemoveFromArray(fileArray, ArrayPos);
			RemoveFromArray(nameArray, ArrayPos);
			
			
			CPrintToChat(client, "{%s}[%s] {%s}Sound %s was added to the shoutlist.", prefixcolor, prefix, textcolor, namebuffer);
			
			ShoutSoundSetup(filebuffer, namebuffer);
			
			RefreshMenu(menu, client, GetMenuSelectionPosition(), fileArray, nameArray);
		}
		else OpenPanelShoutAddRename(client, ArrayPos);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuShoutManager(client);
}

public void OpenPanelShoutAddRename(int client, int arrayPos)
{
	int panel_keys = 0;
	char bLine[128];
	GetArrayString(fileArray, arrayPos, gFilebuffer, sizeof(gFilebuffer));
	GetArrayString(nameArray, arrayPos, gNamebuffer, sizeof(gNamebuffer));
	
	DupRename = true;
	
	Panel panel = new Panel();
	panel.SetTitle("Duplicate Shout");
	panel.DrawText("══════════════════════════════");
	Format(bLine, sizeof(bLine), "A shout with the name > %s <",gNamebuffer);
	panel.DrawText(bLine);
	panel.DrawText("already exists, using the following path:");
	panel.DrawText(" ");
	panel.DrawText(gFilebuffer);
	panel.DrawText(" ");
	panel.DrawText("What do you want to do?");
	panel.DrawText("══════════════════════════════");
	
	// Create Buttons
	char sItem_display[2][32] = {
								"Rename & Add it", 
								"Replace it"	
								};

	for(int i = 1; i <= 2; i++)
	{
		panel_keys |= (1<<i-1);
		Format(bLine, sizeof(bLine), "->%i. %s", i, sItem_display[(i-1)]);
		panel.DrawText(bLine);
	}
	
	panel.DrawText(" ");
	panel_keys |= (1<<10-1);
	Format(bLine, sizeof(bLine), "0. Do nothing");
	panel.DrawText(bLine);

	panel.SetKeys(panel_keys);
 
	panel.Send(client, AddShoutPanelHandler, MENU_TIME_FOREVER);
 
	delete panel;
}

public int AddShoutPanelHandler(Menu menu, MenuAction action, int client, int key)
{
	if (action == MenuAction_Select && key == 1)
	{	
		ReplaceString(gFilebuffer, sizeof(gFilebuffer), "sound/", "",false);
		
		CPrintToChat(client, "{%s}[%s] {%s}Type in the name of the shout, !cancel to stop. Current name is %s.", prefixcolor, prefix, textcolor, gNamebuffer);
		changeSetting[client] = "CustomName";	
	}
	else if (action == MenuAction_Select && key == 2)
	{
		int arrayPos = FindStringInArray(fileArray, gFilebuffer);
		
		ReplaceString(gFilebuffer, sizeof(gFilebuffer), "sound/", "",false);
		
		kvConfigShout = new KeyValues("Shout List");
		kvConfigShout.ImportFromFile(shoutConfigFile);
		
		kvConfigShout.JumpToKey(gNamebuffer, true);
		kvConfigShout.SetString("path", 					gFilebuffer);
		kvConfigShout.GoBack();

		kvConfigShout.Rewind();
		kvConfigShout.ExportToFile(shoutConfigFile);
		kvConfigShout.Close();
		
		RemoveFromArray(fileArray, arrayPos);
		RemoveFromArray(nameArray, arrayPos);
			
		CPrintToChat(client, "{%s}[%s] {%s}Sound %s is now using %s.", prefixcolor, prefix, textcolor, gNamebuffer, gFilebuffer);
				
		ShoutSoundSetup(gFilebuffer, gNamebuffer);
		
		EmptyArrays(fileArray, nameArray);
		GetSounds("sound");
		OpenMenuShoutAdd(client);
	}
	else
	{
		EmptyArrays(fileArray, nameArray);
		GetSounds("sound");
		OpenMenuShoutAdd(client);
	}
}

// ******************************************************************************************************************
// ***************************************************** EDIT *******************************************************

public void OpenMenuShoutEdit(int client)
{
	Menu menu = new Menu(MenuHandlerShoutEdit);
	menu.SetTitle("Edit Shouts");
	
	menu.AddItem("rename", "Rename Shouts");
	menu.AddItem("editvol", "Volume per Shout");
	menu.AddItem("editpit", "Pitch per Shout");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutEdit(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[64];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		if(StrEqual(menuItem, "rename"))
		{
			EmptyArrays(fileArray_Added, nameArray_Added);
			ShoutList();
			OpenMenuShoutRename(client);
		}
		else if(StrEqual(menuItem, "editvol")) 
		{
			EmptyArrays(fileArray_Added, nameArray_Added);
			ShoutList();
			OpenMenuShoutEditSet(client, "volume");
		}
		else if(StrEqual(menuItem, "editpit")) 
		{
			EmptyArrays(fileArray_Added, nameArray_Added);
			ShoutList();
			OpenMenuShoutEditSet(client, "pitch");
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuShoutManager(client);
}

// **************************************************** RENAME ******************************************************

public void OpenMenuShoutRename(int client)
{
	Menu menu = new Menu(MenuHandlerShoutRename);
	menu.SetTitle("Rename Shouts");
	
	DupRename = false;
	char filebuffer[PLATFORM_MAX_PATH], namebuffer[64], menubuffer[512];
	
	for(int i = 0; i < GetArraySize(nameArray_Added); i++)
	{
		GetArrayString(fileArray_Added, i, filebuffer, sizeof(filebuffer));
		GetArrayString(nameArray_Added, i, namebuffer, sizeof(namebuffer));
		Format(menubuffer, sizeof(menubuffer), "[%s] - %s", namebuffer, filebuffer);
		
		char buffer[32];
		IntToString(i, buffer, sizeof(buffer)); 
		
		menu.AddItem(buffer, menubuffer);
	}
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutRename(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[64];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		//char filebuffer[PLATFORM_MAX_PATH], namebuffer[64];
		int ArrayPos = StringToInt(menuItem);
		
		GetArrayString(fileArray_Added, ArrayPos, gFilebuffer, sizeof(gFilebuffer));
		GetArrayString(nameArray_Added, ArrayPos, gNamebuffer, sizeof(gNamebuffer));
		
		ReplaceString(gFilebuffer, sizeof(gFilebuffer), "sound/", "",false);
		
		CPrintToChat(client, "{%s}[%s] {%s}Type in the name of the shout, !cancel to stop. Current name is %s.", prefixcolor, prefix, textcolor, gNamebuffer);
		changeSetting[client] = "CustomName";		
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuShoutEdit(client);
}

// *************************************************** EDITSET ******************************************************

public void OpenMenuShoutEditSet(int client, char StrToGet[32])
{
	Menu menu = new Menu(MenuHandlerShoutEditVolPit);
	if(StrEqual(StrToGet, "volume"))	 menu.SetTitle("Edit per Shout volume");
	else if(StrEqual(StrToGet, "pitch")) menu.SetTitle("Edit per Shout pitch");
	
	char filebuffer[PLATFORM_MAX_PATH], namebuffer[64], menubuffer[512];
	
	for(int i = 0; i < GetArraySize(nameArray_Added); i++)
	{
		GetArrayString(fileArray_Added, i, filebuffer, sizeof(filebuffer));
		GetArrayString(nameArray_Added, i, namebuffer, sizeof(namebuffer));
		
		if(StrEqual(StrToGet, "volume"))Format(menubuffer, sizeof(menubuffer), "[%s] - Vol.:[%i]", namebuffer, GetVolOrPit(namebuffer, "volume"));
		else if(StrEqual(StrToGet, "pitch")) Format(menubuffer, sizeof(menubuffer), "[%s] - Pitch:[%i]", namebuffer, GetVolOrPit(namebuffer, "pitch"));
		
		char buffer[32];
		IntToString(i, buffer, sizeof(buffer)); 
		
		menu.AddItem(buffer, menubuffer);
	}
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutEditVolPit(Menu menu, MenuAction action, int client, int choice)
{
	char title[64];
	GetMenuTitle(menu, title, sizeof(title))
	
	if(StrEqual(title, "Edit per Shout volume"))
	{
		if (action == MenuAction_Select)
		{
			char menuItem[64];
			menu.GetItem(choice, menuItem, sizeof(menuItem));
			
			int ArrayPos = StringToInt(menuItem);
			
			GetArrayString(nameArray_Added, ArrayPos, gNamebuffer, sizeof(gNamebuffer));
			
			OpenMenuShoutVolOrPit(client, "volume")	
		}
		else if (action == MenuAction_Cancel && choice == -6)   OpenMenuShoutEdit(client);
	}
	else if(StrEqual(title, "Edit per Shout pitch"))
	{
		if (action == MenuAction_Select)
		{
			char menuItem[64];
			menu.GetItem(choice, menuItem, sizeof(menuItem));
			
			int ArrayPos = StringToInt(menuItem);
			
			GetArrayString(nameArray_Added, ArrayPos, gNamebuffer, sizeof(gNamebuffer));
			
			OpenMenuShoutVolOrPit(client, "pitch")	
		}
		else if (action == MenuAction_Cancel && choice == -6)   OpenMenuShoutEdit(client);
	}
}


// *************************************************** EDITMENU *****************************************************

public void OpenMenuShoutVolOrPit(int client, char StrToGet[32])
{
	Menu menu = new Menu(MenuHandlerShoutVolPitSet);
	char title[32];
	if (StrEqual(StrToGet, "volume")) 
	{
		Format(title, sizeof(title), "Shout Volume: [%i%]", GetVolOrPit(gNamebuffer, "volume"));
		menu.SetTitle(title);
		
		menu.AddItem("volup", "Volume up (+10)");
		menu.AddItem("voldown", "Volume down (-10)");
		menu.AddItem("volup2", "Volume up (+50)");
		menu.AddItem("voldown2", "Volume down (-50)");
		menu.AddItem("500", "500% (Max)");
		menu.AddItem("100", "100% (Default)");
		menu.AddItem("0", "0% (Off)");
	}
	else if(StrEqual(StrToGet, "pitch"))
	{
		Format(title, sizeof(title), "Shout Pitch: [%i]", GetVolOrPit(gNamebuffer, "pitch"));
		menu.SetTitle(title);
		
		menu.AddItem("100", "100 (Default)");
		menu.AddItem("+5", "+5");
		menu.AddItem("-5", "-5");
	}
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutVolPitSet(Menu menu, MenuAction action, int client, int choice)
{
	char titlecheck[64], check1[64], check2[64];
	GetMenuTitle(menu, titlecheck, sizeof(titlecheck))
	Format(check1, sizeof(check1), "Shout Volume: [%i%]", GetVolOrPit(gNamebuffer, "volume"));
	Format(check2, sizeof(check2), "Shout Pitch: [%i]", GetVolOrPit(gNamebuffer, "pitch"));
	
	if(StrEqual(titlecheck, check1))
	{
		if (action == MenuAction_Select)
		{
			char menuItem[64];
			menu.GetItem(choice, menuItem, sizeof(menuItem));

			int iVolume = GetVolOrPit(gNamebuffer, "volume");
			
			if(StrEqual(menuItem, "0")) iVolume = 0;
			else if (StrEqual(menuItem, "100")) iVolume = 100;
			else if (StrEqual(menuItem, "500")) iVolume = 500;
			else if (StrEqual(menuItem, "volup2")) iVolume = iVolume+50;
			else if (StrEqual(menuItem, "voldown2"))iVolume = iVolume-50;
			else if (StrEqual(menuItem, "volup")) iVolume = iVolume+10;
			else if (StrEqual(menuItem, "voldown"))iVolume = iVolume-10;
			
			if(iVolume > 500) 
			{
				iVolume = 500;
				CPrintToChat(client, "{%s}[%s] {%s}Volume can't be higher than 500!", prefixcolor, prefix, textcolor);
			}
			else if(iVolume < 0) 
			{
				iVolume = 0;
				CPrintToChat(client, "{%s}[%s] {%s}Volume can't be lower than 0!", prefixcolor, prefix, textcolor);
			}
			
			ShoutUpdateConfigInt(gNamebuffer, "volume", iVolume);
			
			char title[32];
			Format(title, sizeof(title), "Shout Volume: [%i]", GetVolOrPit(gNamebuffer, "volume"));
			menu.SetTitle(title);
			DisplayMenuAtItem(menu, client, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
		}
		else if (action == MenuAction_Cancel && choice == -6)   OpenMenuShoutEditSet(client, "volume");
	}
	else if(StrEqual(titlecheck, check2))
	{
		if (action == MenuAction_Select)
		{
			char menuItem[64];
			menu.GetItem(choice, menuItem, sizeof(menuItem));
			
			int iPitch = GetVolOrPit(gNamebuffer, "pitch");
			
			if(StrEqual(menuItem, "100")) iPitch = 100;
			else if (StrEqual(menuItem, "+5")) iPitch = iPitch + 5;
			else if (StrEqual(menuItem, "-5")) iPitch = iPitch - 5;

			if(iPitch > 255) 
			{
				iPitch = 255;
				CPrintToChat(client, "{%s}[%s] {%s}Pitch can't be higher than 255!", prefixcolor, prefix, textcolor);
			}
			else if(iPitch < 0) 
			{
				iPitch = 0;
				CPrintToChat(client, "{%s}[%s] {%s}Pitch can't be lower than 0!", prefixcolor, prefix, textcolor);
			}

			ShoutUpdateConfigInt(gNamebuffer, "pitch", iPitch);
			
			char title[32];
			Format(title, sizeof(title), "Shout Pitch: [%i]", GetVolOrPit(gNamebuffer, "pitch"));
			menu.SetTitle(title);
			DisplayMenuAtItem(menu, client, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
		}
		else if (action == MenuAction_Cancel && choice == -6)   OpenMenuShoutEditSet(client, "pitch");
	}
}

// ******************************************************************************************************************
// ************************************************* REMOVE SHOUTS **************************************************

public void OpenMenuShoutRemove(int client)
{
	Menu menu = new Menu(MenuHandlerShoutRemove);
	menu.SetTitle("Remove Shouts");
	
	char filebuffer[PLATFORM_MAX_PATH], namebuffer[64], menubuffer[512];
	
	for(int i = 0; i < GetArraySize(nameArray_Added); i++)
	{
		GetArrayString(fileArray_Added, i, filebuffer, sizeof(filebuffer));
		GetArrayString(nameArray_Added, i, namebuffer, sizeof(namebuffer));
		Format(menubuffer, sizeof(menubuffer), "[%s] - %s", namebuffer, filebuffer);
		
		char buffer[32];
		IntToString(i, buffer, sizeof(buffer)); 
		
		menu.AddItem(buffer, menubuffer);
	}
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutRemove(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[64];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		char filebuffer[PLATFORM_MAX_PATH], compare[PLATFORM_MAX_PATH], namebuffer[64];
		int ArrayPos = StringToInt(menuItem);
		GetArrayString(fileArray_Added, ArrayPos, filebuffer, sizeof(filebuffer));
		GetArrayString(nameArray_Added, ArrayPos, namebuffer, sizeof(namebuffer));
		
		ReplaceString(filebuffer, sizeof(filebuffer), "sound/", "",false);
		
		kvConfigShout = new KeyValues("Shout List");
		kvConfigShout.ImportFromFile(shoutConfigFile);
	
		kvConfigShout.JumpToKey(namebuffer, false);
		kvConfigShout.GetString("path", compare, sizeof(compare), "");
		if(StrEqual(compare, filebuffer))	kvConfigShout.DeleteThis();
		kvConfigShout.GoBack();

		kvConfigShout.Rewind();
		kvConfigShout.ExportToFile(shoutConfigFile);
		kvConfigShout.Close();
		
		RemoveFromArray(fileArray_Added, ArrayPos);
		RemoveFromArray(nameArray_Added, ArrayPos);
		
		
		CPrintToChat(client, "{%s}[%s] {%s}Sound %s was removed from the shoutlist.", prefixcolor, prefix, textcolor, namebuffer);
		
		RefreshMenu(menu, client, GetMenuSelectionPosition(), fileArray_Added, nameArray_Added);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuShoutManager(client);
}

// ******************************************************************************************************************
// *************************************************** SHOUTLIST ****************************************************
public void OpenMenuShoutPathList(int client)
{
	Menu menu = new Menu(MenuHandlerShoutPathList);
	menu.SetTitle("Shoutlist");
	
	char filebuffer[PLATFORM_MAX_PATH], namebuffer[64], menubuffer[512];
	
	for(int i = 0; i < GetArraySize(nameArray_Added); i++)
	{
		GetArrayString(fileArray_Added, i, filebuffer, sizeof(filebuffer));
		GetArrayString(nameArray_Added, i, namebuffer, sizeof(namebuffer));
		Format(menubuffer, sizeof(menubuffer), "[%s] - %s", namebuffer, filebuffer);
		
		char buffer[32];
		IntToString(i, buffer, sizeof(buffer)); 
		
		menu.AddItem(buffer, menubuffer, ITEMDRAW_DISABLED);
	}
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutPathList(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		RefreshMenu(menu, client, GetMenuSelectionPosition(), fileArray_Added, nameArray_Added);
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuShoutManager(client);
}

// ******************************************************************************************************************
// ****************************************************** HELP ******************************************************
// ******************************************************************************************************************
public void OpenMenuShoutHelp(int client)
{
	Menu menu = new Menu(MenuHandlerShoutHelp);
	menu.SetTitle("Help & Credits");
	
	char formatstring[64], debugstring[64];
	if(shoutMessage == 1) Format(formatstring, sizeof(formatstring), "Join Advert: On");
	else if(shoutMessage == 0)Format(formatstring, sizeof(formatstring), "Join Advert: Off");
	if(shoutDebug == 1) Format(debugstring, sizeof(debugstring), "Debug: On");
	else if (shoutDebug == 0) Format(debugstring, sizeof(debugstring), "Debug: Off");
	
	menu.AddItem("settings", "About: Settings");
	menu.AddItem("adding", "About: Managing shouts");
	menu.AddItem("credits", "Credits");
	menu.AddItem("joinmsg", formatstring);
	if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true)) menu.AddItem("debug", debugstring);
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerShoutHelp(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[64];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
		
		if(StrEqual(menuItem, "settings")) OpenPanelShoutSettings(client);
		else if(StrEqual(menuItem, "adding")) OpenPanelShoutAddHelp(client);
		else if(StrEqual(menuItem, "credits")) OpenPanelShoutCredits(client);
		else if(StrEqual(menuItem, "joinmsg"))
		{
			if(shoutMessage == 1)
			{
				shoutMessage = 0;
				ShoutUpdateSettingsInt("message", shoutMessage);
				OpenMenuShoutHelp(client);
			}
			else
			{
				shoutMessage = 1;
				ShoutUpdateSettingsInt("message", shoutMessage);
				OpenMenuShoutHelp(client);
			}
		}
		else if(StrEqual(menuItem, "debug"))
		{
			if(shoutDebug == 1)
			{
				shoutDebug = 0;
				ShoutUpdateSettingsInt("debug", shoutDebug);
				OpenMenuShoutHelp(client);
			}
			else
			{
				shoutDebug = 1;
				ShoutUpdateSettingsInt("debug", shoutDebug);
				OpenMenuShoutHelp(client);
			}
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuShoutSet(client);
}

public void OpenPanelShoutSettings(int client)
{
	int panel_keys = 0;
	
	Panel panel = new Panel();
	panel.SetTitle("Shoutset Settings");
	panel.DrawText("══════════════════════════════");
	panel.DrawText("Cooldown:");
	panel.DrawText("Adjust the cooldown between uses");
	panel.DrawText(" ");
	panel.DrawText("Volume:");
	panel.DrawText("Adjust the sound volume. 0 = OFF");
	panel.DrawText(" ");
	panel.DrawText("Pitch:");
	panel.DrawText("Adjust the Pitch");
	panel.DrawText(" ");
	panel.DrawText("Radius:");
	panel.DrawText("Change the distance sounds can be heard");
	panel.DrawText(" ");
	panel.DrawText("Commands:");
	panel.DrawText("Create an own command per shout?");
	panel.DrawText(" ");
	panel.DrawText("Mode:");
	panel.DrawText("Switch between the 4 different modes");
	panel.DrawText(" ");
	panel.DrawText("Manager:");
	panel.DrawText("Add, Edit and Remove shouts");
	panel.DrawText("══════════════════════════════");
	panel.DrawText(" ");
	panel.DrawText("0. Back");
	for(int i = 1; i <= 10; i++)
	{
		panel_keys |= (1<<i-1);
	}

	panel.SetKeys(panel_keys);
 
	panel.Send(client, HelpSettingsShoutPanelHandler, MENU_TIME_FOREVER);
 
	delete panel;
}

public void OpenPanelShoutAddHelp(int client)
{
	int panel_keys = 0;
	
	Panel panel = new Panel();
	panel.SetTitle("Managing Shouts");
	panel.DrawText("══════════════════════════════");
	panel.DrawText("Added shouts will automatically added");
	panel.DrawText("to the downloadlist and precached.");
	panel.DrawText("Adding new shouts require a mapchange");
	panel.DrawText("so everyone can hear them, because of");
	panel.DrawText("how downloads work.");
	panel.DrawText(" ");
	panel.DrawText("You can also manually edit the shout-");
	panel.DrawText("list. The file can be found in:");
	panel.DrawText("<game_dir>/cfg/sm_soccermod/");
	panel.DrawText("══════════════════════════════");
	panel.DrawText(" ");
	panel.DrawText("0. Back");
	for(int i = 1; i <= 10; i++)
	{
		panel_keys |= (1<<i-1);
	}

	panel.SetKeys(panel_keys);
 
	panel.Send(client, HelpSettingsShoutPanelHandler, MENU_TIME_FOREVER);
 
	delete panel;
}

public void OpenPanelShoutCredits(int client)
{
	int panel_keys = 0;
	
	Panel panel = new Panel();
	panel.SetTitle("Credits");
	panel.DrawText("══════════════════════════════");
	panel.DrawText("Original Eventscripts version by:");
	panel.DrawText("─────>> Marco Boogers");
	panel.DrawText(" ");
	panel.DrawText("Sourcemod version by:");
	panel.DrawText("─────>> Arturo");
	panel.DrawText(" ");
	panel.DrawText("Request and feature ideas:");
	panel.DrawText("─────>> Subi");
	panel.DrawText(" ");
	panel.DrawText("══════════════════════════════");
	panel.DrawText("0. Back");
	for(int i = 1; i <= 10; i++)
	{
		panel_keys |= (1<<i-1);
	}

	panel.SetKeys(panel_keys);
 
	panel.Send(client, HelpSettingsShoutPanelHandler, MENU_TIME_FOREVER);
 
	delete panel;
}

public int HelpSettingsShoutPanelHandler(Menu menu, MenuAction action, int client, int key)
{
	if (action == MenuAction_Select)
	{	
		OpenMenuShoutHelp(client)
	}
	else
	{
		OpenMenuShoutHelp(client)
	}
}


// ******************************************************************************************************************
// ***************************************************** SHARED *****************************************************

public void RefreshMenu(Menu menu, int client, int position, Handle filearray, Handle namearray)
{
	menu.RemoveAllItems();
	char filebuffer[PLATFORM_MAX_PATH], namebuffer[64], menubuffer[512];
	
	for(int i = 0; i < GetArraySize(namearray); i++)
	{
		GetArrayString(filearray, i, filebuffer, sizeof(filebuffer));
		GetArrayString(namearray, i, namebuffer, sizeof(namebuffer));
		Format(menubuffer, sizeof(menubuffer), "[%s] - %s", namebuffer, filebuffer);
		
		char buffer[32];
		IntToString(i, buffer, sizeof(buffer)); 
		
		if(namearray == nameArray_Added) menu.AddItem(buffer, menubuffer);
		else menu.AddItem(buffer, namebuffer);
	}
	DisplayMenuAtItem(menu, client, position, MENU_TIME_FOREVER);
}

