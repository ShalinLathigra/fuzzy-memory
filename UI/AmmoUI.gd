extends Control

# So, this thing needs to be provided a reference to the following elements:
# 	Seed Launcher
# 	Water Gun

# how do we provide these things? If none exist, then create one and don't worry about it.
# if one exists, then

var player: Player

enum AMMO_SELECTOR{
	SEED_LAUNCHER=0,
	WATER_GUN=1
}

var seed_ui: Control
var water_ui: WaterGunUI

func _ready() -> void:
	seed_ui = %SeedLauncherUI as Control
	water_ui = %WaterGunUI as WaterGunUI

func set_player(p: Player) -> void:
	player = p
	player.change_item.connect(toggle_ui_components)
	var num_ammo_displays: int = player.water_gun.max_ammo
	water_ui.init(num_ammo_displays)
	player.water_gun.on_shot_fired.connect(water_ui.update_ammo_count)
	player.water_gun.on_charge_gained.connect(water_ui.update_ammo_count)


func toggle_ui_components (selected: AMMO_SELECTOR) -> void:
	seed_ui.visible = selected == AMMO_SELECTOR.SEED_LAUNCHER
	water_ui.visible = selected == AMMO_SELECTOR.WATER_GUN
