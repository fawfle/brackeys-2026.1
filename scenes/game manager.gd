extends Node2D

@onready var guest_parent: Node2D = $GuestParent

var day: int = 0

var guest_queue: Array[Guest] = []
@export var current_guest: Guest = null
@export var current_guest_node: Node2D = null

var random_trait_count: int = 1

## phase of gameplay. Either assigning (getting guests) or managing (upgrading)
enum Phase {
	CHECKOUT,
	ASSIGNING,
	MANAGING
}

var phase: Phase = Phase.ASSIGNING

func _ready() -> void:
	# load guests and traits. The lists act as global constants
	TraitList.LOAD_TRAITS()
	GuestList.LOAD_GUESTS()
	
	Globals.select_room.connect(on_room_select)
	
	begin_day()

func begin_day() -> void:
	phase = Phase.ASSIGNING
	guest_queue = GuestList.create_guest_queue(1, day)
	manage_next_guest()
	Globals.set_text.emit(current_guest.get_intro_lines())

## Handle the end of the day. Enter upgrade mode
func end_day() -> void:
	pass

func manage_next_guest() -> void:
	if guest_queue.size() <= 0:
		end_day()
		
		begin_day()
		return
	
	current_guest = guest_queue[0].duplicate_deep()
	TraitList.set_guest_traits(current_guest, random_trait_count)
	guest_queue.pop_front()
	
	# clean children
	for child in guest_parent.get_children(): child.queue_free()
	
	# var guest_scene: PackedScene = current_guest.scene
	current_guest_node = current_guest.instantiate_scene()
	guest_parent.add_child(current_guest_node)
	
	if Globals.DEBUG: print("LOADING GUEST: " + str(current_guest))
	
	play_guest_enter_animation(current_guest_node)

## hook for room selection for assigning guest
func on_room_select(room: Room):
	if phase == Phase.ASSIGNING:
		assign_current_guest(room)
	elif phase == Phase.MANAGING:
		manage_room(room)
		

func assign_current_guest(room: Room):
	if room.guest != null or current_guest == null: return
	
	Globals.set_text.emit([] as Array[String])
	room.add_guest(current_guest)
	await play_guest_exit_animation(current_guest_node)
	current_guest = null
	current_guest_node = null
	
	await get_tree().create_timer(0.8).timeout
	
	manage_next_guest()

func manage_room(room: Room):
	pass

func play_guest_enter_animation(guest_node: Node2D):
	var duration: float = 0.8
	
	var start_color: Color = Color("00000000")
	var end_color: Color = Color("ffffffff")
	
	var timer: SceneTreeTimer = get_tree().create_timer(duration)
	
	while timer.time_left != 0:
		guest_node.modulate = end_color.lerp(start_color, timer.time_left / duration)
		await get_tree().process_frame

func play_guest_exit_animation(guest_node: Node2D):
	var duration: float = 0.4
	
	var start_color: Color = Color("ffffffff")
	var end_color: Color = Color("00000000")
	
	var timer: SceneTreeTimer = get_tree().create_timer(duration)
	
	while timer.time_left != 0:
		guest_node.modulate = end_color.lerp(start_color, timer.time_left / duration)
		await get_tree().process_frame
