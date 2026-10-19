package kumber.oldtech;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Exit extends FlxSprite
{
    public function new(x:Float, y:Float)
    {
        super(x,y);
        var debugColor= #if debug FlxColor.GREEN #else FlxColor.TRANSPARENT #end;
        makeGraphic(16, 16, debugColor);
    }
}