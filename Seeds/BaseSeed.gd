class_name Seed extends Sprite2D

signal on_apply ()
signal on_tick ()
signal on_bloom ()
signal on_wither ()
signal on_remove ()

@export_range(0, 30, .5) var sec_until_full_growth:float = 3.0
@export_range(0, 120, .5) var sec_in_peak_condition:float = 3.0
@export_range(0, 30, .5) var sec_until_full_wither:float = 1.5
@export var growth_transition: Tween.TransitionType = Tween.TransitionType.TRANS_QUAD
@export var growth_ease: Tween.EaseType = Tween.EaseType.EASE_OUT
@export var wither_transition: Tween.TransitionType = Tween.TransitionType.TRANS_QUAD
@export var wither_ease: Tween.EaseType = Tween.EaseType.EASE_IN

@export var start_color: Color
@export var bloom_colour: Color
@export var wither_colour: Color
@export var end_colour: Color

var t: float
var tw: Tween
var shader: ShaderMaterial
var target: Node2D

func _ready() -> void:
	shader = material as ShaderMaterial
	self_modulate = Color(0,0,0,0)

func apply(health: Node2D) -> void:
	call_deferred("reparent", health)
	call_deferred("start_growth")
	target = health
	show()

func start_growth() -> void:
	global_position = target.global_position
	global_rotation = target.global_rotation
	tw = create_tween() \
		.set_ease(growth_ease) \
		.set_trans(growth_transition)
	tw.tween_property(self, "t", 1.0, sec_until_full_growth).from(0.0)
	tw.parallel() \
		.tween_property(self, "self_modulate", bloom_colour, sec_until_full_growth) \
		.from(start_color)
	tw.tween_callback(bloom)
	prints("Applying seed", name, "to", target.name)
	on_apply.emit()

func tick(_delta: float) -> void:
	on_tick.emit()

func bloom() -> void:
	tw.stop()
	tw = create_tween()
	tw.tween_interval(sec_in_peak_condition * .5)
	tw.tween_property(self, "self_modulate", wither_colour, sec_in_peak_condition * .5) \
		.from(bloom_colour)
	tw.tween_callback(wither)
	prints("Blooming seed", name)
	on_bloom.emit()

func wither() -> void:
	tw.stop()
	tw = create_tween() \
		.set_ease(wither_ease) \
		.set_trans(wither_transition)
	tw.tween_property(self, "t", 0.0, sec_until_full_wither) \
		.from(1.0)
	tw.parallel() \
		.tween_property(self, "self_modulate", end_colour, sec_until_full_wither) \
		.from(wither_colour)
	tw.tween_callback(remove)
	prints("Withering seed", name)
	on_wither.emit()

func remove() -> void:
	tw.stop()
	prints("Removing seed", name)
	on_remove.emit()
	call_deferred("queue_free")


func _process(_delta: float) -> void:
	shader.set_shader_parameter("y_cutoff", t);


class state:
	func enter(msg:Dictionary = {}):
		pass
	func exit():
		pass
	func tick(_delta: float):
		pass

class grow extends state:
	func enter(msg:Dictionary = {}):
		pass
	func exit():
		pass
	func tick(_delta: float):
		pass

class wilt extends state:
	func enter(msg:Dictionary = {}):
		pass
	func exit():
		pass
	func tick(_delta: float):
		pass
