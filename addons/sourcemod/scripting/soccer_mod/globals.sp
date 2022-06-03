// **************************************************************************************************************
// ************************************************** VARIABLES *************************************************
// **************************************************************************************************************

// ***************************************************** PATHS **************************************************
char adminSMFileKV[PLATFORM_MAX_PATH];
char adminGroupFileKV[PLATFORM_MAX_PATH];

char configFileKV[PLATFORM_MAX_PATH] 					= "cfg/sm_soccermod/soccer_mod.cfg";
char skinsKeygroup[PLATFORM_MAX_PATH] 					= "cfg/sm_soccermod/soccer_mod_skins.cfg";
char allowedMapsConfigFile[PLATFORM_MAX_PATH] 			= "cfg/sm_soccermod/soccer_mod_allowed_maps.cfg";
char statsKeygroupGoalkeeperAreas[PLATFORM_MAX_PATH] 	= "cfg/sm_soccermod/soccer_mod_GKAreas.cfg";
char adminFileKV[PLATFORM_MAX_PATH] 					= "cfg/sm_soccermod/soccer_mod_admins.cfg";
char pathCapPositionsFile[PLATFORM_MAX_PATH] 			= "cfg/sm_soccermod/soccer_mod_cap_positions.txt";
char pathRefCardsFile[PLATFORM_MAX_PATH] 				= "cfg/sm_soccermod/soccer_mod_referee_cards.txt";
char matchlogKV[PLATFORM_MAX_PATH] 						= "cfg/sm_soccermod/soccer_mod_last_match.txt";
char tempReadyFileKV[PLATFORM_MAX_PATH] 				= "cfg/sm_soccermod/temp_readycheck.txt";
char DCListKV[PLATFORM_MAX_PATH] 						= "cfg/sm_soccermod/soccer_mod_dclist.txt";
char mapDefaults[PLATFORM_MAX_PATH]						= "cfg/sm_soccermod/soccer_mod_mapdefaults.cfg";
char matchlogSettingsKV[PLATFORM_MAX_PATH] 				= "cfg/sm_soccermod/soccer_mod_matchlogsettings.cfg";
char personalSettingsKV[PLATFORM_MAX_PATH]				= "cfg/sm_soccermod/soccer_mod_personalCannonSettings.cfg";

// ************************************************** KEYVALUES *************************************************
KeyValues kvConfig;
KeyValues kvSkins;
KeyValues kvGKArea;
KeyValues kvAdmins;  
KeyValues kvSMAdmins; 
//KeyValues kvAdminGroups;
KeyValues LeagueMatchKV;
KeyValues mapdefaultKV;
KeyValues kvTemp;
KeyValues kvConnectlist;
KeyValues kvMLSettings;
KeyValues statsKeygroupMatch;
KeyValues statsKeygroupRound;
KeyValues personalCannonSettings;

// **************************************************** GENERAL **************************************************
// BOOLS
bool bLATE_LOAD 				= false;
bool currentMapAllowed			= false;
bool goalScored					= false;
bool menuaccessed[MAXPLAYERS+1];
bool roundEnded					= false;
bool xorientation				= true;
bool g_bIsDuck[MAXPLAYERS+1] 	= {false,...};
bool g_bDuck[MAXPLAYERS+1] 		= {false,...};
bool g_bJump[MAXPLAYERS+1] 		= {false,...};
bool CapPrep					= false;

// FLOATS
float phys_timescale			= 1.0;
float respawnDelay 				= 10.0;
float playerMaxHeight[66];
float rrchecktime				= 30.0;//120.0;
float mapBallStartPosition[3];
float vec_tgoal_origin[3];
float vec_ctgoal_origin[3];
float sprayVector[MAXPLAYERS+1][3];
float fJUMP_TIMER				= 0.4; //0.4//0.45;
float jump_time[MAXPLAYERS+1]	= {0.0, ...};
//float gameTickRate      = 64.0;

// HANDLES
Handle allowedMaps	  			= INVALID_HANDLE;
Handle db			   			= INVALID_HANDLE;
Handle respawnTimers[MAXPLAYERS + 1];
Handle delayedFreezeTimer[MAXPLAYERS + 1];
Handle dclistTimer[MAXPLAYERS + 1];
Handle g_cJumpTimer[MAXPLAYERS+1] = {null,...};
Handle h_GRASS_TOGGLE_COOKIE 	= INVALID_HANDLE;
Handle h_SHOUT_TOGGLE_COOKIE 	= INVALID_HANDLE;

ArrayList groupArray;
ArrayList lcPanelArray;

UserMsg TextMsg;

// INTEGER
int djbenabled					= 3;
int publicmode		 			= 1;
int damageSounds				= 0;
int debuggingEnabled			= 0;
int phys_pushscale				= 900;
int healthGodmode				= 1;
int healthAmount				= 250;
int dissolveSet					= 2;
int joinclassSet				= 0;
int defaultSet					= 1;
int killfeedSet					= 0;
int jump_count[MAXPLAYERS+1]	= {0, ...};
int celebrateweaponSet			= 0;
int KickoffWallSet				= 1;
int first12Set					= 0;
int OTCountSet					= 1;
int OTFinalSet					= 1;
int pcGrassSet[MAXPLAYERS+1] 	= {1, ...};
int pcShoutSet[MAXPLAYERS+1] 	= {1, ...};

// STRINGS
char changeSetting[MAXPLAYERS + 1][32];
char gamevar[8]					= "cstrike";
char databaseConfig[64]			= "storage-local";
char cardReceiver[MAX_NAME_LENGTH];
char cardString[32];
char sprayName[MAXPLAYERS + 1][64];
char sprayID[MAXPLAYERS + 1][32];
char wallmodel[128]				= "models/soccer_mod/wall.mdl";
char OTSound1[PLATFORM_MAX_PATH]= "buttons/bell1.wav";
char OTSound2[PLATFORM_MAX_PATH]= "ambient/misc/brass_bell_f.wav"; //Custom sound?

// **************************************************** ADMIN ***************************************************

// BOOL
bool adminRemoved;

// FLOATS

// HANDLES

// INTEGER
int addoredit;
int promoteoredit;
int adminmode;
int playerindex 		= 1;

// STRINGS
char adminFlags[64];
char adminGroup[64];
char adminImmunity[64];
char adminName[64];
char adminSteamID[64];
char clientName[50];
char group[32];
char SteamID[20];
char szFlags[32];
char szTarget2[64];

// ***************************************************** CAP ****************************************************

// BOOL
bool capFightStarted	= false;
bool tempSprint			= true;
bool tempRule			= false;

// FLOATS

// HANDLES
/*ArrayList gkArray = CreateArray(MAXPLAYERS+1);
ArrayList dfArray = CreateArray(MAXPLAYERS+1);
ArrayList mfArray = CreateArray(MAXPLAYERS+1);
ArrayList wgArray = CreateArray(MAXPLAYERS+1);
ArrayList nPArray = CreateArray(MAXPLAYERS+1);*/

// INTEGER
int capPicker			= 0;
int capCT				= 0;
int capT				= 0;
int capPicksLeft		= 0;
int capnr				= 0;
int nrhelper			= 0;

// STRINGS
char capweapon[32]		="knife";
char capwparray[27][32]		=
{
	"knife",
	"glock",
	"usp",
	"p228",
	"deagle",
	"fiveseven",
	"elite",
	"mac10",
	"tmp",
	"mp5navy",
	"ump45",
	"p90",
	"m3",
	"xm1014",
	"galil",
	"famas",
	"ak47",
	"m4a1",
	"sg552",
	"aug",
	"m249",
	"scout",
	"g3sg1",
	"sg550",
	"awp",
	"flashbang",
	"hegrenade"
}
char weaponName[64];

// **************************************************** CHAT ****************************************************

// BOOL
bool g_msgIsChat;
bool g_msgIsTeammate;
bool g_msgTarget[MAXPLAYERS + 1];

// FLOATS

// HANDLES
Handle g_hCvarAllTalk = INVALID_HANDLE;

// INTEGER
int MVPEnabled			= 1;
int DeadChatMode		= 0;
int DeadChatVis			= 0;
int g_msgAuthor;

// STRINGS
char prefix[32]			= "Soccer Mod";
char prefixcolor[32]	= "green";
char textcolor[32]		= "lightgreen";
char g_msgType[64];
char g_msgName[64];
char g_msgText[64];

// *************************************************** FORFEIT **************************************************

// BOOL
bool ffActive 					= false;
bool ForfeitRRCheck				= false;

// FLOATS
float abortTime					= 5.0;
float cdTime					= 450.0;

// HANDLES
Handle forfeitTimer				= null;
Handle ffDelayTimer				= null;
Handle ffRRCheckTimer			= null;

// INTEGER
int ForfeitEnabled				= 0;
int infoForfeit					= 1;
int infoForfeitSet				= 0;
int ForfeitScore				= 8;
int ForfeitPublic				= 0;
int ForfeitAutoSpec 			= 0;
int ForfeitCapMode				= 0;
int forfeitHelper;
int ffcounter 					= 0;
int ffCTScore;
int ffTScore;
int iHelp						= 0;

// STRINGS

// **************************************************** MATCH ***************************************************

// BOOL
bool matchStarted				= false;
bool matchStart					= false;
bool matchPaused				= false;
bool matchPeriodBreak			= false;
bool matchGoldenGoalActive		= false;
bool matchKickOffTaken			= false;
bool matchStoppageTimeStarted	= false;
bool matchValid					= false;
bool matchStopPauseTimer		= false;

// FLOATS
float matchBallStartPosition[3];

// HANDLES
Handle matchTimer				= null;

// INTEGER
int matchMaxPlayers		 		= 6;
int matchPeriodBreakLength		= 60;
int matchPeriodLength	  		= 900;
int matchPeriods				= 2;
int matchGoldenGoal				= 1;
int matchLastScored				= 0;
int matchPeriod					= 1;
int matchScoreCT				= 0;
int matchScoreT					= 0;
int matchStoppageTime			= 0;
int matchTime					= 0;
int matchToss					= 2;
int tagindex					= 1;
int teamIndicator;
int infoPeriods					= 1;
int infoBreak					= 1;
int infoGolden					= 1;

// STRINGS
char custom_name_ct[32]			= "CT";
char custom_name_t[32]			= "T";
char default_name_ct[32]		= "";
char default_name_t[32]			= "";
char tagName[32];

// ************************************************** MATCHINFO *************************************************

// BOOL

// FLOATS

// HANDLES

// INTEGER

// STRINGS
char infostring1[512];
char infostring2[512];

// *************************************************** MATCHLOG *************************************************

// BOOL
bool showcards			= false;

// FLOATS

// HANDLES
Handle matchLogRefresh	= null;
Handle logmenuArray;

// INTEGER
int matchlog			= 0;
int infoMatchlog		= 0;
int iStarthour			= 0;
int iStartmin			= 0;
int iStophour			= 0;
int iStopmin			= 0;
int iPlayerNames[MAXPLAYERS+1];

// STRINGS
char PlayerNames[MAXPLAYERS+1][MAX_NAMES][MAX_NAME_LENGTH+1];
char kvTime[32] 		= "Time:";
char kvScorer[32] 		= "Scorer:";
char kvAssister[32]		= "Assister:";
char kvCard[32] 		= "Card:";
char kvPlayer[32] 		= "Player:";
char kvName[32] 		= "Name:";
char kvGoals[32] 		= "Goals:";
char kvAssists[32]		= "Assists:";
char kvOwngoals[32]		= "Owngoals:";

// *************************************************** RANKING **************************************************

// BOOL
bool rankingPlayerSpammed[MAXPLAYERS+1];

// FLOATS

// HANDLES

// INTEGER
int rankingPointsForGoal			= 17;
int rankingPointsForAssist			= 12;
int rankingPointsForOwnGoal			= -10;
int rankingPointsForHit				= 1;
int rankingPointsForPass			= 5;
int rankingPointsForInterception	= 3;
int rankingPointsForBallLoss		= -3;
int rankingPointsForSave			= 6;
int rankingPointsForRoundWon		= 10;
int rankingPointsForRoundLost		= -10;
int rankingPointsForMVP				= 15;
int rankingPointsForMOTM			= 25;
int gksavesSet						= 0;
int rankMode						= 0;

int rankingCDTime					= 300;
int rankingPlayerCDTimes[MAXPLAYERS+1];

// STRINGS

// ************************************************** READYCHECK ************************************************

// BOOL
bool showPanel					= false;
//bool cdMessage[MAXPLAYERS+1]	= false;
bool tempUnpause 				= false;

// FLOATS

// HANDLES
Handle pauseRdyTimer			= null;

// INTEGER
int matchReadyCheck				= 1;
int startplayers				= 0;
int readydisplay 				= 0;
int cooldownTime[MAXPLAYERS+1]	= {-1, ...};
int pauseplayernum				= 0;

// STRINGS
char vState[32] 				= "Not Ready";
char totalpausetime[32];

// ************************************************** SERVERINFO ************************************************

// BOOL

// ConVars
ConVar g_hostname;

// FLOATS
float hostname_update_time		= 1.0;

// HANDLES
Handle hostnameTimer;

// INTEGER
int hostnameToggle				= 1;

// STRINGS
char old_hostname[250];
char new_hostname[250];

// ************************************************** SERVERLOCK ************************************************

// BOOL
bool pwchange					= false; 
bool bRandPass					= false;

// FLOATS
float afk_kicktime				= 100.0;
float afk_Position[MAXPLAYERS+1][3];
float afk_Angles[MAXPLAYERS+1][3];

// HANDLES
Handle afk_Timer[MAXPLAYERS+1] 	= null;

// INTEGER
int afk_menutime				= 20;
int PWMAXPLAYERS				= 11 
int passwordlock				= 0;
int afk_Buttons[MAXPLAYERS+1];
int afk_Matches[MAXPLAYERS+1];

// STRINGS
char defaultpw[256];


// **************************************************** SHOUT ***************************************************
//PATHS
char shoutConfigFile[PLATFORM_MAX_PATH]		= "cfg/sm_soccermod/soccer_mod_shoutlist.cfg";
char shoutSetFile[PLATFORM_MAX_PATH]		= "cfg/sm_soccermod/soccer_mod_shoutsettings.cfg";

//BOOL
bool DupRename;

//CHAR
char gFilebuffer[PLATFORM_MAX_PATH];
char gNamebuffer[64];
char cdStatus[MAXPLAYERS+1];

//KEYVALUE
KeyValues kvConfigShout;
KeyValues kvSettings;

//INT
int shoutCD 		= 1;
int shoutCommand	= 0;
int shoutMode		= 0;
int shoutPitch 		= 100;
int shoutVolume		= 100;
int shoutMessage	= 2;
int shoutRadius		= 400; //25 feet
int shoutDebug		= 0;

//HANDLE
Handle fileArray;
Handle nameArray;
Handle fileArray_Added;
Handle nameArray_Added;

Handle shoutCDs[MAXPLAYERS+1];
Handle shoutAdvert[MAXPLAYERS+1];


// **************************************************** SKINS ***************************************************

// BOOL
bool bTGoalkeeper	 	= false;
bool bCTGoalkeeper 		= false;

// FLOATS

// HANDLES

// INTEGER
int skinsIsGoalkeeper[MAXPLAYERS + 1];

// STRINGS
char skinsModelCT[128]				  	= "models/player/soccer_mod/termi/2011/away/ct_urban.mdl";
char skinsModelCTNumber[4]			  	= "0";
char skinsModelT[128]				   	= "models/player/soccer_mod/termi/2011/home/ct_urban.mdl";
char skinsModelTNumber[4]			   	= "0";
char skinsModelCTGoalkeeper[128]		= "models/player/soccer_mod/termi/2011/gkaway/ct_urban.mdl";
char skinsModelCTGoalkeeperNumber[4]	= "0";
char skinsModelTGoalkeeper[128]			= "models/player/soccer_mod/termi/2011/gkhome/ct_urban.mdl";
char skinsModelTGoalkeeperNumber[4]		= "0";

// **************************************************** SPAWNBALL ***************************************************

// BOOL
bool ballspawn_required			= false;

// FLOAT
float ballspawn_pos[3];

// INTEGER
int spawnballpos 				= -1;

// STRING
char spawnModelBall[128] = "models/soccer_mod/ball_2011.mdl";


// **************************************************** SPRINT ***************************************************

// BOOL
bool showHudPrev[MAXPLAYERS+1]	= {false, ...};

// FLOATS
float fSPRINT_COOLDOWN 			= 7.5;
float fSPRINT_SPEED 			= 1.25;
float fSPRINT_TIME				= 3.0;

float x_val[MAXPLAYERS+1]		= {0.8, ...};
float y_val[MAXPLAYERS+1]		= {0.8, ...};

// HANDLES
Handle h_SPRINT_COOKIE 			= INVALID_HANDLE;
Handle h_TIMER_XY_COOKIE		= INVALID_HANDLE;
Handle h_TIMER_COL_COOKIE		= INVALID_HANDLE;
Handle h_SPRINT_TIMERS[MAXPLAYERS+1]; 
Handle h_SPRINT_DURATION[MAXPLAYERS+1];
Handle h_TIMER_SET[MAXPLAYERS+1];
Handle antiflood;

// INTEGER
int bSPRINT_BUTTON				= 1//= true;
int bSPRINT_ENABLED				= 1//= true;

int red_val[MAXPLAYERS+1]		= {255, ...};
int green_val[MAXPLAYERS+1]		= {140, ...};
int blue_val[MAXPLAYERS+1]		= {0, ...};

// STRINGS
char iCLIENT_STATUS[MAXPLAYERS+1];
char iP_SETTINGS[MAXPLAYERS+1];

// **************************************************** STATS ***************************************************

// BOOL

// FLOATS
float statsAssisterTimestamp = 0.0;
float statsScorerTimestamp	 = 0.0;
float statsCTGKAreaMinX		 = 0.0;
float statsCTGKAreaMinY		 = 0.0;
float statsCTGKAreaMinZ		 = 0.0;
float statsCTGKAreaMaxX		 = 0.0;
float statsCTGKAreaMaxY		 = 0.0;
float statsCTGKAreaMaxZ		 = 0.0;
float statsTGKAreaMinX		 = 0.0;
float statsTGKAreaMinY		 = 0.0;
float statsTGKAreaMinZ		 = 0.0;
float statsTGKAreaMaxX		 = 0.0;
float statsTGKAreaMaxY		 = 0.0;
float statsTGKAreaMaxZ		 = 0.0;
float statsPossessionTotal	 = 0.0;
float statsPossessionCT		 = 0.0;
float statsPossessionT		 = 0.0;

// HANDLES
Handle h_STATS_TEXT_COOKIE		= INVALID_HANDLE;
Handle h_STATS_MODE_COOKIE		= INVALID_HANDLE;
Handle h_STATS_TOGGLE_COOKIE	= INVALID_HANDLE;

// INTEGER 
int statsAssisterClientid	= 0;
int statsAssisterTeam		= 0;
int statsSaver				= 0;
int statsScorerClientid		= 0;
int statsScorerTeam			= 0;
int statsLastHitId			= 0;

int statsGoalsCT			= 0;
int statsGoalsT				= 0;
int statsAssistsCT			= 0;
int statsAssistsT			= 0;
int statsOwnGoalsCT			= 0;
int statsOwnGoalsT			= 0;
int statsHitsCT				= 0;
int statsHitsT				= 0;
int statsPassesCT			= 0;
int statsPassesT			= 0;
int statsInterceptionsCT	= 0;
int statsInterceptionsT		= 0;
int statsBallLossesCT		= 0;
int statsBallLossesT		= 0;
int statsSavesCT			= 0;
int statsSavesT				= 0;
int statsRoundsWonCT		= 0;
int statsRoundsWonT			= 0;
int statsRoundsLostCT		= 0;
int statsRoundsLostT		= 0;
int extChatSet[MAXPLAYERS+1] = {0, ...};
int extChatMode[MAXPLAYERS+1] = {0, ...};
int extChatPass[MAXPLAYERS+1] = {0, ...};
int extChatSave[MAXPLAYERS+1] = {0, ...};
int extChatLoss[MAXPLAYERS+1] = {0, ...};
//int extChatPoss[MAXPLAYERS+1] = {0, ...};

// STRINGS
char statsAssisterName[MAX_NAME_LENGTH]	= "";
char statsAssisterSteamid[32]		   	= "";
char statsScorerName[MAX_NAME_LENGTH]	= "";
char statsScorerSteamid[32]				= "";

// *************************************************** TRAINING *************************************************

// BOOL
bool trainingGoalsEnabled		= true;
bool accessgranted[MAXPLAYERS+1]= {false, ...};
//bool minigameActive				= false;
bool tgoaltarget				= false;
bool ctgoaltarget				= false;
//bool tgoalgk					= false;
//bool ctgoalgk					= false;
bool trainingModeEnabled		= false;
bool coneDynamic				= false;
bool autoToggle[2]				= {false, ...};
bool hitHelper[2]				= {false, ...};
bool g_pInRotationMode[MAXPLAYERS + 1];
bool g_pWasInNoclip[MAXPLAYERS + 1];
bool g_eReleaseFreeze[MAXPLAYERS + 1] =  { true, ... };

// FLOATS
float trainingCannonFireRate	= 2.5;
float trainingCannonPower		= 10000.0;
float trainingCannonRandomness	= 0.0;
float trainingCannonAim[3];
float trainingCannonPosition[3];
float pers_trainingCannonFireRate[MAXPLAYERS+1]		= {2.5, ...};
float pers_trainingCannonPower[MAXPLAYERS+1]		= {10000.0, ...};
float pers_trainingCannonRandomness[MAXPLAYERS+1]	= {0.0, ...};
float pers_trainingCannonAim[MAXPLAYERS+1][3];
float pers_trainingCannonPosition[MAXPLAYERS+1][3];
float ctTriggerVecMin[3];
float ctTriggerVecMax[3];
float ctTriggerOrigin[3];
float tTriggerVecMin[3];
float tTriggerVecMax[3];
float tTriggerOrigin[3];
float ballPortPosT[3]							= {0.0, ...};
float ballPortPosCT[3]							= {0.0, ...};
float targetResetTime							= 3.0;
float g_pLastButtonPress[MAXPLAYERS + 1];
float g_fGrabOffset[MAXPLAYERS + 1][3];
float g_fGrabDistance[MAXPLAYERS + 1];

// HANDLES
Handle trainingCannonTimer	  					= null;
Handle pers_trainingCannonTimer[MAXPLAYERS+1]	= {null, ...};
Handle trainingBallResetTimer[2]				= {null, ...};
Handle g_eGrabTimer[MAXPLAYERS+1];

// INTEGER
int t_trigger_id								= -1;
int ct_trigger_id								= -1;
int lastTargetBallId[2]							= {-1, ...};
int trainingCannonBallIndex	 					= -1;
int pers_trainingCannonBallIndex[MAXPLAYERS+1]	= {-1, ...};
int trainingballCD[MAXPLAYERS+1] 				= {-1, ...};
int cdTemp[MAXPLAYERS+1];
int AdvTrain_PWReqSet							= 0;
int conecounter									= 0;
int staticconehelper[MAXCONES_STA+MAXCONES_DYN]	= {-1, ...};
int trainingPropType[MAXPLAYERS+1]				= {0, ...};
int pers_hoopIndex[MAXPLAYERS+1]				= {-1, ...};
int pers_canIndex[MAXPLAYERS+1]					= {-1, ...};
int pers_plateIndex[MAXPLAYERS+1]				= {-1, ...};
int respawnIndex[2]								= {-1, ...};
int g_pGrabbedEnt[MAXPLAYERS+1];
int g_eRotationAxis[MAXPLAYERS + 1] 			=  { -1, ... };
int g_eOriginalColor[MAXPLAYERS + 1][4];
int g_BeamSprite; 
int g_HaloSprite;
int target_randint[2]							= {0, 0};
int targetmode									= 0;
int targetcounter[2]							= {0, 0};
//int trailset									= 0;


// STRINGS
char trainingModelBall[128] = "models/soccer_mod/ball_2011.mdl";
char trainingModelHoop[128] = "models/soccer_mod/training_hoop.mdl"; 
char trainingModelCan[128] = "models/soccer_mod/training_can.mdl"; 
char trainingModelPlate[128] = "models/soccer_mod/training_plate.mdl"; 
char trainingModelTarget[128] = "models/soccer_mod/training_goaltarget.mdl";
char trainingModelBlock[128] = "models/soccer_mod/training_goalblock.mdl";
//char trainingModelPass[128] = "models/soccer_mod/training_pass.mdl";
//char trainingModel1v1[128] = "models/soccer_mod/training_1v1.mdl";
char trainingModelCone[128] = "models/props_junk/trafficcone001a.mdl";
char AdvTrain_PW[32]							= "coaching";