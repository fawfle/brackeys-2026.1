class_name HotelMenu extends Control

var floor_scene: PackedScene = preload("res://scenes/hotel/hotel_floor.tscn")

@onready var roof: TextureRect = $Roof

## offset of roof from floor size steps
const ROOF_INITIAL_POSITION: Vector2 = Vector2(-80, -107)
## size of floor in pixels
const FLOOR_SIZE: int = 22

## offset for floors
const FLOOR_INITIAL_POSITION: Vector2 = Vector2(-75, -22)
const FLOOR_OFFSET: Vector2 = Vector2(0, -22)

var build_floor_roof_tween: Tween
var build_floor_tween: Tween

func add_floor(floor_to_add: int):
	if floor_to_add > 5: return

	var hotel_floor: HotelFloor = floor_scene.instantiate()
	add_child(hotel_floor)
	move_child(hotel_floor, 0)
	hotel_floor.set_floor(floor_to_add - 1)
	
	if build_floor_tween != null and build_floor_tween.is_valid() and build_floor_tween.is_running(): build_floor_tween.custom_step(1)
	if build_floor_roof_tween != null and build_floor_roof_tween.is_valid() and build_floor_roof_tween.is_running(): build_floor_roof_tween.custom_step(1)
	
	build_floor_tween = hotel_floor.create_tween()
	build_floor_roof_tween = hotel_floor.create_tween()
	
	build_floor_tween.tween_property(hotel_floor, "position", FLOOR_INITIAL_POSITION + FLOOR_OFFSET * (floor_to_add - 1), 0.5).from(FLOOR_INITIAL_POSITION + FLOOR_OFFSET * (floor_to_add - 2))
	build_floor_roof_tween.tween_property(roof, "position", ROOF_INITIAL_POSITION + Vector2(0, ((floor_to_add - 1) * -FLOOR_SIZE)), 0.5).from(ROOF_INITIAL_POSITION + Vector2(0, ((floor_to_add - 2) * -FLOOR_SIZE)))
	# hotel_floor.position = FLOOR_INITIAL_POSITION + FLOOR_OFFSET * (floor_to_add - 1)
	
	hotel_floor.floor_rooms[0].built = true
