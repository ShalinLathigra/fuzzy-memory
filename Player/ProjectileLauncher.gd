class_name ProjectileLauncher extends Node2D

signal on_shot_fired (remaining: int)

@export var projectile: PackedScene
@export_range(250, 5000, 250) var fire_cooldown: int
@export_range(0, 1, 0.05) var delay_post_shot: float
@export_range(0, 8) var max_ammo: int

var msec_of_next_shot: int
var ammo_remaining: int

func _ready() -> void:
	assert(projectile)

func fire() -> void:
	var t: int = Time.get_ticks_msec()
	if t < msec_of_next_shot: return
	msec_of_next_shot = t + fire_cooldown
	ammo_remaining -= 1

	var instance = projectile.instantiate() as Projectile
	get_tree().get_first_node_in_group("ProjectileRoot").add_child(instance)

	instance.init(global_position, global_rotation)
