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

state("jk2sp", "Speed Outcast Automatic")
{
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

update
{
	if (version == "Speed Outcast Automatic")
	{
		current.map = memory.ReadValue<int>((IntPtr)vars.mapAddress);
		current.ingameTime = memory.ReadValue<int>((IntPtr)vars.ingameTimeAddress);
	}
}

init
{
	version = "Vanilla";
	if (game.MainModule.FileVersionInfo.ProductName == "Speed Outcast")
	{
		var scanner = new SignatureScanner(
			game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize
		);
		var magic_id = new byte[] {
			0x6D, 0x61, 0x67, 0x69, 0x63, 0x20,                    // magic
			0x69, 0x64, 0x20,                                      // id
			0x66, 0x6F, 0x72, 0x20,                                // for
			0x73, 0x70, 0x65, 0x65, 0x64, 0x72, 0x75, 0x6E, 0x20,  // speedrun
			0x64, 0x61, 0x74, 0x61, 0x20,                          // data
			0x66, 0x6F, 0x72, 0x20,                                // for
			0x6C, 0x69, 0x76, 0x65, 0x73, 0x70, 0x6C, 0x69, 0x74   // livesplit
		};
		var ptr = scanner.Scan(new SigScanTarget(magic_id));

		if (ptr != IntPtr.Zero)
		{
			version = "Speed Outcast Automatic";
			ptr += magic_id.Length;
			vars.mapAddress = ptr;
			vars.ingameTimeAddress = vars.mapAddress + 4;
		}
		else if (game.MainModule.FileVersionInfo.FileMajorPart >= 1 &&
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
