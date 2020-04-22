public void RegisterServerCommandsTraining()
{
	RegServerCmd
	(
		"soccer_mod_training_model_ball",
		ServerCommandsTraining,
		"Sets the model of the training ball - values: path/to/dir/file.mdl"
	);
}

public Action ServerCommandsTraining(int args)
{
	char serverCommand[50], cmdArg1[32];
	GetCmdArg(0, serverCommand, sizeof(serverCommand));
	GetCmdArg(1, cmdArg1, sizeof(cmdArg1));

	if (StrEqual(serverCommand, "soccer_mod_training_model_ball"))
	{
		char cmdArgString[128];
		GetCmdArgString(cmdArgString, sizeof(cmdArgString));

		if (FileExists(cmdArgString, true))
		{
			trainingModelBall = cmdArgString;
			UpdateConfigModels("Training Settings", "soccer_mod_training_model_ball", trainingModelBall);
			if (!IsModelPrecached(trainingModelBall)) PrecacheModel(trainingModelBall);

			PrintToServer("[%s] Training ball model set to %s", prefix, cmdArgString);
			CPrintToChatAll("{%s}[%s] {%s}Training ball model set to %s", prefixcolor, prefix, textcolor, cmdArgString);
		}
		else
		{
			PrintToServer("[%s] Can't set training ball model to %s", prefix, cmdArgString);
			CPrintToChatAll("{%s}[%s] {%s}Can't set training ball model to %s", prefixcolor, prefix, textcolor, cmdArgString);
		}
	}

	return Plugin_Handled;
}