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
KeyValues kvTemp;
KeyValues kvMLSettings;
KeyValues statsKeygroupMatch;
KeyValues statsKeygroupRound;
KeyValues personalCannonSettings;

// **************************************************** GENERAL **************************************************
// BOOLS
bool bLATE_LOAD 				= false;
bool currentMapAllowed			= false;
bool goalScored					= false;
bool menuaccessed;
bool roundEnded					= false;

// FLOATS
float phys_timescale			= 1.0;
float respawnDelay 				= 10.0;
float playerMaxHeight[66];

// HANDLES
Handle allowedMaps	  			= INVALID_HANDLE;
Handle db			   			= INVALID_HANDLE;
Handle cvar_BLOCKDJ_ENABLED = INVALID_HANDLE;
Handle respawnTimers[MAXPLAYERS + 1];
Handle delayedFreezeTimer[MAXPLAYERS + 1];

ArrayList groupArray;

// INTEGER
int djbenabled					= 1;
int publicmode		 			= 1;
int damageSounds				= 0;
int debuggingEnabled			= 0;
int phys_pushscale				= 900;
int healthGodmode				= 1;
int healthAmount				= 250;
int dissolveSet					= 2;

// STRINGS
char changeSetting[MAXPLAYERS + 1][32];
char gamevar[8]					= "cstrike";
char databaseConfig[64]			= "storage-local";
char cardReceiver[MAX_NAME_LENGTH];
char cardString[32];

// **************************************************** ADMIN ***************************************************

// BOOL
bool adminRemoved;

// FLOATS

// HANDLES

// INTEGER
int addoredit;
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

// FLOATS

// HANDLES

// INTEGER
int capPicker			= 0;
int capCT				= 0;
int capT				= 0;
int capPicksLeft		= 0;

// STRINGS

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

// FLOATS

// HANDLES

// INTEGER
int rankingPointsForGoal			= 12;
int rankingPointsForAssist			= 12;
int rankingPointsForOwnGoal			= -10;
int rankingPointsForHit				= 1;
int rankingPointsForPass			= 5;
int rankingPointsForInterception	= 3;
int rankingPointsForBallLoss		= -3;
int rankingPointsForSave			= 10;
int rankingPointsForRoundWon		= 10;
int rankingPointsForRoundLost		= -10;
int rankingPointsForMVP				= 15;
int rankingPointsForMOTM			= 25;

// STRINGS

// ************************************************** READYCHECK ************************************************

// BOOL
bool showPanel					= false;
bool cdMessage[MAXPLAYERS+1]	= false;
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

// **************************************************** SKINS ***************************************************

// BOOL

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

// **************************************************** SPRINT ***************************************************

// BOOL
bool showHudPrev[MAXPLAYERS+1]	= {false, ...};

// FLOATS
float fSPRINT_COOLDOWN 			= 0.0;
float fSPRINT_SPEED 			= 0.0;
float fSPRINT_TIME				= 0.0;

float x_val[MAXPLAYERS+1]		= {0.8, ...};
float y_val[MAXPLAYERS+1]		= {0.8, ...};

// HANDLES
Handle h_BUTTON 				= INVALID_HANDLE;
Handle h_COOLDOWN 				= INVALID_HANDLE;
Handle h_SPRINT_ENABLED			= INVALID_HANDLE;
Handle h_SPEED 					= INVALID_HANDLE;
Handle h_TIME 					= INVALID_HANDLE;
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

// INTEGER 
int statsAssisterClientid	= 0;
int statsAssisterTeam		= 0;
int statsSaver				= 0;
int statsScorerClientid		= 0;
int statsScorerTeam			= 0;

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

// STRINGS
char statsAssisterName[MAX_NAME_LENGTH]	= "";
char statsAssisterSteamid[32]		   	= "";
char statsScorerName[MAX_NAME_LENGTH]	= "";
char statsScorerSteamid[32]				= "";

// *************************************************** TRAINING *************************************************

// BOOL
bool trainingGoalsEnabled		= true;

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

// HANDLES
Handle trainingCannonTimer	  					= null;
Handle pers_trainingCannonTimer[MAXPLAYERS+1]	= {null, ...};

// INTEGER
int trainingCannonBallIndex	 					= -1;
int pers_trainingCannonBallIndex[MAXPLAYERS+1]	= {-1, ...};
int trainingballCD[MAXPLAYERS+1] 				= {-1, ...};
int cdTemp[MAXPLAYERS+1];

// STRINGS
char trainingModelBall[128] = "models/soccer_mod/ball_2011.mdl";