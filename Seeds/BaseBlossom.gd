class_name Blossom extends Sprite2D

signal on_blossom_ready

@export_range(0, 10, .5) var sec_until_full_growth:float = .5
@export_range(0, 10, .5) var sec_until_full_wilt:float = .5
@export var growth_transition: Tween.TransitionType = Tween.TransitionType.TRANS_SINE
@export var growth_ease: Tween.EaseType = Tween.EaseType.EASE_OUT
@export var wilt_transition: Tween.TransitionType = Tween.TransitionType.TRANS_SINE
@export var wilt_ease: Tween.EaseType = Tween.EaseType.EASE_IN

@export var start_color: Color
@export var bloom_colour: Color
@export var end_colour: Color


var t: float
var tw: Tween
var shader: ShaderMaterial

func _ready() -> void:
	owner.on_bloom.connect(handle_parent_bloom)
	owner.on_wilt.connect(handle_parent_wilt)
	shader = material as ShaderMaterial
	self_modulate = Color(0,0,0,0)

func handle_parent_bloom() -> void:
	tw = create_tween()
	tw.tween_property(self, "self_modulate", bloom_colour, sec_until_full_growth) \
		.from(start_color)
	tw.tween_property(self, "t", 1.0, sec_until_full_growth) \
		.from(0.0)
	tw.tween_callback(func(): on_blossom_ready.emit())

func handle_parent_wilt() -> void:
	tw = create_tween() \
		.set_ease(wilt_ease) \
		.set_trans(wilt_transition)
	tw.tween_property(self, "t", 0.0, sec_until_full_wilt) \
		.from(1.0)
	tw.parallel() \
		.tween_property(self, "self_modulate", end_colour, sec_until_full_wilt) \
		.from(bloom_colour)


func _process(_delta: float) -> void:
	shader.set_shader_parameter("rad_cutoff", t);
