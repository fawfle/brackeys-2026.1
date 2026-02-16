class_name GuestTrait

var name: String
var condition: Callable
var preference: Preference
var on_leave: Callable

## traits that are mutually exclusive with this one
var blacklisted_traits: Array[TraitList.Trait]

enum Preference {
	HIGH,
	MEDIUM,
	LOW,
	DEALBREAKER
}

## Guest won't appear until day has passed
var appear_after_day: int = 0

## constructed by trait_list class
