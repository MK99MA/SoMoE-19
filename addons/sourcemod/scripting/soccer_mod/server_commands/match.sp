public void RegisterServerCommandsMatch()
{
	RegServerCmd
	(
		"soccer_mod_match_periods",
		ServerCommandsMatch,
		"Sets the number of periods of a match - values: 1-10, default: 2"
	);
	RegServerCmd
	(
		"soccer_mod_match_period_length",
		ServerCommandsMatch,
		"Sets the length of a period (in seconds) - values: 5-86400, default: 900"
	);
	RegServerCmd
	(
		"soccer_mod_match_period_break_length",
		ServerCommandsMatch,
		"Sets the length of a period break (in seconds) - values: 5-3600, default: 60"
	);
	RegServerCmd
	(
		"soccer_mod_match_golden_goal",
		ServerCommandsMatch,
		"Enables or disables match golden goal - values: 0/1, default: 1"
	);
	RegServerCmd(
		"soccer_mod_teamnamet",
		ServerCommands,
		"Changes the name of the T team  - default: T"
	);
	RegServerCmd(
		"soccer_mod_teamnamect",
		ServerCommands,
		"Changes the name of the CT team  - default: CT"
	);

}

public Action ServerCommandsMatch(int args)
{
	char serverCommand[50], cmdArg1[8];
	GetCmdArg(0, serverCommand, sizeof(serverCommand));
	GetCmdArg(1, cmdArg1, sizeof(cmdArg1));
	int number = StringToInt(cmdArg1);

	if (StrEqual(serverCommand, "soccer_mod_match_periods"))
	{
		if (1 <= number <= 10) matchPeriods = number;
		else if (number > 10) matchPeriods = 10;
		else matchPeriods = 1;
		UpdateConfigInt("Match Settings", "soccer_mod_match_periods", matchPeriods);

		PrintToServer("[%s] Match periods set to %i", prefix, matchPeriods);
		CPrintToChatAll("{%s}[%s] {%s}Match periods set to %i", prefixcolor, prefix, textcolor, matchPeriods);
	}
	else if (StrEqual(serverCommand, "soccer_mod_match_period_length"))
	{
		if (5 <= number <= 86400) matchPeriodLength = number;
		else if (number > 86400) matchPeriodLength = 86400;
		else matchPeriodLength = 5;
		UpdateConfigInt("Match Settings", "soccer_mod_match_period_length", matchPeriodLength);

		PrintToServer("[%s] Match period length set to %i", prefix, matchPeriodLength);
		CPrintToChatAll("{%s}[%s] {%s}Match period length set to %i", prefixcolor, prefix, textcolor, matchPeriodLength);
	}
	else if (StrEqual(serverCommand, "soccer_mod_match_period_break_length"))
	{
		if (5 <= number <= 3600) matchPeriodBreakLength = number;
		else if (number > 3600) matchPeriodBreakLength = 3600;
		else matchPeriodBreakLength = 5;
		UpdateConfigInt("Match Settings", "soccer_mod_match_break_length", matchPeriodBreakLength);

		PrintToServer("[%s] Match period break length set to %i", prefix, matchPeriodBreakLength);
		CPrintToChatAll("{%s}[%s] {%s}Match period break length set to %i", prefixcolor, prefix, textcolor, matchPeriodBreakLength);
	}
	else if (StrEqual(serverCommand, "soccer_mod_match_golden_goal"))
	{
		if (StringToInt(cmdArg1))
		{
			matchGoldenGoal = 1;
			UpdateConfigInt("Match Settings", "soccer_mod_match_periods", matchGoldenGoal);
			PrintToServer("[%s] Match golden goal enabled", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Match golden goal enabled", prefixcolor, prefix, textcolor);
		}
		else
		{
			matchGoldenGoal = 0;
			UpdateConfigInt("Match Settings", "soccer_mod_match_periods", matchGoldenGoal);
			PrintToServer("[%s] Match golden goal disabled", prefix);
			CPrintToChatAll("{%s}[%s] {%s}Match golden goal disabled", prefixcolor, prefix, textcolor);
		}
	}
	else if (StrEqual(serverCommand, "soccer_mod_teamnamet"))
	{
		custom_name_t = cmdArg1
		UpdateConfig("Match Settings", "soccer_mod_match_periods", custom_name_t);
		PrintToServer("[%s]Terrorists are now called %s", prefix, custom_name_t);
		CPrintToChatAll("{%s}[%s] {%s}Terrorists are now called %s", prefixcolor, prefix, prefixcolor, custom_name_t);
	}
	else if (StrEqual(serverCommand, "soccer_mod_teamnamect"))
	{
		custom_name_ct = cmdArg1
		UpdateConfig("Match Settings", "soccer_mod_match_periods", custom_name_t);
		PrintToServer("[%s]Counter-Terrorists are now called %s", prefix, custom_name_ct);
		CPrintToChatAll("{%s}[%s] {%s}Counter-Terrorists are now called %s", prefixcolor, prefix, prefixcolor, custom_name_ct);
	}

	return Plugin_Handled;
}