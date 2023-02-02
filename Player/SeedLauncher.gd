class_name SeedLauncher extends Node2D

const MSEC_COOLDOWN: int = 500
@export var projectile: PackedScene
@export_range(0, 2) var delay: float

var msec_of_next_shot: int

func _ready() -> void:
	assert(projectile)

func fire() -> void:
	var t: int = Time.get_ticks_msec()
	if t < msec_of_next_shot: return
	msec_of_next_shot = t + MSEC_COOLDOWN

	var instance = projectile.instantiate() as Projectile
	get_tree().get_first_node_in_group("ProjectileRoot").add_child(instance)

	instance.init(global_position, global_rotation)
