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
	"Four Eyes": { #Michael write this! 
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
		REJECTED_GOODBYE: "Y-you must be o-one of them...",
		MONEY: 10,
	},
	"Octovee": {
		SCENE: preload("res://scenes/characters/octovee.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CLASSY],
		GREETING: ["Hey friend, I'm in town for the day and I'll need a place to crash.", "Lotsa work to do, so don't keep me waiting..."],
		GOODBYE: "Thanks for the room, friend.",
		HAPPY_GOODBYE: "Fancy stuff, friend. I'll keep this place in mind...",
		ANGRY_GOODBYE: "Not a fan, friend. I expect better from this fine establishment.",
		REJECTED_GOODBYE: "Alright. Keep your rooms. I didn't want them anyway.",
		MONEY: 10,
	},
	"Gobby": {
		SCENE: preload("res://scenes/characters/gobby.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.SHY],
		GREETING: ["H-hullo. Can I get a room?", "I'm not looking for anything fancy... or too big..."],
		GOODBYE: "Many thankses. G-goodbye.",
		HAPPY_GOODBYE: "Thank you so much for the room! I'm just chuffed to bits!",
		ANGRY_GOODBYE: "T-thank you for t-the room, but... I didn't... like it...",
		REJECTED_GOODBYE: "T-that's fine. I wouldn't w-want me in a room either...",
		MONEY: 10,
	},
	"Bumpling": {
		SCENE: preload("res://scenes/characters/bumpling.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CLAUSTROPHOBIC],
		GREETING: ["Heyo... Can I get a ruh-ruh-rooooom?", "Looking for something good, I know you won't lemme down here."],
		GOODBYE: "Big thanks, big fella",
		HAPPY_GOODBYE: "You've got a big heart, big fella. Grande service here.",
		ANGRY_GOODBYE: "You've made me feel so small...",
		REJECTED_GOODBYE: "Not enough room for my awesomeness?? Understandable.",
		MONEY: 10,
	},
	"Flibi": {
		SCENE: preload("res://scenes/characters/flibi.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CLEAN],
		GREETING: ["Hiiiii. One hotel room, please!", "My friends told me this was the best hotel in this star system."],
		GOODBYE: "Thanks for the room. Coulda been better, but a girl can't be too picky",
		HAPPY_GOODBYE: "Perfect room! Not a fly in sight! Except me, of course.", 
		ANGRY_GOODBYE: "The room was covered in bugs. I'll take my buzzness elsewhere",
		REJECTED_GOODBYE: "Didn't know pest control was so important here...", 
		MONEY: 10,
	},
	"Gurgario": {
		SCENE: preload("res://scenes/characters/gurgario.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CENTRIST],
		GREETING: ["What's looking, good cooking. Got a room for lil ol me?", "Need a place to sleep and the alley dumpsters were full."],
		GOODBYE: "So long, and thanks for all the room.",
		HAPPY_GOODBYE: "Good stuff. Good bed. Generally good overall.", 
		ANGRY_GOODBYE: "Someone left scratch marks all over the room. Wasn't me.", 
		REJECTED_GOODBYE: "Maybe those dumpsters have some room after all...",
		MONEY: 10,
	},
	"Lewis": {
		SCENE: preload("res://scenes/characters/lewis.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.LEFT_HANDED],
		GREETING: ["LEEEEFT!!!!!!", "LET'S GOOOO LEFT!!!!!"],
		GOODBYE: "My time is up, so I LEEEEEEFT!!!!", 
		HAPPY_GOODBYE: "Great room! I LEEEEEFTTT it in great condition!",
		ANGRY_GOODBYE: "That room was terrible... There's nothing LEEEEFTTT here for me...",
		REJECTED_GOODBYE: "I guess you'd prefer if I LEEEEFTTTT!!!!",
		MONEY: 10,
	},
	"Oney": {
		SCENE: preload("res://scenes/characters/oney.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CLAUSTROPHOBIC],
		GREETING: ["Greetings. I am the leader of a great clan of space ogres.", "But they never tell you how annoying clans are. I seriously need a break."],
		GOODBYE: "The shelter is much appreciated. Have a good day.",
		HAPPY_GOODBYE: "I haven't slept that good in years. I should do this more often.",
		ANGRY_GOODBYE: "I never knew solitude could be worse than a crowd. This is a learning experience.",
		REJECTED_GOODBYE: "So be it. Jerk.",
		MONEY: 10,
	},
	"Pedro": {
		SCENE: preload("res://scenes/characters/pedro.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.AGORAPHOBIA],
		GREETING: ["Hey-lo! I'm in town for an important business appointment and I need to hotel."],
		GOODBYE: "Off to my busyness check-in! Wish me fortune!",
		HAPPY_GOODBYE: "Ah yes, good hoteling! I will give you five gas giants as a reward.",
		ANGRY_GOODBYE: "This hostel is a bad habitat. My real mustache has never been more frightened!",
		REJECTED_GOODBYE: "My appointment is in 20 minutes anyway...",
		MONEY: 10,
	},
	

	"Manny": {
		SCENE: preload("res://scenes/characters/manny.tscn"),
		GREETING: [
			"Hello and welcome to [color=00BFFF]Single Star Hotel[/color]! Where customer satisfaction is our single priority!",
			"You must be new here! Welcome to your first day on the job! Allow me to explain to you how things work!",
			"When a guest is in front of you, click on one of the rooms! Then click the bell to assign them to that room!",
			"If you don't have enough space for them, or you simply don't like them, hit the button under your desk!",
			"Do remember, we are running a hotel here! Most guests don't want a dirty room! To clean a room, simply hold down on said room!",
			"All guests have specific requests! Try to meet them for a [color=00BFFF]5 star[/color] rating! Happy guests pay more! Guests with specific needs usually pay extra!",
			"Corporate won't be happy if you do that! Don't worry, I won't say anything! I understand the struggle!",
			"Guests will trickle in throughout the day and checkout in the morning! Remember, we're running on a [color=red]real clock[/color] here! Don't waste time.",
			"If business is slow, you can play on your company mandated [color=00BFFF]SolarBoy[/color]! Just click and hold and time will just pass by!",
			"Trust me, it will save a lot of your sanity!",
			"Once you feel ready put me in a [color=red]clean[/color] room!"
		],
		MONEY: 25,
		EVENT: true,
		APPEAR_ON_DAY: 0,
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
		if guest_blacklist.has(guest): continue
		
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
