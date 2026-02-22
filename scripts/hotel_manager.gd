class_name Hotel extends Node

static var inst: Hotel = null

## "button" that deselects selected room. For "clicking off"
@onready var room_deselect: TextureButton = $RoomDeselect

@onready var hotel_upgrade_menu: Control = $HotelUpgradeMenu
@onready var room_upgrade_menu: RoomUpgradeMenu = $RoomUpgradeMenu
@onready var room_info_menu: RoomInfoMenu = $RoomInfoMenu

@onready var build_floor_button: UpgradeButton = $HotelUpgradeMenu/BuildFloorButton

@onready var hotel_menu: HotelMenu = $Hotel

var floors: int = 1

var upgrades: Dictionary = {
	
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
	
	Globals.guest_assigned.connect(func(_guest: Guest):  update_room_info_menu())
	Globals.current_guest_changed.connect(func(_guest: Guest):  update_room_info_menu())
	# Globals.guest_checked_out.connect(func(_guest: Guest): update_room_info_menu())
	Globals.room_updated.connect(func(_room: Room): update_room_info_menu())
	
	room_info_menu.visible = false
	hotel_upgrade_menu.visible = false
	room_upgrade_menu.visible = false
	
	build_floor_button.cost = UpgradeCosts.FLOOR[floors]
	
	## give player 1 room to start
	get_room(Vector2i(0, 0)).built = true
	get_room(Vector2i(0, 0)).decrease_sanitation()

func _on_select_room(room: Room):
	selected_room = room
	hotel_upgrade_menu.visible = room == null
	room_upgrade_menu.visible = room != null

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

func get_room(location: Vector2i) -> Room:
	var rooms: Array[Node] = get_tree().get_nodes_in_group("room")
	
	for room: Room in rooms:
		if room.location == location:
			return room
	
	return null


func _on_build_floor_button_pressed() -> void:
	if floors == 5: return
	if GameManager.inst.purchase_upgrade(UpgradeCosts.FLOOR[floors]):
		floors += 1
		hotel_menu.add_floor(floors)
		build_floor_button.cost = UpgradeCosts.FLOOR[floors]

func is_full() -> bool:
	return not get_rooms().any(func(r: Room): return r.built and r.guest == null)

func get_rooms():
	return get_tree().get_nodes_in_group("room")
