class_name Room

var sanitation: Sanitation = Sanitation.CLEAN
var quality: Quality = Quality.DUMP
var size: Size = Size.SMALL

# always dynamic, location properties
var location: Location
var height: Height


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

enum Size {
	LARGE,
	MEDIUM,
	SMALL
}

## invariant, based on physical room location
enum Location {
	LEFT,
	RIGHT,
	CENTER
}

## invariant, based on physical room location
enum Height {
	HIGH,
	MIDDLE,
	GROUND,
}
