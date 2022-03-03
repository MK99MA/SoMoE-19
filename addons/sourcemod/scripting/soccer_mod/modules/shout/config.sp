// ******************************************************************************************************************
// ***************************************************** CONFIG *****************************************************
// ******************************************************************************************************************
public void ShoutCreateConfig()
{
	if(!FileExists(shoutConfigFile))
	{
		File hFile = OpenFile(shoutConfigFile, "w");
		hFile.Close();
	}
		
	// Scan shout folder -> add them
	GetSounds("sound/soccermod/shout");
	
	char filebuffer[PLATFORM_MAX_PATH], namebuffer[64];
	
	kvConfigShout = new KeyValues("Shout List");
	kvConfigShout.ImportFromFile(shoutConfigFile);
	
	for(int i = 0; i < GetArraySize(nameArray); i++)
	{
		GetArrayString(fileArray, i, filebuffer, sizeof(filebuffer));
		GetArrayString(nameArray, i, namebuffer, sizeof(namebuffer));
				
		//ReplaceString(filebuffer, sizeof(filebuffer), "sound/", "",false);
		//PrintToServer(filebuffer);

		kvConfigShout.JumpToKey(namebuffer, true);
		kvConfigShout.SetString("path", 					filebuffer);
		kvConfigShout.GoBack();

		ShoutSoundSetup(filebuffer, namebuffer);
	}

	kvConfigShout.Rewind();
	kvConfigShout.ExportToFile(shoutConfigFile);
	kvConfigShout.Close();
}

public void ShoutReadConfig()
{
	if(!FileExists(shoutConfigFile)) ShoutCreateConfig();
	char soundName[64];
	char sound[PLATFORM_MAX_PATH];
	
	kvConfigShout = new KeyValues("Shout List");
	kvConfigShout.ImportFromFile(shoutConfigFile);
	
	kvConfigShout.GotoFirstSubKey();
	do
	{
		kvConfigShout.GetSectionName(soundName, sizeof(soundName));
		kvConfigShout.GetString("path", sound, sizeof(sound), "soccermod/shout/godlike.mp3");
		ShoutSoundSetup(sound, soundName);
	}
	while(kvConfigShout.GotoNextKey());
	
	kvConfigShout.Rewind();
	kvConfigShout.Close();
}

// *************************************************** SETTINGS ****************************************************

public void ShoutCreateSettings()
{
	File hFile = OpenFile(shoutSetFile, "w");
	hFile.Close();
	
	kvSettings = new KeyValues("Shout Settings");
	kvSettings.ImportFromFile(shoutSetFile);
	
	kvSettings.SetNum("cooldown", 					shoutCD);
	kvSettings.SetNum("volume", 					shoutVolume);
	kvSettings.SetNum("pitch", 						shoutPitch);
	kvSettings.SetNum("commands", 					shoutCommand);
	kvSettings.SetNum("mode",						shoutMode);
	kvSettings.SetNum("message",					shoutMessage);
	kvSettings.SetNum("radius",						shoutRadius);
	kvSettings.SetNum("debug",						shoutDebug);
	kvSettings.GoBack();

	kvSettings.Rewind();
	kvSettings.ExportToFile(shoutSetFile);
	kvSettings.Close();
}

public void ShoutReadSettings()
{
	kvSettings = new KeyValues("Shout Settings");
	kvSettings.ImportFromFile(shoutSetFile);
	
	shoutCD			= kvSettings.GetNum("cooldown", 1);
	shoutVolume		= kvSettings.GetNum("volume", 100);
	shoutPitch 		= kvSettings.GetNum("pitch", 100);
	shoutCommand	= kvSettings.GetNum("commands", 0);
	shoutMode		= kvSettings.GetNum("mode", 0);
	shoutMessage	= kvSettings.GetNum("message", 2);
	shoutRadius		= kvSettings.GetNum("radius", 400);
	shoutDebug		= kvSettings.GetNum("debug", 0);
	kvSettings.GoBack();

	kvSettings.Rewind();
	kvSettings.Close();
}

// *************************************************** UPDATE ****************************************************

public void ShoutUpdateSettingsInt(char type[50], int value)
{
	if(!FileExists(shoutSetFile)) ShoutCreateSettings();
	kvSettings = new KeyValues("Shout Settings");
	kvSettings.ImportFromFile(shoutSetFile);
	kvSettings.SetNum(type, value);
	
	kvSettings.Rewind();
	kvSettings.ExportToFile(shoutSetFile);
	kvSettings.Close();
}

public void ShoutUpdateConfigInt(char section[64], char type[32], int value)
{
	kvConfigShout = new KeyValues("Shout List");
	kvConfigShout.ImportFromFile(shoutConfigFile);
	
	kvConfigShout.JumpToKey(section, false);
	kvConfigShout.SetNum(type, value);
	
	kvConfigShout.Rewind();
	kvConfigShout.ExportToFile(shoutConfigFile);
	kvConfigShout.Close();
}