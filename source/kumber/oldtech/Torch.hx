package kumber.oldtech;

import flixel.FlxSprite;

class Torch extends FlxSprite
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        loadGraphic("assets/torch.png", true, 16,16);
		animation.add("flicker", [0,1],6.0);
		animation.play("flicker");
    }
}