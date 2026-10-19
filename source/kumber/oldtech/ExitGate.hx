package kumber.oldtech;

import flixel.tweens.FlxTween;
import flixel.tweens.motion.LinearPath;

class ExitGate extends IlluminableSprite
{
    public var isOpen(default, null) = false;
    public var opening = false;
    
    public function new(x:Float, y:Float,  open:Bool = false)
    {
        super(x,y);
        loadGraphic("assets/exitgate.png");
        if(open && !isOpen)
            openGate();
        if(open && isOpen)
            visible = false;
        
            
    }

    public function openGate()
    {
        opening = true;
        FlxTween.linearMotion(this, x, y, x, y-16, 5.0, {onComplete: (_)->{isOpen = true;opening = false; visible = false;}});
    }

    override public function update(elapsed:Float)
    {
        if(!isOpen && !opening && R.completedSockets.length>=R.socketsToFill)
        {
            openGate();
        }
    }
}