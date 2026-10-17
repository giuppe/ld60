package kumber.oldtech;

import flixel.FlxSprite;
import flixel.graphics.tile.FlxGraphicsShader;

class LightShader extends FlxGraphicsShader
{

    @:glVertexSource("
        #pragma header

        uniform vec2 frame_pos;
        uniform vec2 frame_size;
        uniform vec2 flip;
        varying vec2 texel_uv;
        varying vec2 screenPos;
        varying vec2 flixel_SpriteCoord;
        varying vec2 flixel_SpriteSize;

        void main(void)
        {
            #pragma body

            vec3 ndc = gl_Position.xyz / gl_Position.w;
            screenPos = ndc.xy * 0.5 + 0.5;
            
            texel_uv = 1.0 / frame_size;
            vec2 frame_uv_min = frame_pos / openfl_TextureSize;
            vec2 frame_uv_size = frame_size / openfl_TextureSize;
            flixel_SpriteCoord = (openfl_TextureCoord - frame_uv_min) / frame_uv_size;
            flixel_SpriteCoord = mix(flixel_SpriteCoord, 1.0-flixel_SpriteCoord, flip);
            flixel_SpriteSize = frame_size;
        }
    ")

    @:glFragmentSource("
    #pragma header
	#line 2

    uniform float uTime;
    uniform vec2 uLightsPos0;
	uniform vec2 uLightsPos1;
	uniform vec2 uLightsPos2;
	uniform vec2 uLightsPos3;
    uniform float uLightsIntensity0;
	uniform float uLightsIntensity1;
	uniform float uLightsIntensity2;
	uniform float uLightsIntensity3;
	uniform vec2 uPos;
	uniform vec2 flip;
	varying vec2 screenPos;
	varying vec2 texel_uv;
	varying vec2 flixel_SpriteCoord;
	varying vec2 flixel_SpriteSize;

	void main()
	{
		vec2 uLightsPos[4] = {
			uLightsPos0,
			uLightsPos1,
			uLightsPos2,
			uLightsPos3
		};
		float uLightsIntensity[4] = {
			uLightsIntensity0,
			uLightsIntensity1,
			uLightsIntensity2,
			uLightsIntensity3
		};

		float total_light = 0.0;
		float total_rim = 0.0;
		float total_rim_int = 0.0;

		float ambient_per_light = 0.03;

		float ambient = 0.0;

		for (int i = 0; i < 4; i++) {
			ambient += ambient_per_light * step(0.01, uLightsIntensity[i]);
		}

		total_light = clamp(total_light + ambient, 0.0, 1.0);
		

		vec2 texture_size = vec2(textureSize(bitmap, 0));
		vec2 texel = 1.0 / texture_size;
		vec2 pixpos = uPos+ (flixel_SpriteCoord-vec2(0.5))*flixel_SpriteSize;
		

		vec3 light_color = normalize(vec3(1.0, 1.0, 1.0));
		// compute the edge normal
		float alphaL = texture(bitmap, openfl_TextureCoordv - vec2(texel.x, 0.0)).a;
		float alphaR = texture(bitmap, openfl_TextureCoordv + vec2(texel.x, 0.0)).a;
		float alphaU = texture(bitmap, openfl_TextureCoordv - vec2(0.0, texel.y)).a;
		float alphaD = texture(bitmap, openfl_TextureCoordv + vec2(0.0, texel.y)).a;
		if(flip.x > 0.5)
		{
			float temp = alphaL;
			alphaL = alphaR;
			alphaR = temp;
		}
		vec2 edge = vec2(alphaR - alphaL, alphaD - alphaU);

		vec2 normal = normalize(edge);
		
		

		for (int i = 0; i < 4; i++) {
			float dist = distance(pixpos, uLightsPos[i]);
			float light_intensity = 1.0 - smoothstep(0.0, 100.0, dist);
			light_intensity = clamp(light_intensity*uLightsIntensity[i],0.0,1.0);
			
			float flicker = 0.85 + 0.10 * sin(uTime * 12.0) + 0.05 * sin(uTime *  19.0);

			light_intensity *= flicker;

			float rim_intensity = 1.0 - smoothstep(0.0, 60.0, distance(pixpos, uLightsPos[i]));
			rim_intensity = clamp(rim_intensity*uLightsIntensity[i], 0.0,1.0 );

			vec2 to_light = normalize(pixpos - uLightsPos[i]);

			float rim = max(dot(normal, to_light), 0.0);
			rim *= rim_intensity;

			total_light += light_intensity;
			total_rim += rim;
			total_rim_int += rim_intensity;
		}
		total_light = clamp(total_light, 0.0, 1.0);
		total_rim = clamp(total_rim, 0.0,1.0);
		total_rim_int = clamp(total_rim_int, 0.0,1.0);

		

		vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
		color *= vec4(total_light*light_color, 1.0);
		vec4 final_light=vec4(total_rim_int*light_color+1.0, 1.0);
		color *= mix(final_light, final_light*2.5, total_rim);
		//color = vec4(total_rim_int, 0.0, 0.0,1.0);
		gl_FragColor = color;
	}
")
	public final sprite:FlxSprite;

    private var time:Float = 0;

	public function new(parent:FlxSprite)
	{
		super();
		
		sprite = parent;
        data.frame_size.value = [sprite.frameWidth, sprite.frameHeight];
		data.frame_pos.value = [sprite.frame.offset.x, sprite.frame.offset.y];
		data.uTime.value = [0.0];
	}

	public function update(elapsed:Float)
	{
		var doFlipX = sprite.flipX != sprite.frame.flipX;
		var doFlipY = sprite.flipY != sprite.frame.flipY;
		data.frame_pos.value = [sprite.frame.frame.x, sprite.frame.frame.y];
		data.flip.value = [doFlipX, doFlipY];
		time+=elapsed;
        data.uTime.value = [time];
	}

	public function updateLights(lights:Array<Torch>):Void
	{

		
		var currLights:Array<LightDescriptor> = [];
        
        
        for(i in 0...4)
        {
            if(i<lights.length)
            {
                currLights.push({x: lights[i].x, y: lights[i].y, value: 1.0 });
            }
            else
            {
                currLights.push({x:0.0,y:0.0, value:0.0});
            }
        }
		//trace(currLights);

        data.uLightsPos0.value = [currLights[0].x, currLights[0].y];
		data.uLightsPos1.value = [	currLights[1].x, currLights[1].y];
		data.uLightsPos2.value = [	currLights[2].x, currLights[2].y]; 
		data.uLightsPos3.value = [	currLights[3].x, currLights[3].y];
        data.uLightsIntensity0.value = [currLights[0].value];
		data.uLightsIntensity1.value = [currLights[1].value];
		data.uLightsIntensity2.value = [	currLights[2].value]; 
		data.uLightsIntensity3.value = [	currLights[3].value];
	}

	public function setPos(x:Float, y:Float):Void
	{
		data.uPos.value = [x, y];
	}

}

typedef LightDescriptor = {x:Float, y: Float, value:Float};