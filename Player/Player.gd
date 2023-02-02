class_name Player extends CharacterBody2D

const SPEED = 96

@export_range(0.05, 2.5) var sec_to_max: float
@export_range(0.05, 2.5) var sec_to_stop: float

var speed_t: float
var dir: Vector2
var can_act: bool = true
var seed_launcher: SeedLauncher

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	seed_launcher = $MouseArm/SeedLauncher as SeedLauncher

func _physics_process(delta: float) -> void:
	# if moving, do acceleration first
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized()
	if input_dir != Vector2.ZERO and can_act:
		dir = input_dir
		speed_t = minf(speed_t + delta * (1 / sec_to_max), 1)
	else:
		speed_t = maxf(speed_t - delta * (1 / sec_to_stop), 0)

	velocity = dir * SPEED * speed_t
	move_and_slide()


func _process(_delta: float) -> void:
	if not can_act: return
	if Input.is_action_pressed("use"):
		can_act = false
		seed_launcher.fire()
		create_tween().tween_callback(func(): can_act = true).set_delay(seed_launcher.delay)
