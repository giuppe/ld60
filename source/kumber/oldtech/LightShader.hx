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
	uniform vec2 uLightPos;
	uniform vec2 uPos;
	uniform vec2 flip;
	varying vec2 screenPos;
	varying vec2 texel_uv;
	varying vec2 flixel_SpriteCoord;
	varying vec2 flixel_SpriteSize;

	void main()
	{
		vec2 texture_size = vec2(textureSize(bitmap, 0));
		vec2 texel = 1.0 / texture_size;
		vec2 pixpos = uPos+ (flixel_SpriteCoord-vec2(0.5))*flixel_SpriteSize;
		float dist= distance(pixpos, uLightPos);
		float light_intensity = 1.0 - smoothstep(0.0, 100.0, dist);
        float rim_intensity = 1.0 - smoothstep(0.0, 60.0, dist);
        float flicker = 0.85 + 0.10 * sin(uTime * 12.0) + 0.05 * sin(uTime *  19.0);

        light_intensity *= flicker;

		vec3 light_color = normalize(vec3(1.0, 1.0, 1.0));

		//vec2 texel = 1.0 / vec2(textureSize(sprite_texture, 0));

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
		vec2 to_light = normalize(pixpos - uLightPos);

		float rim = max(dot(normal, to_light), 0.0);
		rim *= rim_intensity;

		vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
		color *= vec4(light_intensity*light_color+0.5, 1.0);
		vec4 final_light=vec4(rim_intensity*light_color+0.5, 1.0);
		color *= mix(final_light, final_light*2.5, rim);
		//color = vec4(rim, 0.0, 0.0,1.0);
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

	public function setLightPos(x:Float, y:Float):Void
	{
		data.uLightPos.value = [x, y];
	}

	public function setPos(x:Float, y:Float):Void
	{
		data.uPos.value = [x, y];
	}

}