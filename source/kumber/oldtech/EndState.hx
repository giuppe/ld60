package kumber.oldtech;

import flixel.text.FlxText;
import flixel.graphics.atlas.FlxAtlas;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxSplash;
import flixel.FlxState;

class EndState extends FlxState
{
    var motherDuck:FlxSprite;
    var duckl1:FlxSprite;
    var duckl2:FlxSprite;
    var duckl3:FlxSprite;
    var player:FlxSprite;
    var flow1:FlxSprite;
    var flow2:FlxSprite;
    var flowSplash:FlxSprite;
    var heart:FlxSprite;
    var water:FlxSprite;
    var world:World;
    override public function create():Void
	{
		super.create();
        FlxG.camera.bgColor.setRGB(0,230,230);
        world = new World();
        var group = new FlxSpriteGroup();

		add(group);
		world.all_levels.Level_End.l_Tiles.render(group);

        add(motherDuck = new FlxSprite("assets/duck.png"));
        motherDuck.flipX = true;
        add(duckl1 = new FlxSprite("assets/duckling.png"));
        duckl1.flipX = true;
        add(duckl2 = new FlxSprite("assets/duckling.png"));
        duckl2.flipX = true;
        add(duckl3 = new FlxSprite("assets/duckling.png"));
        duckl3.flipX = true;

        add(player = new FlxSprite());
        player.loadGraphic("assets/player.png", true, 16,16);
        player.animation.add("walk", [0,1,2,3]);
        player.animation.add("idle", [0]);
        add(flow1 = new FlxSprite("assets/flow.png"));
        flow1.visible = false;
        add(flow2 = new FlxSprite("assets/flow.png"));
        flow2.visible = false;
        add(flowSplash = new FlxSprite("assets/splash.png"));
        flowSplash.visible = false;
        add(heart = new FlxSprite("assets/heart.png"));
        heart.visible = false;

        water = new FlxSprite();
        water.makeGraphic(16,16, FlxColor.fromString("#4252ff"));
        
        player.setPosition(-1,5*16);
        motherDuck.setPosition(5*16, 8*16);
        duckl1.setPosition(6*16, 8*16);
        duckl2.setPosition(6*16+8, 8*16);
        duckl3.setPosition(7*16, 8*16);
        heart.setPosition(5*16,4*16);
        flow1.setPosition(8*16, 6*16);
        flow2.setPosition(8*16, 7*16);
        flowSplash.setPosition(8*16, 8*16);
        
        FlxTween.num(0.0,1.0, 3.0, {onComplete: (_)->{
            motherDuck.flipX = false;
            }}).then(FlxTween.num(0.0,1.0, 1.0,{onComplete: (_)->{
                flow1.visible = true;
            }})).then(FlxTween.num(0.0,1.0, 0.1,{onComplete: (_)->{
                flow2.visible = true;
            }})).then(FlxTween.num(0.0,1.0, 0.1,{onComplete: (_)->{
                flowSplash.visible = true;
                player.animation.play("walk");
                FlxTween.linearMotion(player, player.x, player.y, 4*16, 5*16,3.0, {onComplete: (_)->{player.animation.play("idle");}});
            }})).then(FlxTween.num(0.0,1.0, 1.5,{onComplete: (_)->{
                //water.setPosition(motherDuck.x, motherDuck.y);
                add(new FlxSprite(motherDuck.x, motherDuck.y).loadGraphicFromSprite(water));
                add(new FlxSprite(motherDuck.x+16, motherDuck.y).loadGraphicFromSprite(water));
                add(new FlxSprite(motherDuck.x+32, motherDuck.y).loadGraphicFromSprite(water));
                add(new FlxSprite(motherDuck.x+48, motherDuck.y).loadGraphicFromSprite(water));
                motherDuck.y -= 14;
                duckl1.y -= 15;
                duckl2.y -= 15;
                duckl3.y -= 15;
                flowSplash.y -= 16;
                flow2.visible = false;
                
                
            }})).then(FlxTween.num(0.0,1.0, 1.5,{onComplete: (_)->{
                add(new FlxSprite(motherDuck.x, motherDuck.y).loadGraphicFromSprite(water));
                add(new FlxSprite(motherDuck.x+16, motherDuck.y).loadGraphicFromSprite(water));
                add(new FlxSprite(motherDuck.x+32, motherDuck.y).loadGraphicFromSprite(water));
                add(new FlxSprite(motherDuck.x+48, motherDuck.y).loadGraphicFromSprite(water));
                motherDuck.y -= 14;
                duckl1.y -= 14;
                duckl2.y -= 14;
                duckl3.y -= 14;
                flowSplash.y -= 16;
                flow1.visible = false;
            }})).then(FlxTween.num(0.0,1.0, 1.5,{onComplete: (_)->{
                add(new FlxSprite(motherDuck.x, motherDuck.y).loadGraphicFromSprite(water));
                add(new FlxSprite(motherDuck.x+16, motherDuck.y).loadGraphicFromSprite(water));
                add(new FlxSprite(motherDuck.x+32, motherDuck.y).loadGraphicFromSprite(water));
                add(new FlxSprite(motherDuck.x+48, motherDuck.y).loadGraphicFromSprite(water));
                motherDuck.y -= 14;
                duckl1.y -= 14;
                duckl2.y -= 14;
                duckl3.y -= 14;
                flowSplash.visible = false;
            }})).then(FlxTween.num(0.0,1.0, 0.8,{onComplete: (_)->{
                motherDuck.flipX = true;
            }})).then(FlxTween.num(0.0,1.0, 1.5,{onComplete: (_)->{
                heart.visible = true;
            }})).then(FlxTween.num(0.0,1.0, 3.0,{onComplete: (_)->{
                var text1 = new FlxText(20, 50);
                text1.text ="Thank you for playing!";
                var text2 = new FlxText(20, 20);
                text2.text ="Made by kumber for the";
                var text3 = new FlxText(20, 35);
                text3.text ="Ludum Dare 60 Jam";
                text1.setFormat(8,FlxColor.fromString("#51375c"));
                text2.setFormat(8,FlxColor.fromString("#51375c"));
                text3.setFormat(8,FlxColor.fromString("#51375c"));
                add(text1);
                add(text2);
                add(text3);

            }}));
        
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}