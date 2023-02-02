class_name SeedCarrier extends Area2D

@export var _seed: Seed

func _on_area_entered(area: Area2D) -> void:
	if not area is Planter: return
	if _seed and not area.try_apply_seed(_seed): return
	owner.call_deferred("queue_free")
