extends CanvasLayer

@onready var label: Label = $ResultLabel

func _ready() -> void:
	visible = false

func show_result(saved: int, money: int) -> void:
	label.text = "SHIFT OVER\n\nGuests saved: %d\nMoney: $%d\n\nPress R to restart" % [saved, money]
	visible = true

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("restart"):
		get_tree().paused = false  # ต้องปลด pause ก่อน reload
		get_tree().reload_current_scene()
