class_name Player extends CharacterBody2D

signal change_item(selection: int)

const SPEED = 96

@export_range(0.05, 2.5) var sec_to_max: float
@export_range(0.05, 2.5) var sec_to_stop: float

var speed_t: float
var dir: Vector2
var can_act: bool = true
var can_move: bool = true
var seed_launcher: ProjectileLauncher
var water_gun: ChargeLauncher
var sickle: Sickle
var items := []

var current: int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	seed_launcher = $MouseArm/SeedLauncher as ProjectileLauncher
	water_gun = $MouseArm/WaterGun
	sickle = $MouseArm/Sickle
	items.push_back(seed_launcher)
	items.push_back(water_gun)

	current = 0
	change_item.emit(current)
	AmmoUI.set_player(self)

func _physics_process(delta: float) -> void:
	# if moving, do acceleration first
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized()
	if input_dir != Vector2.ZERO and can_move:
		dir = input_dir
		speed_t = minf(speed_t + delta * (1 / sec_to_max), 1)
	else:
		speed_t = maxf(speed_t - delta * (1 / sec_to_stop), 0)

	velocity = dir * SPEED * speed_t
	move_and_slide()

func _input(event: InputEvent) -> void:
	# item scrolling
	if event.is_action_pressed("last_item"):
		current = current - 1 if current > 0 else items.size() - 1
		change_item.emit(current)
	if event.is_action_pressed("next_item"):
		current = (current + 1) % items.size()
		change_item.emit(current)

	# ability activation
	if not can_act: return
	if Input.is_action_pressed("use_item") and items[current].is_ready():
		can_act = false
		can_move = false
		items[current].fire()
		var tw = create_tween()
		tw.tween_callback(func(): can_act = true) \
			.set_delay(items[current].delay_post_use)
		tw.tween_callback(func(): can_move = true) \
			.set_delay(items[current].delay_post_use)

	if Input.is_action_pressed("use_sickle") and sickle.is_ready():
		can_act = false
		can_move = false
		sickle.trigger()
		var tw = create_tween()
		tw.tween_callback(func(): can_act = true) \
			.set_delay(sickle.delay_post_use)
		tw.tween_callback(func(): can_move = true) \
			.set_delay(sickle.delay_post_use)
