class_name Room extends Control

@export var sanitation: Sanitation = Sanitation.CLEAN
@export var quality: Quality = Quality.DUMP
@export var room_size: RoomSize = RoomSize.SMALL

## location of room in hotel. Starts at 0,0 from bottom left. Floor is location.y
@export var location: Vector2 = Vector2.ZERO

var guest: Guest = null:
	get: return guest
	set(value):
		guest = value
		guest_indicator.visible = guest != null

@onready var guest_indicator: Sprite2D = $GuestIndicator

func _ready() -> void:
	guest_indicator.visible = false

var occupied: bool:
	get: return guest != null

func add_guest(_guest: Guest):
	if occupied:
		push_error("Attempting to assign guest to occupied room")
		
	if Globals.DEBUG: print("ASSIGNING GUEST " + str(_guest) + " TO ROOM " + str(self))
	
	guest = _guest

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
