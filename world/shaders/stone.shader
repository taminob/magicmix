shader_type spatial;
render_mode blend_mix;

uniform sampler2D noise;

void fragment()
{
	float noise_lod = 1.;
	ALBEDO = vec3(0.3) * textureLod(noise, UV, noise_lod).xyz;
	//ALPHA = 1.;
}