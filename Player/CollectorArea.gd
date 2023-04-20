class_name CollectorArea2D extends Area2D

# need to track how many objects we have collided with. The exact type isn't important

var contained_bodies: Array[Node2D]
var contained_areas: Array[Area2D]

@export var visualizer: Sprite2D

const empty_colour := Color(0.545098, 0, 0, 0.5) # Color.DARK_RED
const full_colour :=  Color(0, 0.392157, 0, 0.5)   # Color.DARK_GREEN

func _ready() -> void:
	_update_visualizer()

func _update_visualizer() -> void:
	if not visualizer: return
	var filled: bool = (contained_bodies.size()+ contained_areas.size()) > 0
	visualizer.self_modulate = full_colour if filled else empty_colour

func _add_to_collection(node: Node2D, collection: Array) -> void:
	if node in collection: return
	collection.append(node)
	_update_visualizer()

func _remove_from_collection(node: Node2D, collection: Array) -> void:
	if not node in collection: return
	collection.remove_at(collection.find(node))
	_update_visualizer()

func _on_body_entered(body: Node2D) -> void:
	_add_to_collection(body, contained_bodies)

func _on_area_entered(area: Area2D) -> void:
	_add_to_collection(area, contained_areas)

func _on_body_exited(body: Node2D) -> void:
	_remove_from_collection(body, contained_bodies)

func _on_area_exited(area: Area2D) -> void:
	_remove_from_collection(area, contained_areas)
