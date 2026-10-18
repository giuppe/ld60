package kumber.oldtech;

import haxe.Exception;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;



class PlayState extends FlxState
{
	var world:World;
	var player:Player;
	var platforms:FlxSpriteGroup;
	var doors:FlxSpriteGroup;
	var gears:FlxSpriteGroup;

	override public function create():Void
	{
		super.create();
		trace("hello");
		var text = new FlxText("Hello");
		add(text);
		text.setFormat(R.FONT_NAME, 30);
		world = new World();
		player = new Player(0,0);
		loadLevel(world.all_levels.Level_0, FlxPoint.get(
			world.all_levels.Level_0.l_Entities.all_Player[0].pixelX,
			world.all_levels.Level_0.l_Entities.all_Player[0].pixelY
			));
	}

	public function loadLevel(level:World_Level, playerPos:FlxPoint)
	{
		trace(level.pxWid);
		
		var group = new FlxSpriteGroup();
		//group.x = level.worldX;
		//group.y = level.worldY;
		add(group);
		level.l_Tiles.render2(group, IlluminableSprite);
		platforms = new FlxSpriteGroup();
		//platforms.x = level.worldX;
		//platforms.y = level.worldY;
		add(platforms);
		level.l_Platforms.render2(platforms, IlluminableSprite);
		platforms.forEachExists((s)->{s.moves = false;s.immovable=true;});
		
		player.setPosition(playerPos.x, playerPos.y);
		
		R.currentLights.resize(0);
		for(i in 0...level.l_Entities.all_Torch.length)
		{
			var torch = new Torch(level.l_Entities.all_Torch[i].pixelX,
				level.l_Entities.all_Torch[i].pixelY);
			
			add(torch);
			R.currentLights.push(torch);
		}

		doors = new FlxSpriteGroup();
		for(i in 0...level.l_Entities.all_Door.length)
		{
			var door = new Door(level.l_Entities.all_Door[i].pixelX,
				level.l_Entities.all_Door[i].pixelY);
			door.levelRef = level.l_Entities.all_Door[i].f_targetLevelPoint.levelIid;
			door.entityRef = level.l_Entities.all_Door[i].f_targetLevelPoint.entityIid;
			doors.add(door);
			
		}
		add(doors);

		gears = new FlxSpriteGroup();
		if(!R.foundGears.contains(level.iid))
		{
			for(i in 0...level.l_Entities.all_Gear.length)
			{
				var gear = new Gear(level.l_Entities.all_Gear[i].pixelX,
					level.l_Entities.all_Gear[i].pixelY);
				gear.levelId = level.iid;
				//door.levelRef = level.l_Entities.all_Door[i].f_targetLevelPoint.levelIid;
				//door.entityRef = level.l_Entities.all_Door[i].f_targetLevelPoint.entityIid;
				gears.add(gear);
				
			}
		}
		add(gears);

		add(player);
		if(player.appendedGear != null)
			add(player.appendedGear);
	}

	public function addGearToPlayer(gear:FlxSprite):Bool
    {
        if(player.appendedGear != null)
            return false;
        var newGear = new IlluminableSprite(gear.x,gear.y);
        newGear.loadGraphicFromSprite(gear);
        player.appendedGear = newGear;
		this.add(player.appendedGear);
        return true;
    }

	override public function update(elapsed:Float):Void
	{
		trace(player.x, player.y);
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

		FlxG.overlap(player, doors, (p:FlxSprite, d:FlxSprite)->
		{
			//trace("player overlaps");
			var player:Null<Player> = Std.downcast(p, kumber.oldtech.Player);
			var door:Null<Door> = Std.downcast(d, kumber.oldtech.Door);
			if(player == null || door == null)
				return;

			if((door.isRight && player.velocity.x > 0) ||
				(!door.isRight &&  player.velocity.x < 0))
			{
				this.remove(player);
				this.remove(player.appendedGear);
				this.clear();
				platforms.clear();
				doors.clear();
				var level = null;
				for(l in world.levels)
				{
					if(l.iid == door.levelRef)
					{
						level = l;
					}
				}
				if(level == null)
				{
					throw new Exception("Unexpected level "+door.levelRef);
					return;
				}
				var targetPos = FlxPoint.get();
				for(targetDoor in level.l_Entities.all_Door)
				{
					if(targetDoor.iid == door.entityRef)
					{
						targetPos.set(targetDoor.pixelX, targetDoor.pixelY);
					}
				}
				
				loadLevel(level, targetPos);

			}
		} );

		FlxG.overlap(player, gears, (p:FlxSprite, d:FlxSprite)->
		{
			//trace("player overlaps");
			var player:Null<Player> = Std.downcast(p, kumber.oldtech.Player);
			var gear:Null<Gear> = Std.downcast(d, kumber.oldtech.Gear);
			if(player == null || gear == null)
				return;
			if(this.addGearToPlayer(gear))
			{
				R.foundGears.push(gear.levelId);
				gear.kill();
			}
			
			

		});

		super.update(elapsed);

	}


}

