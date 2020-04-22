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
	h_BUTTON = CreateConVar(
		"soccer_mod_sprint_button", 
		DEF_BUTTON,
		"Enable/Disable +use button support - Default 1",
		0, true, 0.0, true, 1.0
	);
	h_COOLDOWN = CreateConVar(
		"soccer_mod_sprint_cooldown", 
		DEF_COOLDOWN,
		"Time in seconds the player must wait for the next sprint - Default 7.5",
		0, true, 1.0, true, 15.0
	);
	h_SPRINT_ENABLED = CreateConVar(
		"soccer_mod_sprint_enable", 
		DEF_SPRINT_ENABLED,
		"Enable/Disable ShortSprint - Default: 1",
		0, true, 0.0, true, 1.0
	);
	h_SPEED = CreateConVar(
		"socer_mod_sprint_speed", 
		DEF_SPEED,
		"Ratio for how fast the player will sprint - Default 1.25",
		0, true, 1.01, true, 5.00
	);
	h_TIME= CreateConVar(
		"soccer_mod_sprint_time", 
		DEF_TIME, 
		"Time in seconds the player will sprint - Default 3",
		0, true, 1.0, true, 30.0 
	);

	HookConVarChange			(h_BUTTON, ButtonConVarChanged);
	HookConVarChange			(h_COOLDOWN, CooldownConVarChanged);
	HookConVarChange			(h_SPRINT_ENABLED, EnabledConVarChanged);
	HookConVarChange			(h_SPEED, SpeedConVarChanged);
	HookConVarChange			(h_TIME, TimeConVarChanged);

	//Manually trigger convar readout
	CooldownConVarChanged(INVALID_HANDLE, "0", "0");
	EnabledConVarChanged(INVALID_HANDLE, "0", "0");
	SpeedConVarChanged(INVALID_HANDLE, "0", "0");
	TimeConVarChanged(INVALID_HANDLE, "0", "0"); 

	return;
}

public void EnabledConVarChanged(Handle convar, char[] oldValue, char[] newValue)
{
	bSPRINT_ENABLED = GetConVarInt(h_SPRINT_ENABLED);
	UpdateConfigInt("Sprint Settings", "soccer_mod_sprint_enable", bSPRINT_ENABLED);

	if(!bSPRINT_ENABLED)
	{
		bSPRINT_BUTTON = false;
		CPrintToChatAll("{%s}[%s] {%s}Sprint module was disabled!", prefixcolor, prefix, textcolor);
		return;
	}
	else CPrintToChatAll("{%s}[%s] {%s}Sprint module was enabled!", prefixcolor, prefix, textcolor);

	//ButtonConVarChanged(INVALID_HANDLE, "0", "0");

	return;
}
	
public void ButtonConVarChanged(Handle convar, char[] oldValue, char[] newValue)
{
	bSPRINT_BUTTON = GetConVarInt(h_BUTTON);
	UpdateConfigInt("Sprint Settings", "soccer_mod_sprint_button", bSPRINT_BUTTON);
	if(bSPRINT_BUTTON) CPrintToChatAll("{%s}[%s] {%s}Sprinting with +use was enabled!", prefixcolor, prefix, textcolor);
	else CPrintToChatAll("{%s}[%s] {%s}Sprinting with +use was disabled!", prefixcolor, prefix, textcolor);
	return;
}

public void CooldownConVarChanged(Handle convar, char[] oldValue, char[] newValue)
{
	fSPRINT_COOLDOWN = GetConVarFloat(h_COOLDOWN);
	UpdateConfigFloat("Sprint Settings", "soccer_mod_sprint_cooldown", fSPRINT_COOLDOWN);
	CPrintToChatAll("{%s}[%s] {%s}Sprint cooldown was set to %f!", prefixcolor, prefix, textcolor, h_COOLDOWN);
	
	return;
}

public void SpeedConVarChanged(Handle convar, char[] oldValue, char[] newValue)
{
	fSPRINT_SPEED = GetConVarFloat(h_SPEED);
	UpdateConfigFloat("Sprint Settings", "soccer_mod_sprint_speed", fSPRINT_SPEED);
	CPrintToChatAll("{%s}[%s] {%s}Sprint speed was changed to %f!", prefixcolor, prefix, textcolor, fSPRINT_SPEED);
	return;
}

public void TimeConVarChanged(Handle convar, char[] oldValue, char[] newValue)
{
	fSPRINT_TIME = GetConVarFloat(h_TIME);
	UpdateConfigFloat("Sprint Settings", "soccer_mod_sprint_time", fSPRINT_TIME);
	CPrintToChatAll("{%s}[%s] {%s}Sprint cooldown was changed to %f!", prefixcolor, prefix, textcolor, fSPRINT_TIME);
	return;
}