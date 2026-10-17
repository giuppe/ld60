package kumber.oldtech;

import dn.phys.Velocity;
import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
    final DRAG = 1000;
    final GRAVITY = 980;
    final MAX_SPEED_X = 50;
    final MAX_SPEED_Y = 200;

    

    public function new(x:Float, y:Float)
    {
        super(x,y);
        loadGraphic("assets/player.png");
        moves = true;
        drag.x = DRAG;
        maxVelocity.set(MAX_SPEED_X, MAX_SPEED_Y);

        setSize(4, 14);
        offset.set(6,2);
        //updateHitbox();
    }

    override public function update(elapsed:Float)
    {
        acceleration.x = 0;
        
        acceleration.y = GRAVITY;
        if(FlxG.keys.anyPressed([LEFT,A]))
        {
            acceleration.x = -1000;
        }
        else if(FlxG.keys.anyPressed([RIGHT,D]))
        {
            acceleration.x = 1000;
        }

        if(FlxG.keys.anyJustPressed([UP,W,X]))
        {
            acceleration.y = -10000;
        }
        
        this.flipX = velocity.x<0;

        super.update(elapsed);
    }
}