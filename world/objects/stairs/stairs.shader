shader_type spatial;
render_mode blend_mix;

void vertex()
{
	//COLOR = vec4(1.);
}

void fragment()
{
	ALBEDO = VERTEX;
	ALPHA = 1.;
}
