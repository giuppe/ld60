package kumber.oldtech;

import flixel.tweens.FlxTween;
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
		level.l_Tiles.render2(group, IlluminableSprite);
		platforms = new FlxSpriteGroup();
		platforms.x = level.worldX;
		platforms.y = level.worldY;
		add(platforms);
		level.l_Platforms.render2(platforms, IlluminableSprite);
		platforms.forEachExists((s)->{s.moves = false;s.immovable=true;});
		
		player = new Player(world.all_levels.Level_0.l_Entities.all_Player[0].pixelX,
			world.all_levels.Level_0.l_Entities.all_Player[0].pixelY);
		
		for(i in 0...world.all_levels.Level_0.l_Entities.all_Torch.length)
		{
			var torch = new Torch(world.all_levels.Level_0.l_Entities.all_Torch[i].pixelX,
				world.all_levels.Level_0.l_Entities.all_Torch[i].pixelY);
			
			add(torch);
			R.currentLights.push(torch);
		}
		add(player);
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(player, platforms, (p:FlxSprite, platform:FlxSprite)->
		{
			var player:Null<Player> = Std.downcast(p, kumber.oldtech.Player);
			if(player != null && player.isTouching(FLOOR) && player.timeJumping>0)
			{
				player.timeJumping = 0;
				player.velocity.y = 0;
				FlxTween.tween(player, {"scale.x":1.1, "scale.y":0.9}, 0.05, {type:ONESHOT }).then(
                FlxTween.tween(player, {"scale.x":1.0, "scale.y":1.0}, 0.05, {type:ONESHOT })
            );
			}
		});

		super.update(elapsed);

	}


}

