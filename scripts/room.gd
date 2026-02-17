class_name Room extends Control

@export var sanitation: Sanitation = Sanitation.CLEAN
@export var quality: Quality = Quality.DUMP
@export var room_size: RoomSize = RoomSize.SMALL

# "fixed", location properties
@export var location: Location
@export var height: Height

var guest: Guest = null

var occupied: bool:
	get: return guest != null

func add_guest(_guest: Guest):
	if occupied:
		push_error("Attempting to assign guest to occupied room")
		
	if Globals.DEBUG: print("ASSIGNING GUEST " + str(_guest) + " TO ROOM " + str(self))
	
	guest = _guest

func _on_texture_button_button_down() -> void:
	Globals.select_room.emit(self)

func get_happiness_rating() -> float:
	var rating: float = guest.initial_rating
	# TODO
	return rating

enum Sanitation {
	CLEAN,
	MESSY,
	DIRTY,
}

enum Quality {
	CLASSY,
	NORMAL,
	DUMP
}

enum RoomSize {
	LARGE,
	MEDIUM,
	SMALL
}

## invariant, based on physical room location
enum Location {
	CENTER,
	LEFT,
	RIGHT,
}

## invariant, based on physical room location
enum Height {
	GROUND,
	MIDDLE,
	HIGH,
}
