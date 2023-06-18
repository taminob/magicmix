shader_type spatial;
render_mode blend_mix;

const float TAU = 6.28318530718;

void vertex()
{
	COLOR = vec4((sin(TIME) + 1.) / 2., (sin(TIME + TAU * 1. / 3.) + 1.) / 2., (sin(TIME + TAU * 2. / 3.) + 1.) / 2., 0.);
}

void fragment()
{
	ALBEDO = COLOR.xyz;
}
