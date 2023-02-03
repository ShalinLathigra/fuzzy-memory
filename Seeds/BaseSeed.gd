class_name Seed extends Sprite2D

signal on_apply ()
signal on_tick ()
signal on_bloom ()
signal on_wither ()
signal on_remove ()

@export_range(0, 30, .5) var growth_duration:float = 3.0
@export_range(0, 120, .5) var bloom_duration:float = 3.0
@export_range(0, 30, .5) var wilt_duration:float = 1.5

var t: float
var tw: Tween
var shader: ShaderMaterial
var target: Node2D

var growth_state: PlantState.Grow
var bloom_state: PlantState.Bloom
var wilt_state: PlantState.Wilt
var current_state: PlantState

var times_watered: float

func _ready() -> void:
	shader = material as ShaderMaterial

	growth_state = PlantState.Grow.new()
	bloom_state = PlantState.Bloom.new()
	wilt_state = PlantState.Wilt.new()
	growth_state.target = self
	growth_state.next_state = bloom_state
	growth_state.max_duration = growth_duration
	bloom_state.target = self
	bloom_state.max_duration = bloom_duration
	bloom_state.next_state = wilt_state
	wilt_state.target = self
	wilt_state.max_duration = wilt_duration

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
	on_apply.emit()

func set_state(to_state: PlantState) -> void:
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
	on_remove.emit()
	call_deferred("queue_free")

func _process(_delta: float) -> void:
	shader.set_shader_parameter("y_cutoff", t);

func _on_water_detector_area_entered(_area: Area2D) -> void:
	times_watered += 1.0

