class_name Hotel extends Node

@onready var upgrade_menu = $UpgradeMenu
var selected_room: Room = null


# TODO: manage rooms, assign positions, hold hotel upgrades and allow building of new rooms/floors
func _ready() -> void:
	Globals.select_room.connect(on_select_room)
	upgrade_menu.visible = false

func on_select_room(room: Room):
	upgrade_menu.visible = true
	selected_room = room
	

func _on_clean_pressed() -> void:
	if selected_room == null: return
	selected_room.upgrade_sanitation()


func _on_quality_pressed() -> void:
	if selected_room == null: return
	selected_room.upgrade_quality()


func _on_size_pressed() -> void:
	if selected_room == null: return
	selected_room.upgrade_room_size()
