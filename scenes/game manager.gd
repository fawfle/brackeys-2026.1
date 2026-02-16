extends Node2D

@onready var guest_parent: Node2D = $GuestParent

var day: int = 0

var hotel: Hotel = Hotel.new()

var guest_queue: Array[Guest] = []
@export var current_guest: Guest = null

func _ready() -> void:
	# load guests and traits. The lists act as global constants
	TraitList.LOAD_TRAITS()
	GuestList.LOAD_GUESTS()
	
	begin_day()

func begin_day() -> void:
	guest_queue = GuestList.create_guest_queue(1, day)
	manage_next_guest()

func manage_next_guest() -> void:
	# TODO!!!!!! Need to add some fields PROPRETY_USED_STORAGE to resources for copying
	current_guest = guest_queue[0].duplicate_deep()
	guest_queue.pop_front()
	
	# clean children
	for child in guest_parent.get_children(): child.queue_free()
	
	var guest_scene: PackedScene = current_guest.scene
	if guest_scene != null:
		guest_parent.add_child(guest_scene.instantiate())
	else:
		push_error("No guest scene for guest")
