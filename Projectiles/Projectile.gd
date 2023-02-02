class_name Projectile extends CharacterBody2D

@export_range(0, 256, 8) var base_speed: float
@export_range(0, 10000, 100) var ticks_to_death: int

var death_tick: int
var active: bool

func init(global_pos: Vector2, rot: float) -> void:
	global_position = global_pos
	global_rotation = rot
	velocity = Vector2.from_angle(rot) * base_speed
	active = true
	death_tick = Time.get_ticks_msec() + ticks_to_death

func _physics_process(_delta: float) -> void:
	if not active: return
	var collision = move_and_slide()
	if collision or Time.get_ticks_msec() >= death_tick:
		call_deferred("queue_free")
