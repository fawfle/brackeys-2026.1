class_name GuestList

enum {
	SCENE, ## Scene to load for guest. Consists of sprite, possibly more.
	DEFAULT_TRAITS,	## Default traits always given to a guest.
	GREETING, ## Message sent on greeting before request.
	GOODBYE, ## Message sent when leaving
	HAPPY_GOODBYE, ## Message sent when leaving very happy
	ANGRY_GOODBYE, ## Message sent when leaving angry
	MONEY, ## how much money they initially have
	APPEAR_AFTER, ## Threshold to not appear before a certain day. For gating guests after unlocks.
	EVENT, ## Mark a guest as an "event" type. They won't be added to any normal guest queues.
}

static var GUESTS_DATA: Dictionary[String, Dictionary] = {
	"four_eyes": {
		SCENE: preload("res://scenes/characters/four_eyes.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CLEAN],
		GREETING: ["Hello, this is my first line of greeting.", "glorbo glub shclaoindsf sadfo. This is my second line!"],
		GOODBYE: "Goodbye",
		HAPPY_GOODBYE: "I was so happy. Goodbye.",
		ANGRY_GOODBYE: "I am angry and goodbying",
		MONEY: 10,
	},
	"hazmat": {
		SCENE: preload("res://scenes/characters/hazmat.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.RADIOACTIVE],
		GREETING: ["Hazmat!!!", "You look silly!"],
		GOODBYE: "Hazmat out!",
		HAPPY_GOODBYE: "I was so happy. Goodbye.",
		ANGRY_GOODBYE: "I am angry and goodbying",
		MONEY: 10,
	},
	"mono": {
		SCENE: preload("res://scenes/characters/mono.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.GENEROUS],
		GREETING: ["_ _  _ __ __  _ _  _ __ _ _  _ __ _ _  __  _ __  __ _ __  _  __ _ __ __  __ __ __  _ _ __  __ _ _ _  _  __ _ __ _  __ __ __  __ __  _  _ __", "_ _ _  _ __ __ _  _ __  __ _ __ _  _  __ _ _ _  _ __  __ _ _ _  __ _ __ __  _ __ _ __ _ __"], # "i will make you become a space baby" in morse code
		GOODBYE: "_ _ __ _  _ __  _ __ _  _  __ __  _  _ __ _ _  _ __ _ _  _ __ _ __ _ __", # farewell.
		HAPPY_GOODBYE: "_ _  _ __  __ __  _ __ __ _  _ __ _ _  _  _ __  _ _ _  _  __ _ _  _ __ _ __ _ __", # I am pleased.
		ANGRY_GOODBYE: "_ _  _ _ _ _  _ __  _-  _  __ _ __ __  __ __ __  _ _ __  _ __ _ __ _ __", # I hate you.
		MONEY: 10,
	},
	"newt": {
		SCENE: preload("res://scenes/characters/newt.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.MESSY],
		MONEY: 10,
		
		
	}
}

static var GUESTS: Dictionary[String, Guest]
static var SPECIAL_GUESTS: Dictionary[String, Guest]

## static loader function to load GUESTS from GUESTS_DATA
static func LOAD_GUESTS():
	GUESTS.clear()
	
	for key in GUESTS_DATA.keys():
		var data: Dictionary = GUESTS_DATA.get(key)
		
		var guest = Guest.new();
		
		guest.name = key
		
		if data.has(SCENE): guest.scene = data.get(SCENE)
		if data.has(DEFAULT_TRAITS): guest.default_traits.assign(data.get(DEFAULT_TRAITS))
		
		if data.has(GREETING): guest.greeting.assign(get_as_array(data, GREETING))
		if data.has(GOODBYE): guest.goodbye.assign(get_as_array(data, GOODBYE))
		if data.has(ANGRY_GOODBYE): guest.angry_goodbye.assign(get_as_array(data, ANGRY_GOODBYE))
		if data.has(HAPPY_GOODBYE): guest.happy_goodbye.assign(get_as_array(data, HAPPY_GOODBYE))
		
		if data.has(MONEY): guest.money = data.get(MONEY)
		
		if data.has(APPEAR_AFTER): guest.appear_after_day = data.get(APPEAR_AFTER)
		
		## special guests
		if data.has(EVENT):
			SPECIAL_GUESTS.set(key, guest)
		else:
			GUESTS.set(key, guest)

# TODO: Add feature to stop duplicate guests, probably a recent_guest list
static func create_guest_queue(length: int, current_day: int) -> Array[Guest]:
	var guest_queue: Array[Guest] = [];
	
	for _i in range(100):
		var guest = GUESTS.values().pick_random()
		
		if guest.appear_after_day > current_day: continue
		if guest_queue.has(guest): continue
		
		guest_queue.push_back(guest)
		
		if guest_queue.size() >= length:
			return guest_queue
		
	push_error("create_guest_queue exceeded max iterations and did not meet length:  " + str(length))
	
	return guest_queue;

static func get_as_array(data: Dictionary, key) -> Array[String]:
	var ret: Array[String] = []
	
	if data.get(key) is Array:
		ret.assign(data.get(key))
		return ret

	ret.push_back(data.get(key))
	return ret;
