shader_type spatial;
render_mode blend_add;

uniform sampler2D noise;
uniform float noise_lod = 1.0;
uniform float noise_scale = 1.0;

void vertex()
{
	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0], CAMERA_MATRIX[1], CAMERA_MATRIX[2], WORLD_MATRIX[3]);
}

void fragment()
{
	ALBEDO = smoothstep(0.5, 0.9, textureLod(noise, UV * noise_scale, noise_lod).xyz);
}