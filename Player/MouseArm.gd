extends Node2D

var target: Vector2

func _ready() -> void:
	print(get_viewport_rect().size)

func _process(_delta: float) -> void:
	var target_rotation: float = (target - global_position).normalized().angle()
	rotation = lerp_angle(rotation, target_rotation, 0.5)

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion: return
	var mouse = (event as InputEventMouseMotion)
	target = mouse.position # need to do this - half rect size + global_position
