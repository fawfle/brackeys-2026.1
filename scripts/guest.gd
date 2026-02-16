class_name Guest

enum Race {
	
}

var TRAITS = {
	"Clean Freak": GuestTrait.new(Room.Properties.CLEANLINESS, Room.Cleanliness.CLEAN, GuestTrait.Preference.HIGH)
}

var name: String = ""

## Max money guest can give
var money: int = 0

## message on greeting
var greeting: String = ""
## message on leaving
var goodybye: String = ""
