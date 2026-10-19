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
        loadGraphic("assets/rock.png");
        if(broken)
            breakRock();
        
            
    }

    public function breakRock()
    {
        makeGraphic(16,1,FlxColor.fromString("#51375c"));
        //y=y+15;
        isBroken = true;
        R.brokenRocks.push(iid);
    }
}