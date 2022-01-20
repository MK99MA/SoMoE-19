You can add (almost) any texture you want as areplacer, HOWEVER there are a few things to keep in mind:
	1. Any file added has to be added to the soccer_mod_replacer.cfg with a name and a path
	2. The name does not has to be identical to the file as long as the path is correct, BUT the name in soccer_mod_replacer has to be identical with the one used in a map-config file!
	3. If a client downloaded a file he's "stuck" with it unless he deletes it himself or you use a different file (name / path / etc)

Each map that should use a "replacer" got it's own config file in cfg/sm_soccermod/grassreplacer.
If a map is loaded for the first time a mostly empty file should be created and has to be edited manually!

Editing is rather simple. Each occurence of the texture will have its own position for its center. So a good starting point would be finding the center of the field (usually where the ball spawns) and get it's position. In most cases this should be on (0.000000 0.000000 0.000000).
PLEASE NOTE THAT 0.0 IS NOT A VALID VALUE, so instead we gotta use 

!!			"pos1"			"0.000001 0.000001 0.031250"

The difference of the Z-Axis is IMPORTANT because the decal has to be slightly above the brush where you want it to be placed on!

From that point on you can just go on and substract or add the size of the texture. So if it's a 512px sized texture you'd add 512 to your start point for one side and substract it for the other side.

After you're done the file should look like this:

"Positions"
{
	"grassreplacer"
	{
		"pos1"		"-1024.000001 0.000001 0.031250"
		"pos2"		"-512.000001 0.000001 0.031250"
		"pos3"		"0.000001 0.000001 0.031250"
		"pos4"		"512.000001 0.000001 0.031250"
		"pos5"		"1024.000001 0.000001 0.031250"
		
		"pos6"		"-1024.000001 -512.000001 0.031250"
		"pos7"		"-512.000001 -512.000001 0.031250"
		"pos8"		"0.000001 -512.000001 0.031250"
		"pos9"		"512.000001 -512.000001 0.031250"
		"pos10"		"1024.000001 -512.000001 0.031250"
		
		"pos11"		"-1024.000001 -1024.000001 0.031250"
		"pos12"		"-512.000001 -1024.000001 0.031250"
		"pos13"		"0.000001 -1024.000001 0.031250"
		"pos14"		"512.000001 -1024.000001 0.031250"
		"pos15"		"1024.000001 -1024.000001 0.031250"
		
		"pos16"		"-1024.000001 -1536.000001 0.031250"
		"pos17"		"-512.000001 -1536.000001 0.031250"
		"pos18"		"0.000001 -1536.000001 0.031250"
		"pos19"		"512.000001 -1536.000001 0.031250"
		"pos20"		"1024.000001 -1536.000001 0.031250"
		
		"pos21"		"-1024.000001 512.000001 0.031250"
		"pos22"		"-512.000001 512.000001 0.031250"
		"pos23"		"0.000001 512.000001 0.031250"
		"pos24"		"512.000001 512.000001 0.031250"
		"pos25"		"1024.000001 512.000001 0.031250"
		
		"pos26"		"-1024.000001 1024.000001 0.031250"
		"pos27"		"-512.000001 1024.000001 0.031250"
		"pos28"		"0.000001 1024.000001 0.031250"
		"pos29"		"512.000001 1024.000001 0.031250"
		"pos30"		"1024.000001 1024.000001 0.031250"
		
		"pos31"		"-1024.000001 1536.000001 0.031250"
		"pos32"		"-512.000001 1536.000001 0.031250"
		"pos33"		"0.000001 1536.000001 0.031250"
		"pos34"		"512.000001 1536.000001 0.031250"
		"pos35"		"1024.000001 1536.000001 0.031250"
	}
}

Each "block" is 1 line of textures covering the width of the field on xsl_stadium_b1.
