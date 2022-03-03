// ***********************************************************************************************************************
// ************************************************** COMMAND LISTENERS **************************************************
// ***********************************************************************************************************************

public void ShoutNameSet(int client, char type[32], char customname[64], int min, int max)
{
	if (strlen(customname) >= min && strlen(customname) <= max)
	{
		if (StrEqual(type, "CustomShoutName"))
		{
			if(!StrEqual(customname, "!cancel"))
			{
				RenameFunc(client, customname);
			}
			else 
			{
				if(!DupRename) OpenMenuShoutRename(client);
				else OpenMenuShoutAdd(client);
				CPrintToChat(client, "{%s}[%s] {%s}Input cancelled.", prefixcolor, prefix, textcolor);
				gNamebuffer = "cancelled";
			}
		}

		changeSetting[client] = "";
		if(!DupRename) OpenMenuShoutRename(client);
		else OpenMenuShoutAdd(client);
	}
	else CPrintToChat(client, "{%s}[%s] {%s}The command should be longer than %i and shorter than %i letters.", prefixcolor, prefix, textcolor, min, max);
}

// ***********************************************************************************************************************
// ************************************************** COMMAND LISTENERS **************************************************
// ***********************************************************************************************************************
public void RenameFunc(int client, char customname[64])
{	
	kvConfig = new KeyValues("Shout List");
	kvConfig.ImportFromFile(shoutConfigFile);
	
	if(!DupRename)
	{
		kvConfig.JumpToKey(gNamebuffer, false);
		kvConfig.SetSectionName(customname);
		kvConfig.GoBack();
	}
	else
	{
		kvConfig.JumpToKey(customname, true);
		kvConfig.SetString("path", 					gFilebuffer);
		kvConfig.GoBack();
	}

	kvConfig.Rewind();
	kvConfig.ExportToFile(shoutConfigFile);
	kvConfig.Close();
		
	if(!DupRename)
	{
		int ArrayPos = FindStringInArray(fileArray_Added, gFilebuffer);
			
		SetArrayString(fileArray_Added, ArrayPos, gFilebuffer);
		SetArrayString(nameArray_Added, ArrayPos, customname);
		
		CPrintToChat(client, "{%s}[%s] {%s}Sound %s was renamed to %s.", prefixcolor, prefix, textcolor, gNamebuffer, customname);
		ShoutSoundSetup(gFilebuffer, customname);
		
		EmptyArrays(fileArray, nameArray);
		GetSounds("sound");
		OpenMenuShoutRename(client);
	}
	else
	{
		int ArrayPos = FindStringInArray(fileArray, gFilebuffer);
		RemoveFromArray(fileArray, ArrayPos);
		RemoveFromArray(nameArray, ArrayPos);
		
		CPrintToChat(client, "{%s}[%s] {%s}Sound added as %s with path %s.", prefixcolor, prefix, textcolor, customname, gFilebuffer);
		ShoutSoundSetup(gFilebuffer, customname);

		EmptyArrays(fileArray, nameArray);
		GetSounds("sound");
		OpenMenuShoutAdd(client);
	}
}