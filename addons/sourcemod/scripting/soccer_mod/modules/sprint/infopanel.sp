public void OpenInfoPanel(int client)
{
	char sBuf[256], sBuf2[64];
	Handle h_Infopanel = CreatePanel();
	int panel_keys = 0;

	SetGlobalTransTarget(client);

	Format(sBuf, sizeof(sBuf), "Sprintinfo");
	DrawPanelText(h_Infopanel, sBuf);
	DrawPanelText(h_Infopanel, " ")

	Format(sBuf2, sizeof(sBuf2), "%s%s", "!", "sprint");

	if(bSPRINT_BUTTON)
	{
		Format(sBuf, sizeof(sBuf), "\nPress your 'use'-key\n(default: E) to sprint!");
		DrawPanelText(h_Infopanel, sBuf);
		Format(sBuf, sizeof(sBuf), "\nor use the command %s \n", sBuf2);
		DrawPanelText(h_Infopanel, sBuf);
		DrawPanelText(h_Infopanel, " ")
	}
	else
	{
		Format(sBuf, sizeof(sBuf), "Use %s to sprint \n", sBuf2);
		DrawPanelText(h_Infopanel, sBuf);
		DrawPanelText(h_Infopanel, " ")
	}

	//Client settings
	Format(sBuf, sizeof(sBuf), "Settings:");
	DrawPanelText(h_Infopanel, sBuf);
	DrawPanelText(h_Infopanel, " ")

	int cStatus = '-';
	char sItem_display[5][32] = {"Messages",
	"Progress Bar", "Sound", "Timer", "Timer Settings"};

	for(int i = 1; i <= 5; i++)
	{
		cStatus = '-';
		if(iP_SETTINGS[client] & (1<<i))
		{
			cStatus = '+';
		}

		panel_keys |= (1<<i-1);
		if(i <= 4)	Format(sBuf, sizeof(sBuf), "->%i. [%c] %s", i, cStatus, sItem_display[(i-1)]);
		if(i == 5)  Format(sBuf, sizeof(sBuf), "->%i. %s", i, sItem_display[(i-1)]);
		DrawPanelText(h_Infopanel, sBuf);
	}
	
	//

	DrawPanelText(h_Infopanel, " ");

	Format(sBuf, sizeof(sBuf), "The sprint command can\nbe bound to a free key\nusing the console.\n \nFor example:\nbind \"q\" \"say %s\"", sBuf2);
	DrawPanelText(h_Infopanel, sBuf);
	DrawPanelText(h_Infopanel, " ")

	DrawPanelText(h_Infopanel, " ")
	
	panel_keys |= (1<<10-1);
	Format(sBuf, sizeof(sBuf), "0. Back");
	DrawPanelText(h_Infopanel, sBuf);

	SetPanelKeys(h_Infopanel, panel_keys);

	SendPanelToClient(h_Infopanel, client, InfoPanelReturn, MENU_TIME_FOREVER);
	CloseHandle(h_Infopanel);
}

public int InfoPanelReturn(Handle panel, MenuAction action, int client, int key)
{
	if(action == MenuAction_Select && key >= 1 && key <= 4)
	{
		int iP_setting = key;

		if((iP_SETTINGS[client] ^ (1<<iP_setting)) > PLAYER_INITIALIZED)
		{
			iP_SETTINGS[client] ^= (1<<iP_setting);
			iP_SETTINGS[client] |= PLAYER_INITIALIZED;
		}
		else
		{
			PrintHintText(client, "At least one field must remain activated!");
		}

		OpenInfoPanel(client);
	}
	else if(action == MenuAction_Select && key == 5)	
	{
		DisplayHud(client);
		OpenMenuSprintTimer(client);
	}
	else OpenMenuSoccer(client);

	return;
}

public void OpenMenuSprintTimer(int client)
{
	Menu menu = new Menu(MenuHandlerSprintTimer);

	char menuBuffer[64];
	Format(menuBuffer, sizeof(menuBuffer), "X: %.2f | Y: %.2f", x_val[client], y_val[client]);
	menu.SetTitle(menuBuffer);
	
	menu.AddItem("x+", "X+ (right)");
	menu.AddItem("x-", "X- (left)");
	menu.AddItem("y+", "Y+ (up)");
	menu.AddItem("y-", "Y- (down)");
	menu.AddItem("color", "Color");
	menu.AddItem("show", "Display timer");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerSprintTimer(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "x+"))
		{
			x_val[client] = x_val[client] + 0.01;
			OpenMenuSprintTimer(client);
		}
		else if (StrEqual(menuItem, "x-"))			  
		{
			x_val[client] = x_val[client] - 0.01;
			OpenMenuSprintTimer(client);
		}
		else if (StrEqual(menuItem, "y-"))
		{
			y_val[client] = y_val[client] + 0.01;
			OpenMenuSprintTimer(client);
		}
		else if (StrEqual(menuItem, "y+"))
		{
			y_val[client] = y_val[client] - 0.01;
			OpenMenuSprintTimer(client);
		}
		else if (StrEqual(menuItem, "show")) 
		{
			DisplayHud(client);
			OpenMenuSprintTimer(client);
		}
		else if (StrEqual(menuItem, "color")) OpenMenuSprintTimerColor(client);
	}
	else if (action == MenuAction_Cancel && choice == -6)   
	{
		showHudPrev[client] = false;
		delete h_TIMER_SET[client];
		OpenInfoPanel(client);
	}
	else if (action == MenuAction_Cancel)		
	{
		showHudPrev[client] = false;
		delete h_TIMER_SET[client];
	}
	else if (action == MenuAction_End)	menu.Close();
}

public void OpenMenuSprintTimerColor(int client)
{
	Menu menu = new Menu(MenuHandlerSprintTimerColor);

	char menuBuffer[64];
	Format(menuBuffer, sizeof(menuBuffer), "Red: %i | Green: %i | Blue: %i", red_val[client], green_val[client], blue_val[client]);
	menu.SetTitle(menuBuffer);
		
	menu.AddItem("R+", "Red (+5)");
	menu.AddItem("R-", "Red (-5)");
	menu.AddItem("G+", "Green (+5)");
	menu.AddItem("G-", "Green (-5)");
	menu.AddItem("B+", "Blue (+5)");
	menu.AddItem("B-", "Blue (-5)");
	menu.AddItem("show", "Display timer");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerSprintTimerColor(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));

		if (StrEqual(menuItem, "R+"))
		{
			if(red_val[client] <= 250)	red_val[client] = red_val[client] + 5;
			else if (red_val[client] == 255) red_val[client] = 0;
			OpenMenuSprintTimerColor(client);
		}
		else if (StrEqual(menuItem, "G+"))			  
		{
			if(green_val[client] <= 250)	green_val[client] = green_val[client] + 5;
			else if (green_val[client] == 255) green_val[client] = 0;
			OpenMenuSprintTimerColor(client);
		}
		else if (StrEqual(menuItem, "B+"))
		{
			if(blue_val[client] <= 250)	blue_val[client] = blue_val[client] + 5;
			else if (blue_val[client] == 255) blue_val[client] = 0;
			OpenMenuSprintTimerColor(client);
		}
		else if (StrEqual(menuItem, "R-"))
		{
			if(red_val[client] >= 5)	red_val[client] = red_val[client] - 5;
			else if (red_val[client] == 0) red_val[client] = 255;
			OpenMenuSprintTimerColor(client);
		}
		else if (StrEqual(menuItem, "G-"))			  
		{
			if(green_val[client] >= 5)	green_val[client] = green_val[client] - 5;
			else if (green_val[client] == 0) green_val[client] = 255;
			OpenMenuSprintTimerColor(client);
		}
		else if (StrEqual(menuItem, "B-"))
		{
			if(blue_val[client] >= 5)	blue_val[client] = blue_val[client] - 5;
			else if (blue_val[client] == 0) blue_val[client] = 255;
			OpenMenuSprintTimerColor(client);
		}
		else if (StrEqual(menuItem, "show"))
		{
			DisplayHud(client);
			OpenMenuSprintTimerColor(client)
		}
	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSprintTimer(client);
	else if (action == MenuAction_Cancel)		
	{
		showHudPrev[client] = false;
		delete h_TIMER_SET[client];
	}
	else if (action == MenuAction_End)			menu.Close();
}

public void DisplayHud(int client)
{
	if(h_TIMER_SET[client] == INVALID_HANDLE)
	{
		showHudPrev[client] = true;
		
		DataPack tpack = new DataPack();
		h_TIMER_SET[client] = CreateDataTimer(0.1, DisplayHudText, tpack, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE|TIMER_DATA_HNDL_CLOSE);
		tpack.WriteCell(client);
		tpack.WriteFloat(fSPRINT_TIME);
		tpack.WriteString("Sprinting");
	}
}

public Action DisplayHudText(Handle timer, DataPack tpack)
{
	char sBuf[32];
	tpack.Reset();
	int client = tpack.ReadCell();
	float time = tpack.ReadFloat();
	tpack.ReadString(sBuf, sizeof(sBuf));
	
	char buffer[32];
	
	if(!matchStarted && !(iCLIENT_STATUS[client] & CLIENT_SPRINTUNABLE))
	{
		if(showHudPrev[client])
		{
			SetHudTextParams(x_val[client], y_val[client], 0.1, red_val[client], green_val[client], blue_val[client], 255);
			
			if(time >= 0.1)
			{
				if(StrEqual(sBuf, "Sprinting"))Format(buffer, sizeof(buffer), "Sprinting: %.1f ", time);
				else if(StrEqual(sBuf, "Cooldown"))Format(buffer, sizeof(buffer), "Cooldown: %.1f ", time);
				ShowHudText(client, 5, buffer); 
				time = time - 0.1;
				
				tpack.Reset();
				tpack.WriteCell(client);
				tpack.WriteFloat(time);
				tpack.WriteString(sBuf);
			}
			else if(time < 0.1)
			{
				if(StrEqual(sBuf, "Sprinting")) 
				{
					time = fSPRINT_COOLDOWN;
					sBuf = "Cooldown";
				}
				else if(StrEqual(sBuf, "Cooldown")) 
				{
					time = fSPRINT_TIME;
					sBuf = "Sprinting";
				}
				tpack.Reset();
				tpack.WriteCell(client);
				tpack.WriteFloat(fSPRINT_COOLDOWN);
				tpack.WriteString(sBuf);
			}
		}
		else
		{
			showHudPrev[client] = false;
			delete h_TIMER_SET[client];
			CloseHandle(tpack);
		}
	}
	else 
	{
		showHudPrev[client] = false;
		delete h_TIMER_SET[client];
	}
		
	return;
}