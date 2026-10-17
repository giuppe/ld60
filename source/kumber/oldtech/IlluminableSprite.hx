package kumber.oldtech;

import flixel.FlxSprite;

class IlluminableSprite extends FlxSprite
{
    var lightShader:LightShader = null;
    public function new(x:Float, y:Float)
    {
        super(x, y);
        

    }

    override public function graphicLoaded()
    {
        shader = lightShader = new LightShader(this);
        super.graphicLoaded();
    }

    override public function update(elapsed:Float)
    {
        if(lightShader != null)
        {
            lightShader.setPos(x, y);
            if(R.currentLights.length >0)
                lightShader.setLightPos(R.currentLights[0].x, R.currentLights[0].y);
        }
        else if(frame != null)
        {
            graphicLoaded();
        }
        super.update(elapsed);
        lightShader?.update(elapsed);
    }
}