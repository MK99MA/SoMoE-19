#include "soccer_mod\modules\adminmanagement\add_admins.sp"
#include "soccer_mod\modules\adminmanagement\edit_admins.sp"
#include "soccer_mod\modules\adminmanagement\remove_admins.sp"
#include "soccer_mod\modules\adminmanagement\online_admins.sp"
#include "soccer_mod\modules\adminmanagement\admin_list.sp"

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
			menuaccessed[client] = true;
			OpenMenuOnlineAdmin(client);
		}

	}	
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSettings(client);
	else if (action == MenuAction_End)					  menu.Close();
}

// ************************************************ MODULES SELECTION **************************************************

public void OpenMenuSoccerAdminModules(int client)
{
	char buffer[32], name[64];
	
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);

	kvAdmins.JumpToKey(SteamID, true);
	kvAdmins.GetString("name", name, sizeof(name))
	
	Menu menu = new Menu(MenuHandlerSoccerModules);
	menu.SetTitle("Set Modules of %s", name);
	
	kvAdmins.JumpToKey("modules", true);
	Format(buffer, sizeof(buffer), "[%i] - Match", kvAdmins.GetNum("match", 0));
	menu.AddItem("matchmod", buffer);
	Format(buffer, sizeof(buffer), "[%i] - Cap", kvAdmins.GetNum("cap", 0));
	menu.AddItem("capmod", buffer);
	Format(buffer, sizeof(buffer), "[%i] - Training", kvAdmins.GetNum("training", 0));
	menu.AddItem("trainmod", buffer);
	Format(buffer, sizeof(buffer), "[%i] - Referee", kvAdmins.GetNum("referee", 0));
	menu.AddItem("refmod", buffer);
	Format(buffer, sizeof(buffer), "[%i] - Spec", kvAdmins.GetNum("spec", 0));
	menu.AddItem("specmod", buffer);
	Format(buffer, sizeof(buffer), "[%i] - Map", kvAdmins.GetNum("mapchange", 0));
	menu.AddItem("mapmod", buffer);
	
	kvAdmins.Rewind();
	kvAdmins.Close();
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerSoccerModules(Menu menu, MenuAction action, int client, int choice)
{
	char menuItem[32];
	menu.GetItem(choice, menuItem, sizeof(menuItem));
	
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	
	kvAdmins.JumpToKey(SteamID, true);
	kvAdmins.JumpToKey("modules", true);
		
	if (action == MenuAction_Select)
	{
		if(StrEqual(menuItem, "matchmod"))
		{
			if (kvAdmins.GetNum("match", 0) == 0)
			{
				kvAdmins.SetNum("match", 1);
			}
			else
			{
				kvAdmins.SetNum("match", 0);
			}
		}
		else if(StrEqual(menuItem, "capmod"))
		{
			if (kvAdmins.GetNum("cap", 0) == 0)
			{
				kvAdmins.SetNum("cap", 1);
			}
			else
			{
				kvAdmins.SetNum("cap", 0);
			}
		}
		else if(StrEqual(menuItem, "trainmod"))
		{
			if (kvAdmins.GetNum("training", 0) == 0)
			{
				kvAdmins.SetNum("training", 1);
			}
			else
			{
				kvAdmins.SetNum("training", 0);
			}
		}
		else if(StrEqual(menuItem, "refmod"))
		{
			if (kvAdmins.GetNum("referee", 0) == 0)
			{
				kvAdmins.SetNum("referee", 1);
			}
			else
			{
				kvAdmins.SetNum("referee", 0);
			}
		}
		else if(StrEqual(menuItem, "specmod"))
		{
			if (kvAdmins.GetNum("spec", 0) == 0)
			{
				kvAdmins.SetNum("spec", 1);
			}
			else
			{
				kvAdmins.SetNum("spec", 0);
			}
		}
		else if(StrEqual(menuItem, "mapmod"))
		{
			if (kvAdmins.GetNum("mapchange", 0) == 0)
			{
				kvAdmins.SetNum("mapchange", 1);
			}
			else
			{
				kvAdmins.SetNum("mapchange", 0);
			}
		}
		kvAdmins.GoBack();
		
		kvAdmins.Rewind();
		kvAdmins.ExportToFile(adminFileKV);
		kvAdmins.Close();	
		
		OpenMenuSoccerAdminModules(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)
	{
		if(addoredit == 1)OpenMenuEditSoccerAdmin(client);
		else if(addoredit == 0) OpenMenuAddAdmin(client);
	}
	else if (action == MenuAction_End)					  menu.Close();
}

// *************************************************** ADMIN VALUES ****************************************************

public void OpenMenuAddAdminValues(int client)
{
	char nameString[256], steamidString[256], flagString[32], immunityString[32], groupString[128];
	
	if(!GetAdminFlag(FindAdminByIdentity("steam", SteamID), Admin_Generic)) //(!IsSMAdmin(SteamID))
	{
		AddAdminFunc(SteamID);
		ReadAdminFile();
	}
	else ReadAdminFile();
	
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
// *************************************************** FUNCTIONS *****************************************************
// *******************************************************************************************************************
// ************************************************** CHECK FUNCS ****************************************************
public bool IsSoccerAdmin(int client, char module[32])
{
	//char buffer[32];
	bool check = false;
	char temp_SteamID[20];
	GetClientAuthId(client, AuthId_Engine, temp_SteamID, sizeof(temp_SteamID))
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	
	if(StrEqual(module, "menu"))
	{
		if(kvAdmins.JumpToKey(temp_SteamID, false))		check = true;
		else 											check = false;
	}
	else
	{
		kvAdmins.JumpToKey(temp_SteamID, false);
		kvAdmins.JumpToKey("modules", false);
		if(kvAdmins.GetNum(module, 0) == 1) check = true;
	}
	
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
		kvSMAdmins.GetString("identity", adminSteamID, sizeof(adminSteamID), "");
		if (StrEqual(adminSteamID, SteamID))
		{		
			kvSMAdmins.GetSectionName(adminName, sizeof(adminName));
			kvSMAdmins.GetString("flags", adminFlags, sizeof(adminFlags), "");
			kvSMAdmins.GetString("immunity", adminImmunity, sizeof(adminImmunity), "");
			kvSMAdmins.GetString("group", adminGroup, sizeof(adminGroup), "");
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
	
	adminFlags = "b";
	adminGroup = "Default";
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
		else OpenMenuEditSoccerAdmin(client)
	}

	hFile.Close();
	FakeClientCommandEx(client, "sm_reloadadmins");
}

// ************************************************* SOCCERMOD FUNC ***************************************************

public void AddSoccerAdminMenuFunc(int client)
{
	kvAdmins = new KeyValues("Admins");
	kvAdmins.ImportFromFile(adminFileKV);
	
	kvAdmins.JumpToKey(SteamID, true);
	kvAdmins.SetString("name", clientName);	
	kvAdmins.JumpToKey("modules", true);
	kvAdmins.SetNum("match", 		0);
	kvAdmins.SetNum("cap", 			0);
	kvAdmins.SetNum("training",		0);
	kvAdmins.SetNum("referee", 		0);
	kvAdmins.SetNum("spec", 		0);
	kvAdmins.SetNum("mapchange",	0);
	kvAdmins.GoBack();
	
	CPrintToChat(client, "{%s}[%s] {%s}%s was added as a Soccer Mod admin.", prefixcolor, prefix, textcolor, clientName);
	
	kvAdmins.Rewind();
	kvAdmins.ExportToFile(adminFileKV);
	kvAdmins.Close();	
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