package kumber.oldtech;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Socket extends IlluminableSprite
{
    public var filled(default,null) = false;
    public var iid:String = "";
    public var rotated:Bool;

    public function new(x:Float, y:Float, filled:Bool, rotated:Bool)
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

        this.rotated = rotated;
        this.filled = filled;
        if(rotated)
        {
            this.angle = 45;
        }
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

    override public function update(elapsed:Float)
    {
        if(this.angularVelocity ==0 && R.completedSockets.length >= R.socketsToFill)
        {
            this.angularVelocity = rotated?-10:10;
            FlxG.sound.play("assets/sounds/gears.wav", 1, true);
        }

        super.update(elapsed);
    }

}