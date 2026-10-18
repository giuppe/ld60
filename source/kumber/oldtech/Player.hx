package kumber.oldtech;

import flixel.tweens.FlxTween;
import dn.phys.Velocity;
import flixel.FlxG;
import flixel.FlxSprite;

class Player extends IlluminableSprite
{
    final DRAG = 1000;
    final GRAVITY = 580;
    final MAX_SPEED_X:Float = 50;
    final MAX_SPEED_Y:Float = 200;
    final FAST_FALL = 1.5;
    final MAX_JUMP_TIME = 0.160;
    final JUMP_TIME_PENALTY = -0.06;
    final JUMP_MAX_REMEMBER_TIME = 0.1;           
    
    public var appendedGear:Null<IlluminableSprite> = null;
    var jumpRememberTime = 0.0;

    public var timeJumping:Float = 0;
    var isJumping = false;

    var appendedTime:Float = 0;


    public function new(x:Float, y:Float)
    {
        super(x,y);
        loadGraphic("assets/player.png", true, 16,16);
        animation.add("walk", [0,1,2,3], 10);
        animation.add("idle", [0]);
        animation.add("jump", [1]);
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

        if(velocity.y>0)
        {
            acceleration.y = GRAVITY*FAST_FALL;
        }
        
        if(FlxG.keys.anyPressed([LEFT,A]))
        {
            acceleration.x = -2000;
        }
        else if(FlxG.keys.anyPressed([RIGHT,D]))
        {
            //trace("pressing right");
            acceleration.x = 2000;
        }
        

        if(FlxG.keys.anyJustPressed([UP,W,X])||jumpRememberTime>0)
        {
            if(isTouching(FLOOR))
            {
                acceleration.y = -2000;
                isJumping = true;
                timeJumping = 0;
                
                FlxTween.tween(this, {"scale.x":0.8, "scale.y":1.2}, 0.1, {type:ONESHOT }).then(
                    FlxTween.tween(this, {"scale.x":1.0, "scale.y":1.0}, 0.1, {type:ONESHOT })
                );
            }
            else if(jumpRememberTime == 0)
            {
                jumpRememberTime = JUMP_MAX_REMEMBER_TIME;
            }
            else
            {
                jumpRememberTime -= elapsed;
            }
        }

        var current_max_jump_time = MAX_JUMP_TIME;
        if(appendedGear!=null)
            current_max_jump_time += JUMP_TIME_PENALTY;

        if(FlxG.keys.anyPressed([UP,W,X]) && isJumping && timeJumping < current_max_jump_time)
        {
            velocity.y += -1200*elapsed;
            timeJumping += elapsed;
        }
        else
        {
            isJumping = false;
        }

        if(isTouching(FLOOR))
            jumpRememberTime = 0;

        
        if(velocity.x<0)
            this.flipX = true;
        if(velocity.x>0)
            this.flipX = false;

        if (velocity.x > 0 || velocity.x < 0)
		{
			animation.play("walk");
		}
		else if (velocity.x == 0)
		{
			animation.play("idle");
		}
		if (velocity.y < 0)
		{
			animation.play("jump");
		}

        if(appendedGear!=null)
        {
            appendedTime += elapsed;
            appendedGear.setPosition(flipX?x+width+10:x-appendedGear.width-10,(y-10)+3.0*Math.sin(appendedTime*2));
        }
        
        
        super.update(elapsed);
    }
}