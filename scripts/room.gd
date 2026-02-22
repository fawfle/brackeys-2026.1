class_name Room extends Control

## name of room group
const GROUP_NAME: String = "room"

@export var sanitation: Sanitation = Sanitation.CLEAN
@export var quality: Quality = Quality.DUMP
@export var room_size: RoomSize = RoomSize.SMALL

@export var perks: Array[Perk] = []
var perk_tier: int:
	get: return perks.size()

@onready var button: TextureButton = $TextureButton

@onready var focus_outline: NinePatchRect = $FocusOutline

@onready var clean_progress: TextureProgressBar = $CleanProgressBar
@onready var build_progress: TextureProgressBar = $BuildProgressBar

@onready var dim_overlay: ColorRect = $DimOverlay

## the door to make appear on size 1
@onready var door_one: Sprite2D = $DoorOne
## the door to make appear on size 2
@onready var door_two: Sprite2D = $DoorTwo

## location of room in hotel. Starts at 0,0 from bottom left. Floor is location.y
@export var location: Vector2i = Vector2i.ZERO

var hotel_floor: int:
	get: return location.y

@export var built: bool = false:
	get: return built
	set(value):
		built = value
		update_room_sprite()

@onready var room_background: NinePatchRect = $RoomBackground
@onready var room_body: Sprite2D = $RoomBody
@onready var room_select_sound: AudioStreamPlayer2D = $RoomSelect

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

const DOOR_SPRITES: Dictionary[Quality, Texture] = {
	Quality.DUMP: preload("res://sprites/ui/room_door.png"),
	Quality.NORMAL: preload("res://sprites/ui/room_door_normal.png"),
	Quality.CLASSY: preload("res://sprites/ui/room_door_classy.png"),
}

const ROOM_SIZES: Dictionary[RoomSize, Vector2] = {
	RoomSize.SMALL: Vector2(40, 20),
	RoomSize.MEDIUM: Vector2(44, 20),
	RoomSize.LARGE: Vector2(48, 20)
}

const BUTTON_SIZES: Dictionary[RoomSize, Vector2] = {
	RoomSize.SMALL: Vector2(36, 16),
	RoomSize.MEDIUM: Vector2(40, 16),
	RoomSize.LARGE: Vector2(44, 16)
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

## time to complete an upgrade. Set to be day_length
var time_to_upgrade: float = 120

func _ready() -> void:
	guest_indicator.visible = false
	focus_outline.visible = false
	clean_progress.visible = false
	build_progress.visible = false
	dim_overlay.visible = false
	
	Globals.select_room.connect(_on_room_select)
	
	time_to_upgrade = GameManager.inst.total_day_length
	
	update_room_sprite()
	clean_progress.max_value = time_to_clean
	build_progress.max_value = time_to_upgrade

func _process(delta: float) -> void:
	if upgrading:
		upgrade_time += delta
		build_progress.value = time_to_upgrade - upgrade_time
		if upgrade_time >= time_to_upgrade:
			finish_upgrading()
		return
	
	if sanitation == Sanitation.CLEAN: return
	
	if held and guest == null:
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
	room_select_sound.play()
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
	if is_inactive():
		room_body.texture = ROOM_CONSTRUCTION_TEXTURE
	else:
		room_body.texture = QUALITY_BODY_TEXTURES.get(quality)
	
	room_background.texture = QUALITY_BACKGROUND_TEXTURES.get(quality)
	dim_overlay.visible = is_inactive()
	
	door_one.visible = room_size == RoomSize.MEDIUM or room_size == RoomSize.LARGE
	door_two.visible = room_size == RoomSize.LARGE
	door_one.texture = DOOR_SPRITES.get(quality)
	door_two.texture = DOOR_SPRITES.get(quality)
	
	# i am losing my mind. This is terrible but if's fine
	room_background.size = ROOM_SIZES[room_size]
	room_background.position = - ROOM_SIZES[room_size] / 2
	focus_outline.size = ROOM_SIZES[room_size]
	focus_outline.position = - ROOM_SIZES[room_size] / 2
	button.set_deferred("size", BUTTON_SIZES[room_size])
	button.position = - BUTTON_SIZES[room_size] / 2
	dim_overlay.size = BUTTON_SIZES[room_size]
	dim_overlay.position = - BUTTON_SIZES[room_size] / 2
	

func is_inactive() -> bool:
	return not built or upgrading

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
	return get_neighbors_with(func(room: Room): return room != self and abs(location.x - room.location.x) < 1)

## return neighbors above and below
func get_vertical_neighbors() -> Array[Room]:
	return get_neighbors_with(func(room: Room): return room != self and abs(location.y - room.location.y) < 1)

## return left, right, top, bottom
func get_all_neighbors() -> Array[Room]:
	return get_neighbors_with(func(room: Room): return room != self and abs(location.x - room.location.x) < 1 or abs(location.y - room.location.y) < 1)

## helper
func get_neighbors_with(callable: Callable) -> Array[Room]:
	var neighbors: Array[Room] = []
	var rooms = get_tree().get_nodes_in_group(GROUP_NAME)
	
	for room: Room in rooms:
		if callable.call(room):
			neighbors.push_back(room)
	
	return neighbors

func add_perk(perk: Perk) -> void:
	perks.push_back(perk)
	Globals.room_updated.emit(self)

# TODO: some visual/menu indicator
func upgrade_sanitation(): 
	if sanitation == Sanitation.CLEAN: return
	
	sanitation = (sanitation + 1) as Sanitation
	Globals.room_updated.emit(self)
	
func upgrade_quality(): 
	if quality == Quality.CLASSY: return
	
	quality = (quality + 1) as Quality
	start_upgrading()
	update_room_sprite()
	Globals.room_updated.emit(self)
		
func upgrade_room_size(): 
	if room_size == RoomSize.LARGE: return
	
	room_size = (room_size + 1) as RoomSize
	start_upgrading()
	Globals.room_updated.emit(self)

func build():
	if built: return
	built = true
	Globals.room_updated.emit(self)

func start_upgrading():
	upgrading = true
	upgrade_time = 0
	dim_overlay.visible = true
	build_progress.visible = true
	Globals.room_updated.emit(self)

func finish_upgrading():
	if not upgrading: return
	upgrading = false
	dim_overlay.visible = false
	build_progress.visible = false
	update_room_sprite()
	Globals.room_updated.emit(self)

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

enum Perk {
	SPACE_HEATER,
	AC,
	BATH,
	SHOWER,
	CABLE,
	CONSOLE
}

const PERK_SPRITES: Dictionary[Perk, Texture] = {
	Perk.SPACE_HEATER: preload("res://sprites/ui/space_heater_icon.png"),
	Perk.AC: preload("res://sprites/ui/air_conditioner_icon.png"),
	Perk.BATH: preload("res://sprites/ui/bathtub_icon.png"),
	Perk.SHOWER: preload("res://sprites/ui/shower_icon.png"),
	Perk.CABLE: preload("res://sprites/ui/cable_icon.png"),
	Perk.CONSOLE: preload("res://sprites/ui/console_icon.png"),
}

const PERK_TIER: Dictionary[int, Array] = {
	0: [Perk.SPACE_HEATER, Perk.AC],
	1: [Perk.BATH, Perk.SHOWER],
	2: [Perk.CABLE, Perk.CONSOLE]
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
