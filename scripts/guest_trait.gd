class_name GuestTrait extends Resource

@export var name: String
## callable function that returns a bool. true if condition met
@export var condition: Callable
## request text given by guest
@export var request: String = ""
## feedback given on condition fail
@export var fail_feedback: String = ""
## how much guest cares. Number to subtract from top score on failing condition
@export var preference: int
@export var on_enter: Callable
@export var on_leave: Callable

## traits that are mutually exclusive with this one
@export var blacklisted_traits: Array[TraitList.Trait] = []

@export var enum_key: TraitList.Trait

## special traits won't be included in random selection
@export var special: bool = false

## Guest won't appear until day has passed
@export var appear_after_day: int = 0

func _to_string() -> String:
	return "(GuestTrait) " + name;

## constructed by trait_list class
