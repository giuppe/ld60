package kumber.oldtech;

import flixel.FlxSprite;

class Gear extends IlluminableSprite
{
    public var levelId:String = "";
    
    public function new(x:Float, y:Float){
        super(x,y);
        loadGraphic("assets/gear.png");

    }

}