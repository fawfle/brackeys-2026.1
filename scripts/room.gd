class_name Room extends Control

## name of room group
const GROUP_NAME: String = "room"

@export var sanitation: Sanitation = Sanitation.CLEAN
@export var quality: Quality = Quality.DUMP
@export var room_size: RoomSize = RoomSize.SMALL

@onready var focus_outline: Sprite2D = $FocusOutline

## location of room in hotel. Starts at 0,0 from bottom left. Floor is location.y
@export var location: Vector2i = Vector2i.ZERO

@export var built: bool = false:
	get: return built
	set(value):
		built = value
		update_room_sprite()

@onready var room_sprite:Sprite2D = $RoomSprite
@export var room_construction_texture: Texture
@export var room_dump_texture: Texture

var guest: Guest = null:
	get: return guest
	set(value):
		guest = value
		guest_indicator.visible = guest != null

@onready var guest_indicator: Sprite2D = $GuestIndicator

func _ready() -> void:
	guest_indicator.visible = false
	focus_outline.visible = false
	
	Globals.select_room.connect(_on_room_select)
	
	update_room_sprite()

var occupied: bool:
	get: return guest != null

## returns if adding was successful
func add_guest(_guest: Guest) -> bool:
	if not can_assign_guest():
		push_error("Attempting to assign guest to occupied or unbuilt room")
		return false
		
	if Globals.DEBUG: print("ASSIGNING GUEST " + str(_guest) + " TO ROOM " + str(self))
	
	guest = _guest
	return true

func can_assign_guest() -> bool:
	return not occupied and built

func _on_room_select(room: Room):
	focus_outline.visible = room == self

func _on_texture_button_button_down() -> void:
	Globals.select_room.emit(self)

func _on_texture_button_mouse_entered() -> void:
	Globals.hover_room.emit(self)

func _on_texture_button_mouse_exited() -> void:
	Globals.exit_hover_room.emit(self)


func checkout_guest() -> Guest:
	for guest_trait: GuestTrait in guest.traits:
		if guest_trait.on_leave.is_valid(): guest_trait.on_leave.call(self)
	
	var g: Guest = guest;
	guest = null
	return g

func update_room_sprite():
	if not built:
		room_sprite.texture = room_construction_texture
		return
	
	room_sprite.texture = room_dump_texture

## makes room messier, mostly for when guests leave
func decrease_sanitation():
	if sanitation == Sanitation.DIRTY: return
	sanitation = (sanitation - 1) as Sanitation

## functions to get location properties
func in_center() -> bool:
	return location.x == 1

func on_left() -> bool:
	return location.x == 0

func on_right() -> bool:
	return location.x  == 2

func on_ground_floor() -> bool:
	return location.y == 0

## return rooms on left/right
func get_floor_neighbors() -> Array[Room]:
	return get_neighbors_with(func(room: Room): return abs(location.x - room.location.x) < 1)

## return neighbors above and below
func get_vertical_neighbors() -> Array[Room]:
	return get_neighbors_with(func(room: Room): return abs(location.y - room.location.y) < 1)

## return left, right, top, bottom
func get_all_neighbors() -> Array[Room]:
	return get_neighbors_with(func(room: Room): return abs(location.x - room.location.x) < 1 or abs(location.y - room.location.y) < 1)

## helper
func get_neighbors_with(callable: Callable) -> Array[Room]:
	var neighbors: Array[Room] = []
	var rooms = get_tree().get_nodes_in_group(GROUP_NAME)
	
	for room: Room in rooms:
		if callable.call(room):
			neighbors.push_back(room)
	
	return neighbors

# TODO: some visual/menu indicator
func upgrade_sanitation(): 
	if sanitation == Sanitation.CLEAN: return
	
	sanitation = (sanitation + 1) as Sanitation
	Globals.room_upgraded.emit(self)
	
func upgrade_quality(): 
	if quality == Quality.CLASSY: return
	
	quality = (quality + 1) as Quality
	Globals.room_upgraded.emit(self)
		
func upgrade_room_size(): 
	if room_size == RoomSize.LARGE: return
	
	room_size = (room_size + 1) as RoomSize
	Globals.room_upgraded.emit(self)

enum Sanitation {
	DIRTY,
	MESSY,
	CLEAN,
}

enum Quality {
	DUMP,
	NORMAL,
	CLASSY,
}

enum RoomSize {
	SMALL,
	MEDIUM,
	LARGE,
}

## TODO, one or the other type upgrades
enum Perks {
	
}

# helper functions, enum -> string
static func sanitation_string(prop: Sanitation) -> String:
	match(prop):
		Sanitation.CLEAN: return "Clean"
		Sanitation.MESSY: return "Messy"
		Sanitation.DIRTY: return "Dirty"

	return "Prop not found."

## quality string
static func quality_string(prop: Quality) -> String:
	match(prop):
		Quality.CLASSY: return "Classy"
		Quality.NORMAL: return "Normal"
		Quality.DUMP: return "Dump"

	return "Prop not found."

## quality string
static func room_size_string(prop: RoomSize) -> String:
	match(prop):
		RoomSize.SMALL: return "Small"
		RoomSize.MEDIUM: return "Medium"
		RoomSize.LARGE: return "Large"

	return "Prop not found."


func _on_guest_indicator_visibility_changed() -> void:
	pass # Replace with function body.
