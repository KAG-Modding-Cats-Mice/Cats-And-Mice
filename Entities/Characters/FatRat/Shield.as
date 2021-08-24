#include "Knocked.as";
#include "RunnerCommon.as"; //

const int SHIELD_FREQUENCY = 45 * 30; // 45 secs

void onInit( CBlob@ this )
{
	this.set_u32("last shield", 0);
	this.set_bool("shield ready", true);
	this.set_u32("shield", 0);
}

void onTick(CBlob@ this) 
{	
	bool ready = this.get_bool("shield ready");
	const u32 gametime = getGameTime();
	CControls@ controls = getControls();
	
	if (ready) 
    {
		if (this !is null)
		{
			if (isClient() && this.isMyPlayer())
			{
				if (controls.isKeyJustPressed(KEY_KEY_R))
				{
					this.set_u32("last shield", gametime);
					this.set_bool("shield ready", false);
					Shield(this);
				}
			}
		}
	} else 
    {		
		u32 lastShield = this.get_u32("last shield");
		int diff = gametime - (lastShield + SHIELD_FREQUENCY);
		
		if (controls.isKeyJustPressed(KEY_KEY_R) && this.isMyPlayer())
		{
			Sound::Play("Entities/Characters/Sounds/NoAmmo.ogg");
		}

		if (diff > 0)
		{
			this.set_bool("shield ready", true);
			this.getSprite().PlaySound("/Cooldown1.ogg"); 
		}
	}
	RunnerMoveVars@ moveVars;
    if (this.get("moveVars", @moveVars))
    {
       moveVars.walkSpeed = 2.1f;
	   moveVars.walkSpeedInAir = 2.1f;
    }
}

void Shield(CBlob@ this)	
{	
	this.set_u32("shield", 5*30);
	this.Sync("shield", true);
	CMap@ map = getMap();
	CBlob@[] blobs;
	map.getBlobsInRadius(this.getPosition(), 64.0f, @blobs);
	for(int i = 0; i < blobs.length; i++)
	{
		ParticleAnimated( "LargeSmoke.png", this.getPosition(), Vec2f(0,0), 0.0f, 1.0f, 1.5, -0.1f, false );
		Vec2f vel = this.getVelocity();
		CBlob@ b = blobs[i];
		if (b.getPlayer() !is null && b.getTeamNum() != this.getTeamNum())
		{
			return;
			//b.addForce(Vec2f(vel.x * 100.0f, 100.0f));
		}
	}
}