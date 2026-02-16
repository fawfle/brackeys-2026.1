## class to manage the hotel
class_name Hotel

var rooms: Array[Room] = []

func get_happiness_rating(room: Room, guest: Guest) -> float:
	var rating: float = guest.initial_rating;
	# TODO
	return rating;
