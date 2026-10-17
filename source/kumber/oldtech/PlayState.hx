package kumber.oldtech;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;



class PlayState extends FlxState
{
	var level:World_Level;
	var player:Player;
	var platforms:FlxSpriteGroup;

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
		platforms = new FlxSpriteGroup();
		platforms.x = level.worldX;
		platforms.y = level.worldY;
		add(platforms);
		level.l_Platforms.render(platforms);
		platforms.forEachExists((s)->{s.moves = false;s.immovable=true;});
		
		player = new Player(world.all_levels.Level_0.l_Entities.all_Player[0].pixelX,
			world.all_levels.Level_0.l_Entities.all_Player[0].pixelY);
		add(player);
		
		var torch = new Torch(world.all_levels.Level_0.l_Entities.all_Torch[0].pixelX,
			world.all_levels.Level_0.l_Entities.all_Torch[0].pixelY);
		
		add(torch);
		

	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(player, platforms);

		super.update(elapsed);

	}


}

