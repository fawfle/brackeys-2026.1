class_name Hotel extends Node

static var inst: Hotel = null

## "button" that deselects selected room. For "clicking off"
@onready var room_deselect: TextureButton = $RoomDeselect

@onready var hotel_upgrade_menu: Control = $HotelUpgradeMenu
@onready var room_upgrade_menu: Control = $RoomUpgradeMenu
@onready var room_info_menu: RoomInfoMenu = $RoomInfoMenu

var upgrades: Dictionary = {
	
}

## Sanitation upgrade costs. Dictionary goes from current level to next upgrade cost b/c of implementation easiness
const SANITATION_UPGRADE_COSTS: Dictionary[Room.Sanitation, int] = {
	Room.Sanitation.DIRTY: 5,
	Room.Sanitation.MESSY: 10,
}
## Quality upgrade costs. Takes current room prop
const QUALITY_UPGRADE_COSTS: Dictionary[Room.Quality, int] = {
	Room.Quality.DUMP: 20,
	Room.Quality.NORMAL: 100,
}
const ROOM_SIZE_UPGRADE_COSTS: Dictionary[Room.RoomSize, int] = {
	Room.RoomSize.SMALL: 25,
	Room.RoomSize.MEDIUM: 100,
}

var selected_room: Room = null:
	get: return selected_room
	set(value):
		selected_room = value
		update_room_info_menu()
var hovered_room: Room = null:
	get: return hovered_room
	set(value):
		hovered_room = value
		update_room_info_menu()

func _init():
	inst = self

# TODO: manage rooms, assign positions, hold hotel upgrades and allow building of new rooms/floors
func _ready() -> void:
	Globals.select_room.connect(_on_select_room)
	Globals.hover_room.connect(_on_hover_room)
	Globals.exit_hover_room.connect(_on_exit_hover_room)
	room_deselect.button_down.connect(func(): Globals.select_room.emit(null))
	
	Globals.guest_assigned.connect(func(_guest: Guest): update_room_info_menu())
	Globals.guest_checked_out.connect(func(_guest: Guest): update_room_info_menu())
	Globals.room_upgraded.connect(func(_room: Room): update_room_info_menu())
	
	room_upgrade_menu.visible = false
	room_info_menu.visible = false

func _on_select_room(room: Room):
	selected_room = room
	room_upgrade_menu.visible = room != null
	hotel_upgrade_menu.visible = room == null

func _on_hover_room(room: Room):
	hovered_room = room
	
func _on_exit_hover_room(room: Room):
	if hovered_room == room:
		hovered_room = null

func update_room_info_menu():
	var room: Room = hovered_room
	if room == null: room = selected_room
	if room == null:
		room_info_menu.visible = false
		return
	
	room_info_menu.visible = true
	room_info_menu.update_viewed_room(room)

func _on_clean_pressed() -> void:
	if selected_room == null or selected_room.sanitation == Room.Sanitation.CLEAN: return
	if GameManager.inst.purchase_upgrade(SANITATION_UPGRADE_COSTS[selected_room.sanitation]): selected_room.upgrade_sanitation()


func _on_quality_pressed() -> void:
	if selected_room == null or selected_room.quality == Room.Quality.CLASSY: return
	if GameManager.inst.purchase_upgrade(QUALITY_UPGRADE_COSTS[selected_room.quality]): selected_room.upgrade_quality()


func _on_size_pressed() -> void:
	if selected_room == null or selected_room.room_size == Room.RoomSize.LARGE: return
	if GameManager.inst.purchase_upgrade(QUALITY_UPGRADE_COSTS[selected_room.quality]): selected_room.upgrade_room_size()

func _on_room_upgrade_button_pressed() -> void:
	pass
