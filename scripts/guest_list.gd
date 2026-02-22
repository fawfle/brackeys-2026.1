class_name GuestList

enum {
	NAME, ## name. If not specified, will be key
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
	STOP_TIME, ## should this guest stop time when active
	SPRITE_OFFSET, ## amnt to offset sprite in guestparent
}

static var GUESTS_DATA: Dictionary[String, Dictionary] = {
	"Four Eyes": {
		SCENE: preload("res://scenes/characters/four_eyes.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CLEAN],
		GREETING: ["Hello, one of my eyes can see my name behind there, how did you get my name?", "Besides the point. My eyes need a space to close!"],
		GOODBYE: "I feel well rested.",
		HAPPY_GOODBYE: "I am tearimg up from ecstasy, thank you!",
		ANGRY_GOODBYE: "I couldn't get a wink of sleep!",
		REJECTED_GOODBYE: "I can see that you don't want me here, I'll take my leave.",
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
		DEFAULT_TRAITS: [TraitList.Trait.SHY],
		GREETING: ["H-hey. Looking for a p-p-place to lay low for a-a while.", "Think you can hook m-me up?"],
		GOODBYE: "T-t-t-thanks, c-comrade. See you l-later... or not...",
		HAPPY_GOODBYE: "Perfectly secure. You must be one of us. Long live the Brotherhood, and never forget that they're out there...",
		ANGRY_GOODBYE: "S-s-s-s-so m-many ey-eyes watchimg m-me. I n-need to go.",
		REJECTED_GOODBYE: "Y-you must be o-one of them...",
		MONEY: 10,
	},
	"Octovee": {
		SCENE: preload("res://scenes/characters/octovee.tscn"),
		DEFAULT_TRAITS: [],
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
	"Manny": {
		SCENE: preload("res://scenes/characters/manny.tscn"),
		GREETING: [
			"Hello and welcome to [color=00BFFF]Single Star Hotel[/color]! Where customer satisfaction is our single priority!",
			"You must be new here! Welcome to your first day on the job! Allow me to explain to you how things work!",
			"When a guest is in front of you, click on one of the rooms! Then click the bell to assign them to that room!",
			"If you don't have enough space for them, or you simply don't like them, hit the button under your desk!",
			"Corporate won't be happy if you do that! Don't worry, I won't say anything! I understand the struggle!",
			"Do remember, we are running a hotel here! Most guests don't want a dirty room! To clean a room, simply hold down on said room!",
			"All guests have specific requests! Try to meet them for a [color=00BFFF]5 star[/color] rating! Happy guests pay more! Guests with specific needs usually pay extra!",
			"The longer a guest stays, the more they will pay, and they will only stay if they are comfortable!",
			"Guests will trickle in throughout the day and checkout in the morning! Remember, we're running on a [color=red]real clock[/color] here! Don't waste time.",
			"If business is slow, you can play on your company mandated [color=00BFFF]SolarBoy[/color]! Just click and hold and time will just pass by!",
			"Trust me, it will save a lot of your sanity!",
			"Don't forget, you can improve your hotel! Just remember to click off of a room first!",
			"Once you feel ready put me in a [color=red]clean[/color] room!"
		],
		GOODBYE: [
			"That was fine I guess, you could probably do better.",
			"Either way, you have 30 days until your performance review! If you meet quota, you can become a [color=00BFFF]Star[/color] employee!",
			],
		HAPPY_GOODBYE: [
			"That was exquisite! You'll truly manage this hotel perfectly!",
			"Either way, you have 30 days until your performance review! If you meet quota, you can become a [color=00BFFF]Star[/color] employee!",
			"I'm not worried about you though! You got this!"
			],
		ANGRY_GOODBYE: [
			"what are you doing? you realize you need to [color=red]MAKE[/color] your guests feel [color=red]GOOD[/color] to get [color=red]MONEY[/color] and good [color=red]REVIEWS[/color]",
			"Either way, you have 30 days until your performance review! If you meet quota, you can become a [color=00BFFF]Star[/color] employee!",
			"if you don't focus, you will not be making quota. get it together."
			],
		REJECTED_GOODBYE: [
			"you realize there is a timer, right? i understand you may not like our guests, but at least work with me here.",
			"Either way, you have 30 days until your performance review! If you meet quota, you can become a [color=00BFFF]Star[/color] employee!",
			"just keep an eye on the clock next time. if you don't focus, you're gone."
			],
		MONEY: 25,
		EVENT: true,
		APPEAR_ON_DAY: 0,
		STOP_TIME: true,
	},
	"Manny 2": {
		NAME: "Manny",
		SCENE: preload("res://scenes/characters/manny.tscn"),
		GREETING: [
			"Hello, I have returned for your quota! Have you been a good employee?"
		],
		GOODBYE: [
			"That was fine I guess, you could probably do better.",
			"Either ways, you have 30 days until you're performace review! If you meet quota, you can become a [color=00BFFF]Star[/color] employee!",
			],
		HAPPY_GOODBYE: [
			"That was exquisite! You'll truly mamge this hotel perfectly!",
			"Either ways, you have 30 days until you're performace review! If you meet quota, you can become a [color=00BFFF]Star[/color] employee!",
			"I'm not worried about you though! You got this!"
			],
		ANGRY_GOODBYE: [
			"what are you doing? you realize you need to [color=red]MAKE[/color] your guests feel [color=red]GOOD[/color] to get [color=red]MONEY[/color] and good [color=red]REVIEWS[/color]",
			"Either ways, you have 30 days until you're performace review! If you meet quota, you can become a [color=00BFFF]Star[/color] employee!",
			"if you don't focus, you will not be making quota. get it together."
			],
		REJECTED_GOODBYE: [
			"you realize there is a timer, right? i understand you may not like our guests, but at least work with me here.",
			"Either ways, you have 30 days until you're performace review! If you meet quota, you can become a [color=00BFFF]Star[/color] employee!",
			"just keep an eye on the clock next time. if you don't focus, you're gone."
			],
		MONEY: 0,
		EVENT: true,
		APPEAR_ON_DAY: 31,
		STOP_TIME: true,
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
	"Mr Mestopli": {
		SCENE: preload("res://scenes/characters/mr__mestoplis.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CLEAN],
		GREETING: ["I am requesting one room. If you have any spare employees or annoying collegues send them my way for dinner tonight.",
		"Oh, and do make sure it's actually clean this time."],
		GOODBYE: "Fairwell.", 
		HAPPY_GOODBYE: "I shall see you in the future. I hope you prosper in your ventures!",
		ANGRY_GOODBYE: "Perish.",
		REJECTED_GOODBYE: ["I will cast you to the void! Count your days. You have scorned me for the last time!", 
		"I shall destroy your lineage!", "I will leave you for last so I can see the terror in your eyes when I drink your entire bloodline extinct."],
		MONEY: 10,
	},
	"Mawce": {
		SCENE: preload("res://scenes/characters/mawce.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.SHY],
		GREETING: "Hi, um- Hello? C-can I have a room? Please.",
		GOODBYE: "Um, bye... I guess", 
		HAPPY_GOODBYE: "bye :)",
		ANGRY_GOODBYE: "...",
		REJECTED_GOODBYE: "I'm sorry for bothering you.",
		MONEY: 10,
	},
	"Treebert": {
		SCENE: preload("res://scenes/characters/treebert.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CLAUSTROPHOBIC],
		GREETING: ["Hello, I would like a room, I need one to perform photosynthesis", "I just need a lot of space, you know?"],
		GOODBYE: "Thank you for the space",
		HAPPY_GOODBYE: "I give you a thousand blessings, Namaste",
		ANGRY_GOODBYE: "You won't be getting any oxygen from me",
		REJECTED_GOODBYE: "I'll make like a tree and leaf",
		MONEY: 10,
		SPRITE_OFFSET: Vector2i(0, -20)
	},
	"Bertrum": {
		SCENE: preload("res://scenes/characters/1800s_guy.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.VIEW_SEEKER],
		GREETING: ["Excuse me good friend, I would like some lodging.", "I come from a long away place, so I want to experience new things."],
		GOODBYE: "Farewell, my friend",
		HAPPY_GOODBYE: "That was a tremendous view, good show young chap!",
		ANGRY_GOODBYE: "How incredulous, truly terrible!",
		REJECTED_GOODBYE: "Why I should duel you for this establishment, but I won't... today.",
		MONEY: 10,
		SPRITE_OFFSET: Vector2i(17, -10)
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
	"Plazmotron": {
		SCENE: preload("res://scenes/characters/plazmotron.tscn"),
		DEFAULT_TRAITS: [],
		GREETING: ["SALUTATIONS CARBON-BASED LIFEFORM", "BATTERIES RUNNING LOW: RECHARGE REQUESTED"],
		GOODBYE: "ACTIVATE MONEY DISPENSE", 
		HAPPY_GOODBYE: "SUFFICIENT WORK, ORGANIC SERVANT",
		ANGRY_GOODBYE: "FAILURE TO RECHARGE: EXPECT TERMINATION SOON",
		REJECTED_GOODBYE: "ERROR: NO INTELLIGENT LIFE DETECTED",
		MONEY: 10,
	},
	"Ripley": {
		SCENE: preload("res://scenes/characters/ripley.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.MESSY],
		GREETING: ["Bark!", "Woof woof!"],
		GOODBYE: "Awoooooo!",
		HAPPY_GOODBYE: "Bork bjork! Woof!",
		ANGRY_GOODBYE: "Grrrrrrrr...",
		REJECTED_GOODBYE: "*dejected wimpers*",
		MONEY: 10,
	},
	"Skarr": {
		SCENE: preload("res://scenes/characters/skarr.tscn"),
		DEFAULT_TRAITS: [],
		GREETING: ["'Ey. Got a bounty near here and I needs a place to crash.","Don' worry, I'll make it worth yer while."],
		GOODBYE: "Early bird gets the kill.",
		HAPPY_GOODBYE: "Slept perfectly. This bounty will be easy as pie.",
		ANGRY_GOODBYE: "Gotsa crick in my neck. If I miss my shot, you'll be the one paying for it.",
		REJECTED_GOODBYE: "Yer lucky I'm outta bullets", 
		MONEY: 10,
	},
	"Trooper": {
		SCENE: preload("res://scenes/characters/trooper.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.VIEW_SEEKER],
		GREETING: ["Hello, citizen!","My batallion is launching an attack come daybreak, we need a location for reconnaissance!"],
		GOODBYE: "May strength be with you!",
		HAPPY_GOODBYE: "If fate wills it, we may win this battle yet!",
		ANGRY_GOODBYE: "Morale is low! We are forced to retreat!", 
		REJECTED_GOODBYE: "If only the Space Empire still enforced quartering!",
		MONEY: 10,
	},
	"Xena": {
		SCENE: preload("res://scenes/characters/xena.tscn"),
		DEFAULT_TRAITS: [],
		GREETING: ["Hey-hey!!! I'm literally so jazzed to meet you!", "I'm in town for a hugemongous concert, and I, like, need a room please!"],
		GOODBYE: "Catch you later, b!",
		HAPPY_GOODBYE: "OMG, you are totes getting five stars!",
		ANGRY_GOODBYE: "Ugh, that room sucked! I'm, like, literally dying!!!",
		REJECTED_GOODBYE: "Whatever. You couldn't handle me anyway.",
		MONEY: 10,
	},
	"Birbert": {
		SCENE: preload("res://scenes/characters/birbert.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.SOCIAL],
		GREETING: ["I'm here for the convention on worm rights.", "Give me your chillest room, if you would."],
		GOODBYE: "Catch you later!",
		HAPPY_GOODBYE: "You're an ally, worm rights!",
		ANGRY_GOODBYE: "I don't need your feeder rooms anyways.",
		REJECTED_GOODBYE: "Don't be such a chicken. I'm not robin you.",
		MONEY: 10,
	},
	"Peter": {
		SCENE: preload("res://scenes/characters/peter.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.SHY],
		GREETING: ["Hey man, I need a place to crash.", "I just feel a little worn out."],
		GOODBYE: "Thanks for the place.",
		HAPPY_GOODBYE: "Man, I feel better, I think I'm ready for what's next.",
		ANGRY_GOODBYE: "Hey man, the room was kind of uncool.",
		REJECTED_GOODBYE: "I just don't want to be cooked, you feel me?",
		MONEY: 10,
	},
	"Michael": {
		SCENE: preload("res://scenes/characters/michael.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CLASSY],
		GREETING: ["I'm here for the midnight release of PRODUCT.", "I need a good place to rest before I camp out the local Space Walgreens."],
		GOODBYE: "Thanks for the restful place.",
		HAPPY_GOODBYE: "I am so ready to join the wait for PRODUCT!",
		ANGRY_GOODBYE: "I bet I won't even be third in the queue. Thanks a lot.",
		REJECTED_GOODBYE: "But the line doesn't start till 6 o'clock!",
		MONEY: 10,
	},
	"Mona": {
		SCENE: preload("res://scenes/characters/mona.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CLASSY],
		GREETING: ["I require your finest room."],
		GOODBYE: "Thank you, darling.",
		HAPPY_GOODBYE: "What a lovely hotel! Thank you for your services.",
		ANGRY_GOODBYE: "You ruined my beauty sleep.",
		REJECTED_GOODBYE: "These people! Who dares turn away a beautiful woman such as myself?",
		MONEY: 10,
	},
<<<<<<< HEAD
	"Rudy": {
		SCENE: preload("res://scenes/characters/rudy.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.RIGHT_HANDED],
		GREETING: ["RIIIIGHT!!!!!!", "LET'S GOOOO RIGHT!!!!!"],
		GOODBYE: "!!!!", 
		HAPPY_GOODBYE: "Great room! I made the RIGHT decision staying here!",
		ANGRY_GOODBYE: "That room was terrible... None of the rooms were RIIIGHT for me...",
		REJECTED_GOODBYE: "I guess I'll just go RIIIGHT home!!!!",
		MONEY: 10,
	},
		"Gary": {
		SCENE: preload("res://scenes/characters/gary.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.MESSY],
		GREETING: ["Brooooo, like, do you have a rooooom?"],
		GOODBYE: "See you later", 
		HAPPY_GOODBYE: "I had a greeeat time last night. Best sleep of my liiiife.",
		ANGRY_GOODBYE: "You totally killed my vibe, Bro. Like, how do you ruin sleep?",
		REJECTED_GOODBYE: "Bro, that's like, so not cool.",
		MONEY: 10,
	},
			"The Director": {
		SCENE: preload("res://scenes/characters/the_director.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.CLASSY],
		GREETING: ["I require your finest room. My business is very important"],
		GOODBYE: "Good business.", 
		HAPPY_GOODBYE: "Business business",
		ANGRY_GOODBYE: "You have terrible service. I'm going to make sure that this business fails.",
		REJECTED_GOODBYE: "Fine! I'll just take my business somewhere else!",
		MONEY: 10,
=======
	"Cameron": {
		SCENE: preload("res://scenes/characters/cameron.tscn"),
		DEFAULT_TRAITS: [],
		GREETING: ["Hey man, I got the graveyard shift and this looks like the perfect place to pass out.", "By the by, you housing any criminals? Just asking..."],
		GOODBYE: "Time for another riveting day at work.",
		HAPPY_GOODBYE: "Thanks for the room, man. And all the new leads. Uh, forget I said that.",
		ANGRY_GOODBYE: "I'm watching you, man. Always watching...",
		REJECTED_GOODBYE: "Whatever, man. I'll just sleep in my car.",
		MONEY: 10,
	},
	"Molar": {
		SCENE: preload("res://scenes/characters/molar.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.MESSY],
		GREETING: ["Hey, bestie. Just looking for a place to stay for the night.", "Ball and chain? It's, uhhh... a fashion statement..."],
		GOODBYE: "Thanks. You've helped a lot more than you could ever imagine...",
		HAPPY_GOODBYE: "If I ever need help again, I know you won't let me down.",
		ANGRY_GOODBYE: "Hmmm. You're next, hehehehehe.",
		REJECTED_GOODBYE: "Darn. Couldn't pull the wool over your eyes, huh?",
		MONEY: 0,
>>>>>>> main
	},
}

static var GUESTS: Dictionary[String, Guest]
static var EVENT_GUESTS: Dictionary[String, Guest]

## static loader function to load GUESTS from GUESTS_DATA
static func LOAD_GUESTS():
	GUESTS.clear()
	
	for key in GUESTS_DATA.keys():
		var data: Dictionary = GUESTS_DATA.get(key)
		
		var guest = Guest.new();
		
		if data.get(NAME): guest.name = data.get(NAME)
		else: guest.name = key
		
		if data.has(SCENE): guest.scene = data.get(SCENE)
		if data.has(DEFAULT_TRAITS): guest.default_traits.assign(data.get(DEFAULT_TRAITS))
		
		if data.has(GREETING): guest.greeting.assign(get_as_array(data, GREETING))
		if data.has(GOODBYE): guest.goodbye.assign(get_as_array(data, GOODBYE))
		if data.has(ANGRY_GOODBYE): guest.angry_goodbye.assign(get_as_array(data, ANGRY_GOODBYE))
		if data.has(HAPPY_GOODBYE): guest.happy_goodbye.assign(get_as_array(data, HAPPY_GOODBYE))
		if data.has(REJECTED_GOODBYE): guest.rejected_goodbye.assign(get_as_array(data, REJECTED_GOODBYE))
		
		if data.has(MONEY): guest.money = data.get(MONEY)
		
		if data.has(APPEAR_AFTER): guest.appear_after_day = data.get(APPEAR_AFTER)
		if data.has(STOP_TIME): guest.stop_time = data.get(STOP_TIME)
		
		if data.has(SPRITE_OFFSET): guest.sprite_offset = data.get(SPRITE_OFFSET)
		
		## event guests
		if data.has(EVENT):
			guest.event = data.get(EVENT)
			if data.has(APPEAR_ON_DAY): guest.appear_on_day = data.get(APPEAR_ON_DAY)
			EVENT_GUESTS.set(key, guest)
		else:
			GUESTS.set(key, guest)
	
	print("TOTAL GUESTS LOADED: " + str(GUESTS.size()))

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
