shader_type spatial;

uniform vec3 color = vec3(1., 0., 0.);
uniform float percentage = 0.5;
uniform float angle = 0.0;

void vertex()
{
	//float angle = cosh(dot(dir.xz, BINORMAL.xz) / length(BINORMAL.xz) * length(dir.xz));
	float old_x = VERTEX.x;
	VERTEX.x = 1.0-2.0*percentage;
	if(VERTEX.x < old_x)
		VERTEX.x = old_x;
	VERTEX = (inverse(WORLD_MATRIX) * mat4(vec4(cos(angle), 0.0, sin(angle), 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(-sin(angle), 0.0, cos(angle), 0.0),
			vec4(0.0, 0.0, 0.0, 1.0)) * WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
	//COLOR = vec4(1.0, 0.0, 0.0, 1.0);
}

void fragment()
{
	ALBEDO = color;
	if(percentage <= 0.0)
		ALPHA = 0.0;
}