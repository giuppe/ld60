package kumber.oldtech;

class Pickaxe extends IlluminableSprite
{
    var floatingTime:Float=0.0;
    var origY:Float;
    public function new(x:Float, y:Float)
    {
        super(x,y);
        loadGraphic("assets/pickaxe.png");
        origY = y;

    }

    override public function update(elapsed:Float)
    {
        floatingTime+=elapsed;
        y= origY+1.0*Math.sin(floatingTime*2);
        super.update(elapsed);
    }

}