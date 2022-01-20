public void PlaySound(char sound[PLATFORM_MAX_PATH])
{
	EmitSoundToAll(sound);
}

public Action AmbientSHook(char sample[PLATFORM_MAX_PATH], int& entity, float& volume, int& level, int& pitch, float pos[3], int& flags, float& delay)
{
	if(StrContains(sample, "sifflet_start.wav") != -1)
	{
		if(matchStart)	return Plugin_Handled;
		else return Plugin_Continue;
		/*if(volume > 0.0)
		{
			if(matchStart)
			{
				volume = 0.0;
					
				return Plugin_Changed;
			}
			else return Plugin_Continue;
		}
		else return Plugin_Continue;*/
	}
	else if(StrContains(sample, "sifflet_but.wav") != -1)
	{
		if((matchGoldenGoalActive || matchStoppageTimeStarted)) return Plugin_Handled;
		else return Plugin_Continue;
		/*if(volume > 0.0)
		{
			if((matchGoldenGoalActive || matchStoppageTimeStarted))
			{
				volume = 0.0;
					
				return Plugin_Changed;
			}
			else return Plugin_Continue;
		}
		else return Plugin_Continue;*/
	}
	else return Plugin_Continue;
}

public Action sound_hook(int clients[64], int& numClients, char sample[PLATFORM_MAX_PATH], int& entity, int& channel, float& volume, int& level, int& pitch, int& flags)
{
	if(damageSounds == 0)
	{
		if(StrContains(sample, "player/damage", false) >= 0) 	return Plugin_Handled;
	}
	if(StrContains(sample, "player/kevlar", false) >= 0) 		return Plugin_Handled;
	if(StrContains(sample, "player/bhit_helmet", false) >= 0) 	return Plugin_Handled;
	if(StrContains(sample, "player/headshot", false) >= 0) 		return Plugin_Handled;
	
	return Plugin_Continue;
}