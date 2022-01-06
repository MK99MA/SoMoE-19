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
	else if (djbenabled >= 2)
	{
		/*if(buttons & IN_JUMP)
		{
			if(g_bJump[client])
			{
				buttons &= ~IN_JUMP;
				return Plugin_Changed;
			}
		}*/
		if(buttons & IN_DUCK)
		{
			g_bIsDuck[client] = true;
			
			if(g_bJump[client])
			{
				buttons &= ~IN_DUCK;
				
				//g_bDuck[client] = false;
				return Plugin_Changed;
			}
		}
		else if(g_bIsDuck[client])
		{
			g_bIsDuck[client] = false;
			g_bDuck[client] = true;
		}
				
		return Plugin_Continue;
	}
	
	//else return view_as<Action>(0);
	
	return Plugin_Continue;
}

public Action EventPlayerJump(Event event, const char[] name, bool dontBroadcast)
{
	if(djbenabled == 2)
	{
		int client = GetClientOfUserId(event.GetInt("userid"));
		g_bJump[client] = true;

		//get gametime of jump
		jump_time[client] = GetGameTime();
		//PrintToChatAll("Jump %.1f", jump_time[client]);
		//reset jumpstate
		//g_cJumpTimer[client] = CreateTimer(0.1, Timer_ResetJump, client);//fJUMP_TIMER, Timer_ResetJump, client);
	}
	else if(djbenabled == 3)
	{
		int client = GetClientOfUserId(event.GetInt("userid"));
		
		g_bJump[client] = true;
		
		//when should the block start?
		jump_time[client] = GetGameTime() + 0.20; //was 0.33
	}
	
	return Plugin_Handled;
}

public void JumpDisconnect(int client)
{
	g_bJump[client] = false;
	g_cJumpTimer[client] = null;
	jump_count[client] = 0;
	jump_time[client] = 0.0;
}

/*
public Action Timer_ResetJump(Handle timer, any client)
{
	// is the player on the ground?
	if(GetEntityFlags(client) & FL_ONGROUND)
	{
		// reset if true
		//PrintToChatAll("groundreset");
		g_bJump[client] = false;
		g_cJumpTimer[client] = null;
		jump_count[client] = 0;
	}
	else
	{
		// do stuff if false
		jump_count[client] += 1;
		//PrintToChatAll("air %i", jump_count[client]);
		
		if(jump_count[client] >= 3)
		{
			// reset after 0.4 seconds
			//PrintToChatAll("reset");
			g_bJump[client] = false;
			g_cJumpTimer[client] = null;
			jump_count[client] = 0;
		}
		else
		{			
			//g_bJump[client] = true;
			// restart the timer
			g_cJumpTimer[client] = CreateTimer(0.1, Timer_ResetJump, client);
		}
	}
}
*/