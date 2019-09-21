float playerMaxHeight[66];
Handle cvar_BLOCKDJ_ENABLED = INVALID_HANDLE;

public void RegisterServerCVarsBlockDJ()
{
	cvar_BLOCKDJ_ENABLED = CreateConVar(
		"soccer_mod_blockdj_enable", 
		"1",
		"Enable/Disable Duckjump Block - Default 1",
		0, true, 0.0, true, 1.0
	);
	
	HookConVarChange		(cvar_BLOCKDJ_ENABLED, DJBlockEnabledConVarChanged);
}


public void DJBlockEnabledConVarChanged(Handle convar, char[] oldValue, char[] newValue)
{
	djbenabled = GetConVarInt(cvar_BLOCKDJ_ENABLED);
	UpdateConfigInt("Misc Settings", "soccer_mod_blockdj_enable", djbenabled);
	return;
}

public Action DJBOnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon)
{
	djbenabled = GetConVarInt(cvar_BLOCKDJ_ENABLED);
	if (djbenabled == 1)
	{
		int onGround = GetEntPropEnt(client, view_as<PropType>(0), "m_hGroundEntity", 0);
		float vecPosition[3] = 0.0;
		GetClientAbsOrigin(client, vecPosition);
		if (onGround == -1)
		{
			if (vecPosition[2] > playerMaxHeight[client])
			{
				playerMaxHeight[client] = vecPosition[2];
				buttons = buttons & -5;
				return view_as<Action>(1);
			}
		}
		else
		{
			playerMaxHeight[client] = vecPosition[2];
		}
		return view_as<Action>(0);
	}
	else return view_as<Action>(0);
}

