#include "Knocked.as";
#include "RunnerCommon.as"; //

const int HEAL_FREQUENCY = 60 * 30; // 45 secs

void onInit( CBlob@ this )
{
	this.set_u32("last heal", 0);
	this.set_bool("heal ready", true);
	this.set_u32("heal", 0);
}

void onTick(CBlob@ this) 
{	
	bool ready = this.get_bool("heal ready");
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
					this.set_u32("last heal", gametime);
					this.set_bool("heal ready", false);
					heal(this);
				}
			}
		}
	} else 
    {		
		u32 lastHeal = this.get_u32("last heal");
		int diff = gametime - (lastHeal + HEAL_FREQUENCY);
		
		if (controls.isKeyJustPressed(KEY_KEY_R) && this.isMyPlayer())
		{
			Sound::Play("Entities/Characters/Sounds/NoAmmo.ogg");
		}

		if (diff > 0)
		{
			this.set_bool("heal ready", true);
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

void heal(CBlob@ this)	
{	
	this.set_string("eat sound", "blobob.ogg");
	if (this !is null)
	{
		ParticleAnimated( "Heal.png", this.getPosition(), Vec2f(0,0), 0.0f, 1.0f, 1.5, -0.1f, false );
		this.server_SetHealth(3.0f);
		this.getSprite().PlaySound(this.get_string("eat sound"));
	}
}