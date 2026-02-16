class_name GuestList

enum {
	SCENE,
	DEFAULT_TRAITS,
	APPEAR_AFTER,
	EVENT,
}

static var GUESTS_DATA: Dictionary[String, Dictionary] = {
	"four_eyes": {
		SCENE: preload("res://scenes/characters/four_eyes.tscn"),
		DEFAULT_TRAITS: [TraitList.Trait.NEAT],
	}
}

static var GUESTS: Array[Guest]

static func LOAD_GUESTS():
	GUESTS.clear()
	
	for key in GUESTS_DATA.keys():
		var data: Dictionary = GUESTS_DATA.get(key)
		
		var guest = Guest.new();
		
		if data.has(SCENE): guest.scene = data.get(SCENE)
		if data.has(DEFAULT_TRAITS): guest.default_traits = data.get(DEFAULT_TRAITS)
		
		GUESTS.push_back(guest)
