public void RegisterServerCommandsRespawn()
{
	RegServerCmd
	(
		"soccer_mod_respawn_delay",
		ServerCommandsRespawn,
		"Sets the respawn delay (in seconds) - values: 1-600, default: 10"
	);
}

public Action ServerCommandsRespawn(int args)
{
	char cmdArg1[8];
	GetCmdArg(1, cmdArg1, sizeof(cmdArg1));

	float value = StringToFloat(cmdArg1);
	
	if (1 <= value <= 600) respawnDelay = value;
	else if (value > 600) respawnDelay = 600.0;
	else respawnDelay = 1.0;
	UpdateConfigFloat("Misc Settings", "soccer_mod_respawn_delay", respawnDelay);

	PrintToServer("[%s] Respawn delay set to %.1f", prefix, respawnDelay);
	CPrintToChatAll("{%s}[%s] {%s}Respawn delay set to %.1f", prefixcolor, prefix, textcolor, respawnDelay);

	return Plugin_Handled;
}