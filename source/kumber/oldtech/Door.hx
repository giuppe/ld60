package kumber.oldtech;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

class Door extends FlxSprite
{
    public var levelRef:String = "";
    public var entityRef:String = "";
    public var isRight = false;

    public function new(x:Float, y:Float)
    {
        super(x,y);
        isRight = x > 8;
        makeGraphic(16, 16, FlxColor.MAGENTA);
    }


}