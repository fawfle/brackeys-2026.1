class_name RoomUpgradeMenu extends Control

@onready var manage_menu: Control = $Manage
@onready var build_menu: Control = $Build

func _ready() -> void:
	Globals.select_room.connect(update_menu)
	Globals.room_upgraded.connect(update_menu)

func update_menu(room: Room) -> void:
	if room == null:
		visible = false
		return
	
	visible = true
	
	build_menu.visible = not room.built
	manage_menu.visible = room.built

func _on_quality_pressed() -> void:
	if Hotel.inst.selected_room == null or Hotel.inst.selected_room.quality == Room.Quality.CLASSY: return
	if GameManager.inst.purchase_upgrade(UpgradeCosts.QUALITY[Hotel.inst.selected_room.quality]): Hotel.inst.selected_room.upgrade_quality()


func _on_size_pressed() -> void:
	if Hotel.inst.selected_room == null or Hotel.inst.selected_room.room_size == Room.RoomSize.LARGE: return
	if GameManager.inst.purchase_upgrade(UpgradeCosts.ROOM_SIZE[Hotel.inst.selected_room.room_size]): Hotel.inst.selected_room.upgrade_room_size()

func _on_build_pressed() -> void:
	if Hotel.inst.selected_room == null or Hotel.inst.selected_room.built: return
	if GameManager.inst.purchase_upgrade(UpgradeCosts.BUILD_ROOM): Hotel.inst.selected_room.build()
