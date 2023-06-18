shader_type spatial;
render_mode unshaded;

uniform vec4 base_color: source_color;
uniform vec4 secondary_color: source_color;
uniform sampler2D base_texture: source_color;

void fragment()
{
	ALBEDO = mix(base_color.rgb, secondary_color.rgb, 0.4) * texture(base_texture, UV).rgb;
	ALPHA = base_color.a;
	METALLIC = 0.75;
	SPECULAR = 0.8;
}
