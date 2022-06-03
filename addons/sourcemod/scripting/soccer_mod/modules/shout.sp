#include "soccer_mod\modules\shout\config.sp"
#include "soccer_mod\modules\shout\listener.sp"
#include "soccer_mod\modules\shout\menu.sp"

// ******************************************************************************************************************
// ************************************************** PLUGIN START **************************************************
// ******************************************************************************************************************
public void ShoutOnPluginStart()
{
	fileArray 		= CreateArray(PLATFORM_MAX_PATH);
	fileArray_Added = CreateArray(PLATFORM_MAX_PATH);
	nameArray 		= CreateArray(64);
	nameArray_Added	= CreateArray(64);

	if (!DirExists("sound/soccermod/shout"))			CreateDirectory("sound/soccermod/shout", 511, false);
}

public void ShoutOnClientConnected(int client)
{
	ShoutSetDefaultClientSettings(client);

	if(shoutMessage == 1) shoutAdvert[client] = CreateTimer(10.0, shoutAD_Timer, client);
	else shoutAdvert[client] = INVALID_HANDLE;
	
	return;
}

public void ShoutSetDefaultClientSettings(int client)
{
	cdStatus[client] = 0;

	shoutCDs[client] = INVALID_HANDLE;

	return;
}

// ******************************************************************************************************************
// **************************************************** COMMANDS ****************************************************
// ******************************************************************************************************************
public Action ShoutMenu(int client, int args)
{
	if(shoutMode != -1)		OpenMenuShout(client, false);
	else CPrintToChat(client, "{%s}[%s] {%s}Shouts are disabled.", prefixcolor, prefix, textcolor);

	return Plugin_Handled;
}

public Action ShoutCommand(int client, int args)
{
	char cmd[64];
	GetCmdArg(0, cmd, sizeof(cmd));
	int iVolume, iPitch;
	char sound[PLATFORM_MAX_PATH]
	
	strcopy(cmd, sizeof(cmd), cmd[3]);
	
	kvConfig = new KeyValues("Shout List");
	kvConfig.ImportFromFile(shoutConfigFile);
	if(kvConfig.JumpToKey(cmd, false))
	{
		kvConfig.GetString("path", sound, sizeof(sound), "shout/godlike.mp3")
		iVolume = kvConfig.GetNum("volume", shoutVolume);
		iPitch 	= kvConfig.GetNum("pitch", shoutPitch);
	}
	
	if(shoutMode != -1)
	{
		ShoutPlaySound(client, sound, cmd, iVolume, iPitch);
	}
		
	kvConfig.Rewind();
	kvConfig.Close();
	
	return Plugin_Handled;
}

public Action ShoutSettings(int client, int args)
{
	OpenMenuShoutSet(client);

	return Plugin_Handled;
}

// ******************************************************************************************************************
// **************************************************** FUNCTIONS ***************************************************
// ******************************************************************************************************************
public void ShoutSoundSetup(char sound[PLATFORM_MAX_PATH], char soundName[64])
{
	char checksound[PLATFORM_MAX_PATH];
	char soundCMD[64];
	
	Format(checksound, sizeof(checksound), "sound/%s", sound);
	Format(soundCMD, sizeof(soundCMD), "sm_%s", soundName);
	
	//PrintToServer("check: %s | sm: %s | sound: %s | soundName: %s",checksound, soundCMD, sound, soundName)
	if (FileExists(checksound))		
	{
		AddFileToDownloadsTable(checksound);
		PrecacheSound(sound)
		if(shoutCommand == 1 && !(CommandExists(soundCMD)))		
		{
			PrintToServer("[Shouts] %s added", soundCMD);
			RegConsoleCmd(soundCMD, ShoutCommand, "Plays a sound");
		}
	}
	else 
	{
		PrintToServer("[Shouts] Soundfile %s not found!", sound);
		RemoveShout(soundName);
	}
}


public void ShoutPlaySound(int client, char sound[PLATFORM_MAX_PATH], char soundName[64], int iVolume, int iPitch)
{
	float floatCD = float(shoutCD);
	float floatRadius = float(shoutRadius);
	if(shoutVolume != 0 && shoutMode != -1)
	{
		if (IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) > 1)
		{
			if(pcShoutSet[client] == 1)
			{
				if(!(cdStatus[client] & CLIENT_SHOUTCD))
				{
					cdStatus[client] |= CLIENT_SHOUTCD;
					
					// client position holen
					float pos[3];
					GetClientAbsOrigin(client, pos);
					
					int modVolume = RoundToCeil(float(iVolume)/100);
					float floatVolume = float(iVolume)/(modVolume*100);

					if(shoutMode == 0)	
					{
						for(int i = 1; i <= modVolume; i++)						EmitAmbientSound(sound, pos, SOUND_FROM_PLAYER, _, _, floatVolume, iPitch);	
					}
					else if (shoutMode == 1) 
					{					
						for(int i = 1; i <= MaxClients; i++)
						{
							if(IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i)) 
							{
								for(int k = 1; k <= modVolume; k++)
								{
									if (pcShoutSet[i] == 1)
									{
										EmitSoundToClient(i, sound, _, _, _, _, floatVolume, iPitch, _, pos, _, true, _);
									}
								}
							}
						}
					}
					else if (shoutMode == 2) 
					{					
						for(int i = 1; i <= MaxClients; i++)
						{
							if(IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i)) 
							{
								if(GetClientTeam(i) == GetClientTeam(client))	
								{
									for(int k = 1; k <= modVolume; k++)			
									{
										if (pcShoutSet[i] == 1)
										{
											EmitSoundToClient(i, sound, _, _, _, _, floatVolume, iPitch, _, pos, _, true, _);
										}
									}
								}
							}
						}
					}
					else if (shoutMode == 3)
					{
						for(int i = 1; i <= MaxClients; i++)
						{
							if(IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i)) 
							{
								float pos2[3];
								GetClientAbsOrigin(i, pos2);
								char namebuffer[MAX_NAME_LENGTH];
								GetClientName(i, namebuffer, sizeof(namebuffer));

								if(shoutDebug == 1)	if(GetVectorDistance(pos, pos2, false) > 0.0)PrintToChatAll("Player %s is %.0f away. Current radius: %.0f", namebuffer, GetVectorDistance(pos, pos2, false), floatRadius);
								
								if(GetVectorDistance(pos, pos2, false) <= floatRadius)
								{
									for(int k = 1; k <= modVolume; k++)			
									{
										if (pcShoutSet[i] == 1)
										{
											EmitSoundToClient(i, sound, _, _, _, _, floatVolume, iPitch, _, pos, _, true, _);
										}
									}
								}
							}
						}
					}
					else if (shoutMode == 4)
					{
						for(int i = 1; i <= MaxClients; i++)
						{
							if(IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i)) 
							{
								float pos2[3];
								GetClientAbsOrigin(i, pos2);
								char namebuffer[MAX_NAME_LENGTH];
								GetClientName(i, namebuffer, sizeof(namebuffer));
								
								if(shoutDebug == 1)	if(GetVectorDistance(pos, pos2, false) > 0.0)PrintToChatAll("Player %s is %.0f away. Current radius: %.0f", namebuffer, GetVectorDistance(pos, pos2, false), floatRadius);
								
								if((GetVectorDistance(pos, pos2, false) <= floatRadius) && (GetClientTeam(i) == GetClientTeam(client)))
								{
									for(int k = 1; k <= modVolume; k++)			
									{
										if (pcShoutSet[i] == 1)
										{
											EmitSoundToClient(i, sound, _, _, _, _, floatVolume, iPitch, _, pos, _, true, _);
										}
									}
								}
							}
						}
					}
					shoutCDs[client] = CreateTimer(floatCD, shoutCD_Timer, client);
				}
				else CPrintToChat(client, "{%s}[%s] {%s}Shout is on cooldown.", prefixcolor, prefix, textcolor);
			}
			else CPrintToChat(client, "{%s}[%s] {%s}You can only shout if you can hear them yourself.", prefixcolor, prefix, textcolor);
		}
		else CPrintToChat(client, "{%s}[%s] {%s}Only living players can shout.", prefixcolor, prefix, textcolor);
	}
	else if(iVolume == 0) CPrintToChat(client, "{%s}[%s] {%s}Shout is currently disabled.", prefixcolor, prefix, textcolor);
	else CPrintToChat(client, "{%s}[%s] {%s}Shouts are currently disabled.", prefixcolor, prefix, textcolor);
}

public Action shoutCD_Timer(Handle timer, int client)
{
	shoutCDs[client] = INVALID_HANDLE;
	if(IsClientInGame(client) && (cdStatus[client] & CLIENT_SHOUTCD))
	{
		cdStatus[client] &= ~ CLIENT_SHOUTCD;
	}

	return;
}

// *************************************************** SOUNDLISTS ***************************************************
public void GetSounds(char path[PLATFORM_MAX_PATH])
{
	Handle dir = OpenDirectory(path);

	if (dir != INVALID_HANDLE)
	{
		char filename[64];
		FileType type;
		char full[PLATFORM_MAX_PATH];

		while (ReadDirEntry(dir, filename, sizeof(filename), type))
		{
			if (!StrEqual(filename, ".") && !StrEqual(filename, ".."))
			{
				Format(full, sizeof(full), "%s/%s", path, filename);
				
				if (type == FileType_File) 
				{
					if(StrContains(full, ".ztmp") == -1)			
					{
						if(!IsShout(full))
						{
							PushArrayString(fileArray, full);
							if(StrContains(filename, ".wav") != -1) ReplaceString(filename, sizeof(filename), ".wav", "", false);
							else if(StrContains(filename, ".mp3") != -1) ReplaceString(filename, sizeof(filename), ".mp3", "", false);
							PushArrayString(nameArray, filename);
						}
					}
				}
				else if (type == FileType_Directory) GetSounds(full);
			}
		}

		dir.Close();
	}
	else PrintToServer("[Shouts] Can't add file %s.", path);
}

public void ShoutList()
{
	char soundName[64];
	char sound[PLATFORM_MAX_PATH];
	
	kvConfig = new KeyValues("Shout List");
	kvConfig.ImportFromFile(shoutConfigFile);
	
	kvConfig.GotoFirstSubKey();
	do
	{
		kvConfig.GetSectionName(soundName, sizeof(soundName));
		kvConfig.GetString("path", sound, sizeof(sound), "shout/godlike.mp3");
		PushArrayString(fileArray_Added, sound);
		PushArrayString(nameArray_Added, soundName);
	}
	while(kvConfig.GotoNextKey());
	
	kvConfig.Rewind();
	kvConfig.Close();
}

// ******************************************************************************************************************
// ***************************************************** UTILITY ****************************************************
// ******************************************************************************************************************

public bool IsShout(char compare[PLATFORM_MAX_PATH])
{
	EmptyArrays(fileArray_Added, nameArray_Added);
	ShoutList();
	
	ReplaceString(compare, sizeof(compare), "sound/", "",false);
	
	if(FindStringInArray(fileArray_Added, compare) != -1) return true;
	return false;
}

public bool NameTaken(char compare[64])
{
	EmptyArrays(fileArray_Added, nameArray_Added);
	ShoutList();
	
	if(FindStringInArray(nameArray_Added, compare) != -1) return true;
	return false;
}

public Action shoutAD_Timer(Handle timer, int client)
{
	shoutAdvert[client] = INVALID_HANDLE;

	if(IsClientInGame(client) && GetClientTeam(client) > 1)
	{
		if(CheckCommandAccess(client, "generic_admin", ADMFLAG_RCON, true)) CPrintToChat(client, "{%s}[%s] {%s}Use !shout to shout or !shoutset to manage them.", prefixcolor, prefix, textcolor);
		else CPrintToChat(client, "{%s}[%s] {%s}Use !shout to bring up the shout menu.", prefixcolor, prefix, textcolor);
	}

	return;
}

public void RemoveShout(char soundName[64])
{
	kvConfig = new KeyValues("Shout List");
	kvConfig.ImportFromFile(shoutConfigFile);
	
	kvConfig.JumpToKey(soundName, false);
	kvConfig.DeleteThis();
	kvConfig.GoBack();

	kvConfig.Rewind();
	kvConfig.ExportToFile(shoutConfigFile);
	kvConfig.Close();
}

public int GetVolOrPit(char shoutname[64], char StrToGet[32])
{
	int iVolume, iPitch;
		
	kvConfig = new KeyValues("Shout List");
	kvConfig.ImportFromFile(shoutConfigFile);
	kvConfig.JumpToKey(shoutname);

	iVolume = kvConfig.GetNum("volume", shoutVolume);
	iPitch	= kvConfig.GetNum("pitch", shoutPitch);
	
	kvConfig.Rewind();
	kvConfig.Close();	
	
	if(StrEqual(StrToGet, "volume")) return iVolume;
	else if(StrEqual(StrToGet, "pitch")) return iPitch;
	
	return 100;
}

public void EmptyArrays(Handle array1, Handle array2)
{
 	ClearArray(array1);
	ClearArray(array2);
}