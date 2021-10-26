// ********************************************************************************************************************
// ************************************************** DEADCHAT MODULE *************************************************
// ********************************************************************************************************************
public void DeadChatOnPluginStart()
{
	UserMsg SayText2 = GetUserMessageId("SayText2");
	
	if (SayText2 == INVALID_MESSAGE_ID)
	{
		SetFailState("This game doesn't support SayText2 user messages.");
	}
	
	if (DeadChatMode > 0)
	{
		HookUserMessage(SayText2, Hook_UserMessage);
		HookEvent("player_say", Event_PlayerSay);
	}
	
	// Convars.
	g_hCvarAllTalk = FindConVar("sv_alltalk");
		
	//AutoExecConfig(true, "allchat");
	
	// Commands.
	AddCommandListener(Command_Say, "say");
	AddCommandListener(Command_Say, "say_team");
	
}

public Action Hook_UserMessage(UserMsg msg_id, Handle bf, const char[] players, int playersNum, bool reliable, bool init)
{
	g_msgAuthor = BfReadByte(bf);
	g_msgIsChat = view_as<bool>(BfReadByte(bf));
	BfReadString(bf, g_msgType, sizeof(g_msgType), false);
	BfReadString(bf, g_msgName, sizeof(g_msgName), false);
	BfReadString(bf, g_msgText, sizeof(g_msgText), false);
	
	for (int i = 0; i < playersNum; i++)
	{
		g_msgTarget[players[i]] = false;
	}
}

public Action Event_PlayerSay(Handle event, const char[] name, bool dontBroadcast)
{
	int mode = DeadChatMode;
	
	if (mode < 1)
	{
		return;
	}
	
	if (mode > 1 && g_hCvarAllTalk != INVALID_HANDLE && !GetConVarBool(g_hCvarAllTalk))
	{
		return;
	}
	
	if (GetClientOfUserId(GetEventInt(event, "userid")) != g_msgAuthor)
	{
		return;
	}
	
	mode = DeadChatVis;
	
	if (g_msgIsTeammate && mode < 1)
	{
		return;
	}
	
	int[] players = new int[MaxClients];
	int playersNum = 0;
	
	if (g_msgIsTeammate && mode == 1 && g_msgAuthor > 0)
	{
		int team = GetClientTeam(g_msgAuthor);
		
		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsClientInGame(client) && g_msgTarget[client] && GetClientTeam(client) == team)
			{
				players[playersNum++] = client;
			}
			
			g_msgTarget[client] = false;
		}
	}
	else
	{
		for (int client = 1; client <= MaxClients; client++)
		{
			if (IsClientInGame(client) && g_msgTarget[client])
			{
				players[playersNum++] = client;
			}
			
			g_msgTarget[client] = false;
		}
	}
	
	if (playersNum == 0)
	{
		return;
	}
	
	Handle SayText2 = StartMessage("SayText2", players, playersNum, USERMSG_RELIABLE | USERMSG_BLOCKHOOKS);
	
	if (SayText2 != INVALID_HANDLE)
	{
		BfWriteByte(SayText2, g_msgAuthor);
		BfWriteByte(SayText2, g_msgIsChat);
		BfWriteString(SayText2, g_msgType);
		BfWriteString(SayText2, g_msgName);
		BfWriteString(SayText2, g_msgText);
		EndMessage();
	}
}

public Action Command_Say(int client, const char[] command, int argc)
{
	for (int target = 1; target <= MaxClients; target++)
	{
		g_msgTarget[target] = true;
	}
	
	if (StrEqual(command, "say_team", false))
	{
		g_msgIsTeammate = true;
	}
	else
	{
		g_msgIsTeammate = false;
	}
	
	return Plugin_Continue;
}