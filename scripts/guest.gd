class_name Guest extends Resource

@export var name: String = ""
@export var scene: PackedScene

## traits assigned to guest by default. Used for "template" guests.
@export var default_traits: Array[TraitList.Trait] = []
@export var traits: Array[GuestTrait] = []

## Max money guest can give
@export var money: int = 0

## message on greeting
@export var greeting: String = ""
## message on leaving
@export var goodybye: String = ""
## message on angry leaving
@export var angry_goodbye: String = ""

## initial rating given by guest. Can be lower than 5 for picky or snobbish guests.
@export var initial_rating: float = 5

## Guest won't appear until day has passed
@export var appear_after_day: int = 0

##
func get_lines() -> Array[String]:
	return [greeting, generate_request()]

## Todo, will return **random** dynamic request based on traits
func generate_request() -> String:
	return "placeholder request"

# constructed by guest_list class

func _to_string() -> String:	
	return "(Guest) " + name + "Traits: " + str(traits);
