shader_type canvas_item;

void fragment()
{
	vec3 col = -8.0 * texture(TEXTURE, UV).xyz;
	col += texture(TEXTURE, UV + vec2(0.0, SCREEN_PIXEL_SIZE.y)).xyz;
	col += texture(TEXTURE, UV + vec2(0.0, -SCREEN_PIXEL_SIZE.y)).xyz;
	col += texture(TEXTURE, UV + vec2(SCREEN_PIXEL_SIZE.x, 0.0)).xyz;
	col += texture(TEXTURE, UV + vec2(-SCREEN_PIXEL_SIZE.x, 0.0)).xyz;
	col += texture(TEXTURE, UV + SCREEN_PIXEL_SIZE.xy).xyz;
	col += texture(TEXTURE, UV - SCREEN_PIXEL_SIZE.xy).xyz;
	col += texture(TEXTURE, UV + vec2(-SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y)).xyz;
	col += texture(TEXTURE, UV + vec2(SCREEN_PIXEL_SIZE.x, -SCREEN_PIXEL_SIZE.y)).xyz;
	COLOR.xyz = col;
}