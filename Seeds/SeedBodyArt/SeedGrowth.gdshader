shader_type canvas_item;

uniform float y_cutoff: hint_range(0.0, 1.0, 0.05);

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float t_cutoff = step(1.0-y_cutoff, UV.y);
	float colour_mask = tex.r;
	COLOR = (modulate * colour_mask + vec4(0,0,0,modulate.a) * (1.0-colour_mask)) * t_cutoff;
}
