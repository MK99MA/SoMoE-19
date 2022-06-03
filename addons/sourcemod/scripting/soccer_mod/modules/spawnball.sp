public void SpawnBallOnMapStart()
{
	ballspawn_required = false;
	//ballspawnpoint trigger_once
	spawnballpos = GetEntityIndexByName("ballspawnpoint", "trigger_once");
	
	if(spawnballpos != -1)
	{
		GetEntPropVector(spawnballpos, Prop_Send, "m_vecOrigin", ballspawn_pos);
		
		int index = CreateEntityByName("prop_physics");
		if (index)
		{
			if (!IsModelPrecached(spawnModelBall)) PrecacheModel(spawnModelBall);

			DispatchKeyValue(index, "targetname", "ballon");
			DispatchKeyValue(index, "model", spawnModelBall);


			DispatchKeyValueVector(index, "origin", ballspawn_pos);

			DispatchSpawn(index);
		}
		ballspawn_required = true;
		PrintToServer("Ballspawn required!");
	}
	else
	{
		LogError("Entity not found (%i)",
             spawnballpos);
		
		return;
	}
}

public void SpawnBallOnRoundStart()
{
	if(ballspawn_required)
	{
		int index = CreateEntityByName("prop_physics");
		if (index)
		{
			if (!IsModelPrecached(spawnModelBall)) PrecacheModel(spawnModelBall);

			DispatchKeyValue(index, "targetname", "ballon");
			DispatchKeyValue(index, "model", spawnModelBall);


			DispatchKeyValueVector(index, "origin", ballspawn_pos);

			DispatchSpawn(index);
		}
	}
}