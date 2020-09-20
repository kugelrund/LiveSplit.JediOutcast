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

start
{
	return current.map == 17 && current.start == 4;
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
		version = "Speed Outcast v0.3";
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
