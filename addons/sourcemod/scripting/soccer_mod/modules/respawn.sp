// ************************************************************************************************************
// ************************************************** EVENTS **************************************************
// ************************************************************************************************************
public void RespawnOnClientPutInServer(int client)
{
	respawnTimers[client] = null;
}

public void RespawnOnClientDisconnect(int client)
{
	if (respawnTimers[client] != null)
	{
		KillTimer(respawnTimers[client]);
		respawnTimers[client] = null;
	}
}

public void RespawnEventPlayer(Event event)
{
	int userid = event.GetInt("userid");
	int client = GetClientOfUserId(userid);
	respawnTimers[client] = CreateTimer(respawnDelay, TimerRespawn, client);
}

// ************************************************************************************************************
// ************************************************** TIMERS **************************************************
// ************************************************************************************************************
public Action TimerRespawn(Handle timer, any client)
{
	respawnTimers[client] = null;

	if (client > 0 && IsClientInGame(client) && IsClientConnected(client) && !IsPlayerAlive(client) && !roundEnded && GetClientTeam(client) > 1) CS_RespawnPlayer(client);
}

public Action DelayFreezePlayer(Handle timer, any client)
{
	SetEntityMoveType(client, MOVETYPE_NONE);
}

// ************************************************************************************************************
// ************************************************ FUNCTIONS *************************************************
// ************************************************************************************************************
public Action Dissolve(Handle timer, any client)
{
	if (!IsValidEntity(client))		return;
	
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");
	if (ragdoll<0)
	{
		PrintToServer("Could not get ragdoll for player!");	
		return;
	}
	
	char dname[32];
	Format(dname, sizeof(dname), "dis_%d", client);
	
	int dis_ent = CreateEntityByName("env_entity_dissolver");
	if (dis_ent>0)
	{
		if(dissolveSet == 2)
		{
			DispatchKeyValue(ragdoll, "targetname", dname);
			DispatchKeyValue(dis_ent, "dissolvetype", "0");
			DispatchKeyValue(dis_ent, "target", dname);
			AcceptEntityInput(dis_ent, "Dissolve");
			AcceptEntityInput(dis_ent, "kill");
		}
		else if(dissolveSet == 1) AcceptEntityInput(ragdoll, "kill");
	}
}