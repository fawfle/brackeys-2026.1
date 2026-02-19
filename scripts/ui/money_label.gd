extends Label

func _ready() -> void:
	Globals.set_money.connect(on_set_money)

func on_set_money(money: int) -> void:
	text = "$" + str(money)
