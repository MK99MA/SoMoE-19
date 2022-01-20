public void SetDefaultValues(int type)
{
	int buffer;
	char map[128];
	GetCurrentMap(map, sizeof(map));
	//PrintToServer(map);
	
	mapdefaultKV = new KeyValues("Map Defaults");
	mapdefaultKV.ImportFromFile(mapDefaults);
	
	if (mapdefaultKV.JumpToKey(map, false))
	{
		if (type == 0)
		{
			//PrintToServer("FOUND");
			buffer = mapdefaultKV.GetNum("default_periodlength", -1);
			if(buffer != -1) 
			{
				matchPeriodLength = buffer;
				UpdateConfigInt("Match Settings", "soccer_mod_match_period_length", matchPeriodLength);
			}
			buffer = mapdefaultKV.GetNum("default_breaklength", -1);
			if(buffer != -1)
			{
				matchPeriodBreakLength = buffer;
				UpdateConfigInt("Match Settings", "soccer_mod_match_period_break_length", matchPeriodBreakLength);
			}
			buffer = mapdefaultKV.GetNum("default_periods", -1);
			if(buffer != -1)
			{
				matchPeriods = buffer;
				UpdateConfigInt("Match Settings", "soccer_mod_match_periods", matchPeriods);
			}
			buffer = mapdefaultKV.GetNum("default_kickoffwall", -1);
			if(buffer != -1)
			{
				KickoffWallSet = buffer;
				UpdateConfigInt("Misc Settings", "soccer_mod_kickoffwall", KickoffWallSet);
			}
		}
		else if (type == 1)
		{
			if (mapdefaultKV.JumpToKey("removed sounds", false))
			{
				char sound[32], entitytype[32];
				mapdefaultKV.GotoFirstSubKey();
				
				do
				{
					//retrieve soundname & type
					mapdefaultKV.GetSectionName(sound, sizeof(sound));
					//PrintToServer(sound);
					mapdefaultKV.GetString("type", entitytype, sizeof(entitytype), "ambient_generic");
					//PrintToServer(entitytype);
					
					int entityid
					entityid = GetEntityIndexByName(sound, entitytype);
					if (entityid != -1)
					{
						AcceptEntityInput(entityid, "StopSound");
						AcceptEntityInput(entityid, "Kill");
						PrintToServer("Entity %s of type %s killed!", sound, entitytype);
					}
				}	
				while mapdefaultKV.GotoNextKey();
			}
		}
	}
	
	mapdefaultKV.Rewind();
	mapdefaultKV.Close();
}