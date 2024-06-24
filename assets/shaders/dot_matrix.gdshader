/*
	印刷物風ハーフトーンシェーダー by あるる（きのもと 結衣） @arlez80
	Halftone Shader by Yui Kinomoto

	MIT License
*/
shader_type canvas_item;

uniform float radius_c = 0.2;
uniform float radius_m = -0.3;
uniform float radius_y = 0.0;
uniform float radius_k = 0.785;

uniform float frequency = 400.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

mat2 rotate( float r )
{
	float c = cos( r );
	float s = sin( r );
	return mat2(
		vec2( c, s )
	,	vec2( -s, c )
	);
}

float f( float value, vec2 uv, float radius )
{
	return smoothstep( -1.0, 1.0, sqrt( value ) - length( 2.0 * fract( rotate( radius ) * ( frequency * uv ) ) - 1.0 ) );
}

void fragment( )
{
	vec3 color = texture( SCREEN_TEXTURE, SCREEN_UV ).rgb;
	vec4 cmyk = vec4( vec3( 1.0 ) - color, 1.0 - max( max( color.r, color.g ), color.b ) );
	cmyk.xyz -= cmyk.w;

	float k = f( cmyk.w, UV, radius_k );
	float c = f( cmyk.x, UV, radius_c );
	float m = f( cmyk.y, UV, radius_m );
	float y = f( cmyk.z, UV, radius_y );

	vec3 new_color = mix( vec3( 1.0 ) - 0.9 * vec3( c, m, y ), vec3( 0.0 ), 0.85 * k );

	COLOR = vec4( new_color, 1.0 );
}
