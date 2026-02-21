class_name Room extends Control

## name of room group
const GROUP_NAME: String = "room"

@export var sanitation: Sanitation = Sanitation.CLEAN
@export var quality: Quality = Quality.DUMP
@export var room_size: RoomSize = RoomSize.SMALL

@onready var focus_outline: Sprite2D = $FocusOutline

@onready var clean_progress: TextureProgressBar = $TextureProgressBar

@onready var dim_overlay: ColorRect = $DimOverlay

## location of room in hotel. Starts at 0,0 from bottom left. Floor is location.y
@export var location: Vector2i = Vector2i.ZERO

var hotel_floor: int:
	get: return location.y

@export var built: bool = false:
	get: return built
	set(value):
		built = value
		update_room_sprite()

@onready var room_background: Sprite2D = $RoomBody
@onready var room_body: Sprite2D = $RoomBody

const ROOM_CONSTRUCTION_TEXTURE: Texture = preload("res://sprites/ui/room_construction.png")

const QUALITY_BACKGROUND_TEXTURES: Dictionary[Quality, Texture] = {
	Quality.DUMP: preload("res://sprites/ui/room_bg.png"),
	Quality.NORMAL: preload("res://sprites/ui/room_normal_bg.png"),
	Quality.CLASSY: preload("res://sprites/ui/room_classy_bg.png")
}

const QUALITY_BODY_TEXTURES: Dictionary[Quality, Texture] = {
	Quality.DUMP: preload("res://sprites/ui/room_body.png"),
	Quality.NORMAL:preload("res://sprites/ui/room_normal_body.png"),
	Quality.CLASSY:preload("res://sprites/ui/room_classy_body.png"),
}

var guest: Guest = null:
	get: return guest
	set(value):
		guest = value
		guest_indicator.visible = guest != null

@onready var guest_indicator: Sprite2D = $GuestIndicator

## time it takes to clean room
var time_to_clean: float = 5
## time spent cleaning
var clean_timer: float = 0

var held: bool = false

var upgrading: bool = false
var upgrade_time: float = 0

func _ready() -> void:
	guest_indicator.visible = false
	focus_outline.visible = false
	clean_progress.visible = false
	dim_overlay.visible = false
	
	Globals.select_room.connect(_on_room_select)
	
	update_room_sprite()
	clean_progress.max_value = time_to_clean

func _process(delta: float) -> void:
	if upgrading:
		upgrade_time += delta
		if upgrade_time >= GameManager.inst.total_day_length:
			stop_upgrading()
		return
	
	if sanitation == Sanitation.CLEAN: return
	
	if held:
		clean_timer += delta
	elif clean_timer > 0:
		clean_timer -= delta
	
	if clean_timer > time_to_clean:
		upgrade_sanitation()
		clean_progress.visible = sanitation != Sanitation.CLEAN
		clean_timer = 0
		return
	
	clean_progress.visible = held or clean_timer > 0
	clean_progress.value = clean_timer

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
	held = true
	Globals.select_room.emit(self)

func _on_texture_button_button_up() -> void:
	held = false

func _on_texture_button_mouse_entered() -> void:
	Globals.hover_room.emit(self)

func _on_texture_button_mouse_exited() -> void:
	Globals.exit_hover_room.emit(self)


func checkout_guest() -> Guest:
	for guest_trait: GuestTrait in guest.traits:
		if guest_trait.on_leave.is_valid(): guest_trait.on_leave.call(self)
	
	var g: Guest = guest;
	guest = null
	
	decrease_sanitation()
	
	return g

func update_room_sprite():
	if not built or upgrading:
		room_body.texture = ROOM_CONSTRUCTION_TEXTURE
	else:
		room_body.texture = QUALITY_BODY_TEXTURES.get(quality)
	
	room_background.texture = QUALITY_BACKGROUND_TEXTURES.get(quality)
	dim_overlay.visible = upgrading

## makes room messier, mostly for when guests leave
func decrease_sanitation():
	if sanitation == Sanitation.DIRTY: return
	sanitation = (sanitation - 1) as Sanitation
	Globals.room_updated.emit(self)

## functions to get location properties
func in_center() -> bool:
	return location.x == 1

func on_left() -> bool:
	return location.x == 0

func on_right() -> bool:
	return location.x  == 2

func on_ground_floor() -> bool:
	return location.y == 0

func on_top_floor() -> bool:
	return location.y == Hotel.inst.floors - 1

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
	Globals.room_updated.emit(self)
	
func upgrade_quality(): 
	if quality == Quality.CLASSY: return
	
	quality = (quality + 1) as Quality
	set_upgrading()
	update_room_sprite()
	Globals.room_updated.emit(self)
		
func upgrade_room_size(): 
	if room_size == RoomSize.LARGE: return
	
	room_size = (room_size + 1) as RoomSize
	set_upgrading()
	Globals.room_updated.emit(self)

func build():
	if built: return
	built = true
	Globals.room_updated.emit(self)

func set_upgrading():
	upgrading = true
	upgrade_time = 0
	dim_overlay.visible = true

func stop_upgrading():
	upgrading = false
	dim_overlay.visible = true

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
