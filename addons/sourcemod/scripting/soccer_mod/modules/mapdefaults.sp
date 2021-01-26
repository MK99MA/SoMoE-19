public void SetDefaultValues()
{
	int buffer;
	char map[128];
	GetCurrentMap(map, sizeof(map));
	//PrintToServer(map);
	
	mapdefaultKV = new KeyValues("Map Defaults");
	mapdefaultKV.ImportFromFile(mapDefaults);
	
	if (mapdefaultKV.JumpToKey(map, false))
	{
		//PrintToServer("FOUND");
		buffer = mapdefaultKV.GetNum("default_periodlength", 0);
		if(buffer != 0) 
		{
			matchPeriodLength = buffer;
			UpdateConfigInt("Match Settings", "soccer_mod_match_period_length", matchPeriodLength);
		}
		buffer = mapdefaultKV.GetNum("default_breaklength", 0);
		if(buffer != 0)
		{
			matchPeriodBreakLength = buffer;
			UpdateConfigInt("Match Settings", "soccer_mod_match_period_break_length", matchPeriodBreakLength);
		}
		buffer = mapdefaultKV.GetNum("default_periods", 0);
		if(buffer != 0)
		{
			matchPeriods = buffer;
			UpdateConfigInt("Match Settings", "soccer_mod_match_periods", matchPeriods);
		}
	}
	
	mapdefaultKV.Rewind();
	mapdefaultKV.Close();
}