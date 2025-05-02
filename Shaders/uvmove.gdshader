shader_type spatial;

uniform sampler2D albedo_texture;
uniform vec2 uv_offset = vec2(1.0);

void fragment() {
	vec2 uv = UV + uv_offset;
	ALBEDO = texture(albedo_texture, uv).rgb;
}
