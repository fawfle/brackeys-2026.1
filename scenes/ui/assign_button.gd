extends TextureButton

func _ready() -> void:
	Globals.select_room.connect(update_disabled)
	Globals.current_guest_changed.connect(_on_current_guest_changed)
	Globals.managing_guest.connect(_on_manage_guest)
	Globals.room_updated.connect(update_disabled)
	
	pressed.connect(func(): disabled = true)

## hook for room selection for assigning guest
func update_disabled(room: Room):
	if GameManager.inst.phase == GameManager.Phase.MANAGEMENT:
		disabled = room == null or not room.can_assign_guest()

func _on_current_guest_changed(_guest: Guest):
	disabled  = true

func _on_manage_guest(guest: Guest):
	if guest == null:
		disabled = true
		return
	
	update_disabled(null if Hotel.inst == null else Hotel.inst.selected_room)
