class_name GuestList

enum {
	## Scene to load for guest. Consists of sprite, possibly more.
	SCENE,
	## Default traits always given to a guest.
	DEFAULT_TRAITS,
	## Message sent on greeting before request.
	GREETING,
	## Message sent when leaving
	GOODBYE,
	## Message sent when leaving very happy
	HAPPY_GOODBYE,
	## Message sent when leaving angry
	ANGRY_GOODBYE,
	## Threshold to not appear before a certain day. For gating guests after unlocks.
	APPEAR_AFTER,
	## Mark a guest as an "event" type. They won't be added to any normal guest queues.
	EVENT,
}

static var GUESTS_DATA: Dictionary[String, Dictionary] = {
	"four_eyes": {
		SCENE: preload("res://scenes/characters/four_eyes.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.NEAT],
		GREETING: "Hello",
		GOODBYE: "Goodbye",
		HAPPY_GOODBYE: "I was so happy. Goodbye.",
		ANGRY_GOODBYE: "I am angry and goodbying",
	}
}

static var GUESTS: Array[Guest] = []
static var SPECIAL_GUESTS: Dictionary[String, Guest]

static func LOAD_GUESTS():
	GUESTS.clear()
	
	for key in GUESTS_DATA.keys():
		var data: Dictionary = GUESTS_DATA.get(key)
		
		var guest = Guest.new();
		
		if data.has(SCENE): guest.scene = data.get(SCENE)
		if data.has(DEFAULT_TRAITS): guest.default_traits.assign(data.get(DEFAULT_TRAITS))
		if data.has(GREETING): guest.greeting = data.get(GREETING)
		if data.has(GOODBYE): guest.goodybye = data.get(GOODBYE)
		if data.has(ANGRY_GOODBYE): guest.angry_goodbye = data.get(ANGRY_GOODBYE)
		if data.has(APPEAR_AFTER): guest.appear_after_day = data.get(APPEAR_AFTER)
		
		## special guests
		if data.has(EVENT):
			SPECIAL_GUESTS.set(key, guest)
		else:
			GUESTS.push_back(guest)

# TODO: Add feature to stop duplicate guests, probably a recent_guest list
static func create_guest_queue(length: int, current_day: int) -> Array[Guest]:
	var guest_queue: Array[Guest] = [];
	
	for _i in range(100):
		var guest = GUESTS.pick_random()
		
		if guest.appear_after_day > current_day: continue
		if guest_queue.has(guest): continue
		
		guest_queue.push_back(guest)
		
		if guest_queue.size() >= length:
			return guest_queue
		
	push_error("create_guest_queue exceeded max iterations and did not meet length:  " + str(length))
	
	return guest_queue;
