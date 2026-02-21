class_name HotelMenu extends Control

var floor_scene: PackedScene = preload("res://scenes/hotel/hotel_floor.tscn")

@onready var roof: Sprite2D = $Roof

## offset of roof from floor size steps
const ROOF_INITIAL_POSITION: int = -43
## size of floor in pixels
const FLOOR_SIZE: int = 22

## offset for floors
const FLOOR_INITIAL_POSITION: Vector2 = Vector2(-75, -22)
const FLOOR_OFFSET: Vector2 = Vector2(0, -22)

func add_floor(floor_to_add: int):
	if floor_to_add > 5: return
	roof.position.y = ROOF_INITIAL_POSITION + ((floor_to_add - 1) * -FLOOR_SIZE)

	print(floor_to_add)
	var hotel_floor: HotelFloor = floor_scene.instantiate()
	add_child(hotel_floor)
	hotel_floor.set_floor(floor_to_add - 1)
	
	hotel_floor.position = FLOOR_INITIAL_POSITION + FLOOR_OFFSET * (floor_to_add - 1)
	
	hotel_floor.floor_rooms[0].built = true
