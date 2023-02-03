class_name ChargeLauncher extends ProjectileLauncher

signal on_charge_gained (remaining: int)

@export_range(250, 5000, 250) var recharge_cooldown: int

var msec_of_next_charge: int

func _ready() -> void:
	assert(projectile)
	ammo_remaining = max_ammo

func _process(_delta: float) -> void:
	if ammo_remaining >= max_ammo: return
	var t: int = Time.get_ticks_msec()
	if t < msec_of_next_charge: return
	ammo_remaining += 1
	msec_of_next_charge = t + recharge_cooldown
	on_charge_gained.emit(ammo_remaining)

func fire() -> void:
	var t: int = Time.get_ticks_msec()
	if t < self.msec_of_next_shot or ammo_remaining <= 0: return
	self.msec_of_next_shot = t + self.fire_cooldown

	# expend a shot
	ammo_remaining -= 1
	msec_of_next_charge = t + recharge_cooldown

	var instance = projectile.instantiate() as Projectile
	get_tree().get_first_node_in_group("ProjectileRoot").add_child(instance)

	instance.init(global_position, global_rotation)
	self.on_shot_fired.emit(ammo_remaining)

