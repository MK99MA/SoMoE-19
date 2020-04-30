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
				float time = fSPRINT_COOLDOWN
				DataPack pack = new DataPack();
				h_SPRINT_DURATION[client] = CreateDataTimer(0.1, SprintHud, pack, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE|TIMER_DATA_HNDL_CLOSE);
				pack.WriteCell(client);
				pack.WriteFloat(time);
				pack.WriteString("Cooldown");
			}
			
			//----
			h_SPRINT_TIMERS[client] = CreateTimer(fSPRINT_COOLDOWN,
			Timer_SprintCooldown, client);
		}
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