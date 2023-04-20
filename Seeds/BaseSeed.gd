class_name Seed extends Sprite2D

signal on_apply (duration: float)
signal on_tick ()
signal on_bloom ()
signal on_wilt ()

@export_range(0, 30, .5) var growth_duration:float = 16
@export_range(0, 120, .5) var bloom_duration:float = 4
@export_range(0, 30, .5) var wilt_duration:float = 12
@export_range(0, 50, 5) var bloom_value:int = 50
@export_range(0,  50, 5) var late_value:int = 20

var t: float
var tw: Tween
var shader: ShaderMaterial
var target: Node2D

var growth_state: PlantState.Grow
var bloom_state: PlantState.Bloom
var wilt_state: PlantState.Wilt
var current_state: PlantState
var state_pre_harvest: PlantState

var times_watered: float

var harvest_global_position: Vector2
var is_harvested: bool

func _ready() -> void:
	shader = material as ShaderMaterial

	# define states
	growth_state = PlantState.Grow.new()
	bloom_state = PlantState.Bloom.new()
	wilt_state = PlantState.Wilt.new()

	growth_state.init(self, growth_duration)
	bloom_state.init(self, bloom_duration)
	wilt_state.init(self, wilt_duration)

func apply(health: Node2D) -> void:
	call_deferred("reparent", health)
	call_deferred("start_growth")
	target = health
	show()

func start_growth() -> void:
	global_position = target.global_position
	global_rotation = target.global_rotation
	set_state(growth_state)
	show()
	on_apply.emit(growth_duration)

func set_state(to_state: PlantState) -> void:
	if current_state:
		current_state.exit()
	current_state = to_state
	current_state.enter()

func tick(_delta: float) -> void:
	if (not current_state) or is_harvested:
		return
	current_state.tick(_delta)
	on_tick.emit()

func remove() -> void:
	harvest_global_position = global_position
	state_pre_harvest = current_state
	is_harvested = true
	get_parent().remove_child(self)

func calculate_value() -> int:
	match state_pre_harvest:
		growth_state:
			return 0
		bloom_state:
			return bloom_value
		_:
			return late_value

func _process(_delta: float) -> void:
	shader.set_shader_parameter("y_cutoff", t);

func _on_water_detector_area_entered(_area: Area2D) -> void:
	times_watered += 1.0

