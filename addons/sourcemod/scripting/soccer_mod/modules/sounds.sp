//SOUND STUFF

public void PlaySound(char sound[PLATFORM_MAX_PATH])
{
	EmitSoundToAll(sound);
	//EmitSoundToAll(sound);
}


public Action AmbientSHook(char sample[PLATFORM_MAX_PATH], int& entity, float& volume, int& level, int& pitch, float pos[3], int& flags, float& delay)
{
	if(StrContains(sample, "sifflet_start.wav") != -1)
	{
		if(volume > 0.0)
		{
			if(matchStart)
			{
				volume = 0.0;
					
				return Plugin_Changed;
			}
			else return Plugin_Continue;
		}
		else return Plugin_Continue;
	}
	else if(StrContains(sample, "sifflet_but.wav") != -1)
	{
		if(volume > 0.0)
		{
			if((matchGoldenGoalActive || matchStoppageTimeStarted))
			{
				volume = 0.0;
					
				return Plugin_Changed;
			}
			else return Plugin_Continue;
		}
		else return Plugin_Continue;
	}
	else return Plugin_Continue;
}