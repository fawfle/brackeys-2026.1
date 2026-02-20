extends Button

func _ready() -> void:
	Globals.select_room.connect(update_disabled)
	Globals.current_guest_changed.connect(_on_current_guest_changed)
	Globals.room_upgraded.connect(update_disabled)
	
	pressed.connect(func(): disabled = true)

## hook for room selection for assigning guest
func update_disabled(room: Room):
	if GameManager.inst.phase == GameManager.Phase.MANAGEMENT:
		disabled = room == null or not room.can_assign_guest()

func _on_current_guest_changed(guest: Guest):
	if GameManager.inst.phase != GameManager.Phase.MANAGEMENT or guest == null:
		visible = false
		disabled  = true
	else:
		visible = true
		update_disabled(null if Hotel.inst == null else Hotel.inst.selected_room)
