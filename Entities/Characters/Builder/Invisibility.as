#include "Knocked.as";

//f32 SOUND_DISTANCE = 256.0f;
const int INVISIBILITY_FREQUENCY = 60 * 30; //60 secs

void onInit( CBlob@ this )
{
	this.set_u32("last invisibility", 0 );
	this.set_bool("invisibility ready", true );
	this.set_u32("invisible", 0);
}

void onTick( CBlob@ this ) 
{	
	bool ready = this.get_bool("invisibility ready");
	const u32 gametime = getGameTime();
	CControls@ controls = getControls();
	
	if(ready) 
    {
		if (this !is null)
		{
			if (isClient() && this.isMyPlayer())
			{
				if (controls.isKeyJustPressed(KEY_KEY_R))
				{
					this.set_u32("last invisibility", gametime);
					this.set_bool("invisibility ready", false );
					Invisibility(this);
				}
			}
		}
	} else 
    {		
		u32 lastInvisibility = this.get_u32("last invisibility");
		int diff = gametime - (lastInvisibility + INVISIBILITY_FREQUENCY);
		
		if(controls.isKeyJustPressed(KEY_KEY_R) && this.isMyPlayer())
		{
			Sound::Play("Entities/Characters/Sounds/NoAmmo.ogg");
		}

		if (diff > 0)
		{
			this.set_bool("invisibility ready", true );
			this.getSprite().PlaySound("/Cooldown1.ogg"); 
		}
	}
}

void Invisibility( CBlob@ this) //check the anim and logic files too	
{	
	//turn ourselves invisible
	ParticleAnimated( "LargeSmoke.png", this.getPosition(), Vec2f(0,0), 0.0f, 1.0f, 1.5, -0.1f, false );
	this.set_u32("invisible", 10*30); //10 secs
	
    //sound
	//CBlob@[] nearBlobs;
	//this.getMap().getBlobsInRadius( this.getPosition(), SOUND_DISTANCE, @nearBlobs );
	//this.getSprite().PlaySound("", 3.0f);
	
}