state("jk2sp", "Vanilla")
{
	int map            :  0x5E6098;
	int finalsplit     :  0x41D59C;
	int start          :  0x40D370;
	string9 mapString  :  0x4226F9;
}

state("jk2sp", "Speed Outcast v0.3")
{
	int map            :  0xC14F98;
	int start          :  0x4B87B0;
	int ingameTime     :  0x100CA30;
}

state("jk2sp", "Speed Outcast v0.5")
{
	int map            :  0xC138D8;
	int ingameTime     :  0x100B940;
}

state("jk2sp", "Speed Outcast v0.6")
{
	int map            :  0xC169F8;
	int ingameTime     :  0x100ea60;
}

state("jk2sp", "Speed Outcast v0.7")
{
	int map            :  0xC159F8;
	int ingameTime     :  0x100DA60;
}

state("jk2sp", "Speed Outcast v1.0")
{
	int map            :  0xC1B9F8;
	int ingameTime     :  0x1013A60;
}

start
{
	if (version == "Vanilla")
	{
		return current.map == 17 && (current.start == 4 && old.start != 4);
	}
	return old.ingameTime == 0 && current.ingameTime != 0;
}

reset
{
	return current.map == 17 && old.map != 17;
}
split
{
	if (version == "Vanilla")
	{
		return current.map != old.map && current.map > 2 ||
		       current.mapString == "yavin_fin" && current.finalsplit == 1;
	}
	return current.map != old.map && current.map > 2;
}

isLoading
{
	return true;
}

init
{
	version = "Vanilla";
	if (game.MainModule.FileVersionInfo.ProductName == "Speed Outcast")
	{
		if (game.MainModule.FileVersionInfo.FileMajorPart == 1 &&
                    game.MainModule.FileVersionInfo.FileMinorPart >= 0)
		{
			version = "Speed Outcast v1.0";
		}
		else if (game.MainModule.FileVersionInfo.FileMajorPart == 0 &&
		         game.MainModule.FileVersionInfo.FileMinorPart >= 7)
		{
			version = "Speed Outcast v0.7";
		}
		else if (game.MainModule.FileVersionInfo.FileMajorPart == 0 &&
		         game.MainModule.FileVersionInfo.FileMinorPart >= 6)
		{
			version = "Speed Outcast v0.6";
		}
		else if (game.MainModule.FileVersionInfo.FileMajorPart == 0 &&
		         game.MainModule.FileVersionInfo.FileMinorPart >= 5)
		{
			version = "Speed Outcast v0.5";
		}
		else
		{
			version = "Speed Outcast v0.3";
		}
	}
}

gameTime
{
	if (version == "Vanilla")
	{
		return TimeSpan.FromMilliseconds(0);
	}
	return TimeSpan.FromMilliseconds(current.ingameTime);
}
