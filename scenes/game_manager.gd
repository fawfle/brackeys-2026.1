class_name GameManager extends Node2D

static var inst: GameManager = null

const assign_guest_leave_time: float = 30
var guests_per_day: int = 1
var guest_stay_length_max: int = 1

const floating_text_scene: PackedScene = preload("res://scenes/ui/floating_text.tscn")

@onready var guest_parent: Node2D = $GuestParent
@onready var guest_leave_timer: Timer = $GuestLeaveTimer

@onready var guest_window: Control = $CanvasLayer/GuestWindow

#TODO: placeholder, replace with actual stars
@onready var star_rating: Label = $"CanvasLayer/GuestWindow/StarRating"
@onready var assign_button: TextureButton = $CanvasLayer/GuestWindow/AssignButton

@onready var reject_button: TextureButton = $CanvasLayer/GuestWindow/RejectButton

var day: int = 0

## total length of day in seconds
var daytime_length: float = 60
var night_length: float = 10

var total_day_length:
	get: return daytime_length + night_length

var time_ratio:
	get: return time / total_day_length

## current time of day. Represents a fraction of total_day_length
var time: float = 0

var money: int = 0:
	get: return money
	set(value):
		Globals.set_money.emit(value)
		money = value

## moeny to be deducted at end of day. TODO: concrete penatly for debt
var expenses: int = 0

var guest_assign_queue: Array[Guest] = []
var guest_checkout_queue: Array[Guest] = []
@export var current_guest: Guest = null:
	get: return current_guest
	set(value):
		current_guest = value
		Globals.current_guest_changed.emit(current_guest)

var random_trait_count: int = 1
var guest_assign_start_time: float = 0
var time_since_guest: float:
	get: return time - guest_assign_start_time

## time given to player to assign each guest. Next guest can't appear before timer runs out FROM initial guest assigning time
var assign_time_per_guest: float = 0

## builtin time to give player to manage day easier
var guest_assign_time_bias: float = 10

## Boolean heaven!!
## bool for if currently playing an animation. forces functions to wait
var playing_animation: bool:
	get: return playing_exit_animation or playing_enter_animation
var playing_enter_animation: bool = false ## is playing enter animation
var playing_exit_animation: bool = false ## is currently playing exit animation
var assigning_guest: bool = false ## is currently assigning guest
var leaving_guest: bool = false ## is currently leaving guest

## stores list of last n guests and "blacklists" them
var past_guest_queue: Array[Guest] = []
const past_guest_queue_limit: int = 5

## phase of gameplay. Either assigning (getting guests),  managing (upgrading), or checkout (guests leaving and paying). ASSIGN -> UPGRADE -> CHECKOUT
enum Phase {
	CHECKOUT, ## checking out guests, beginning of day
	MANAGEMENT, ## managing guests and hotel
	NIGHT, ## rest, possibly just a menu
}

var is_daytime_phase: bool:
	get: return phase == Phase.CHECKOUT or phase == Phase.MANAGEMENT

var phase: Phase = Phase.MANAGEMENT:
	get: return phase
	set(value):
		phase = value
		Globals.phase_changed.emit(phase)

var time_stopped: bool = false

func _init():
	inst = self

func _ready() -> void:
	# load guests and traits. The lists act as global constants
	TraitList.LOAD_TRAITS()
	GuestList.LOAD_GUESTS()
	
	star_rating.visible = false
	
	assign_button.button_down.connect(_on_assign_button_button_down)
	reject_button.button_down.connect(_on_reject_button_down)
	
	begin_management_phase()

func _process(delta: float) -> void:
	if not time_stopped: time += delta
	if is_daytime_phase and time > daytime_length:
		end_day()
		return
	
	if phase == Phase.MANAGEMENT and current_guest == null and time_since_guest >= assign_time_per_guest and not playing_animation and not leaving_guest:
		if guest_assign_queue.size() > 0:
			manage_next_guest()
	
	if phase == Phase.NIGHT and time > total_day_length:
		begin_day()

func begin_management_phase() -> void:
	phase = Phase.MANAGEMENT
	
	guest_assign_queue = GuestList.create_guest_queue(guests_per_day, day, past_guest_queue)
	past_guest_queue.append_array(guest_assign_queue)
	if past_guest_queue.size() > past_guest_queue_limit:
		past_guest_queue.reverse()
		past_guest_queue.resize(past_guest_queue_limit)
		past_guest_queue.reverse()
		
	
	assign_time_per_guest = (daytime_length - guest_assign_time_bias) / guest_assign_queue.size()

	manage_next_guest()

func begin_checkout_phase() -> void:
	if Globals.DEBUG: print("BEGINNING CHECKOUT PHASE")
	
	phase = Phase.CHECKOUT
	guest_checkout_queue.clear()
	for room: Room in get_rooms():
		if room.guest != null and room.guest.stay_duration <= room.guest.days_stayed:
			var guest: Guest = room.checkout_guest()
			guest_checkout_queue.push_back(guest)
	
	guest_checkout_queue.shuffle()
	begin_checkout_next_guest()

## sets up day and updates variables
func begin_day() -> void:
	day += 1
	time = 0
	
	# lol integer divison
	guests_per_day = 2 + floor(day / 7.0)
	guest_stay_length_max = 1 + floor(day / 9.0)
	
	if day == 0: guests_per_day = 0
	
	Globals.begin_day.emit(day)
	begin_checkout_phase()

## Handle the end of the day
func end_day() -> void:
	phase = Phase.NIGHT
	for room: Room in get_rooms():
		if room.guest != null: room.guest.days_stayed += 1
	
	if current_guest != null:
		leave_guest()
	
	for guest: Guest in get_guests():
		guest.update_happiness_rating()
	
	await get_tree().create_timer(2).timeout

func manage_next_guest() -> void:
	if phase != Phase.MANAGEMENT: return
	if guest_assign_queue.size() <= 0: return
	
	current_guest = create_next_guest()
	guest_assign_start_time = time
	
	time_stopped = current_guest.stop_time
	
	# clean children
	for child in guest_parent.get_children(): guest_parent.remove_child(child)
	
	current_guest.instantiate_scene()
	guest_parent.add_child(current_guest.node)
	
	if Globals.DEBUG: print("LOADING GUEST: " + str(current_guest))
	
	await play_guest_enter_animation(current_guest.node)
	
	if phase != Phase.MANAGEMENT: return
	
	if not time_stopped: start_assign_guest_leave_timer(current_guest)
	
	if current_guest != null: Globals.set_text.emit(current_guest.get_intro_lines())
	Globals.managing_guest.emit(current_guest)
	
	await Globals.text_final_line_displayed
	
	time_stopped = false

## have guest leave
func leave_guest() -> void:
	if current_guest == null or playing_exit_animation or assigning_guest: return
	
	leaving_guest = true
	if current_guest.stop_time:
		time_stopped = false
	
	var node: Node2D = current_guest.node
	Globals.set_text.emit(current_guest.rejected_goodbye)
	current_guest = null
	await Globals.text_displayed
	await get_tree().create_timer(1.0).timeout
	await play_guest_exit_animation(node)
	
	node.queue_free()
	
	if current_guest == null: Globals.set_text.emit() # just in case overlaps with something else
	
	await get_tree().create_timer(0.9).timeout # time padding
	
	leaving_guest = false

## currently duplicate guests and set traits here. Maybe change in the future if it's confusing.
func create_next_guest() -> Guest:
	var guest: Guest = guest_assign_queue.pop_front().duplicate_deep()
	TraitList.set_guest_traits(guest, random_trait_count if not guest.event else 0)
	guest.stay_duration = randi_range(1, guest_stay_length_max)
	return guest

func begin_checkout_next_guest() -> void:
	if phase != Phase.CHECKOUT: return
	
	if guest_checkout_queue.size() == 0:
		begin_management_phase()
		return
	
	current_guest = guest_checkout_queue.pop_front()
	
	if Globals.DEBUG: print("CHECKING OUT: " + str(current_guest))
	
	current_guest.node.reparent(guest_parent)
	await play_guest_enter_animation(current_guest.node)
	
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
	
	play_star_rating_animation(current_guest.happiness_rating)
	
	Globals.set_text.emit()
	Globals.guest_checked_out.emit(current_guest)
	var guest_node: Node2D = current_guest.node
	
	current_guest = null
	await play_guest_exit_animation(guest_node)
	guest_node.queue_free()
	await get_tree().create_timer(0.8).timeout
	begin_checkout_next_guest()

func _on_assign_button_button_down() -> void:
	if Hotel.inst.selected_room != null: assign_guest(Hotel.inst.selected_room)

func _on_reject_button_down() -> void:
	if phase == Phase.MANAGEMENT: leave_guest()

func assign_guest(room: Room):
	if room.guest != null or current_guest == null or playing_animation: return
	assigning_guest = true
	
	if current_guest.stop_time:
		time_stopped = false
	
	Globals.set_text.emit()
	
	await play_guest_exit_animation(current_guest.node)
	current_guest.node.reparent(room)
	await get_tree().create_timer(0.8).timeout
	
	room.add_guest(current_guest)
	current_guest.room = room
	Globals.guest_assigned.emit(current_guest)
	current_guest = null
	
	guest_leave_timer.stop()
	guest_leave_timer.timeout.emit() # need to call manually :)
	
	assigning_guest = false

const AGITATED_THRESHOLD: float = 10
const ANGRY_THRESHOLD: float = 4

func start_assign_guest_leave_timer(guest: Guest):
	if guest == null: return
	guest_leave_timer.start(assign_guest_leave_time - AGITATED_THRESHOLD - ANGRY_THRESHOLD)
	
	var node: GuestSprite = guest.node
	await guest_leave_timer.timeout
	
	if phase != Phase.MANAGEMENT or node == null: return
	play_agitated_animation(node)
	
	await get_tree().create_timer(AGITATED_THRESHOLD - ANGRY_THRESHOLD).timeout
	
	if phase != Phase.MANAGEMENT or node == null: return
	node.play_angry_animation()
	
	await get_tree().create_timer(ANGRY_THRESHOLD).timeout
	
	if current_guest != guest or current_guest == null: return
	
	leave_guest()


## Purchase an upgrade. Returns true if upgrade is successful. should be called with an if purchase_upgrade(): add_upgrade()
func purchase_upgrade(cost: int) -> bool:
	if money < cost: return false
	money -= cost
	return true


func play_guest_enter_animation(guest_node: Node2D):
	playing_enter_animation = true
	var duration: float = 0.9
	guest_node.position = Vector2.ZERO
	
	# var end_color: Color = Color("ffffffff")
	
	var timer: SceneTreeTimer = get_tree().create_timer(duration)
	
	var end_color: Color = Color("ffffffff")
	
	while timer.time_left != 0:
		var t: float = (duration - timer.time_left) / duration
		# t = 1 - (1 - t) * (1 - t) # ease out
		guest_node.modulate = lerp(Color("#ffffff00"), end_color, t)
		await get_tree().process_frame
	
	guest_node.modulate = end_color

	# guest_node.modulate = Color("#ffffff00")
	# get_tree().create_tween().tween_property(guest_node, "modulate", end_color, duration)
	# await get_tree().create_timer(duration).timeout
	
	playing_enter_animation = false

func play_guest_exit_animation(guest_node: Node2D):
	playing_exit_animation = true
	var duration: float = 0.6
	
	var end_color: Color = Color("ffffff00")
	
	get_tree().create_tween().tween_property(guest_node, "modulate", end_color, duration)
	
	await get_tree().create_timer(duration).timeout
	guest_node.modulate = end_color
	
	playing_exit_animation = false

func get_rooms() -> Array:
	return get_tree().get_nodes_in_group("room")

func get_guests() -> Array[Guest]:
	var guests: Array[Guest] = []
	for r: Room in get_rooms():
		if r.guest != null: guests.push_back(r.guest)
	return guests

func create_floating_text(text: String):
	var floating_text: FloatingText = floating_text_scene.instantiate() as FloatingText
	guest_window.add_child(floating_text)
	floating_text.position += Vector2(randi_range(-5, 5), randi_range(-25, -15))
	floating_text.play_animation(text, 1.3)

func play_star_rating_animation(stars: float):
	star_rating.text = str(stars) + " Stars"
	star_rating.visible = true
	star_rating.modulate = Color("#ffffff")
	await get_tree().create_timer(2.0).timeout
	
	await get_tree().create_tween().tween_property(star_rating, "modulate", Color("#ffffff00"), 1.0).finished
	
	star_rating.visible = false

func play_agitated_animation(guest_node: Node2D):
	var duration: float = 1.2
	var timer: float = 0
	
	var start_y: float = guest_node.position.y
	
	while timer < duration:
		guest_node.position.y = start_y + pow(sin(2 * PI * timer / duration), 4) * 5
		timer += get_process_delta_time()
		await get_tree().process_frame
	
	guest_node.position.y = start_y

func ease_out(t: float) -> float:
	return 1 - (1 - t) * (1 - t)
