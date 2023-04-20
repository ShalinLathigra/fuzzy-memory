class_name ChargeLauncher extends ProjectileLauncher

signal on_charge_gained (remaining: int)

@export_range(250, 5000, 250) var charge_cooldown: int

var msec_of_next_charge: int
var charge_timer: CooldownTimer

func _ready() -> void:
	super._ready()
	ammo_remaining = max_ammo
	charge_timer = $RechargeTimer as CooldownTimer
	charge_timer. cooldown = charge_cooldown

func _process(_delta: float) -> void:
	if ammo_remaining >= max_ammo: return
	if not charge_timer.is_ready: return
	charge_timer.reset()
	ammo_remaining += 1
	on_charge_gained.emit(ammo_remaining)

func is_ready() -> bool:
	return timer.is_ready and ammo_remaining > 0

func fire() -> void:
	if not timer.is_ready or ammo_remaining <= 0: return
	timer.reset()

	# expend a shot + restart charge counter
	ammo_remaining -= 1
	charge_timer.reset()

	var instance = projectile.instantiate() as Projectile
	get_tree().get_first_node_in_group("ProjectileRoot").add_child(instance)

	instance.init(global_position, global_rotation)
	self.on_shot_fired.emit(ammo_remaining)

