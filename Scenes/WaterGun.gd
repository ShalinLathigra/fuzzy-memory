class_name WaterGun extends Node2D

@export var projectile: PackedScene
@export_range(250, 5000, 250) var recharge_cooldown: int
@export_range(250, 5000, 250) var fire_cooldown: int
@export_range(0, 8) var max_charges: int

var msec_of_next_shot: int
var msec_of_next_charge: int
var charges_remaining: int

func _ready() -> void:
	assert(projectile)
	charges_remaining = max_charges

func _process(_delta: float) -> void:
	if charges_remaining >= max_charges: return
	var t: int = Time.get_ticks_msec()
	if t < msec_of_next_charge: return
	charges_remaining += 1
	prints("added charge:", charges_remaining)
	msec_of_next_charge = t + recharge_cooldown

func fire() -> void:
	var t: int = Time.get_ticks_msec()
	if t < msec_of_next_shot or charges_remaining <= 0: return
	msec_of_next_shot = t + fire_cooldown

	# expend a shot
	charges_remaining -= 1
	msec_of_next_charge = t + recharge_cooldown
	prints("removed charge", charges_remaining)

	var instance = projectile.instantiate() as Projectile
	get_tree().get_first_node_in_group("ProjectileRoot").add_child(instance)

	instance.init(global_position, global_rotation)

