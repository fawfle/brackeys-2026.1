class_name HotelMenu extends Control

var floor_scene: PackedScene = preload("res://scenes/hotel/hotel_floor.tscn")

@onready var roof: Sprite2D = $Roof

## offset of roof from floor size steps
const ROOF_OFFSET: int = 1
## size of floor in pixels
const FLOOR_SIZE: int = 22

func add_floor(floors: int):
	if floors > 5: return
	
	roof.position.y = (floors * -FLOOR_SIZE) + ROOF_OFFSET
