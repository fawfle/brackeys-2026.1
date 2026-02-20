extends Sprite2D

@onready var hand_pivot: Node2D = $HandPivot

@onready var small_hand_pivot: Node2D = $SmallHandPivot

func _process(_delta: float) -> void:
	hand_pivot.rotation = 2 * PI * GameManager.inst.time_ratio
	small_hand_pivot.rotation = 2 * PI * (GameManager.inst.time_ratio * 12)
