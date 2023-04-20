class_name Planter extends Area2D

var current_seed: Seed
@export var health: Node2D
@export var growth_harvest_effect: GPUParticles2D
@export var bloom_harvest_effect: GPUParticles2D
@export var wilt_harvest_effect: GPUParticles2D
# give this thing an export for health, etc. These will be passed in
# to the current seed as the only thing modifying them over time.
# i.e. movement is modified to

# maybe it only takes in a "health" component? Then the movment code will refer
# to the health to check if movment flags are set.

func try_apply_seed(new_seed: Seed) -> bool:
	if current_seed:
		return false
	current_seed = new_seed
	current_seed.apply(health)
	return true

func _process(delta: float) -> void:
	if not current_seed:
		return
	current_seed.tick(delta)

func harvest() -> Seed:
	var ret:Seed = current_seed
	if not ret: return null
	if ret.current_state is PlantState.Grow:
		if growth_harvest_effect:
			growth_harvest_effect.restart()
	if ret.current_state is PlantState.Bloom:
		if bloom_harvest_effect:
			bloom_harvest_effect.restart()
	if ret.current_state is PlantState.Wilt:
		if wilt_harvest_effect:
			wilt_harvest_effect.restart()

	current_seed.remove()
	current_seed = null
	return ret
