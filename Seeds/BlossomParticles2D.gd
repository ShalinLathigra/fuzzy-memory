extends CPUParticles2D

func _ready() -> void:
	if not get_parent() is Blossom: return
	get_parent().on_blossom_ready.connect(func(): emitting = true)
