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
var days_stayed: int = 0

## message on greeting
@export var greeting: Array[String] = []
## message on leaving
@export var goodbye: Array[String] = []
## message on angry leaving
@export var angry_goodbye: Array[String] = []
## message on happy leaving
@export var happy_goodbye: Array[String] = []
## message on ignored or rejected
@export var rejected_goodbye: Array[String] = []

## initial rating given by guest. Can be lower than 5 for picky or snobbish guests.
@export var initial_rating: float = 5

## Guest won't appear until day has passed
@export var appear_after_day: int = 0

## if guest is special
@export var event: bool = false

## basically reserved for event types
@export var appear_on_day: int = -1

## true if guest should stop time when entering
@export var stop_time: bool = false

@export var sprite_offset: Vector2i = Vector2i.ZERO

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

const NORMAL_BONUS: int = 15
const CLASSY_BONUS: int = 25

func get_money() -> int:
	update_happiness_rating()
	
	var effective_money = money
	
	for t: GuestTrait in traits:
		effective_money += t.value
	
	if room.quality == Room.Quality.NORMAL: effective_money += NORMAL_BONUS
	if room.quality == Room.Quality.CLASSY: effective_money += CLASSY_BONUS
	
	var stars: int = floor(happiness_rating / 5)
	
	var ac_bonus: int = 5 if room.perks.has(Room.Perk.AC) else 0
	var heater_bonus: int = stars * 2 if room.perks.has(Room.Perk.SPACE_HEATER) else 0
	
	if room.perks.has(Room.Perk.CABLE): effective_money *= 1.25
	if room.perks.has(Room.Perk.CONSOLE) and stars == 5: effective_money *= 1.75
	
	return round(effective_money * (happiness_rating/5.0)) + ac_bonus + heater_bonus

## TODO:ish, will return **random** dynamic request based on traits
func generate_request() -> Array[String]:
	var arr: Array[String] = []
	var pickable_traits: Array[GuestTrait] = traits.duplicate()
	
	var request_depth: int = 0
	
	while pickable_traits.size() > 0 and request_depth < MAX_REQUEST_DEPTH:
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
		push_error("attempted to get happiness rating of guest without a room")
		return -1
	
	# if a trait has this flag, ignore sanitation
	var ignore_sanitation: float = false
	var rating: float = initial_rating
	fail_feedback.clear()
	
	for guest_trait: GuestTrait in traits:
		if not guest_trait.condition.is_valid(): continue
		if guest_trait.tags.has(TraitList.Tag.IGNORE_DEFAULT_SANITATION): ignore_sanitation = true
		guest_trait.check_condition(room)
		if not guest_trait.met:
			var effective_preference: float = guest_trait.preference
			if room.perks.has(Room.Perk.BATH): effective_preference = max(0, effective_preference- 0.1)
			rating -= effective_preference
			if guest_trait.fail_feedback != "": fail_feedback.push_back(guest_trait.fail_feedback)
	
	# deduct 1 star for each sanitation issue
	if not ignore_sanitation:
		if room.sanitation == Room.Sanitation.DIRTY: happiness_rating -= 2
		elif room.sanitation == Room.Sanitation.MESSY: happiness_rating -= 1
	
	happiness_rating = max(0, rating)
	return happiness_rating

func instantiate_scene() -> Node2D:
	if scene == null:
		push_error("No guest scene for guest")
		return null
	
	node = scene.instantiate()
	node.sprite_offset = sprite_offset
	return node

func _to_string() -> String:	
	return "(Guest) " + name + " Traits: " + str(traits);

# constructed by guest_list class
