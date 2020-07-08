public Action DJBOnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon)
{
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

