## this is a class for global variables and signals
extends Node

## is the game paused
var paused: bool = false

## if in debug mode, for conditional logging
var DEBUG: bool = true

## average star rating of player
var average_rating: float = 0

var total_ratings: int = 0
## total money gained during playthrough
var total_profit: int = 0
## total guests player checked out
var total_guests: int = 0

func add_average_rating(rating: float) -> void:
	average_rating = (average_rating * total_ratings + rating) / (total_ratings + 1)
	total_ratings += 1

## signals phase changes
@warning_ignore("unused_signal")
signal phase_changed(phase: GameManager.Phase)

## used to signal textbox to display a mesage. Message is given as an array and clicking through will cycle until final message.
@warning_ignore("unused_signal")
signal set_text(lines: Array[String])
## emited when text has been cycled through to end of queue
@warning_ignore("unused_signal")
signal text_finished()

## emited when text is fully displayed
@warning_ignore("unused_signal")
signal text_displayed()

## emitted when text is fully displayed and finished
@warning_ignore(("unused_signal"))
signal text_final_line_displayed()

## used to signal money updated
@warning_ignore("unused_signal")
signal set_money(money: int)

@warning_ignore("unused_signal")
## used by rooms to signal a click.
signal select_room(room: Room)
## used by rooms to signal a hover/exit hover.
@warning_ignore("unused_signal")
signal hover_room(room: Room)
@warning_ignore(("unused_signal"))
signal exit_hover_room(room: Room)

@warning_ignore("unused_signal")
signal room_updated(room: Room)

@warning_ignore(("unused_signal"))
signal begin_day(day: int)

@warning_ignore(("unused_signal"))
signal guest_assigned(guest: Guest)
@warning_ignore(("unused_signal"))
signal guest_checked_out(guest: Guest)

@warning_ignore(("unused_signal"))
signal current_guest_changed(guest: Guest)

@warning_ignore("unused_signal")
signal managing_guest(guest: Guest)

## used in upgrade_button to set the text of the upgrade description field
@warning_ignore(("unused_signal"))
signal update_upgrade_text(text: String)
