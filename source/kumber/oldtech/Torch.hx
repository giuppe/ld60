package kumber.oldtech;

import flixel.util.FlxColor;
import flixel.FlxSprite;


class Torch extends IlluminableSprite
{
    public var lightColor:FlxColor = FlxColor.WHITE;
    public var intensity:Float = 1.0;
    public var isLed(default, null) = false;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        loadGraphic("assets/torch.png", true, 16,16);
		animation.add("flicker", [0,1],6.0);
		animation.play("flicker");
        animation.add("idle", [0]);
    }

    public function setAsLedRed()
    {
        loadGraphic("assets/led.png");
        animation.add("idle", [0]);
        animation.play("idle");
        intensity = 0.7;
        lightColor.setRGBFloat(1.0,0.3,0.3);
        isLed = true;
    }
    public function setAsLedGreen()
    {
        loadGraphic("assets/led.png");
        animation.add("idle", [0]);
        animation.play("idle");
        intensity = 0.8;
        lightColor.setRGBFloat(0.1,1.0,0.1);
        isLed = true;
    }
}