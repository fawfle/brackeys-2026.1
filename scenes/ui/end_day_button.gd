extends Button

func _ready() -> void:
	Globals.current_guest_changed.connect(_on_guest_changed)
	Globals.phase_changed.connect(_on_phase_changed)
	
	visible = false
	
	pressed.connect(_on_pressed)

func _on_guest_changed(_guest: Guest) -> void:
	if GameManager.inst.phase == GameManager.Phase.NIGHT:
		visible = false
		return
	
	if Hotel.inst.is_full() or (GameManager.inst.phase == GameManager.Phase.MANAGEMENT and GameManager.inst.guest_assign_queue.size() == 0 and GameManager.inst.current_guest == null):
		visible = true

func _on_pressed() -> void:
	if GameManager.inst.phase == GameManager.Phase.NIGHT: return
	
	Engine.time_scale = 10
	
	while GameManager.inst.phase != GameManager.Phase.NIGHT:
		await Globals.phase_changed
	
	Engine.time_scale = 1

func _on_phase_changed(phase: GameManager.Phase):
	if phase == GameManager.Phase.NIGHT:
		visible = false
