package kumber.oldtech;

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

}