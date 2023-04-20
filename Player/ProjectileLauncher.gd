class_name ProjectileLauncher extends Node2D

signal on_shot_fired (remaining: int)

@export var projectile: PackedScene
@export_range(250, 5000, 250) var cooldown: int
@export_range(0, 1, 0.05) var delay_post_use: float
@export_range(0, 8) var max_ammo: int

var msec_of_next_shot: int
var ammo_remaining: int

var timer: CooldownTimer

func _ready() -> void:
	assert(projectile)
	timer = $CooldownTimer as CooldownTimer
	timer.cooldown = cooldown

func is_ready() -> bool:
	return timer.is_ready

func fire() -> void:
	if not timer.is_ready: return
	timer.reset()
	ammo_remaining -= 1

	var instance = projectile.instantiate() as Projectile
	get_tree().get_first_node_in_group("ProjectileRoot").add_child(instance)

	instance.init(global_position, global_rotation)
	if max_ammo > 0:
		on_shot_fired.emit(ammo_remaining)
