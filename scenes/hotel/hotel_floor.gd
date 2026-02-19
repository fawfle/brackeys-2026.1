class_name HotelFloor extends Control

@onready var floor_rooms: Array[Room] = [$RoomLeft, $RoomCenter, $RoomRight]

func set_floor(floor_num: int):
	for room in floor_rooms:
		room.y = floor_num
