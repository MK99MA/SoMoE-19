public Action Timer_SprintEnd(Handle timer, int client)
{
	h_SPRINT_TIMERS[client] = INVALID_HANDLE;

	if(IsClientInGame(client) && (iCLIENT_STATUS[client] & CLIENT_SPRINTUSING))
	{
		iCLIENT_STATUS[client] &= ~ CLIENT_SPRINTUSING;

		//Reset sprint speed
		SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.0);

		if(IsPlayerAlive(client) && GetClientTeam(client) > 1)
		{
			//Outputs
			PrintSprintEndMsgToClient(client);

			if(iP_SETTINGS[client] & PLAYER_PROGRESS_BAR)
			{
				SetEntPropFloat(client, Prop_Send, "m_flProgressBarStartTime",
				GetGameTime());
		
				SetEntProp(client, Prop_Send, "m_iProgressBarDuration", 
				RoundFloat(fSPRINT_COOLDOWN));
			}

			if(iP_SETTINGS[client] & PLAYER_TIMER)
			{
				DataPack pack = new DataPack();
				h_SPRINT_REFILL[client] = CreateTimer(0.1, SprintHudRefill, pack, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE|TIMER_DATA_HNDL_CLOSE);
				pack.WriteCell(client);
				pack.WriteFloat(fSPRINT_COOLDOWN);
			}
			else delete h_SPRINT_REFILL[client];
			
			//----

			h_SPRINT_TIMERS[client] = CreateTimer(fSPRINT_COOLDOWN,
			Timer_SprintCooldown, client);
		}
	}

	return;
}

public Action SprintHudRefill(Handle timer, DataPack pack)
{
	pack.Reset();
	int client = pack.ReadCell();
	float time = pack.ReadFloat();
	
	char cdBuffer[32];
	SetHudTextParams(x_val[client], y_val[client], 0.1, red_val[client], green_val[client], blue_val[client], 255);
	
	if(time > 0.0)
	{
		Format(cdBuffer, sizeof(cdBuffer), "Cooldown: %.1f ", time);
		ShowHudText(client, 5, cdBuffer); 
		time = time - 0.1;
		
		pack.Reset();
		pack.WriteCell(client);
		pack.WriteFloat(time);
	}
	else if(time == 0.0)
	{
		delete h_SPRINT_REFILL[client];
		CloseHandle(pack);
		ShowHudText(client, 5, "");	
	}
	
	return;
}

public Action Timer_SprintCooldown(Handle timer, int client)
{
	h_SPRINT_TIMERS[client] = INVALID_HANDLE;

	if(IsClientInGame(client) && (iCLIENT_STATUS[client] & CLIENT_SPRINTUNABLE))
	{
		iCLIENT_STATUS[client] &= ~ CLIENT_SPRINTUNABLE;

		if(IsPlayerAlive(client) && GetClientTeam(client) > 1)
		{
			//Outputs
			PrintSprintCDMsgToClient(client);

			SendProgressBarResetToClient(client);
			//----
		}
	}

	return;
}