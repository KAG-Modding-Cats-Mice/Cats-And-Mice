// A script by TFlippy
#include "GramophoneCommon.as";

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	CPlayer@ byPlayer = byBlob.getPlayer();
	if (byPlayer !is null && byPlayer.isMod())
	{
 		return true;
	} else
	{
		return false;
	}
}

void onInit(CBlob@ this)
{
	if (!this.exists("track_id")) 
	{
		Random@ rand = Random(this.getNetworkID());
		this.set_u8("track_id", rand.NextRanged(records.length));
	}
	const u8 track_id = this.get_u8("track_id");
}
