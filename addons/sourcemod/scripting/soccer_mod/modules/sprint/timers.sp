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

      h_SPRINT_REFILL[client] = CreateTimer((fSPRINT_COOLDOWN/20), Sprint_Refill, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE|TIMER_DATA_HNDL_CLOSE);
      //----

      h_SPRINT_TIMERS[client] = CreateTimer(fSPRINT_COOLDOWN,
      Timer_SprintCooldown, client);
    }
  }

  return;
}

public Action Sprint_Refill(Handle timer, int client)
{
	int armor_val = GetClientArmor(client);

	if (armor_val < 100 && !capFightStarted) SetEntProp(client, Prop_Send, "m_ArmorValue", (armor_val+(100/RoundFloat(fSPRINT_COOLDOWN*(20/fSPRINT_COOLDOWN)))));
	else if (armor_val < 100 && capFightStarted) KillTimer(h_SPRINT_REFILL[client]); //Killtimer Sprint_Refill
	else if (armor_val >= 100)
	{
		if(h_SPRINT_REFILL[client] != null)
		{
			KillTimer(h_SPRINT_REFILL[client]); //Killtimer Sprint_Refill
			h_SPRINT_REFILL[client] = null;
		}
		SetEntProp(client, Prop_Send, "m_ArmorValue", 100);
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