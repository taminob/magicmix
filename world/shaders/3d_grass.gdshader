shader_type spatial;
render_mode blend_mix;

uniform vec3 base_color = vec3(0.3, 0.5, 0.1);
uniform sampler2D noise;
uniform float color_noise_lod = 0;
uniform float color_noise_scale = 5.;
uniform float grass_height = 0.9;
uniform float grass_amount = 1000.;

void vertex()
{
	vec4 c = textureLod(noise, UV * color_noise_scale, color_noise_lod);
	VERTEX.y += abs(cos(VERTEX.x * grass_amount * c.x) * sin(VERTEX.z * grass_amount * c.z)) * grass_height;
}

void fragment()
{
	vec2 wind =  vec2(cos(TIME) + 1., 0.) * 0.005;
	ALBEDO = base_color * textureLod(noise, UV * color_noise_scale + wind, color_noise_lod).xyz;
	//ALPHA = 1.;
}
