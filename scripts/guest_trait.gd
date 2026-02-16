class_name GuestTrait extends Resource

@export var name: String
@export var condition: Callable
@export var preference: Preference
@export var on_leave: Callable

## traits that are mutually exclusive with this one
@export var blacklisted_traits: Array[TraitList.Trait] = []

@export var enum_key: TraitList.Trait

enum Preference {
	HIGH,
	MEDIUM,
	LOW,
	DEALBREAKER
}

## Guest won't appear until day has passed
var appear_after_day: int = 0

## constructed by trait_list class

func _to_string() -> String:
	return "(Guest Trait) " + name;
