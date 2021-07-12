shader_type spatial;
render_mode blend_mix;

uniform vec3 base_color = vec3(0.3, 0.5, 0.1);
uniform sampler2D color_noise;
uniform float color_noise_lod = 0;
uniform float color_noise_scale = 5.;
uniform float grass_height = 0.9;
uniform float grass_amount = 1000.; // should be equal to subdivision of mesh

void vertex()
{
	VERTEX.y += cos(VERTEX.x * grass_amount) * sin(VERTEX.z * grass_amount) * grass_height;
}

void fragment()
{
	ALBEDO = base_color * textureLod(color_noise, UV * color_noise_scale, color_noise_lod).xyz;
	//ALPHA = 1.;
}
