class_name Guest extends Resource

@export var name: String = ""
## scene loaded, possibly change to just texture
@export var scene: PackedScene

## traits assigned to guest by default. Used for "template" guests.
@export var default_traits: Array[TraitList.Trait] = []
@export var traits: Array[GuestTrait] = []

## trait tag effects given by guests that affect others. EX RADIOACTIVE can be given as a trait tag
@export var trait_tags: Array[TraitList.Trait] = []

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
var room: Room = null

## store fail_feedback string from get_happiness_value
var fail_feedback: Array[String] = []
var happiness_rating: float = -1

## return array of greeting and request
func get_intro_lines() -> Array[String]:
	var arr: Array[String] = greeting.duplicate();
	arr.append_array(generate_request())
	return arr

const MAX_REQUEST_DEPTH: int = 100

## TODO:ish, will return **random** dynamic request based on traits
func generate_request() -> Array[String]:
	var arr: Array[String] = []
	var pickable_traits: Array[GuestTrait] = traits.duplicate()
	
	var request_depth: int = 0
	
	while arr.size() < 3 and pickable_traits.size() > 0 and request_depth < MAX_REQUEST_DEPTH:
		if arr.size() >= traits.size(): break
		request_depth += 1
		var t: GuestTrait = pickable_traits.pop_at(randi_range(0, pickable_traits.size() - 1))
		if (t.request == ""):
			continue
		arr.push_back(t.request)
	
	if request_depth > MAX_REQUEST_DEPTH: print("Max depth exceeded for generating request")
	
	return arr

func get_exit_lines() -> Array[String]:
	if happiness_rating <= -1:
		push_error("Attempted to get exit lines before setting happiness_rating. Did you mean to call update_happiness_rating?")
		return []
	
	var goodbye_lines: Array[String] = fail_feedback.duplicate()
	
	if happiness_rating <= 2.0:
		goodbye_lines.append_array(angry_goodbye)
	elif happiness_rating >= 4.0:
		goodbye_lines.append_array(happy_goodbye)
	else:
		goodbye_lines.append_array(goodbye)
		
	
	return goodbye_lines

## has big side effects. Sets happiness_rating and updates fail_lines
func update_happiness_rating() -> float:
	if room == null:
		push_error("attempted to get happiness rating of guest without a roomm")
		return -1
		
	var rating: float = initial_rating
	fail_feedback.clear()
	
	for guest_trait: GuestTrait in traits:
		if not guest_trait.condition.is_valid(): continue
		var condition_met: bool = guest_trait.condition.call(room)
		if not condition_met:
			rating -= guest_trait.preference
			if guest_trait.fail_feedback != "": fail_feedback.push_back(guest_trait.fail_feedback)
	
	happiness_rating = max(0, rating)
	return happiness_rating

func instantiate_scene() -> Node2D:
	if scene == null:
		push_error("No guest scene for guest")
		return null
	
	node = scene.instantiate()
	return node

func _to_string() -> String:	
	return "(Guest) " + name + " Traits: " + str(traits);

# constructed by guest_list class
