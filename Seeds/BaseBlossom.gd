extends Sprite2D

@export_range(0, 10, .5) var sec_until_full_growth:float = .25
@export_range(0, 10, .5) var sec_until_full_wither:float = .25
@export var growth_transition: Tween.TransitionType = Tween.TransitionType.TRANS_QUAD
@export var growth_ease: Tween.EaseType = Tween.EaseType.EASE_OUT
@export var wither_transition: Tween.TransitionType = Tween.TransitionType.TRANS_QUAD
@export var wither_ease: Tween.EaseType = Tween.EaseType.EASE_IN

@export var start_color: Color
@export var bloom_colour: Color
@export var end_colour: Color


var t: float
var tw: Tween
var shader: ShaderMaterial

func _ready() -> void:
	owner.on_bloom.connect(handle_parent_bloom)
	owner.on_wither.connect(handle_parent_wither)
	shader = material as ShaderMaterial
	self_modulate = Color(0,0,0,0)

func handle_parent_bloom() -> void:
	tw = create_tween()
	tw.tween_property(self, "self_modulate", bloom_colour, sec_until_full_growth) \
		.from(start_color)
	tw.tween_property(self, "t", 1.0, sec_until_full_growth) \
		.from(0.0)

func handle_parent_wither() -> void:
	tw = create_tween() \
		.set_ease(wither_ease) \
		.set_trans(wither_transition)
	tw.tween_property(self, "t", 0.0, sec_until_full_wither) \
		.from(1.0)
	tw.parallel() \
		.tween_property(self, "self_modulate", end_colour, sec_until_full_wither) \
		.from(bloom_colour)


func _process(_delta: float) -> void:
	shader.set_shader_parameter("rad_cutoff", t);
