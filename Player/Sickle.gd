class_name Sickle extends Node2D

@export_range(250, 5000, 250) var cooldown: int
@export_range(0, 1, 0.05) var delay_post_use: float

var collector: CollectorArea2D
var timer: CooldownTimer

func _ready() -> void:
	collector = %CollectorArea2D as CollectorArea2D
	timer = $CooldownTimer as CooldownTimer
	timer.cooldown = cooldown

func is_ready() -> bool:
	return timer.is_ready

func trigger() -> void:
	if not timer.is_ready: return
	timer.reset()

	var _planters: Array[Planter] = []
	for candidate in collector.contained_areas:
		if not candidate is Planter: return
		_planters.push_back(candidate as Planter)

	var _plants: Array[Seed] = []
	for planter in _planters:
		# now we know all the ones that are to be added
		var current = planter.harvest()
		if current:
			_plants.push_back(current)

	# need to pass this bundle off to the ScoreUI so it can handle the rest here.
	ScoreUI.on_harvest_seeds.emit(_plants)
