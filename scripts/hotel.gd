class_name Hotel extends Node

@onready var upgrade_menu = $UpgradeMenu

# TODO: manage rooms, assign positions, hold hotel upgrades and allow building of new rooms/floors
func _ready() -> void:
	Globals.select_room.connect(on_select_room)

func on_select_room(room: Room):
	upgrade_menu.visible = true
	
