class_name Guest extends Resource

@export var name: String = ""
## scene loaded, possibly change to just texture
@export var scene: PackedScene

## traits assigned to guest by default. Used for "template" guests.
@export var default_traits: Array[TraitList.Trait] = []
@export var traits: Array[GuestTrait] = []

## Max money guest can give
@export var money: int = 0

## Stay duration
@export var stay_duration: int = 1

## message on greeting
@export var greeting: Array[String] = []
## message on leaving
@export var goodbye: Array[String] = []
## message on angry leaving
@export var angry_goodbye: Array[String] = []
## message on happy leaving
@export var happy_goodbye: Array[String] = []

## initial rating given by guest. Can be lower than 5 for picky or snobbish guests.
@export var initial_rating: float = 5

## Guest won't appear until day has passed
@export var appear_after_day: int = 0

## reference to current node loaded in scene tree
var node: Node2D = null

## return array of greeting and request
func get_intro_lines() -> Array[String]:
	var arr: Array[String] = greeting.duplicate();
	arr.append(generate_request())
	return arr

## Todo, will return **random** dynamic request based on traits
func generate_request() -> String:
	return "placeholder request"

func get_exit_lines(happiness: float = 3) -> Array[String]:
	if happiness <= 2.0:
		return angry_goodbye
	elif happiness >= 4.0:
		return happy_goodbye
	
	return goodbye

func get_happiness_rating(room: Room) -> float:
	var rating: float = initial_rating
	
	for guest_trait: GuestTrait in traits:  
		var condition_met: bool = guest_trait.condition.call(room)
		if not condition_met:
			rating -= guest_trait.get_preference_score()
	
	return max(0, rating)

func instantiate_scene() -> Node2D:
	if scene == null:
		push_error("No guest scene for guest")
		return null
	
	node = scene.instantiate()
	return node

func _to_string() -> String:	
	return "(Guest) " + name + " Traits: " + str(traits);

# constructed by guest_list class
