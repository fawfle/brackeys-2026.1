class_name GuestTrait

var property: Room.Properties
var value
var preference: Preference

enum Preference {
	HIGH,
	MEDIUM,
	LOW,
	DEALBREAKER
}

func _init(_property: Room.Properties, _value, _preference: Preference) -> void:
	property = _property
	value = _value
	preference = _preference
