extends Node2D

const SHIFT_COOLDOWN : float = 1.5

@onready var day_layer : TileMapLayer = $DayLayer
@onready var night_layer : TileMapLayer = $NightLayer

var is_night : bool = false
var cooldown_left : float = 0.0

func _ready() -> void:
	#always starting in day , no matter the inspector says
	_apply_world()

func _process(delta: float) -> void:
	if cooldown_left > 0.0:
		cooldown_left -= delta

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shift_world"):
		if cooldown_left > 0.0:
			print("Shift blocked, cooldown left ", snappedf(cooldown_left,0.1))
			return
		is_night = not is_night
		cooldown_left = SHIFT_COOLDOWN
		_apply_world()
		print("Shifted! is_night = ", is_night)

func _apply_world() -> void:
	# HAVE TO SET BOTH VISINIL AND ENABLE-Y
	day_layer.visible = not is_night
	day_layer.collision_enabled = not is_night
	night_layer.visible = is_night
	night_layer.collision_enabled = is_night
