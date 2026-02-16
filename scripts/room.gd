class_name Room extends Control

@export var sanitation: Sanitation = Sanitation.CLEAN
@export var quality: Quality = Quality.DUMP
@export var room_size: RoomSize = RoomSize.SMALL

# "fixed", location properties
@export var location: Location
@export var height: Height

var guest: Guest = null



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
