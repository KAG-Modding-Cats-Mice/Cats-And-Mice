// Lever.as

#include "MechanismsCommon.as";
#include "GenericButtonCommon.as";
#include "dig.as";

class Lever : Component
{
	Lever(Vec2f position)
	{
		x = position.x;
		y = position.y;
	}
};

u32 timer; // container
int main = XORRandom(4) + 71; // random num
int coinFlip = XORRandom(2); // 0 - stone, 1 - gold

void onTick(CBlob@ this) // runs body every tick
{
    if (isClient() && this.get_u8("state") == 1)
    {
	timer++;
	if (main - timer == 60 && coinFlip == 0)
	{
		this.getSprite().PlaySound(digStoneGold[XORRandom(3)].filename, 3.0f);
	}
	else if (main - timer == 48 && coinFlip == 0)
	{
		this.getSprite().PlaySound(digStoneGold[XORRandom(3)].filename, 3.0f);
	}
	else if (main - timer == 36 && coinFlip == 0)
	{
		this.getSprite().PlaySound(digStoneGold[XORRandom(3)].filename, 3.0f);
	}
	else if (main - timer == 24 && coinFlip == 0)
	{
		this.getSprite().PlaySound(digStoneGold[XORRandom(3)].filename, 3.0f);
	}
	else if (main - timer == 12 && coinFlip == 0)
	{
		this.getSprite().PlaySound(digStoneGold[XORRandom(3)].filename, 3.0f);
	}
	else if (main - timer == 0 && coinFlip == 0)
	{
		this.getSprite().PlaySound(digStoneGold[3].filename, 3.0f);
		timer = 0;
		main = XORRandom(4) + 71;
		coinFlip = XORRandom(2);
	}
	else if (main - timer == 48 && coinFlip == 1)
	{
		this.getSprite().PlaySound(digStoneGold[XORRandom(3)].filename, 3.0f);
	}
	else if (main - timer == 36 && coinFlip == 1)
	{
		this.getSprite().PlaySound(digStoneGold[XORRandom(3)].filename, 3.0f);
	}
	else if (main - timer == 24 && coinFlip == 1)
	{
		this.getSprite().PlaySound(digStoneGold[XORRandom(3)].filename, 3.0f);
	}
	else if (main - timer == 12 && coinFlip == 1)
	{
		this.getSprite().PlaySound(digStoneGold[XORRandom(3)].filename, 3.0f);
	}
	else if (main - timer == 0 && coinFlip == 1)
	{
		this.getSprite().PlaySound(digStoneGold[4].filename, 3.0f);
		timer = 0;
		main = XORRandom(4) + 71;
		coinFlip = XORRandom(2);
	}
}
}
void onInit(CBlob@ this)
{
	// used by BuilderHittable.as
	this.Tag("builder always hit");

	// used by BlobPlacement.as
	this.Tag("place norotate");

	// used by TileBackground.as
	this.set_TileType("background tile", CMap::tile_wood_back);

	// background, let water overlap
	this.getShape().getConsts().waterPasses = true;

	this.addCommandID("toggle");

	AddIconToken("$lever_0$", "Lever.png", Vec2f(16, 16), 4);
	AddIconToken("$lever_1$", "Lever.png", Vec2f(16, 16), 5);
}

void onSetStatic(CBlob@ this, const bool isStatic)
{
	if (!isStatic || this.exists("component")) return;

	const Vec2f position = this.getPosition() / 8;

	Lever component(position);
	this.set("component", component);

	this.set_u8("state", 0);

	if (getNet().isServer())
	{
		MapPowerGrid@ grid;
		if (!getRules().get("power grid", @grid)) return;

		grid.setAll(
		component.x,                        // x
		component.y,                        // y
		TOPO_NONE,                          // input topology
		TOPO_CARDINAL,                      // output topology
		INFO_SOURCE,                        // information
		0,                                  // power
		0);                                 // id
	}

	CSprite@ sprite = this.getSprite();
	if (sprite is null) return;

	sprite.SetFacingLeft(false);
	sprite.SetZ(-50);

	CSpriteLayer@ layer = sprite.addSpriteLayer("background", "Lever.png", 8, 8);
	layer.addAnimation("default", 0, false);
	layer.animation.AddFrame(2);
	layer.SetRelativeZ(-1);
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (!canSeeButtons(this, caller)) return;

	if (!this.isOverlapping(caller) || !this.getShape().isStatic()) return;

	u8 state = this.get_u8("state");
	string description = (state > 0)? "Deactivate" : "Activate";

	CButton@ button = caller.CreateGenericButton(
	"$lever_"+state+"$",                        // icon token
	Vec2f_zero,                                 // button offset
	this,                                       // button attachment
	this.getCommandID("toggle"),                // command id
	description);                               // description

	button.radius = 8.0f;
	button.enableRadius = 20.0f;
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("toggle"))
	{
		if (getNet().isServer())
		{
			Component@ component = null;
			if (!this.get("component", @component)) return;

			MapPowerGrid@ grid;
			if (!getRules().get("power grid", @grid)) return;

			u8 state = this.get_u8("state") == 0? 1 : 0;
			u8 info = state == 0? INFO_SOURCE : INFO_SOURCE | INFO_ACTIVE;

			this.set_u8("state", state);
			this.Sync("state", true);

			grid.setInfo(
			component.x,                        // x
			component.y,                        // y
			info);                              // information
		}

		CSprite@ sprite = this.getSprite();
		if (sprite is null) return;

		sprite.SetFrameIndex(this.get_u8("state"));
		sprite.PlaySound("dig_stone1");
	}
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return false;
}