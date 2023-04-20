class_name WaterGunUI extends Control

var ammo_visualizers := []
const filled_color := Color("00b3ff")

func init(max_ammo: int) -> void:
	for i in range(max_ammo):
		var child = ColorRect.new()
		child.color = filled_color
		child.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		$HBoxContainer.add_child(child)
	ammo_visualizers = $HBoxContainer.get_children()

func update_ammo_count(current_ammo: int) -> void:
	for i in range(ammo_visualizers.size()):
		var child = ammo_visualizers[i]
		child.color = filled_color if i <= current_ammo else Color.BLACK
