class_name HotelFloor extends Control

@onready var floor_rooms: Array[Room] = [$RoomLeft, $RoomCenter, $RoomRight]

func set_floor(floor_num: int):
	for room: Room in floor_rooms:
		room.location.y = floor_num
		# print("HOTEL_FLOOR: " + str(floor_num))
