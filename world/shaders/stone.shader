shader_type spatial;
render_mode blend_mix;

uniform sampler2D noise;
uniform float noise_lod = 1.;
uniform vec3 base_color = vec3(0.3);

void fragment()
{
	ALBEDO = base_color * textureLod(noise, UV, noise_lod).xyz;
	//ALPHA = 1.;
}