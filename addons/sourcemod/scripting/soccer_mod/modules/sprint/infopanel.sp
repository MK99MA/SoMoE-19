#define PANEL_DISPLAYTIME  86400

public Action Command_InfoPanel(int client, int args)
{
	if(!client)
	{
		return(Plugin_Continue);
	}

	if(!bSPRINT_ENABLED)
	{
		return(Plugin_Handled);
	}

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
	char sItem_display[3][27] = {"Messages",
	"Progress Bar", "Sound"};

	for(int i = 1; i <= 3; i++)
	{
		cStatus = '-';
		if(iP_SETTINGS[client] & (1<<i))
		{
			cStatus = '+';
		}

		panel_keys |= (1<<i-1);
		Format(sBuf, sizeof(sBuf), "->%i. [%c] %s", i, cStatus, sItem_display[(i-1)]);
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

	SendPanelToClient(h_Infopanel, client, InfoPanelReturn, PANEL_DISPLAYTIME);
	CloseHandle(h_Infopanel);

	return(Plugin_Handled);
}

public int InfoPanelReturn(Handle panel, MenuAction action, int client, int key)
{
	if(action == MenuAction_Select && key >= 1 && key <= 3)
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

		Command_InfoPanel(client, 0);
	}
	else OpenMenuSoccer(client);

	return;
}