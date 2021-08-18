
class MiceSound
{
	string filename;

	MiceSound(string filename)
	{
		this.filename = filename;
	}
};

const MiceSound@[] squeak =
{
	MiceSound("squeakOne.ogg"),
	MiceSound("squeakThree.ogg"),
	MiceSound("squeakFour.ogg"),
	MiceSound("squeakFive.ogg"),
	MiceSound("squeakSix.ogg"),
	MiceSound("squeakSeven.ogg"),
	MiceSound("squeakEight.ogg"),
};

void onTick(CRules@ this)
{
    if (getGameTime() % 300 == 0 && getGameTime() > 5250)
    {
    	for (int i = 0; i < getPlayersCount(); i++) // loop through every player on server
       	{
            CBlob@ blob = getPlayer(i).getBlob(); // get player's blob

            if (blob is null) continue; // if blob is null (because player is dead, for example), skip this iteration

            if (blob.getName() == "builder")
            {
	        Sound::Play(squeak[XORRandom(squeak.length - 1)].filename, blob.getPosition(), 1.5f, 1.0f);
	        }
        }
    }
}