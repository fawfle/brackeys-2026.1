class_name Guest

var name: String = ""
var scene: PackedScene

## traits assigned to guest by default. Used for "template" guests.
var default_traits: Array[GuestTrait] = []
var traits: Array[GuestTrait] = []

## Max money guest can give
var money: int = 0

## message on greeting
var greeting: String = ""
## message on leaving
var goodybye: String = ""

## initial rating given by guest. Can be lower than 5 for picky or snobbish guests.
var initial_rating: float = 5

## Guest won't appear until day has passed
var appear_after_day: int = 0

# constructed by guest_list class
