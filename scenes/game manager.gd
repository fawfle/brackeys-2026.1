class_name GameManager extends Node2D

static var inst: GameManager = null

const assign_guest_leave_time: float = 30

const floating_text_scene: PackedScene = preload("res://scenes/ui/floating_text.tscn")

@onready var guest_parent: Node2D = $GuestParent
@onready var guest_leave_timer: Timer = $GuestLeaveTimer

@onready var guest_window: Control = $CanvasLayer/GuestWindow

#TODO: placeholder, replace with actual stars
@onready var star_rating: Label = $"CanvasLayer/GuestWindow/StarRating"
@onready var radial_bar: TextureProgressBar = $CanvasLayer/GuestWindow/GuestTimerRadialBar
@onready var assign_button: Button = $CanvasLayer/GuestWindow/AssignButton

var day: int = 0

var money: int = 0:
	get: return money
	set(value):
		Globals.set_money.emit(value)
		money = value

var guest_assign_queue: Array[Guest] = []
var guest_checkout_queue: Array[Guest] = []
@export var current_guest: Guest = null

var random_trait_count: int = 1
var stay_length_max: int = 1

## bool for if currently playing an animation. forces functions to wait
var playing_animation: bool = false

## phase of gameplay. Either assigning (getting guests),  managing (upgrading), or checkout (guests leaving and paying). ASSIGN -> UPGRADE -> CHECKOUT
enum Phase {
	CHECKOUT,
	ASSIGNING,
	UPGRADING,
	END_DAY,
}

var phase: Phase = Phase.ASSIGNING

func _ready() -> void:
	inst = self
	# load guests and traits. The lists act as global constants
	TraitList.LOAD_TRAITS()
	GuestList.LOAD_GUESTS()
	
	radial_bar.visible = false
	
	Globals.select_room.connect(on_room_select)
	assign_button.button_down.connect(_on_assign_button_button_down)
	
	begin_assigning_phase()

func begin_next_phase() -> void:
	# use call_deferred to keep call stack in check
	match(phase):
		Phase.CHECKOUT:
			begin_assigning_phase.call_deferred()
		Phase.ASSIGNING:
			begin_upgrading_phase.call_deferred()
		Phase.UPGRADING:
			end_day.call_deferred()
		Phase.END_DAY:
			begin_checkout_phase.call_deferred()
	
	Globals.phase_changed.emit(phase)

func begin_assigning_phase() -> void:
	phase = Phase.ASSIGNING
	guest_assign_queue = GuestList.create_guest_queue(1, day)
	manage_next_guest()

func begin_upgrading_phase() -> void:
	phase = Phase.UPGRADING
	
	await Globals.text_finished
	
	begin_next_phase()

func begin_checkout_phase() -> void:
	if Globals.DEBUG: print("BEGINNING CHECKOUT PHASE")
	
	phase = Phase.CHECKOUT
	guest_checkout_queue.clear()
	for room: Room in get_rooms():
		if room.guest != null and room.guest.stay_duration <= 0:
			var guest: Guest = room.checkout_guest()
			guest_checkout_queue.push_back(guest)
	
	guest_checkout_queue.shuffle()
	begin_checkout_next_guest()

## Handle the end of the day
func end_day() -> void:
	phase = Phase.END_DAY
	day += 1
	for room: Room in get_rooms():
		if room.guest != null: room.guest.stay_duration -= 1
	
	Globals.begin_day.emit(day)
	
	begin_next_phase()

func manage_next_guest() -> void:
	if phase != Phase.ASSIGNING: return
	if guest_assign_queue.size() <= 0:
		begin_next_phase()
		return
	
	current_guest = create_next_guest()
	
	# clean children
	for child in guest_parent.get_children(): guest_parent.remove_child(child)
	
	current_guest.instantiate_scene()
	guest_parent.add_child(current_guest.node)
	
	if Globals.DEBUG: print("LOADING GUEST: " + str(current_guest))
	
	await play_guest_enter_animation(current_guest.node)
	
	start_assign_guest_leave_timer(current_guest)
	
	if current_guest != null: Globals.set_text.emit(current_guest.get_intro_lines())

## have guest leave
func leave_guest() -> void:
	Globals.set_text.emit(current_guest.goodbye)
	await Globals.text_finished
	await play_guest_exit_animation(current_guest.node)
	current_guest.node.queue_free()
	manage_next_guest()

## currently duplicate guests and set traits here. Maybe change in the future if it's confusing.
func create_next_guest() -> Guest:
	var guest: Guest = guest_assign_queue.pop_front().duplicate_deep()
	TraitList.set_guest_traits(guest, random_trait_count)
	return guest

func begin_checkout_next_guest() -> void:
	if phase != Phase.CHECKOUT: return
	
	if guest_checkout_queue.size() <= 0:
		begin_assigning_phase()
		return
	
	current_guest = guest_checkout_queue.pop_front()
	print(guest_checkout_queue)
	
	if Globals.DEBUG: print("CHECKING OUT: " + str(current_guest))
	
	current_guest.node.reparent(guest_parent)
	await play_guest_enter_animation(current_guest.node)
	
	current_guest.update_happiness_rating()
	
	Globals.set_text.emit(current_guest.get_exit_lines())
	
	await Globals.text_finished
	
	checkout_guest()

## checkout guest
func checkout_guest() -> void:
	if current_guest == null:
		return
	
	var profit: int = current_guest.get_money()
	money += profit
	create_floating_text("+$" + str(profit))
	
	star_rating.text = str(current_guest.happiness_rating) + " Stars"
	
	Globals.set_text.emit()
	var guest_node: Node2D = current_guest.node
	
	current_guest = null
	await play_guest_exit_animation(guest_node)
	guest_node.queue_free()
	await get_tree().create_timer(0.8).timeout
	begin_checkout_next_guest()

## hook for room selection for assigning guest
func on_room_select(room: Room):
	if phase == Phase.ASSIGNING:
		assign_button.disabled = room == null

func _on_assign_button_button_down() -> void:
	if Hotel.inst.selected_room != null: assign_current_guest(Hotel.inst.selected_room)


func assign_current_guest(room: Room):
	if room.guest != null or current_guest == null or playing_animation: return
	
	Globals.set_text.emit()
	room.add_guest(current_guest)
	current_guest.room = room
	
	var guest_node: Node2D = current_guest.node
	current_guest = null
	guest_leave_timer.stop()
	guest_leave_timer.timeout.emit() # need to call manually :)
	
	await play_guest_exit_animation(guest_node)
	guest_node.reparent(room)
	await get_tree().create_timer(0.8).timeout
	
	manage_next_guest()


func start_assign_guest_leave_timer(guest: Guest):
	guest_leave_timer.start(assign_guest_leave_time)
	radial_bar.visible = true
	radial_bar.modulate = Color("#ffffff00")
	radial_bar.create_tween().tween_property(radial_bar, "modulate", Color("ffffffff"), 0.2)
	radial_bar.value = 100
	var tween: Tween =  get_tree().create_tween()
	tween.tween_property(radial_bar, "value", 5, assign_guest_leave_time)
	
	await guest_leave_timer.timeout
	
	tween.stop()
	radial_bar.create_tween().tween_property(radial_bar, "modulate", Color("ffffff00"), 0.2)
	if current_guest != guest: return
	
	leave_guest()

func play_guest_enter_animation(guest_node: Node2D):
	playing_animation = true
	var duration: float = 0.9
	
	# var end_color: Color = Color("ffffffff")
	
	var timer: SceneTreeTimer = get_tree().create_timer(duration)
	
	while timer.time_left != 0:
		var t: float = (duration - timer.time_left) / duration
		# t = 1 - (1 - t) * (1 - t) # ease out
		guest_node.modulate = lerp(Color("#ffffff00"), Color("ffffffff"), t)
		await get_tree().process_frame


	# guest_node.modulate = Color("#ffffff00")
	# get_tree().create_tween().tween_property(guest_node, "modulate", end_color, duration)
	# await get_tree().create_timer(duration).timeout
	
	playing_animation = false

func play_guest_exit_animation(guest_node: Node2D):
	playing_animation = true
	var duration: float = 0.6
	
	var end_color: Color = Color("ffffff00")
	
	get_tree().create_tween().tween_property(guest_node, "modulate", end_color, duration)
	
	await get_tree().create_timer(duration).timeout
	
	playing_animation = false

func get_rooms():
	return get_tree().get_nodes_in_group("room")

func create_floating_text(text: String):
	var floating_text: FloatingText = floating_text_scene.instantiate() as FloatingText
	guest_window.add_child(floating_text)
	floating_text.position += Vector2(randi_range(-5, 5), randi_range(-25, -15))
	floating_text.play_animation(text, 1.3)
