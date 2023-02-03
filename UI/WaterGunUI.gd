class_name WaterGunUI extends Control

var ammo_visualizers := []

func init(max_ammo: int) -> void:
	for i in range(max_ammo):
		var child = ColorRect.new()
		child.color = Color.CYAN
		child.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		$HBoxContainer.add_child(child)
	ammo_visualizers = $HBoxContainer.get_children()

func update_ammo_count(current_ammo: int) -> void:
	for i in range(ammo_visualizers.size()):
		var child = ammo_visualizers[i]
		child.color = Color.CYAN if i <= current_ammo else Color.BLACK
