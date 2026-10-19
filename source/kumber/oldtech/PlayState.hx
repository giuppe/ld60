package kumber.oldtech;

import flixel.FlxObject;
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
	var sockets:FlxSpriteGroup;
	var rocks:FlxSpriteGroup;
	var torches:FlxSpriteGroup;
	var pickaxe:Null<Pickaxe> = null;
	var minitorch:Null<Minitorch> = null;
	var exit:Null<Exit> = null;
	//var exitGate:Null<ExitGate> = null;
	var levelTransition:Bool = false;

	override public function create():Void
	{
		super.create();
		//trace("hello");
		var text = new FlxText("Hello");
		//add(text);
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
		//trace(level.pxWid);
		levelTransition = true;
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
		torches = new FlxSpriteGroup();
		for(i in 0...level.l_Entities.all_Torch.length)
		{
			var torch = new Torch(level.l_Entities.all_Torch[i].pixelX,
				level.l_Entities.all_Torch[i].pixelY);
			if(level.l_Entities.all_Torch[i].f_isLed)
			{
				if(R.completedSockets.length>=R.socketsToFill)
					torch.setAsLedGreen();
				else
					torch.setAsLedRed();
			}
			torches.add(torch);
			
			R.currentLights.push(torch);
		}
		this.add(torches);
		updateLevelLed();

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

				gears.add(gear);
				
			}
		}
		add(gears);

		sockets = new FlxSpriteGroup();
		
		for(i in 0...level.l_Entities.all_Socket.length)
		{
			var filled = R.completedSockets.contains(level.l_Entities.all_Socket[i].iid);
			var socket = new Socket(level.l_Entities.all_Socket[i].pixelX,
				level.l_Entities.all_Socket[i].pixelY, filled);
			socket.iid = level.l_Entities.all_Socket[i].iid;
			sockets.add(socket);
			
		}
		
		add(sockets);



		rocks = new FlxSpriteGroup();
		
		for(i in 0...level.l_Entities.all_Rock.length)
		{
			var broken = R.brokenRocks.contains(level.l_Entities.all_Rock[i].iid)||level.l_Entities.all_Rock[i].f_broken;
			var rock = new Rock(level.l_Entities.all_Rock[i].pixelX,
				level.l_Entities.all_Rock[i].pixelY, 
				level.l_Entities.all_Rock[i].iid,
				broken);
			rock.immovable = true;
			rock.moves = false;
			rocks.add(rock);

			
		}
		
		add(rocks);

		

		if(!player.hasPickaxe)
		{
			for(i in 0...level.l_Entities.all_Pickaxe.length)
			{
				add(pickaxe = new Pickaxe(level.l_Entities.all_Pickaxe[i].pixelX, level.l_Entities.all_Pickaxe[i].pixelY));
			}
		}

		if(player.intensity==0)
		{
			for(i in 0...level.l_Entities.all_Minitorch.length)
			{
				add(minitorch = new Minitorch(level.l_Entities.all_Minitorch[i].pixelX, level.l_Entities.all_Minitorch[i].pixelY));
			}
		}

		for(i in 0...level.l_Entities.all_Exit.length)
		{
			add(exit = new Exit(level.l_Entities.all_Exit[i].pixelX, level.l_Entities.all_Exit[i].pixelY));
		}

		add(player);
		if(player.appendedGear != null)
			add(player.appendedGear);
		R.currentLights.push(player);
	}

	public function updateLevelLed()
	{
		for(t in this.torches)
		{
			var torch = Std.downcast(t, kumber.oldtech.Torch);
			if(torch != null && torch.isLed)
			{
				if(R.completedSockets.length>=R.socketsToFill)
					torch.setAsLedGreen();
				else
					torch.setAsLedRed();
			}
		}
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

	public function removeGearFromPlayer(socket:Socket):Void
	{
		if(player.appendedGear == null)
			return;
		this.remove(player.appendedGear);
		player.appendedGear.kill();
		player.appendedGear = null;
		socket.setFilled();
		updateLevelLed();
	}

	override public function update(elapsed:Float):Void
	{
		levelTransition = false;
		//trace(player.x, player.y);
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

		FlxG.overlap(player, rocks, (p:FlxSprite, r:FlxSprite)->
		{
			var player:Null<Player> = Std.downcast(p, kumber.oldtech.Player);
			var rock:Null<Rock> = Std.downcast(r, kumber.oldtech.Rock);
			if(player == null || rock == null)
				return;
			if(player.hasPickaxe)
				rock.breakRock();
			else 
				FlxObject.separate(player, rock);
			
		});

		FlxG.overlap(player, doors, (p:FlxSprite, d:FlxSprite)->
		{
			if(levelTransition)
				return;
			//trace("player overlaps");
			var player:Null<Player> = Std.downcast(p, kumber.oldtech.Player);
			var door:Null<Door> = Std.downcast(d, kumber.oldtech.Door);
			if(player == null || door == null)
				return;
			if(door.isRight && !player.pixelsOverlapPoint(FlxPoint.get(door.x+door.width, door.y+door.height/2)))
				return;

			if(!door.isRight && !player.pixelsOverlapPoint(FlxPoint.get(door.x, door.y+door.height/2)))
				return;

			if((door.isRight && player.velocity.x > 0) ||
				(!door.isRight &&  player.velocity.x < 0))
			{
				this.remove(player);
				if(player.appendedGear != null)
					this.remove(player.appendedGear);
				this.clear();
				platforms.clear();
				doors.clear();
				torches.clear();
				gears.clear();
				sockets.clear();
				pickaxe = null;
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
						var isRight = targetDoor.pixelX > 8;
						if(isRight)
							targetPos.set(targetDoor.pixelX+16-player.width, targetDoor.pixelY);
						else
							targetPos.set(targetDoor.pixelX, targetDoor.pixelY);
					}
				}
				
				loadLevel(level, targetPos);

			}
		} );

		FlxG.overlap(player, exit, (p:FlxSprite, d:FlxSprite)->
		{

			var player:Null<Player> = Std.downcast(p, kumber.oldtech.Player);
			var exit:Null<Exit> = Std.downcast(d, kumber.oldtech.Exit);
			if(player == null || exit == null)
				return;
			if(!player.pixelsOverlapPoint(FlxPoint.get(exit.x+exit.width, exit.y+exit.height/2)))
				return;



			if(player.velocity.x > 0)
			{
				FlxG.switchState(EndState.new);
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

		FlxG.overlap(player, sockets, (p:FlxSprite, d:FlxSprite)->
		{
			//trace("player overlaps");
			var player:Null<Player> = Std.downcast(p, kumber.oldtech.Player);
			var socket:Null<Socket> = Std.downcast(d, kumber.oldtech.Socket);
			if(player == null || socket == null)
				return;
			if(player.appendedGear != null && !socket.filled )
			{
				this.removeGearFromPlayer(socket);
			}
		});

		FlxG.overlap(player, pickaxe, (p:FlxSprite, d:FlxSprite)->
		{
			//trace("player overlaps");
			var player:Null<Player> = Std.downcast(p, kumber.oldtech.Player);
			var pickaxe:Null<Pickaxe> = Std.downcast(d, kumber.oldtech.Pickaxe);
			if(player == null || pickaxe == null)
				return;
			player.hasPickaxe = true;
			pickaxe.kill();
			pickaxe = null;
			
		});

		FlxG.overlap(player, minitorch, (p:FlxSprite, d:FlxSprite)->
		{
			//trace("player overlaps");
			var player:Null<Player> = Std.downcast(p, kumber.oldtech.Player);
			var minitorch:Null<Minitorch> = Std.downcast(d, kumber.oldtech.Minitorch);
			if(player == null || minitorch == null)
				return;
			
			minitorch.kill();
			minitorch = null;
			player.intensity +=0.1;
			
		});
		

		super.update(elapsed);

	}


}

