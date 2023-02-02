class_name Planter extends Area2D

var current_seed: Seed
@export var health: Node2D
# give this thing an export for health, etc. These will be passed in
# to the current seed as the only thing modifying them over time.
# i.e. movement is modified to

# maybe it only takes in a "health" component? Then the movment code will refer
# to the health to check if movment flags are set.

func try_apply_seed(new_seed: Seed) -> bool:
	print("trying seed")
	if current_seed:
		return false
	current_seed = new_seed
	current_seed.apply(health)
	current_seed.on_remove.connect(func (): current_seed = null)
	return true

func _process(delta: float) -> void:
	if not current_seed:
		return
	current_seed.tick(delta)

# if harvested, current_seed.remove()

func harvest() -> Seed:
	var ret:Seed = current_seed
	current_seed.remove()
	current_seed = null
	return ret
