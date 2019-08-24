// *********************************************************************************************************************
// ************************************************** CLIENT COMMANDS **************************************************
// *********************************************************************************************************************
public void ClientCommandPublicRanking(int client)
{
    char query[256] = "SELECT soccer_mod_players.steamid, points FROM soccer_mod_players, soccer_mod_public_stats \
        WHERE soccer_mod_players.steamid = soccer_mod_public_stats.steamid AND hits > 0 ORDER BY points desc";
    SQL_TQuery(db, ClientCommandPublicRankingCallback, query, client);
}

public void ClientCommandPublicRankingCallback(Handle owner, Handle hndl, const char[] error, any client)
{
    int total;
    total = SQL_GetRowCount(hndl);

    if (hndl == INVALID_HANDLE)
    {
        LogError("Failed to query (error: %s)", error);
        CPrintToChat(client, "{%s}[%s] {%s}You are not ranked yet", prefixcolor, prefix, textcolor);
    }
    else if (total)
    {
        char clientSteamid[32];
        GetClientAuthId(client, AuthId_Engine, clientSteamid, sizeof(clientSteamid));

        char steamid[32];
        int rank;
        int points;
        while (SQL_FetchRow(hndl))
        {
            rank++;
            SQL_FetchString(hndl, 0, steamid, sizeof(steamid));
            points = SQL_FetchInt(hndl, 1);
            if (StrEqual(clientSteamid, steamid)) break;
        }

        for (int player = 1; player <= MaxClients; player++)
        {
            if (IsClientInGame(player) && IsClientConnected(player)) CPrintToChat(player, "{%s}[%s] {%s}%N is ranked %i with %i points", prefixcolor, prefix, textcolor, client, rank, total, points);
        }
    }
    else CPrintToChat(client, "{%s}[%s] {%s}You are not ranked yet", prefixcolor, prefix, textcolor);
}

// ******************************************************************************************************************
// ************************************************** RANKING MENU **************************************************
// ******************************************************************************************************************
public void OpenRankingMenu(int client)
{
    Menu menu = new Menu(RankingMenuHandler);

    menu.SetTitle("Soccer Mod - Ranking");

    menu.AddItem("match_top", "Match Top 50");

    menu.AddItem("public_top", "Public Top 50");

    menu.AddItem("match_personal", "Match Personal");

    menu.AddItem("public_personal", "Public Personal");

    menu.AddItem("last_connected", "Last Connected");

    menu.ExitBackButton = true;
    menu.Display(client, MENU_TIME_FOREVER);
}

public int RankingMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
    if (action == MenuAction_Select)
    {
        char menuItem[32];
        menu.GetItem(choice, menuItem, sizeof(menuItem));

        if (StrEqual(menuItem, "match_top"))                OpenRankingTopMenu(client, "match");
        else if (StrEqual(menuItem, "public_top"))          OpenRankingTopMenu(client, "public");
        else if (StrEqual(menuItem, "match_personal"))      OpenRankingPersonalMenu(client, "match");
        else if (StrEqual(menuItem, "public_personal"))     OpenRankingPersonalMenu(client, "public");
        else if (StrEqual(menuItem, "last_connected"))      OpenRankingLastConnectedMenu(client);
    }
    else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSoccer(client);
    else if (action == MenuAction_End)                      menu.Close();
}

// **********************************************************************************************************************
// ************************************************** RANKING TOP MENU **************************************************
// **********************************************************************************************************************
public void OpenRankingTopMenu(int client, char type[8])
{
    char query[256];
    Format(query, sizeof(query), "SELECT soccer_mod_players.steamid, points, name FROM soccer_mod_players, soccer_mod_%s_stats \
        WHERE soccer_mod_players.steamid = soccer_mod_%s_stats.steamid AND hits > 0 ORDER BY points desc LIMIT 0,50", type, type);

    Handle pack = CreateDataPack();
    WritePackCell(pack, client);
    WritePackString(pack, type);

    SQL_TQuery(db, OpenRankingTopMenuCallback, query, pack);
}

public void OpenRankingTopMenuCallback(Handle owner, Handle hndl, const char[] error, any pack)
{
    ResetPack(pack);
    int client = ReadPackCell(pack);

    if (hndl == INVALID_HANDLE)
    {
        LogError("Failed to query (error: %s)", error);
        CPrintToChat(client, "{%s}[%s] {%s}No players are ranked yet", prefixcolor, prefix, textcolor);
        OpenRankingMenu(client);
    }
    else if (SQL_GetRowCount(hndl))
    {
        char type[64];
        ReadPackString(pack, type, sizeof(type));

        //char langString[64], langString1[64], langString2[64];
        //Format(langString1, sizeof(langString1), "Ranking", client);

        if (StrEqual(type, "match"))
        {
            //Format(langString2, sizeof(langString2), "%T", "Match top $number", client, 50);
            //Format(langString, sizeof(langString), "Soccer Mod - %s - %s", langString1, langString2);
            CreateRankingTopMenu(client, "Match top 50", hndl);
        }
        else if (StrEqual(type, "public"))
        {
            //Format(langString2, sizeof(langString2), "%T", "Public top $number", client, 50);
            //Format(langString, sizeof(langString), "Soccer Mod - %s - %s", langString1, langString2);
            CreateRankingTopMenu(client, "Public top 50", hndl);
        }
    }
    else
    {
        CPrintToChat(client, "{%s}[%s] {%s}No players are ranked yet", prefixcolor, prefix, textcolor);
        OpenRankingMenu(client);
    }
}

public void CreateRankingTopMenu(int client, char title[64], Handle hndl)
{
    Menu menu = new Menu(RankingTopMenuHandler);
    menu.SetTitle(title);

    char steamid[32];
    char name[64];
    char menuString[1024];
    int points;
    int position;

    while (SQL_FetchRow(hndl))
    {
        position++;
        SQL_FetchString(hndl, 0, steamid, sizeof(steamid));
        SQL_FetchString(hndl, 2, name, sizeof(name));
        points = SQL_FetchInt(hndl, 1);
        Format(menuString, sizeof(menuString), "(%i) %s (%i)", position, name, points);
        menu.AddItem(steamid, menuString, ITEMDRAW_DISABLED);
    }

    menu.ExitBackButton = true;
    menu.Display(client, MENU_TIME_FOREVER);
}

public int RankingTopMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
    if (action == MenuAction_Select)                        OpenRankingMenu(client);
    else if (action == MenuAction_Cancel && choice == -6)   OpenRankingMenu(client);
    else if (action == MenuAction_End)                      menu.Close();
}

// ***************************************************************************************************************************
// ************************************************** RANKING PERSONAL MENU **************************************************
// ***************************************************************************************************************************
public void OpenRankingPersonalMenu(int client, char type[8])
{
    char steamid[32];
    GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));

    char query[512];
    Format(query, sizeof(query), "SELECT goals, assists, own_goals, passes, interceptions, ball_losses, hits, points, saves, rounds_won, rounds_lost, \
        mvp, motm, last_connected, created, play_time FROM soccer_mod_players, soccer_mod_%s_stats \
        WHERE soccer_mod_players.steamid = soccer_mod_%s_stats.steamid AND soccer_mod_players.steamid = '%s'", type, type, steamid);

    Handle pack = CreateDataPack();
    WritePackCell(pack, client);
    WritePackString(pack, type);

    SQL_TQuery(db, OpenRankingPersonalMenuCallback, query, pack);
}

public void OpenRankingPersonalMenuCallback(Handle owner, Handle hndl, const char[] error, any pack)
{
    ResetPack(pack);
    int client = ReadPackCell(pack);

    if (hndl == INVALID_HANDLE)
    {
        LogError("Failed to query (error: %s)", error);
        CPrintToChat(client, "{%s}[%s] {%s}You are not ranked yet", prefixcolor, prefix, textcolor);
        OpenRankingMenu(client);
    }
    else if (SQL_GetRowCount(hndl))
    {
        char type[64];
        ReadPackString(pack, type, sizeof(type));

        //char langString[64], langString1[64], langString2[64];
        //Format(langString1, sizeof(langString1), "Ranking", client);

        if (StrEqual(type, "match"))
        {
            //Format(langString2, sizeof(langString2), "%T", "Match personal", client);
            //Format(langString, sizeof(langString), "Soccer Mod - %s - %s", langString1, langString2);
            CreateRankingPersonalMenu(client, "Match personal", hndl);
        }
        else if (StrEqual(type, "public"))
        {
            //Format(langString2, sizeof(langString2), "%T", "Public personal", client);
            //Format(langString, sizeof(langString), "Soccer Mod - %s - %s", langString1, langString2);
            CreateRankingPersonalMenu(client, "Public personal", hndl);
        }
    }
    else
    {
        CPrintToChat(client, "{%s}[%s] {%s}You are not ranked yet", prefixcolor, prefix, textcolor);
        OpenRankingMenu(client);
    }
}

public void CreateRankingPersonalMenu(int client, char title[64], Handle hndl)
{
    Menu menu = new Menu(RankingPersonalMenuHandler);
    menu.SetTitle(title);

    char menuString[128];
    int number;

    while (SQL_FetchRow(hndl))
    {

        number = SQL_FetchInt(hndl, 7);
        Format(menuString, sizeof(menuString), "%s: %i", "Points", number);
        menu.AddItem("points", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 0);
        Format(menuString, sizeof(menuString), "%s: %i", "Goals", number);
        menu.AddItem("goals", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 1);
        Format(menuString, sizeof(menuString), "%s: %i", "Assists", number);
        menu.AddItem("assists", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 2);
        Format(menuString, sizeof(menuString), "%s: %i", "Own goals", number);
        menu.AddItem("own_goals", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 8);
        Format(menuString, sizeof(menuString), "%s: %i", "Saves", number);
        menu.AddItem("saves", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 3);
        Format(menuString, sizeof(menuString), "%s: %i", "Passes", number);
        menu.AddItem("passes", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 4);
        Format(menuString, sizeof(menuString), "%s: %i", "Interceptions", number);
        menu.AddItem("interceptions", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 5);
        Format(menuString, sizeof(menuString), "%s: %i", "Ball losses", number);
        menu.AddItem("ball_losses", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 6);
        Format(menuString, sizeof(menuString), "%s: %i", "Hits", number);
        menu.AddItem("hits", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 9);
        Format(menuString, sizeof(menuString), "%s: %i", "Rounds won", number);
        menu.AddItem("rounds_won", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 10);
        Format(menuString, sizeof(menuString), "%s: %i", "Rounds lost", number);
        menu.AddItem("rounds_lost", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 11);
        Format(menuString, sizeof(menuString), "%s: %i", "MVP", number);
        menu.AddItem("mvp", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 12);
        Format(menuString, sizeof(menuString), "%s: %i", "MOTM", number);
        menu.AddItem("motm", menuString, ITEMDRAW_DISABLED);

        /*
        char dateString[32];

        number = SQL_FetchInt(hndl, 13);
        FormatTime(dateString, sizeof(dateString), NULL_STRING, number);
        Format(menuString, sizeof(menuString), "Last connected: %s", dateString);
        menu.AddItem("last_connected", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 14);
        FormatTime(dateString, sizeof(dateString), NULL_STRING, number);
        Format(menuString, sizeof(menuString), "First connected: %s", dateString);
        menu.AddItem("created", menuString, ITEMDRAW_DISABLED);

        number = SQL_FetchInt(hndl, 15);
        Format(menuString, sizeof(menuString), "Play time: %i", number);
        menu.AddItem("play_time", menuString, ITEMDRAW_DISABLED);
        */
    }

    menu.ExitBackButton = true;
    menu.Display(client, MENU_TIME_FOREVER);
}

public int RankingPersonalMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
    if (action == MenuAction_Select)                        OpenRankingMenu(client);
    else if (action == MenuAction_Cancel && choice == -6)   OpenRankingMenu(client);
    else if (action == MenuAction_End)                      menu.Close();
}

// *************************************************************************************************************************
// ************************************************** LAST CONNECTED MENU **************************************************
// *************************************************************************************************************************
public void OpenRankingLastConnectedMenu(int client)
{
    char query[128];
    Format(query, sizeof(query), "SELECT steamid, last_connected, name FROM soccer_mod_players ORDER BY last_connected DESC LIMIT 0,100");

    SQL_TQuery(db, OpenRankingLastConnectedMenuCallback, query, client);
}

public void OpenRankingLastConnectedMenuCallback(Handle owner, Handle hndl, const char[] error, int client)
{
    if (hndl == INVALID_HANDLE)
    {
        LogError("Failed to query (error: %s)", error);
        CPrintToChat(client, "{%s}[%s] {%s}No players found", prefixcolor, prefix, textcolor);
        OpenRankingMenu(client);
    }
    else if (SQL_GetRowCount(hndl))
    {
        Menu menu = new Menu(RankingLastConnectedMenuHandler);
        menu.SetTitle("Soccer Mod - Ranking - Last connected");

        char steamid[32];
        char name[64];
        int last_connected;
        int time = GetTime();
        char menuString[64];
        char timeAgo[32];

        while (SQL_FetchRow(hndl))
        {
            SQL_FetchString(hndl, 0, steamid, sizeof(steamid));
            SQL_FetchString(hndl, 2, name, sizeof(name));
            last_connected = SQL_FetchInt(hndl, 1);

            last_connected = time - last_connected;
            if (last_connected == 1)        timeAgo = "second ago";
            else if (last_connected < 60)   timeAgo = "seconds ago";
            else if (last_connected < 120)
            {
                last_connected = last_connected / 60;
                timeAgo = "minute ago";
            }
            else if (last_connected < 3600)
            {
                last_connected = last_connected / 60;
                timeAgo = "minutes ago";
            }
            else if (last_connected < 7200)
            {
                last_connected = last_connected / 3600;
                timeAgo = "hour ago";
            }
            else if (last_connected < 86400)
            {
                last_connected = last_connected / 3600;
                timeAgo = "hours ago";
            }
            else if (last_connected < 172800)
            {
                last_connected = last_connected / 86400;
                timeAgo = "day ago";
            }
            else
            {
                last_connected = last_connected / 86400;
                timeAgo = "days ago";
            }

            Format(menuString, sizeof(menuString), "%s (%i %s)", name, last_connected, timeAgo);
            menu.AddItem(steamid, menuString, ITEMDRAW_DISABLED);
        }

        menu.ExitBackButton = true;
        menu.Display(client, MENU_TIME_FOREVER);
    }
    else
    {
        CPrintToChat(client, "{%s}[%s] {%s}No players found", prefixcolor, prefix, textcolor);
        OpenRankingMenu(client);
    }
}

public int RankingLastConnectedMenuHandler(Menu menu, MenuAction action, int client, int choice)
{
    if (action == MenuAction_Select)                        OpenRankingMenu(client);
    else if (action == MenuAction_Cancel && choice == -6)   OpenRankingMenu(client);
    else if (action == MenuAction_End)                      menu.Close();
}