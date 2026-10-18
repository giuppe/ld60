package kumber.oldtech;

import flixel.util.FlxColor;

class Rock extends IlluminableSprite
{
    public var isBroken(default, null) = false;
    public var iid(default,null):String = "";
    public function new(x:Float, y:Float, iid:String, broken:Bool = false)
    {
        super(x,y);
        this.iid = iid;
        makeGraphic(16,16,FlxColor.ORANGE);
        if(broken)
            breakRock();
        
            
    }

    public function breakRock()
    {
        makeGraphic(16,16,FlxColor.GRAY);
        isBroken = true;
        R.brokenRocks.push(iid);
    }
}