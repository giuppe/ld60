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
        var debugColor= #if debug FlxColor.MAGENTA #else FlxColor.TRANSPARENT #end;
        makeGraphic(16, 16, debugColor);
    }


}