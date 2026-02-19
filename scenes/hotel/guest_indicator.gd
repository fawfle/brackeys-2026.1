extends Sprite2D

var walk_range_x: Vector2 = Vector2(-12, 12)
var walk_range_y: Vector2 = Vector2(1, 2)

var wait_time_range: Vector2 = Vector2(3, 4)

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if visible:
		position = get_random_position()
		
		await get_tree().create_timer(1.5).timeout
		print('wal')
		walk_in_random_direction()

func walk_in_random_direction():
	var duration: float = 3
	
	var random_direction: Vector2 = Vector2.from_angle(randf_range(0, 2 * PI))
	
	var timer: SceneTreeTimer = get_tree().create_timer(duration)
	
	while(timer.time_left > 0):
		if not visible: return
		
		position += random_direction * 4 * get_process_delta_time()
		
		clamp_position()
		
		await get_tree().process_frame
	
	await get_tree().create_timer(randf_range(wait_time_range.x, wait_time_range.y)).timeout
	
	call_deferred("walk_in_random_direction")

func clamp_position() -> void:
	position.x = clamp(position.x, walk_range_x.x, walk_range_x.y)
	position.y = clamp(position.y, walk_range_y.x, walk_range_y.y)

func get_random_position() -> Vector2:
	var rand_x: float = randf_range(walk_range_x.x, walk_range_x.y)
	var rand_y: float = randf_range(walk_range_y.x, walk_range_y.y)
	return Vector2(rand_x, rand_y)
