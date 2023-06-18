shader_type spatial;
render_mode blend_mix;

uniform sampler2D noise;
uniform float noise_lod = 1.;
uniform float noise_scale = 1.;

void fragment()
{
	ALBEDO = vec3(0.4, 0.4, 0.5) * textureLod(noise, UV * noise_scale, noise_lod).xyz;
}