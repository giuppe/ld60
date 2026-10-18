package kumber.oldtech;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Socket extends IlluminableSprite
{
    public var filled(default,null) = false;
    public var iid:String = "";

    public function new(x:Float, y:Float, filled:Bool)
    {
        super(x,y);
        var debugColor= #if debug FlxColor.CYAN #else FlxColor.TRANSPARENT #end;
        if(filled)
        {
            loadGraphicFromSprite(new Gear(x,y));
        }
        else
        {
            makeGraphic(2, 2, debugColor);
            setPosition(x+7,y+7);
        }

        
        this.filled = filled;
    }

    public function setFilled()
    {
        if(filled) return;
        loadGraphicFromSprite(new Gear(x,y));
        updateHitbox();
        setPosition(x-7,y-7);
        filled = true;
        R.completedSockets.push(iid);
    }


}