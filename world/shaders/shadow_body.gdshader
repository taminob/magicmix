shader_type spatial;
render_mode blend_sub;

void vertex()
{
	COLOR = vec4(vec3(abs(VERTEX.x) + abs(VERTEX.z) + abs(1. - VERTEX.y)) * 0.3, 1.);
}

void fragment()
{
	EMISSION = vec3(10.);
	ALBEDO = vec3(COLOR.x * 10., 0., 0.);
}