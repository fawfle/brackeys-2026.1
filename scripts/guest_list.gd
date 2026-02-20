class_name GuestList

enum {
	SCENE, ## Scene to load for guest. Consists of sprite, possibly more.
	DEFAULT_TRAITS,	## Default traits always given to a guest.
	GREETING, ## Message sent on greeting before request.
	GOODBYE, ## Message sent when leaving
	HAPPY_GOODBYE, ## Message sent when leaving very happy
	ANGRY_GOODBYE, ## Message sent when leaving angry
	REJECTED_GOODBYE, ## Message sent when leaving b/c ignored or turned away
	MONEY, ## how much money they initially have
	APPEAR_AFTER, ## Threshold to not appear before a certain day. For gating guests after unlocks.
	EVENT, ## Mark a guest as an "event" type.
	APPEAR_ON_DAY, ## appear on specific day. Only for event types
}

static var GUESTS_DATA: Dictionary[String, Dictionary] = {
	"Four Eyes": {
		SCENE: preload("res://scenes/characters/four_eyes.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CLEAN],
		GREETING: ["Hello, this is my first line of greeting.", "glorbo glub shclaoindsf sadfo. This is my second line!"],
		GOODBYE: "Goodbye",
		HAPPY_GOODBYE: "I was so happy. Goodbye.",
		ANGRY_GOODBYE: "I am angry and goodbying",
		REJECTED_GOODBYE: "I didn't want to stay here anyway.",
		MONEY: 10,
	},
	"Hazmat": {
		SCENE: preload("res://scenes/characters/hazmat.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.RADIOACTIVE],
		GREETING: ["My name are Hazmat!!!", "You looking silly!"],
		GOODBYE: "Me go, you stay!",
		HAPPY_GOODBYE: "Me like bathtub! It is so green now!",
		ANGRY_GOODBYE: "Bed was too soft! Get rid of bed!!!",
		REJECTED_GOODBYE: "you can't see me!!",
		MONEY: 10,
	},
	"Mono": {
		SCENE: preload("res://scenes/characters/mono.tscn"),
		DEFAULT_TRAITS: [],
		GREETING: ["_ _  _ __ __  _ _  _ __ _ _  _ __ _ _  __  _ __  __ _ __  _  __ _ __ __  __ __ __  _ _ __  __ _ _ _  _  __ _ __ _  __ __ __  __ __  _  _ __", "_ _ _  _ __ __ _  _ __  __ _ __ _  _  __ _ _ _  _ __  __ _ _ _  __ _ __ __  _ __ _ __ _ __"], # "i will make you become a space baby" in morse code
		GOODBYE: "_ _ __ _  _ __  _ __ _  _  __ __  _  _ __ _ _  _ __ _ _  _ __ _ __ _ __", # farewell.
		HAPPY_GOODBYE: "_ _  _ __  __ __  _ __ __ _  _ __ _ _  _  _ __  _ _ _  _  __ _ _  _ __ _ __ _ __", # I am pleased.
		ANGRY_GOODBYE: "_ _  _ _ _ _  _ __  _-  _  __ _ __ __  __ __ __  _ _ __  _ __ _ __ _ __", # I hate you.
		REJECTED_GOODBYE: "_ __ _ __ _ __ _ __ _ __ _ __ _ __ _ __ _ __", # ...
		MONEY: 10,
	},
	"Newt": {
		SCENE: preload("res://scenes/characters/newt.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.MESSY],
		GREETING: ["Hello fellow extraterrestrial! I require one lodgement please!", "I urge you to check there are no pesky, killable humans hiding inside."],
		GOODBYE: "Adequate service! Thank you, and don't forget: Kill all humans!",
		HAPPY_GOODBYE: "Exquisite service! May the space-gods smile upon you! Enjoy some space-credits!",
		ANGRY_GOODBYE: "Reprehensible service! Take me to your leader- I mean, manager!",
		REJECTED_GOODBYE: "You must be hiding humans! I'm getting the mothership.",
		MONEY: 10,
	},
	"Norman": {
		SCENE: preload("res://scenes/characters/norman.tscn"),
		DEFAULT_TRAITS: [],
		GREETING: ["'Wassup, homie?' That's how they greet each other on Earth, brah.", "I'd preesh if you could lend me a crib, dawg."],
		GOODBYE: "Peace out, girl scout.",
		HAPPY_GOODBYE: "Best digs I've seen since Roswell. Don't be a stranger, ranger.",
		ANGRY_GOODBYE: "That pad killed my vibes, dude. I'm outtie five thou...",
		REJECTED_GOODBYE: "Not cool man. The service here is out of this world.",
		MONEY: 10,
	},
	"Brainiac": {
		SCENE: preload("res://scenes/characters/brainiac.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CLASSY],
		GREETING: ["Greetings, inferior. I'd like to book one room for personal use.", "I don't want any of that room service crap. Don't mess with me and we won't have issues."],
		GOODBYE: "Au revoir, hotel person.",
		HAPPY_GOODBYE: "I am pleasantly surprised, confrère. Perhaps we're not so different, you and I.",
		ANGRY_GOODBYE: "Hideous, as I expected. Adieu, brainlet.",
		REJECTED_GOODBYE: "Think you're better than me, chump? I'm taking my money somewhere else.",
		MONEY: 10,
	},
	"Sheeple": {
		SCENE: preload("res://scenes/characters/sheeple.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.MESSY],
		GREETING: ["H-hey. Looking for a p-p-place to lay low for a-a while.", "Think you can hook m-me up?"],
		GOODBYE: "T-t-t-thanks, c-comrade. See you l-later... or not...",
		HAPPY_GOODBYE: "Perfectly secure. You must be one of us. Long live the Brotherhood, and never forget that they're out there...",
		ANGRY_GOODBYE: "S-s-s-s-so m-many ey-eyes watchimg m-me. I n-need to go.",
		MONEY: 10,
	},
	"Octovee": {
		SCENE: preload("res://scenes/characters/octovee.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CHEAP],
		GREETING: ["wsg. lookin for a 1337 room for small $$$", "u seem cool lul, gimme somethin gud :)"],
		GOODBYE: "gtg, thx for te room ;D",
		HAPPY_GOODBYE: "10/10. room wuz awsumsauce btw. cul8r :p",
		ANGRY_GOODBYE: "WTF dewd. u think im a n00b or somethn? kys >:(",
		MONEY: 10,
	}
}

static var GUESTS: Dictionary[String, Guest]
static var EVENT_GUESTS: Dictionary[String, Guest]

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
		if data.has(REJECTED_GOODBYE): guest.rejected_goodbye.assign(get_as_array(data, REJECTED_GOODBYE))
		
		if data.has(MONEY): guest.money = data.get(MONEY)
		
		if data.has(APPEAR_AFTER): guest.appear_after_day = data.get(APPEAR_AFTER)
		
		## event guests
		if data.has(EVENT):
			if data.has(APPEAR_ON_DAY): guest.appear_on_day = data.get(APPEAR_ON_DAY)
			EVENT_GUESTS.set(key, guest)
		else:
			GUESTS.set(key, guest)

# TODO: Add feature to stop duplicate guests, probably a recent_guest list
static func create_guest_queue(length: int, current_day: int, guest_blacklist: Array[Guest] = []) -> Array[Guest]:
	var guest_queue: Array[Guest] = [];
	
	# add event guests
	for g: Guest in EVENT_GUESTS.values():
		if g.appear_on_day == current_day:
			guest_queue.push_back(g)
	
	if guest_queue.size() >= length: return guest_queue
	
	for _i in range(100):
		var guest = GUESTS.values().pick_random()
		
		if guest.appear_after_day > current_day: continue
		if guest_queue.has(guest): continue
		if guest_blacklist.any(func(g: Guest): return g.name == guest.name): continue
		
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
