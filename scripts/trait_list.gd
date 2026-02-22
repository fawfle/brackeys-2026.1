class_name TraitList

enum {
	NAME, ## name of trait, for internal reference
	CONDITION, ## Function that must be true for condition to be met.
	REQUEST, ## Text to hit at request
	APPLY_TYPE, ## When to apply
	FAIL_FEEDBACK, ## response given of fail
	ON_ENTER, ## Function applied after guest is assigned. EX making neighbors RADIOACTIVE
	ON_LEAVE, ## Function applied after guest leaves. EX making room very messy.
	PREFERENCE, ## How much guest cares. Determines point deduction for failing.
	BLACKLIST, ## Traits that are mutually exclusive.
	TAGS, ## Tags
	SPECIAL, ## don't assign randomly
	VALUE, ## money value to add to guest total money
	APPEAR_AFTER ## day to wait to appear after
}

## trait name for comparisons between traits. KEY to make traits more easily viewable in editor
enum Trait {
	CLEAN, ## likes clean
	MESSY, ## likes messy
	CLASSY, ## likes classy
	SIMPLE, ## likes normal
	CHEAP, ## likes cheap
	
	ACROPHOBIA, ## afraid of heights, wants floor 0
	VIEW_SEEKER, ## wants top floor
	
	SHY, ## doesn't want neighbors
	SOCIAL, ## wants neighbors
	
	CLAUSTROPHOBIC, ## wants big
	AGORAPHOBIA, ## wants small
	
	LEFT_HANDED, ## wants a room on the left
	RIGHT_HANDED, ## wants a room on the right
	
	CENTRIST, ## wants a center room
	
	RADIOACTIVE, # makes surrounding guests/rooms less happy TODO
}

enum Tag {
	IGNORE_DEFAULT_SANITATION ## don't apply normal sanitation happiness
}

## dictionary of data for traits
static var TRAIT_DATA: Dictionary[Trait, Dictionary] = {
	Trait.CLEAN: {
		NAME: "Clean",
		REQUEST: "I prefer rooms that are [color=red]clean[/color].",
		FAIL_FEEDBACK: "The room you gave me was so [color=red]messy[/color].",
		CONDITION: func(room: Room): return room.sanitation == Room.Sanitation.CLEAN,
		PREFERENCE: 3,
		VALUE: 5,
		TAGS: [Tag.IGNORE_DEFAULT_SANITATION],
		BLACKLIST: [Trait.MESSY]
	},
	Trait.MESSY: {
		NAME: "Messy",
		REQUEST: "I hope you're not a [color=red]neat freak[/color].",
		FAIL_FEEDBACK: "You're so [color=red]uptight[/color]!",
		CONDITION: func(room: Room): return room.sanitation != Room.Sanitation.CLEAN,
		ON_LEAVE: func(room: Room): room.sanitation = Room.Sanitation.DIRTY,
		PREFERENCE: 2,
		VALUE: 3,
		TAGS: [Tag.IGNORE_DEFAULT_SANITATION],
		BLACKLIST: [Trait.CLEAN]
	},
	Trait.CLASSY: {
		NAME: "Classy",
		REQUEST: "Put me in one of your [color=red]finest quarters[/color].",
		FAIL_FEEDBACK: "Do you take me for a [color=red]peon[/color]?",
		CONDITION: func(room: Room): return room.quality == Room.Quality.CLASSY,
		PREFERENCE: 3,
		VALUE: 10,
		BLACKLIST: [Trait.CHEAP, Trait.SIMPLE]
	},
	Trait.SIMPLE: {
		NAME: "Simple",
		REQUEST: "I'm looking for something [color=red]simple[/color].",
		FAIL_FEEDBACK: "This place is [color=red]too fancy[/color]. I wanted something that felt like home.",
		CONDITION: func(room: Room): return room.quality == Room.Quality.DUMP,
		PREFERENCE: 3,
		VALUE: 2,
		BLACKLIST: [Trait.CLASSY, Trait.CHEAP]
	},
	Trait.CHEAP: {
		NAME: "Cheap",
		REQUEST: "Don't [color=red]charge me[/color] too much.",
		FAIL_FEEDBACK: "You charged me [color=red]way too much[/color] for that room! How will I pay my space depts now?",
		CONDITION: func(room: Room): return room.quality == Room.Quality.DUMP,
		PREFERENCE: 3,
		VALUE: 2,
		BLACKLIST: [Trait.CLASSY, Trait.SIMPLE]
	},
	Trait.ACROPHOBIA: {
		NAME: "Acrophobia",
		REQUEST: "I'm a little afraid of [color=red]heights[/color].",
		FAIL_FEEDBACK: "I was [color=red]so high[/color]! Were you trying to kill me?",
		CONDITION: func(room: Room): return room.on_ground_floor(),
		PREFERENCE: 3,
		VALUE: 4,
		BLACKLIST: [Trait.CLASSY]
	},
	Trait.VIEW_SEEKER: {
		NAME: "View Seeker",
		REQUEST: "Give me your [color=red]highest[/color] room.",
		FAIL_FEEDBACK: "I couldn't see anything. The stars were so [color=red]far away[/color].",
		CONDITION: func(room: Room): return room.on_top_floor(),
		PREFERENCE: 3,
		VALUE: 4,
		BLACKLIST: [Trait.CLASSY]
	},
	Trait.SHY: {
		NAME: "Shy",
		REQUEST: "I don't do well in [color=red]big[/color] crowds.",
		FAIL_FEEDBACK: "There were [color=red]too many people[/color], I couldn't focus.",
		CONDITION: func(room: Room): return not room.get_floor_neighbors().any(func(r: Room): return r.guest != null),
		APPLY_TYPE: GuestTrait.ApplyType.ALWAYS,
		PREFERENCE: 3,
		VALUE: 4,
		BLACKLIST: [Trait.SOCIAL]
	},
	Trait.SOCIAL: {
		NAME: "Social",
		REQUEST: "I want to be [color=red]around others[/color].",
		FAIL_FEEDBACK: "[color=red]No one[/color] was around. It was sooooo boring!",
		CONDITION: func(room: Room): return room.get_floor_neighbors().all(func(r: Room): return r.guest != null),
		APPLY_TYPE: GuestTrait.ApplyType.ALWAYS,
		PREFERENCE: 3,
		VALUE: 4,
		BLACKLIST: [Trait.SHY]
	},
	Trait.CLAUSTROPHOBIC: {
		NAME: "Claustrophobic",
		REQUEST: "I want a really [color=red]large room[/color].",
		FAIL_FEEDBACK: "It was [color=red]too small[/color], I couldn't move around at all!",
		CONDITION: func(room: Room): return room.room_size == Room.RoomSize.LARGE,
		PREFERENCE: 3,
		VALUE: 4,
		BLACKLIST: [Trait.AGORAPHOBIA]
	},
	Trait.AGORAPHOBIA: {
		NAME: "Agoraphobia",
		REQUEST: "I want a really [color=red]small room[/color].",
		FAIL_FEEDBACK: "It was [color=red]too big[/color], what would I need that space for?",
		CONDITION: func(room: Room): return room.room_size == Room.RoomSize.SMALL,
		PREFERENCE: 3,
		VALUE: 4,
		BLACKLIST: [Trait.CLAUSTROPHOBIC]
	},
	Trait.LEFT_HANDED: {
		NAME: "LeftHanded",
		REQUEST: "By the way, I'm [color=red]left[/color] handed.",
		FAIL_FEEDBACK: "I wasn't happy with that room so I [color=red]left[/color].",
		CONDITION: func(room: Room): return room.on_left(),
		PREFERENCE: 3,
		VALUE: 4,
		BLACKLIST: [Trait.RIGHT_HANDED, Trait.CENTRIST]
	},
	Trait.RIGHT_HANDED: {
		NAME: "RightHanded",
		REQUEST: "I'm [color=red]right[/color] handed.",
		FAIL_FEEDBACK: "You're clearly not feeling [color=red]right[/color].",
		CONDITION: func(room: Room): return room.on_right(),
		PREFERENCE: 3,
		VALUE: 4,
		BLACKLIST: [Trait.RIGHT_HANDED, Trait.CENTRIST]
	},
	Trait.CENTRIST: {
		NAME: "Centrist",
		REQUEST: "I'm always [color=red]middle[/color] of the road.",
		FAIL_FEEDBACK: "You're too [color=red]extreme[/color] for me.",
		CONDITION: func(room: Room): return room.in_center(),
		PREFERENCE: 3,
		VALUE: 4,
		BLACKLIST: [Trait.RIGHT_HANDED, Trait.CENTRIST]
	},
	Trait.RADIOACTIVE: { ## TODO, make neighboring guests radioactive decreasing happiness by 1
		NAME: "Radioactive",
		REQUEST: "Everyone around me so [color=green]green[/color].",
		ON_ENTER: func(room: Room): return,
		VALUE: 10,
		SPECIAL: true
	},
}

static var TRAITS: Dictionary[Trait, GuestTrait]

## static loader function to load traits from TRAIT_DATA
static func LOAD_TRAITS():
	TRAITS.clear()
	for key in TRAIT_DATA.keys():
		var data: Dictionary = TRAIT_DATA[key];
		
		var guest_trait: GuestTrait = GuestTrait.new();
		if data.has(NAME): guest_trait.name = data.get(NAME)
		if data.has(CONDITION): guest_trait.condition = data.get(CONDITION)
		if data.has(REQUEST): guest_trait.request = data.get(REQUEST)
		if data.has(FAIL_FEEDBACK): guest_trait.fail_feedback = data.get(FAIL_FEEDBACK)
		if data.has(PREFERENCE): guest_trait.preference = data.get(PREFERENCE)
		if data.has(ON_ENTER): guest_trait.on_enter = data.get(ON_ENTER)
		if data.has(ON_LEAVE): guest_trait.on_leave = data.get(ON_LEAVE)
		if data.has(VALUE): guest_trait.value = data.get(VALUE)
		if data.has(BLACKLIST): guest_trait.blacklisted_traits.assign(data.get(BLACKLIST))
		
		if data.has(TAGS): guest_trait.tags.assign(data.get(TAGS))
		
		if data.has(SPECIAL): guest_trait.special = data.get(SPECIAL)
		
		if data.has(APPLY_TYPE): guest_trait.apply_type = data.get(APPLY_TYPE)
		
		guest_trait.enum_key = key
		
		TRAITS.set(key, guest_trait);
	
	if TRAITS.size() != Trait.size():
		push_error("Number of defined traits is not equal to Trait enum keys")

## set guest traits of a guest
static func set_guest_traits(guest: Guest, trait_count: int):
	# sets default traits. Possibly better to preload? I don't think it should affect performance though, just dictionary lookup.
	guest.traits.clear()
	for t: Trait in guest.default_traits:
		guest.traits.push_back(TRAITS.get(t))
	
	for i in range(trait_count):
		var guest_trait: GuestTrait = get_valid_trait(guest)
		guest.traits.push_back(guest_trait)

## Maximum recursive depth for get_valid_trait.
const MAX_DEPTH: int = 100

## returns a valid trait according to guest's current trait_list
static func get_valid_trait(guest: Guest, depth: int = 0) -> GuestTrait:
	if depth >= MAX_DEPTH: return null
	
	var random_trait: Trait = TRAITS.keys().pick_random()
	
	# check trait conflicts
	for t: GuestTrait in guest.traits:
		if t == null:
			push_error("Guest trait is null")
		if TRAITS.get(random_trait).special or t == null or t.enum_key == random_trait or t.blacklisted_traits.has(random_trait):
			return get_valid_trait(guest, depth + 1)
	
	return TRAITS.get(random_trait)
