shader_type canvas_item;

uniform vec2 pixel_size = vec2(0.008, 0.008);

void fragment()
{
	vec3 col = texture(TEXTURE, UV).rgb;
	vec2 uv = UV;
	uv -= mod(uv, pixel_size);
	COLOR.rgb = texture(TEXTURE, uv).rgb;
}