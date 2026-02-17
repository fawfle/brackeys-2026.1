class_name GuestTrait extends Resource

@export var name: String
@export var condition: Callable
@export var request: String
@export var preference: Preference
@export var on_leave: Callable

## traits that are mutually exclusive with this one
@export var blacklisted_traits: Array[TraitList.Trait] = []

@export var enum_key: TraitList.Trait

## How much the guest cares. May change to pure number value. Might be easier as presets but could be more complicated?
enum Preference {
	HIGH,
	MEDIUM,
	LOW,
	DEALBREAKER
}

const PreferenceScore: Dictionary[Preference, float] = {
	Preference.HIGH: 3,
	Preference.MEDIUM: 2,
	Preference.LOW: 1,
	Preference.DEALBREAKER: 5,
}

## Guest won't appear until day has passed
var appear_after_day: int = 0

func get_preference_score():
	return PreferenceScore.get(preference)

func _to_string() -> String:
	return "(GuestTrait) " + name;

## constructed by trait_list class
