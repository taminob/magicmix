shader_type canvas_item;

uniform float intensity = 0.8;
uniform float radius = 1.;
uniform float threshold = 0.2;

vec3 get_bloom_color(sampler2D tex, vec2 uv, vec2 pos, vec2 tex_size)
{
	vec2 tex_size2 = tex_size * radius;
	vec2 uv2 = floor((uv + pos * tex_size2) / tex_size2) * tex_size2;
	uv2 += tex_size2 * 0.001;
	vec3 t00 = max(texture(tex, uv2 + vec2(0.0, 0.0)).rgb - threshold, 0.0);
	vec3 t01 = max(texture(tex, uv2 + vec2(0.0, tex_size2.y)).rgb - threshold, 0.0);
	vec3 t10 = max(texture(tex, uv2 + vec2(tex_size2.x, 0.0)).rgb - threshold, 0.0);
	vec3 t11 = max(texture(tex, uv2 + vec2(tex_size2.x, tex_size2.y)).rgb - threshold, 0.0);
	vec2 factor = fract(pos / tex_size2);

	vec3 m0x = mix(t00, t10, factor.x);
	vec3 m1x = mix(t01, t11, factor.x);

	return mix(m0x, m1x, factor.y);
}

void fragment()
{
	vec3 original_color = texture(TEXTURE, UV).rgb;
	vec3 bloom_color = vec3(0.);
	vec2 scale = vec2(radius) * TEXTURE_PIXEL_SIZE;

	const mat3 blur_kernel = mat3(vec3(1., 12., 72.), vec3(210., 150., 210.), vec3(72., 12., 1.));
	const float total_kernel_weight = 890.;

	bloom_color += get_bloom_color(TEXTURE, UV, vec2(-1., -1.), TEXTURE_PIXEL_SIZE) * blur_kernel[0][0];
	bloom_color += get_bloom_color(TEXTURE, UV, vec2(-1., +0.), TEXTURE_PIXEL_SIZE) * blur_kernel[0][1];
	bloom_color += get_bloom_color(TEXTURE, UV, vec2(-1., +1.), TEXTURE_PIXEL_SIZE) * blur_kernel[0][2];
	bloom_color += get_bloom_color(TEXTURE, UV, vec2(+0., -1.), TEXTURE_PIXEL_SIZE) * blur_kernel[1][0];
	bloom_color += get_bloom_color(TEXTURE, UV, vec2(+0., +0.), TEXTURE_PIXEL_SIZE) * blur_kernel[1][1];
	bloom_color += get_bloom_color(TEXTURE, UV, vec2(+0., +1.), TEXTURE_PIXEL_SIZE) * blur_kernel[1][2];
	bloom_color += get_bloom_color(TEXTURE, UV, vec2(+1., -1.), TEXTURE_PIXEL_SIZE) * blur_kernel[2][0];
	bloom_color += get_bloom_color(TEXTURE, UV, vec2(+1., +0.), TEXTURE_PIXEL_SIZE) * blur_kernel[2][1];
	bloom_color += get_bloom_color(TEXTURE, UV, vec2(+1., +1.), TEXTURE_PIXEL_SIZE) * blur_kernel[2][2];

	bloom_color /= total_kernel_weight;
	COLOR = vec4(original_color + bloom_color * intensity, COLOR.a);
}