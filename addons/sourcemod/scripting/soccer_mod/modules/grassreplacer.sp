#define READ	0
#define LIST	1

Handle adt_decal_names = INVALID_HANDLE;
Handle adt_decal_paths = INVALID_HANDLE;
Handle adt_decal_precache = INVALID_HANDLE;

Handle adt_decal_id = INVALID_HANDLE;
Handle adt_decal_position = INVALID_HANDLE;

char ReplacerMapName[256];
char path_mapdecals[PLATFORM_MAX_PATH];
char path_decals[PLATFORM_MAX_PATH]						= "cfg/sm_soccermod/soccer_mod_replacer.cfg";

public void ReplacerOnPluginStart()
{
	// Create subfolder
	if (!DirExists("cfg/sm_soccermod/grassreplacer"))			CreateDirectory("cfg/sm_soccermod/grassreplacer", 511, false);
	
	// Create our dynamic arrays we need for the keyvalues/decal data
	adt_decal_names = CreateArray(64);
	adt_decal_paths = CreateArray(PLATFORM_MAX_PATH);
	adt_decal_precache = CreateArray();
	adt_decal_id = CreateArray();
	adt_decal_position = CreateArray(3);
}

public void ReplacerOnMapStart()
{
	ClearReplacerArrays();
	GetCurrentMap(ReplacerMapName, sizeof(ReplacerMapName));
	GetMapDisplayName(ReplacerMapName, ReplacerMapName, sizeof(ReplacerMapName));
	
	// get map config path
	Format(path_mapdecals, sizeof(path_mapdecals), "cfg/sm_soccermod/grassreplacer/%s.cfg", ReplacerMapName);
	CreateDecalConfig();
	CreateMapConfig();
	
	if (FileExists(path_mapdecals))	ReadDecals();
}

public void ReplacerOnClientPostAdminCheck(int client) 
{
	// Show him what we have
	float position[3];
	int id;
	int precache;
	
	int size = GetArraySize(adt_decal_id);
	if(pcGrassSet[client] == 1)
	{
		for (int i = 0; i < size; i++) 
		{
			id = GetArrayCell(adt_decal_id, i);
			precache = GetArrayCell(adt_decal_precache, id);
			GetArrayArray(adt_decal_position, i, view_as<int>(position));
			TE_SetupBSPDecal(position, 0, precache);
			TE_SendToClient(client);
		}
	}
}

void TE_SetupBSPDecal(const float vecOrigin[3], int entity, int index) 
{
	TE_Start("BSP Decal");
	TE_WriteVector("m_vecOrigin", vecOrigin);
	TE_WriteNum("m_nEntity", entity);
	TE_WriteNum("m_nIndex", index);
}

public void CreateDecalConfig()
{
	if(!FileExists(path_decals))
	{
		File hFile = OpenFile(path_decals, "w");
		hFile.Close();
		
		KeyValues kvRep = new KeyValues("Replacer");
		kvRep.ImportFromFile(path_decals);
		
		kvRep.JumpToKey("grassreplacer", true);
		kvRep.SetString("path", "decals/soccer_mod/grassreplacer");
		kvRep.GoBack();
		kvRep.JumpToKey("grassreplacer_light", true);
		kvRep.SetString("path", "decals/soccer_mod/grassreplacer_light");
		kvRep.GoBack();
		
		kvRep.Rewind();
		kvRep.ExportToFile(path_decals);
		kvRep.Close();
	}
}

public void CreateMapConfig()
{
	if(!FileExists("cfg/sm_soccermod/grassreplacer/readme.cfg"))
	{
		File hFile = OpenFile("cfg/sm_soccermod/grassreplacer/readme.cfg", "w");
		hFile.WriteLine("An example config file can be found here:");
		hFile.WriteLine("https://github.com/MK99MA/SoMoE-19/blob/master/cfg/sm_soccermod/grassreplacer/ka_soccer_xsl_stadium_b1.cfg");
		hFile.WriteLine("Additional information can be found here:");
		hFile.WriteLine("https://github.com/MK99MA/SoMoE-19/blob/master/cfg/sm_soccermod/grassreplacer/readme.txt");
		hFile.Close();
	}
	if(!FileExists(path_mapdecals))
	{
		File hFile = OpenFile(path_mapdecals, "w");
		hFile.Close();
		
		KeyValues kvRep = new KeyValues("Positions");
		kvRep.ImportFromFile(path_mapdecals);
		
		kvRep.JumpToKey("grassreplacer", true);
		kvRep.SetString("pos1", "Please read the information found here:");
		kvRep.SetString("pos2", "https://github.com/MK99MA/SoMoE-19/blob/master/cfg/sm_soccermod/grassreplacer/readme.txt");
		kvRep.GoBack();
		
		kvRep.Rewind();
		kvRep.ExportToFile(path_mapdecals);
		kvRep.Close();
	}
}

public bool ReadDecals()
{
	char buffer[PLATFORM_MAX_PATH];
	char file[PLATFORM_MAX_PATH];
	char download[PLATFORM_MAX_PATH];
	KeyValues kvReplace;
	KeyValues kvVTF;
		
	// Read Decal config File
	kvReplace = new KeyValues("Replacer");
	kvReplace.ImportFromFile(path_decals);
	
	if (!kvReplace.GotoFirstSubKey()) 
	{
		
		LogMessage("CFG File not found: %s", file);
		kvReplace.Close();
		return false;
	}
	else
	{
		do 
		{
			// Get texture to use
			kvReplace.GetSectionName(buffer, sizeof(buffer));
			PushArrayString(adt_decal_names, buffer);
			// save Path in Variable
			kvReplace.GetString("path", buffer, sizeof(buffer));
			PushArrayString(adt_decal_paths, buffer);
			
			int precacheId = PrecacheDecal(buffer, true);
			PushArrayCell(adt_decal_precache, precacheId);
			
			// Add Files to downloadtable !!Independent from downloads.cfg!!
			char decalpath[PLATFORM_MAX_PATH];
			Format(decalpath, sizeof(decalpath), buffer);
			Format(download, sizeof(download), "materials/%s.vmt", buffer);
			AddFileToDownloadsTable(download);

			kvVTF = new KeyValues("LightmappedGeneric");
			kvVTF.ImportFromFile(download);
			kvVTF.GetString("$basetexture", buffer, sizeof(buffer), buffer);
			kvVTF.Close();
			Format(download, sizeof(download), "materials/%s.vtf", buffer);
			AddFileToDownloadsTable(download);
		}
		while (kvReplace.GotoNextKey());
	}

	kvReplace.Close();
	
	// We're done with preparing the texture/decal
	//############################################################################
	//
	
	kvReplace = new KeyValues("Positions");
	kvReplace.ImportFromFile(path_mapdecals);
	if (!kvReplace.GotoFirstSubKey()) 
	{
		LogMessage("CFG File for Map %s not found", path_mapdecals);
		
		kvReplace.Close();
		return false;
	}
	do 
	{
		kvReplace.GetSectionName(buffer, sizeof(buffer));
		int id = FindStringInArray(adt_decal_names, buffer);
		if(id != -1)
		{
			float position[3];
			char strpos[8];
			int n = 1;
			Format(strpos, sizeof(strpos), "pos%d", n);
			KvGetVector(kvReplace, strpos, position);
			while (position[0] != 0 && position[1] != 0 && position[2] != 0) 
			{
				PushArrayCell(adt_decal_id, id);
				PushArrayArray(adt_decal_position, view_as<int>(position));
				
				n++;
				Format(strpos, sizeof(strpos), "pos%d", n);
				KvGetVector(kvReplace, strpos, position);
			}
		}
	} 
	while (kvReplace.GotoNextKey());
	
	kvReplace.Close();
	return true;
}

public void ClearReplacerArrays()
{
	ClearArray(adt_decal_names);
	ClearArray(adt_decal_paths);
	ClearArray(adt_decal_precache);
	ClearArray(adt_decal_id);
	ClearArray(adt_decal_position);
}

//	Fileformat
//	mapname.cfg
//	"Replacer"
//	{
//		"texture"
//		{
//			"name" "texturename"
//			"path" "path/path/filename"
//		}
//		"positions"
//		{
//			"pos1"		"123.000000 456.000000 789.000000"
//			"pos2"		"123.000000 456.000000 789.000000"
//		}
//	}