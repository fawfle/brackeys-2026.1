extends Node2D

@onready var guest_parent: Node2D = $GuestParent
@onready var guest_timer: Timer = $GuestTimer

var day: int = 0

var money: int = 0

var guest_assign_queue: Array[Guest] = []
var guest_checkout_queue: Array[Guest] = []
@export var current_guest: Guest = null

var random_trait_count: int = 1
var stay_length_max: int = 1

## phase of gameplay. Either assigning (getting guests),  managing (upgrading), or checkout (guests leaving and paying). ASSIGN -> UPGRADE -> CHECKOUT
enum Phase {
	CHECKOUT,
	ASSIGNING,
	UPGRADING
}

var phase: Phase = Phase.ASSIGNING

func _ready() -> void:
	# load guests and traits. The lists act as global constants
	TraitList.LOAD_TRAITS()
	GuestList.LOAD_GUESTS()
	
	Globals.select_room.connect(on_room_select)
	Globals.text_finished.connect(on_text_finish)
	
	begin_assigning_phase()

func begin_assigning_phase() -> void:
	phase = Phase.ASSIGNING
	guest_assign_queue = GuestList.create_guest_queue(1, day)
	manage_next_guest()

func begin_upgrading_phase() -> void:
	phase = Phase.UPGRADING
	## michael TODO
	end_day()

func begin_checkout_phase() -> void:
	if Globals.DEBUG: print("BEGINNING CHECKOUT PHASE")
	
	phase = Phase.CHECKOUT
	guest_checkout_queue.clear()
	for room: Room in get_rooms():
		if room.guest != null and room.guest.stay_duration <= 0:
			var guest: Guest = room.checkout_guest()
			guest_checkout_queue.push_back(guest)
	
	guest_checkout_queue.shuffle()
	checkout_next_guest()

## Handle the end of the day
func end_day() -> void:
	day += 1
	for room: Room in get_rooms():
		if room.guest != null: room.guest.stay_duration -= 1
	
	Globals.begin_day.emit(day)
	
	begin_checkout_phase()

func manage_next_guest() -> void:
	if guest_assign_queue.size() <= 0:
		begin_upgrading_phase()
		return
	
	current_guest = create_next_guest()
	
	# clean children
	for child in guest_parent.get_children(): child.queue_free()
	
	current_guest.instantiate_scene()
	guest_parent.add_child(current_guest.node)
	
	if Globals.DEBUG: print("LOADING GUEST: " + str(current_guest))
	
	await play_guest_enter_animation(current_guest.node)
	
	Globals.set_text.emit(current_guest.get_intro_lines())

## currently duplicate guests and set traits here. Maybe change in the future if it's confusing.
func create_next_guest() -> Guest:
	var guest: Guest = guest_assign_queue.pop_front().duplicate_deep()
	TraitList.set_guest_traits(guest, random_trait_count)
	return guest

func checkout_next_guest() -> void:
	if guest_checkout_queue.size() <= 0:
		begin_assigning_phase()
		return
	
	current_guest = guest_checkout_queue.pop_front()
	
	if Globals.DEBUG: print("CHECKING OUT: " + str(current_guest))
	
	await play_guest_enter_animation(current_guest.node)
	
	Globals.set_text.emit(current_guest.get_exit_lines())

## checkout guest
func checkout_guest() -> void:
	if current_guest == null:
		return
		
	Globals.set_text.emit()
	var guest_node: Node2D = current_guest.node
	current_guest = null
	await play_guest_exit_animation(guest_node)
	await get_tree().create_timer(0.8).timeout
	begin_checkout_next_guest()

## hook for room selection for assigning guest
func on_room_select(room: Room):
	if phase == Phase.ASSIGNING:
		assign_current_guest(room)
	elif phase == Phase.UPGRADING:
		manage_room(room)
		

func assign_current_guest(room: Room):
	if room.guest != null or current_guest == null: return
	
	Globals.set_text.emit()
	room.add_guest(current_guest)
	
	var guest_node: Node2D = current_guest.node
	current_guest = null
	await play_guest_exit_animation(guest_node)
	await get_tree().create_timer(0.8).timeout
	
	manage_next_guest()

func manage_room(room: Room):
	## TODO: remove, michael will deal with
	pass

func on_text_finish():
	if phase == Phase.CHECKOUT and current_guest != null:
		Globals.set_text.emit()
		var guest_node: Node2D = current_guest.node
		current_guest = null
		await play_guest_exit_animation(guest_node)
		await get_tree().create_timer(0.8).timeout
		checkout_next_guest()

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

func get_rooms():
	return get_tree().get_nodes_in_group("room")
