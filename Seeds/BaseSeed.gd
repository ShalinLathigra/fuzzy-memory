class_name Seed extends Sprite2D

signal on_apply ()
signal on_tick ()
signal on_bloom ()
signal on_wither ()
signal on_remove ()

@export_range(0, 30, .5) var sec_until_full_growth:float = 3.0
@export_range(0, 120, .5) var sec_in_peak_condition:float = 3.0
@export_range(0, 30, .5) var sec_until_full_wither:float = 1.5
#@export var growth_transition: Tween.TransitionType = Tween.TransitionType.TRANS_QUAD
#@export var growth_ease: Tween.EaseType = Tween.EaseType.EASE_OUT
#@export var wither_transition: Tween.TransitionType = Tween.TransitionType.TRANS_QUAD
#@export var wither_ease: Tween.EaseType = Tween.EaseType.EASE_IN
#
#@export var start_color: Color
#@export var bloom_colour: Color
#@export var wither_colour: Color
#@export var end_colour: Color

var t: float
var tw: Tween
var shader: ShaderMaterial
var target: Node2D

var growth_state: grow
var bloom_state: bloom
var wilt_state: wilt
var current_state: plant_state

var times_watered: float

func _ready() -> void:
	shader = material as ShaderMaterial

	growth_state = grow.new()
	bloom_state = bloom.new()
	wilt_state = wilt.new()
	growth_state.target = self
	growth_state.next_state = bloom_state
	growth_state.duration = sec_until_full_growth
	bloom_state.target = self
	bloom_state.duration = sec_in_peak_condition
	bloom_state.next_state = wilt_state
	wilt_state.target = self
	wilt_state.duration = sec_until_full_wither

func apply(health: Node2D) -> void:
	call_deferred("reparent", health)
	call_deferred("start_growth")
	target = health
	show()

func start_growth() -> void:
	global_position = target.global_position
	global_rotation = target.global_rotation
	prints("Applying seed", name, "to", target.name)
	set_state(growth_state)
	show()
	on_apply.emit()

func set_state(to_state: plant_state) -> void:
	if current_state:
		current_state.exit()
	current_state = to_state
	current_state.enter()

func tick(_delta: float) -> void:
	if not current_state:
		return
	current_state.tick(_delta)
	on_tick.emit()

func remove() -> void:
	prints("Removing seed", name)
	on_remove.emit()
	call_deferred("queue_free")

func _process(_delta: float) -> void:
	shader.set_shader_parameter("y_cutoff", t);

func _on_water_detector_area_entered(area: Area2D) -> void:
	times_watered += 1.0

class plant_state:
	var target: Seed
	var next_state: plant_state
	var duration: float
	func enter():
		pass
	func exit():
		pass
	func tick(_delta: float):
		pass

class grow extends plant_state:
	var t: float
	var base_growth_pace: float = 0.0
	var water_growth_mod: float = 2.0
	var water_inst_jump: float = 1.0
	func enter():
		target.t = 0.0
		target.on_apply.emit()
		target.times_watered = 0.0
	func tick(delta: float):
		var growth_rate = base_growth_pace + water_growth_mod * target.times_watered
		t = minf(t + delta * (growth_rate), duration)
		target.t = min((t + target.times_watered * water_inst_jump) / duration, 1.0)
		if target.t >= 1.0:
			target.set_state(target.bloom_state)
	func exit():
		target.current_state = next_state

class bloom extends plant_state:
	var t: float
	func enter():
		t = 0.0
		target.on_bloom.emit()
		target.times_watered = 0.0
	func tick(delta: float):
		t = minf(t + delta, duration)
		if t >= duration:
			target.set_state(target.wilt_state)
	func exit():
		pass

class wilt extends plant_state:
	var t: float
	func enter():
		target.t = 1.0
		target.on_wither.emit()
		target.times_watered = 0.0
	func tick(delta: float):
		t = minf(t + delta, duration)
		target.t = 1.0 - t / duration
		if target.t == 0.0:
			target.remove()
