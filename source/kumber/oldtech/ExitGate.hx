package kumber.oldtech;

import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.motion.LinearPath;

class ExitGate extends IlluminableSprite
{
    public var isOpen(default, null) = false;
    public var opening = false;
    var openingSound:Null<FlxSound> = null;
    
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
        openingSound = FlxG.sound.play("assets/sounds/opengate.wav", 1, true);
    }

    override public function kill()
    {
        if(openingSound != null)
            openingSound.stop();
        super.kill();
    }

    override public function update(elapsed:Float)
    {
        if(!isOpen && !opening && R.completedSockets.length>=R.socketsToFill)
        {
            openGate();
        }
    }
}