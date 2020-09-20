state("jk2sp")
{
	int isLoading      :  0x41D45C;
	int Loading2       :  0xEF5200;
	int map            :  0x5E6098;
	int finalsplit     :  0x41D59C;
	int start          :  0x40D370;
	string9 mapString  :  0x4226F9;
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
	return current.map != old.map && current.map > 2 ||
		   current.mapString == "yavin_fin" && current.finalsplit == 1;
}

isLoading
{
	return current.isLoading == 0 || current.isLoading == 1 && current.Loading2 == 0;
}

init
{
    timer.IsGameTimePaused = false;
}

exit
{
    timer.IsGameTimePaused = true;
}
