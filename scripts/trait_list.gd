class_name TraitList

enum {
	NAME,
	CONDITION,
	ON_LEAVE,
	PREFERENCE,
	BLACKLIST
}

enum Trait {
	NEAT,
	SLOB
}

## dictionary of data for traits
static var TRAIT_DATA: Dictionary[Trait, Dictionary] = {
	Trait.NEAT: {
		NAME: "Neat",
		CONDITION: func(room: Room): return room.sanitation == Room.Sanitation.CLEAN,
		PREFERENCE: GuestTrait.Preference.HIGH,
		BLACKLIST: [Trait.SLOB]
	},
	Trait.SLOB: {
		NAME: "Slob",
		CONDITION: func(room: Room): return room.sanitation == Room.Sanitation.MESSY,
		PREFERENCE: GuestTrait.Preference.MEDIUM,
		ON_LEAVE: func(room: Room): room.sanitation = Room.Sanitation.MESSY,
		BLACKLIST: [Trait.NEAT]
	}
}

static var TRAITS: Dictionary[Trait, GuestTrait]

static func LOAD_TRAITS():
	TRAITS.clear()
	for key in TRAIT_DATA.keys():
		var data: Dictionary = TRAIT_DATA[key];
		
		var guest_trait: GuestTrait = GuestTrait.new();
		if data.has(NAME): guest_trait.name = data.get(NAME)
		if data.has(CONDITION): guest_trait.condition = data.get(CONDITION)
		if data.has(PREFERENCE): guest_trait.preference = data.get(PREFERENCE)
		if data.has(ON_LEAVE): guest_trait.on_leave = data.get(ON_LEAVE)
		if data.has(BLACKLIST): guest_trait.blacklisted_traits = data.get(BLACKLIST)
		
		TRAITS.set(key, guest_trait);
