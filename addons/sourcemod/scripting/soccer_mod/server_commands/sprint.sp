//Convar defaults
#define DEF_BUTTON             "1"
#define DEF_CHATTRIGGER        "!"
#define DEF_COOLDOWN           "7.5"
#define DEF_SPRINT_ENABLED     "1"
#define DEF_SPEED              "1.25"
#define DEF_TIME               "3"

//Register Commands
public void RegisterServerCommandsSprint()
{
	RegServerCmd
	(
		"soccer_mod_sprint_button",
		ServerCommandsSprint,
		"Enable(1)/Disable(0) the sprint button (+use), default: 1" 
	);
	RegServerCmd
	(
		"soccer_mod_sprint_cooldown",
		ServerCommandsSprint,
		"Time in seconds the player must wait for the next sprint - values: 1.0-15.0, default: 7.5" 
	);
	RegServerCmd
	(
		"soccer_mod_sprint_enable",
		ServerCommandsSprint,
		"Enable(1)/Disable(0) the sprint module, default: 1" 
	);
	RegServerCmd
	(
		"soccer_mod_sprint_speed",
		ServerCommandsSprint,
		"Ratio for how fast the player will sprint - values: 1.01-5.00, default: 1.25" 
	);
	RegServerCmd
	(
		"soccer_mod_sprint_time",
		ServerCommandsSprint,
		"Time in seconds the player will sprint - values: 1.0-30.0, default 3.0" 
	);
}

public Action ServerCommandsSprint(int args)
{
	char serverCommand[50], cmdArg1[8];
	GetCmdArg(0, serverCommand, sizeof(serverCommand));
	GetCmdArg(1, cmdArg1, sizeof(cmdArg1));
	int number = StringToInt(cmdArg1);
	float numfloat = StringToFloat(cmdArg1);

	if (StrEqual(serverCommand, "soccer_mod_sprint_button"))
	{
		if (number == 0) 
		{
			bSPRINT_BUTTON = number;
			CPrintToChatAll("{%s}[%s] {%s}Sprinting with +use was disabled!", prefixcolor, prefix, textcolor);
		}
		else if (number >= 1)
		{
			bSPRINT_BUTTON = 1;
			CPrintToChatAll("{%s}[%s] {%s}Sprinting with +use was enabled!", prefixcolor, prefix, textcolor);
		}
		
		UpdateConfigInt("Sprint Settings", "soccer_mod_sprint_button", bSPRINT_BUTTON);
	}
	else if (StrEqual(serverCommand, "soccer_mod_sprint_cooldown"))
	{
		if (1.0 <= numfloat <= 15.0) 
		{
			fSPRINT_COOLDOWN = numfloat;
			UpdateConfigFloat("Sprint Settings", "soccer_mod_sprint_cooldown", fSPRINT_COOLDOWN);

			CPrintToChatAll("{%s}[%s] {%s}Sprint cooldown was set to %f!", prefixcolor, prefix, textcolor, fSPRINT_COOLDOWN);
		}
	}
	else if (StrEqual(serverCommand, "soccer_mod_sprint_enable"))
	{
		if (number == 0)
		{
			bSPRINT_ENABLED = number;
			CPrintToChatAll("{%s}[%s] {%s}Sprinting module disabled!", prefixcolor, prefix, textcolor);
		}
		else if (number >= 1)
		{
			bSPRINT_ENABLED = 1; 
			CPrintToChatAll("{%s}[%s] {%s}Sprinting module enabled!", prefixcolor, prefix, textcolor);
		}
		
		UpdateConfigInt("Sprint Settings", "soccer_mod_sprint_enable", bSPRINT_ENABLED);
	}
	else if (StrEqual(serverCommand, "soccer_mod_sprint_speed"))
	{
		if (1.01 <= numfloat <= 5.00) 
		{
			fSPRINT_SPEED = numfloat;
			UpdateConfigFloat("Sprint Settings", "soccer_mod_sprint_speed", fSPRINT_SPEED);

			CPrintToChatAll("{%s}[%s] {%s}Sprint cooldown was set to %f!", prefixcolor, prefix, textcolor, fSPRINT_SPEED);
		}
	}
	else if (StrEqual(serverCommand, "soccer_mod_sprint_time"))
	{
		if (1.0 <= numfloat <= 30.0) 
		{
			fSPRINT_TIME = numfloat;
			UpdateConfigFloat("Sprint Settings", "soccer_mod_sprint_time", fSPRINT_TIME);

			CPrintToChatAll("{%s}[%s] {%s}Sprint cooldown was changed to %f!", prefixcolor, prefix, textcolor, fSPRINT_TIME);
		}
	}

	return Plugin_Handled;
}