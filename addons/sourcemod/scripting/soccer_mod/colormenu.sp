public void OpenMenuColorlist(int client)
{
	Menu menu = new Menu(MenuHandlerColorlist);
	menu.SetTitle("Color List");

	menu.AddItem("white", "white, black & grey");
	menu.AddItem("blue", "blue, purple & turquoise");
	menu.AddItem("red", "red, orange & pink");
	menu.AddItem("yellow", "yellow, green & brown");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int 	MenuHandlerColorlist(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
	
		if (StrEqual(menuItem, "white"))					OpenMenuColorlistWhite(client);
		else if (StrEqual(menuItem, "blue"))				OpenMenuColorlistBlue(client);
		else if (StrEqual(menuItem, "red"))					OpenMenuColorlistRed(client);
		else if (StrEqual(menuItem, "yellow"))				OpenMenuColorlistYellow(client); 

	}
	//else if (action == MenuAction_Cancel && choice == -6)   OpenMenuSoccer(client);
	else if (action == MenuAction_End)                      menu.Close();
}

// ****************************************************************************************************************
// ************************************************** WHITE MENU **************************************************
// ****************************************************************************************************************

public void OpenMenuColorlistWhite(int client)
{
	Menu menu = new Menu(MenuHandlerColorlistWhite);
	menu.SetTitle("Color List - white, black & grey");

	menu.AddItem("aliceblue", "aliceblue");
	menu.AddItem("black","black");
	menu.AddItem("common","common");
	menu.AddItem("darkgray","darkgray");
	menu.AddItem("darkgrey","darkgrey");
	menu.AddItem("dimgray","dimgray");
	menu.AddItem("dimgrey","dimgrey");
	menu.AddItem("exalted","exalted");
	menu.AddItem("floralwhite","floralwhite");
	menu.AddItem("gainsboro","gainsboro");
	menu.AddItem("ghostwhite","ghostwhite");
	menu.AddItem("gray","gray");
	menu.AddItem("grey","grey");
	menu.AddItem("ivory","ivory");
	menu.AddItem("lavenderblush","lavenderblush");
	menu.AddItem("lightgray","lightgray");
	menu.AddItem("lightgrey","lightgrey");
	menu.AddItem("lightslategray","lightslategray");
	menu.AddItem("lightslategrey","lightslategrey");
	menu.AddItem("linen","linen");
	menu.AddItem("mintcream","mintcream");
	menu.AddItem("mistyrose","mistyrose");
	menu.AddItem("normal","normal");
	menu.AddItem("oldlace","oldlace");
	menu.AddItem("seashell","seashell");
	menu.AddItem("silver","silver");
	menu.AddItem("slategray","slategray");
	menu.AddItem("slategrey","slategrey");
	menu.AddItem("white","white");
	menu.AddItem("whitesmoke","whitesmoke");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerColorlistWhite(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
	
		if (StrEqual(menuItem, "aliceblue"))
		{
			CPrintToChat(client, "{aliceblue}aliceblue");
			OpenMenuColorlistWhite(client);
		}
		else if (StrEqual(menuItem, "black"))
		{
			CPrintToChat(client, "{black}black");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "common"))
		{
			CPrintToChat(client, "{common}common");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "darkgray"))
		{
			CPrintToChat(client, "{darkgray}darkgray");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "darkgrey"))
		{
			CPrintToChat(client, "{darkgrey}darkgrey");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "dimgray"))
		{
			CPrintToChat(client, "{dimgray}dimgray");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "dimgrey"))
		{
			CPrintToChat(client, "{dimgrey}dimgrey");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "exalted"))
		{
			CPrintToChat(client, "{exalted}exalted");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "floralwhite"))
		{
			CPrintToChat(client, "{floralwhite}floralwhite");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "gainsboro"))
		{
			CPrintToChat(client, "{gainsboro}gainsboro");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "ghostwhite"))
		{
			CPrintToChat(client, "{ghostwhite}ghostwhite");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "gray"))
		{
			CPrintToChat(client, "{gray}gray");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "grey"))
		{
			CPrintToChat(client, "{grey}grey");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "ivory"))
		{
			CPrintToChat(client, "{ivory}ivory");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "lavenderblush"))
		{
			CPrintToChat(client, "{lavenderblush}lavenderblush");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "lightgray"))
		{
			CPrintToChat(client, "{lightgray}lightgray");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "lightgrey"))
		{
			CPrintToChat(client, "{lightgrey}lightgrey");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "lightslategray"))
		{
			CPrintToChat(client, "{lightslategray}lightslategray");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "lightslategrey"))
		{
			CPrintToChat(client, "{lightslategrey}lightslategrey");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "linen"))
		{
			CPrintToChat(client, "{linen}linen");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "mintcream"))
		{
			CPrintToChat(client, "{mintcream}mintcream");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "mistyrose"))
		{
			CPrintToChat(client, "{mistyrose}mistyrose");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "normal"))
		{
			CPrintToChat(client, "{normal}normal");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "oldlace"))
		{
			CPrintToChat(client, "{oldlace}oldlace");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "seashell"))
		{
			CPrintToChat(client, "{seashell}seashell");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "silver"))
		{
			CPrintToChat(client, "{silver}silver");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "slategray"))
		{
			CPrintToChat(client, "{slategray}slategray");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "slategrey"))
		{
			CPrintToChat(client, "{slategrey}slategrey");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "white"))
		{
			CPrintToChat(client, "{white}white");
			OpenMenuColorlistWhite(client);
		}		
		else if (StrEqual(menuItem, "whitesmoke"))
		{
			CPrintToChat(client, "{whitesmoke}whitesmoke");
			OpenMenuColorlistWhite(client);
		}		

	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuColorlist(client);
	else if (action == MenuAction_End)                      menu.Close();
}

// ****************************************************************************************************************
// ************************************************** BLUE MENU **************************************************
// ****************************************************************************************************************
public void OpenMenuColorlistBlue(int client)
{
	Menu menu = new Menu(MenuHandlerColorlistBlue);
	menu.SetTitle("Color List - blue, purple & turquoise");

	menu.AddItem("aqua","aqua");
	menu.AddItem("aquamarine","aquamarine");
	menu.AddItem("azure","azure");
	menu.AddItem("blue","blue");
	menu.AddItem("blueviolet","blueviolet");
	menu.AddItem("cadetblue","cadetblue");
	menu.AddItem("cornflowerblue","cornflowerblue");
	menu.AddItem("cyan","cyan");
	menu.AddItem("darkblue","darkblue");
	menu.AddItem("darkcyan","darkcyan");
	menu.AddItem("darkmagenta","darkmagenta");
	menu.AddItem("darkorchid","darkorchid");
	menu.AddItem("darkslateblue","darkslateblue");
	menu.AddItem("darkturquoise","darkturquoise");
	menu.AddItem("darkviolet","darkviolet");
	menu.AddItem("deepskyblue","deepskyblue");
	menu.AddItem("dodgerblue","dodgerblue");
	menu.AddItem("frozen","frozen");
	menu.AddItem("fullblue","fullblue");
	menu.AddItem("indigo","indigo");
	menu.AddItem("legendary","legendary");
	menu.AddItem("lightblue","lightblue");
	menu.AddItem("lightcyan","lightcyan");
	menu.AddItem("lightskyblue","lightskyblue");
	menu.AddItem("lightsteelblue","lightsteelblue");
	menu.AddItem("mediumblue","mediumblue");
	menu.AddItem("mediumorchid","mediumorchid");
	menu.AddItem("mediumpurple","mediumpurple");
	menu.AddItem("mediumslateblue","mediumslateblue");
	menu.AddItem("mediumturquoise","mediumturquoise");
	menu.AddItem("midnightblue","midnightblue");
	menu.AddItem("mythical","mythical");
	menu.AddItem("navy","navy");
	menu.AddItem("paleturquoise","paleturquoise");
	menu.AddItem("powderblue","powderblue");
	menu.AddItem("purple","purple");
	menu.AddItem("rare","rare");
	menu.AddItem("royalblue","royalblue");
	menu.AddItem("skyblue","skyblue");
	menu.AddItem("slateblue","slateblue");
	menu.AddItem("snow","snow");
	menu.AddItem("steelblue","steelblue");
	menu.AddItem("teal","teal");
	menu.AddItem("turquoise","turquoise");
	menu.AddItem("uncommon","uncommon");
	menu.AddItem("unusual","unusual");
	menu.AddItem("valve","valve");
	menu.AddItem("vintage","vintage");
	menu.AddItem("violet","violet");

	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerColorlistBlue(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
	
		if (StrEqual(menuItem, "aqua"))
		{
			CPrintToChat(client, "{aqua}aqua");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "aquamarine"))
		{
			CPrintToChat(client, "{aquamarine}aquamarine");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "azure"))
		{
			CPrintToChat(client, "{azure}azure");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "blue"))
		{
			CPrintToChat(client, "{blue}blue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "blueviolet"))
		{
			CPrintToChat(client, "{blueviolet}blueviolet");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "cadetblue"))
		{
			CPrintToChat(client, "{cadetblue}cadetblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "cornflowerblue"))
		{
			CPrintToChat(client, "{cornflowerblue}cornflowerblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "cyan"))
		{
			CPrintToChat(client, "{cyan}cyan");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "darkblue"))
		{
			CPrintToChat(client, "{darkblue}darkblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "darkcyan"))
		{
			CPrintToChat(client, "{darkcyan}darkcyan");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "darkmagenta"))
		{
			CPrintToChat(client, "{darkmagenta}darkmagenta");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "darkorchid"))
		{
			CPrintToChat(client, "{darkorchid}darkorchid");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "darkslateblue"))
		{
			CPrintToChat(client, "{darkslateblue}darkslateblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "darkturquoise"))
		{
			CPrintToChat(client, "{darkturquoise}darkturquoise");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "darkviolet"))
		{
			CPrintToChat(client, "{darkviolet}darkviolet");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "deepskyblue"))
		{
			CPrintToChat(client, "{deepskyblue}deepskyblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "dodgerblue"))
		{
			CPrintToChat(client, "{dodgerblue}dodgerblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "frozen"))
		{
			CPrintToChat(client, "{frozen}frozen");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "fullblue"))
		{
			CPrintToChat(client, "{fullblue}fullblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "indigo"))
		{
			CPrintToChat(client, "{indigo}indigo");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "legendary"))
		{
			CPrintToChat(client, "{legendary}legendary");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "lightblue"))
		{
			CPrintToChat(client, "{lightblue}lightblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "lightcyan"))
		{
			CPrintToChat(client, "{lightcyan}lightcyan");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "lightskyblue"))
		{
			CPrintToChat(client, "{lightskyblue}lightskyblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "lightsteelblue"))
		{
			CPrintToChat(client, "{lightsteelblue}lightsteelblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "mediumblue"))
		{
			CPrintToChat(client, "{mediumblue}mediumblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "mediumorchid"))
		{
			CPrintToChat(client, "{mediumorchid}mediumorchid");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "mediumpurple"))
		{
			CPrintToChat(client, "{mediumpurple}mediumpurple");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "mediumslateblue"))
		{
			CPrintToChat(client, "{mediumslateblue}mediumslateblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "mediumturquoise"))
		{
			CPrintToChat(client, "{mediumturquoise}mediumturquoise");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "midnightblue"))
		{
			CPrintToChat(client, "{midnightblue}midnightblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "mythical"))
		{
			CPrintToChat(client, "{mythical}mythical");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "navy"))
		{
			CPrintToChat(client, "{navy}navy");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "paleturquoise"))
		{
			CPrintToChat(client, "{paleturquoise}paleturquoise");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "powderblue"))
		{
			CPrintToChat(client, "{powderblue}powderblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "purple"))
		{
			CPrintToChat(client, "{purple}purple");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "rare"))
		{
			CPrintToChat(client, "{rare}rare");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "royalblue"))
		{
			CPrintToChat(client, "{royalblue}royalblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "skyblue"))
		{
			CPrintToChat(client, "{skyblue}skyblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "slateblue"))
		{
			CPrintToChat(client, "{slateblue}slateblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "snow"))
		{
			CPrintToChat(client, "{snow}snow");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "steelblue"))
		{
			CPrintToChat(client, "{steelblue}steelblue");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "teal"))
		{
			CPrintToChat(client, "{teal}teal");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "turquoise"))
		{
			CPrintToChat(client, "{turquoise}turquoise");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "uncommon"))
		{
			CPrintToChat(client, "{uncommon}uncommon");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "unusual"))
		{
			CPrintToChat(client, "{unusual}unusual");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "valve"))
		{
			CPrintToChat(client, "{valve}valve");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "vintage"))
		{
			CPrintToChat(client, "{vintage}vintage");
			OpenMenuColorlistBlue(client);
		}
		else if (StrEqual(menuItem, "violet"))
		{
			CPrintToChat(client, "{violet}violet");
			OpenMenuColorlistBlue(client);
		}

	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuColorlist(client);
	else if (action == MenuAction_End)                      menu.Close();
}

// ****************************************************************************************************************
// ************************************************** RED MENU **************************************************
// ****************************************************************************************************************
public void OpenMenuColorlistRed(int client)
{
	Menu menu = new Menu(MenuHandlerColorlistRed);
	menu.SetTitle("Color List - red, orange & pink");

	menu.AddItem("ancient","ancient");
	menu.AddItem("axis","axis");
	menu.AddItem("collectors","collectors");
	menu.AddItem("coral","coral");
	menu.AddItem("corrupted","corrupted");
	menu.AddItem("crimson","crimson");
	menu.AddItem("darkgoldenrod","darkgoldenrod");
	menu.AddItem("darkorange","darkorange");
	menu.AddItem("darkred","darkred");
	menu.AddItem("darksalmon","darksalmon");
	menu.AddItem("deeppink","deeppink");
	menu.AddItem("firebrick","firebrick");
	menu.AddItem("fuchsia","fuchsia");
	menu.AddItem("fullred","fullred");
	menu.AddItem("hotpink","hotpink");
	menu.AddItem("immortal","immortal");
	menu.AddItem("indianred","indianred");
	menu.AddItem("lightcoral","lightcoral");
	menu.AddItem("lightpink","lightpink");
	menu.AddItem("lightsalmon","lightsalmon");
	menu.AddItem("magenta","magenta");
	menu.AddItem("maroon","maroon");
	menu.AddItem("mediumvioletred","mediumvioletred");
	menu.AddItem("orange","orange");
	menu.AddItem("orangered","orangered");
	menu.AddItem("orchid","orchid");
	menu.AddItem("palevioletred","palevioletred");
	menu.AddItem("peru","peru");
	menu.AddItem("pink","pink");
	menu.AddItem("plum","plum");
	menu.AddItem("red","red");
	menu.AddItem("salmon","salmon");
	menu.AddItem("strange","strange");

	menu.ExitBackButton = true;
	menu.Display(client, 	MENU_TIME_FOREVER);
}

public int MenuHandlerColorlistRed(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
	
		if (StrEqual(menuItem, "ancient"))
		{
			CPrintToChat(client, "{ancient}ancient");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "axis"))
		{
			CPrintToChat(client, "{axis}axis");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "collectors"))
		{
			CPrintToChat(client, "{collectors}collectors");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "coral"))
		{
			CPrintToChat(client, "{coral}coral");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "corrupted"))
		{
			CPrintToChat(client, "{corrupted}corrupted");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "crimson"))
		{
			CPrintToChat(client, "{crimson}crimson");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "darkgoldenrod"))
		{
			CPrintToChat(client, "{darkgoldenrod}darkgoldenrod");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "darkorange"))
		{
			CPrintToChat(client, "{darkorange}darkorange");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "darkred"))
		{
			CPrintToChat(client, "{darkred}darkred");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "darksalmon"))
		{
			CPrintToChat(client, "{darksalmon}darksalmon");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "deeppink"))
		{
			CPrintToChat(client, "{deeppink}deeppink");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "firebrick"))
		{
			CPrintToChat(client, "{firebrick}firebrick");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "fuchsia"))
		{
			CPrintToChat(client, "{fuchsia}fuchsia");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "fullred"))
		{
			CPrintToChat(client, "{fullred}fullred");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "hotpink"))
		{
			CPrintToChat(client, "{hotpink}hotpink");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "immortal"))
		{
			CPrintToChat(client, "{immortal}immortal");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "indianred"))
		{
			CPrintToChat(client, "{indianred}indianred");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "lightcoral"))
		{
			CPrintToChat(client, "{lightcoral}lightcoral");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "lightpink"))
		{
			CPrintToChat(client, "{lightpink}lightpink");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "lightsalmon"))
		{
			CPrintToChat(client, "{lightsalmon}lightsalmon");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "magenta"))
		{
			CPrintToChat(client, "{magenta}magenta");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "maroon"))
		{
			CPrintToChat(client, "{maroon}maroon");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "mediumvioletred"))
		{
			CPrintToChat(client, "{mediumvioletred}mediumvioletred");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "orange"))
		{
			CPrintToChat(client, "{orange}orange");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "orangered"))
		{
			CPrintToChat(client, "{orangered}orangered");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "orchid"))
		{
			CPrintToChat(client, "{orchid}orchid");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "palevioletred"))
		{
			CPrintToChat(client, "{palevioletred}palevioletred");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "peru"))
		{
			CPrintToChat(client, "{peru}peru");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "pink"))
		{
			CPrintToChat(client, "{pink}pink");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "plum"))
		{
			CPrintToChat(client, "{plum}plum");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "red"))
		{
			CPrintToChat(client, "{red}red");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "salmon"))
		{
			CPrintToChat(client, "{salmon}salmon");
			OpenMenuColorlistRed(client);
		}
		else if (StrEqual(menuItem, "strange"))
		{
			CPrintToChat(client, "{strange}strange");
			OpenMenuColorlistRed(client);
		}


	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuColorlist(client);
	else if (action == MenuAction_End)                      menu.Close();
}

// ****************************************************************************************************************
// ************************************************** YELLOW MENU **************************************************
// ****************************************************************************************************************
public void OpenMenuColorlistYellow(int client)
{
	Menu menu = new Menu(MenuHandlerColorlistYellow);
	menu.SetTitle("Color List - yellow, green & brown");

	menu.AddItem("allies","allies");
	menu.AddItem("antiquewhite","antiquewhite");
	menu.AddItem("arcana","arcana");
	menu.AddItem("beige","beige");
	menu.AddItem("bisque","bisque");
	menu.AddItem("blanchedalmond","blanchedalmond");
	menu.AddItem("brown","brown");
	menu.AddItem("burlywood","burlywood");
	menu.AddItem("chartreuse","chartreuse");
	menu.AddItem("chocolate","chocolate");
	menu.AddItem("community","community");
	menu.AddItem("cornsilk","cornsilk");
	menu.AddItem("darkgreen","darkgreen");
	menu.AddItem("darkkhaki","darkkhaki");
	menu.AddItem("darkolivegreen","darkolivegreen");
	menu.AddItem("darkseagreen","darkseagreen");
	menu.AddItem("darkslategray","darkslategray");
	menu.AddItem("darkslategrey","darkslategrey");
	menu.AddItem("forestgreen","forestgreen");
	menu.AddItem("genuine","genuine");
	menu.AddItem("gold","gold");
	menu.AddItem("goldenrod","goldenrod");
	menu.AddItem("green","green");
	menu.AddItem("greenyellow","greenyellow");
	menu.AddItem("haunted","haunted");
	menu.AddItem("honeydew","honeydew");
	menu.AddItem("khaki","khaki");
	menu.AddItem("lavender","lavender");
	menu.AddItem("lawngreen","lawngreen");
	menu.AddItem("lemonchiffon","lemonchiffon");
	menu.AddItem("lightgoldenrodyellow","lightgoldenrodyellow");
	menu.AddItem("lightgreen","lightgreen");
	menu.AddItem("lightseagreen","lightseagreen");
	menu.AddItem("lightyellow","lightyellow");
	menu.AddItem("lime","lime");
	menu.AddItem("limegreen","limegreen");
	menu.AddItem("mediumaquamarine","mediumaquamarine");
	menu.AddItem("mediumseagreen","mediumseagreen");
	menu.AddItem("mediumspringgreen","mediumspringgreen");
	menu.AddItem("moccasin","moccasin");
	menu.AddItem("navajowhite","navajowhite");
	menu.AddItem("olive","olive");
	menu.AddItem("olivedrab","olivedrab");
	menu.AddItem("palegoldenrod","palegoldenrod");
	menu.AddItem("palegreen","palegreen");
	menu.AddItem("papayawhip","papayawhip");
	menu.AddItem("peachpuff","peachpuff");
	menu.AddItem("rosybrown","rosybrown");
	menu.AddItem("saddlebrown","saddlebrown");
	menu.AddItem("sandybrown","sandybrown");
	menu.AddItem("seagreen","seagreen");
	menu.AddItem("selfmade","selfmade");
	menu.AddItem("sienna","sienna");
	menu.AddItem("springgreen","springgreen");
	menu.AddItem("tan","tan");
	menu.AddItem("thistle","thistle");
	menu.AddItem("tomato","tomato");
	menu.AddItem("unique","unique");
	menu.AddItem("wheat","wheat");
	menu.AddItem("yellow","yellow");
	menu.AddItem("yellowgreen","yellowgreen");
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandlerColorlistYellow(Menu menu, MenuAction action, int client, int choice)
{
	if (action == MenuAction_Select)
	{
		char menuItem[32];
		menu.GetItem(choice, menuItem, sizeof(menuItem));
	
		if (StrEqual(menuItem, "allies"))
		{
			CPrintToChat(client, "{allies}allies");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "antiquewhite"))
		{
			CPrintToChat(client, "{antiquewhite}antiquewhite");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "arcana"))
		{
			CPrintToChat(client, "{arcana}arcana");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "beige"))
		{
			CPrintToChat(client, "{beige}beige");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "bisque"))
		{
			CPrintToChat(client, "{bisque}bisque");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "blanchedalmond"))
		{
			CPrintToChat(client, "{blanchedalmond}blanchedalmond");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "brown"))
		{
			CPrintToChat(client, "{brown}brown");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "burlywood"))
		{
			CPrintToChat(client, "{burlywood}burlywood");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "chartreuse"))
		{
			CPrintToChat(client, "{chartreuse}chartreuse");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "chocolate"))
		{
			CPrintToChat(client, "{chocolate}chocolate");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "community"))
		{
			CPrintToChat(client, "{community}community");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "cornsilk"))
		{
			CPrintToChat(client, "{cornsilk}cornsilk");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "darkgreen"))
		{
			CPrintToChat(client, "{darkgreen}darkgreen");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "darkkhaki"))
		{
			CPrintToChat(client, "{darkkhaki}darkkhaki");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "darkolivegreen"))
		{
			CPrintToChat(client, "{darkolivegreen}darkolivegreen");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "darkseagreen"))
		{
			CPrintToChat(client, "{darkseagreen}darkseagreen");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "darkslategray"))
		{
			CPrintToChat(client, "{darkslategray}darkslategray");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "darkslategrey"))
		{
			CPrintToChat(client, "{darkslategrey}darkslategrey");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "forestgreen"))
		{
			CPrintToChat(client, "{forestgreen}forestgreen");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "genuine"))
		{
			CPrintToChat(client, "{genuine}genuine");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "gold"))
		{
			CPrintToChat(client, "{gold}gold");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "goldenrod"))
		{
			CPrintToChat(client, "{goldenrod}goldenrod");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "green"))
		{
			CPrintToChat(client, "{green}green");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "greenyellow"))
		{
			CPrintToChat(client, "{greenyellow}greenyellow");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "haunted"))
		{
			CPrintToChat(client, "{haunted}haunted");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "honeydew"))
		{
			CPrintToChat(client, "{honeydew}honeydew");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "khaki"))
		{
			CPrintToChat(client, "{khaki}khaki");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "lavender"))
		{
			CPrintToChat(client, "{lavender}lavender");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "lawngreen"))
		{
			CPrintToChat(client, "{lawngreen}lawngreen");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "lemonchiffon"))
		{
			CPrintToChat(client, "{lemonchiffon}lemonchiffon");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "lightgoldenrodyellow"))
		{
			CPrintToChat(client, "{lightgoldenrodyellow}lightgoldenrodyellow");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "lightgreen"))
		{
			CPrintToChat(client, "{lightgreen}lightgreen");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "lightseagreen"))
		{
			CPrintToChat(client, "{lightseagreen}lightseagreen");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "lightyellow"))
		{
			CPrintToChat(client, "{lightyellow}lightyellow");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "lime"))
		{
			CPrintToChat(client, "{lime}lime");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "limegreen"))
		{
			CPrintToChat(client, "{limegreen}limegreen");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "mediumaquamarine"))
		{
			CPrintToChat(client, "{mediumaquamarine}mediumaquamarine");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "mediumseagreen"))
		{
			CPrintToChat(client, "{mediumseagreen}mediumseagreen");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "mediumspringgreen"))
		{
			CPrintToChat(client, "{mediumspringgreen}mediumspringgreen");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "moccasin"))
		{
			CPrintToChat(client, "{moccasin}moccasin");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "navajowhite"))
		{
			CPrintToChat(client, "{navajowhite}navajowhite");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "olive"))
		{
			CPrintToChat(client, "{olive}olive");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "olivedrab"))
		{
			CPrintToChat(client, "{olivedrab}olivedrab");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "palegoldenrod"))
		{
			CPrintToChat(client, "{palegoldenrod}palegoldenrod");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "palegreen"))
		{
			CPrintToChat(client, "{palegreen}palegreen");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "papayawhip"))
		{
			CPrintToChat(client, "{papayawhip}papayawhip");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "peachpuff"))
		{
			CPrintToChat(client, "{peachpuff}peachpuff");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "rosybrown"))
		{
			CPrintToChat(client, "{rosybrown}rosybrown");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "saddlebrown"))
		{
			CPrintToChat(client, "{saddlebrown}saddlebrown");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "sandybrown"))
		{
			CPrintToChat(client, "{sandybrown}sandybrown");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "seagreen"))
		{
			CPrintToChat(client, "{seagreen}seagreen");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "selfmade"))
		{
			CPrintToChat(client, "{selfmade}selfmade");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "sienna"))
		{
			CPrintToChat(client, "{sienna}sienna");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "springgreen"))
		{
			CPrintToChat(client, "{springgreen}springgreen");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "tan"))
		{
			CPrintToChat(client, "{tan}tan");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "thistle"))
		{
			CPrintToChat(client, "{thistle}thistle");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "tomato"))
		{
			CPrintToChat(client, "{tomato}tomato");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "unique"))
		{
			CPrintToChat(client, "{unique}unique");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "wheat"))
		{
			CPrintToChat(client, "{wheat}wheat");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "yellow"))
		{
			CPrintToChat(client, "{yellow}yellow");
			OpenMenuColorlistYellow(client);
		}
		else if (StrEqual(menuItem, "yellowgreen"))
		{
			CPrintToChat(client, "{yellowgreen}yellowgreen");
			OpenMenuColorlistYellow(client);
		}



	}
	else if (action == MenuAction_Cancel && choice == -6)   OpenMenuColorlist(client);
	else if (action == MenuAction_End)                      menu.Close();
}