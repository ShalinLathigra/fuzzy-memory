shader_type canvas_item;

uniform float scaling: hint_range(0, 100, 1);

void fragment() {
	vec2 uv = UV * scaling;
	vec4 color = texture(TEXTURE, uv);
	uv = floor(uv);
	float t = float((int(uv.x) + int(uv.y)) % 2);
	COLOR = color.grra * t + color.rrba * (1.0-t);
}
