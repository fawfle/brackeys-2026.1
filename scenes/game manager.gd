extends Node2D

var day: int = 0

var hotel: Hotel = Hotel.new()

var guest_queue: Array[Guest] = []

func _ready() -> void:
	# load guests and traits. The lists act as global constants
	TraitList.LOAD_TRAITS()
	GuestList.LOAD_GUESTS()

func begin_day() -> void:
	guest_queue = make_guest_queue()

func make_guest_queue() -> Array[Guest]:
	var queue: Array[Guest] = [];
	
	return queue;
