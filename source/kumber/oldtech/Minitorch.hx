package kumber.oldtech;

import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;

class Minitorch extends IlluminableSprite
{
    var floatingTime:Float=0.0;
    var origY:Float;
    public function new(x:Float, y:Float)
    {
        super(x,y);
        loadGraphic("assets/torch.png",true,16,16);
        
        scale.set(0.5,0.5);
        updateHitbox();
        setPosition(x+6,y+6);
        origY = y;

    }

    override public function update(elapsed:Float)
    {
        floatingTime+=elapsed;
        y= origY+1.0*Math.sin(floatingTime*2);
        super.update(elapsed);
    }

    public function createParticles():FlxEmitter {
        var emitter = new FlxEmitter(x, y, 30);
        emitter.makeParticles(1, 1, FlxColor.RED, 30);

        emitter.width = 8;
        emitter.height = 8;
        emitter.launchMode = FlxEmitterMode.SQUARE;
        emitter.velocity.set(-5, -8, 5, 8);
        emitter.lifespan.set(1.5, 3.0);
        emitter.alpha.set(0.2, 0.8);
        emitter.start(false, 0.15);
        
        return emitter;
    }

}