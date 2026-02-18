class_name Room extends Control

@export var sanitation: Sanitation = Sanitation.CLEAN
@export var quality: Quality = Quality.DUMP
@export var room_size: RoomSize = RoomSize.SMALL

## location of room in hotel. Starts at 0,0 from bottom left. Floor is location.y
@export var location: Vector2 = Vector2.ZERO

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

## functions to get location properties
func in_center() -> bool:
	return location.x == 1

func on_left() -> bool:
	return location.x == 0

func on_right() -> bool:
	return location.x  == 2

func on_ground_floor() -> bool:
	return location.y == 0

func upgrade_sanitation(): 
	if sanitation == Sanitation.CLEAN:
		print("Good already")
		return
	else:
		sanitation -= 1
		print("Upgrade")
		# TODO: some visual/menu indicator
		
func upgrade_quality(): 
	if quality == Quality.CLASSY:
		print("Good already")
		return
	else:
		quality -= 1
		print("Upgrade")
		
func upgrade_room_size(): 
	if room_size == RoomSize.LARGE:
		print("Good already")
		return
	else:
		room_size -= 1
		print("Upgrade")


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
