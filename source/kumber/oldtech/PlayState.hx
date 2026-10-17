package kumber.oldtech;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;



class PlayState extends FlxState
{
	var level:World_Level;

	override public function create():Void
	{
		super.create();
		trace("hello");
		var text = new FlxText("Hello");
		add(text);
		text.setFormat(R.FONT_NAME, 30);
		var world = new World();
		level = world.all_levels.Level_0;
		trace(level.pxWid);
		trace(world.all_levels.Level_0.l_Entities.all_Player[0].json);
		var group = new FlxSpriteGroup();
		group.x = level.worldX;
		group.y = level.worldY;
		add(group);

		level.l_Tiles.render(group);
		var player = new FlxSprite(world.all_levels.Level_0.l_Entities.all_Player[0].pixelX,
			world.all_levels.Level_0.l_Entities.all_Player[0].pixelY,
			"assets/player.png");
		add(player);
		var torch = new FlxSprite(world.all_levels.Level_0.l_Entities.all_Torch[0].pixelX,
			world.all_levels.Level_0.l_Entities.all_Torch[0].pixelY);
		torch.loadGraphic("assets/torch.png", true, 16,16);
		torch.animation.add("flicker", [0,1],6.0);
		torch.animation.play("flicker");
		add(torch);
		

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

	}


}

