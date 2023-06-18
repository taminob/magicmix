shader_type spatial;
render_mode blend_sub;

const float PI = 3.1415926535;

uniform sampler2D noise;
uniform float noise_lod = 1.;
uniform float noise_scale = 1.;
uniform vec3 base_color = vec3(0.7, 1., 0.8);

void fragment()
{
	vec2 uv = UV * noise_scale;
	uv.y -= fract(TIME);
	vec3 noise_value = textureLod(noise, uv, noise_lod).xyz;
	ALBEDO = base_color * pow(noise_value, vec3(2.));
	ALPHA = 0.8;
}