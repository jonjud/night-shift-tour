extends Node2D

const SHIFT_COOLDOWN : float = 1.5

@onready var day_layer : TileMapLayer = $DayLayer
@onready var night_layer : TileMapLayer = $NightLayer
@onready var red_flash: ColorRect = $FlashLayer/RedFlash

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
	_update_ghosts(is_night)

# Check if this node with overlapped with another layer 
func _hits_wall(node: Node2D, layer: TileMapLayer) -> bool:
	var cell := layer.local_to_map(layer.to_local(node.global_position))
	var data := layer.get_cell_tile_data(cell)
	return data != null and data.get_collision_polygons_count(0) > 0

# every player and guest won't ovelapped with wall
func _can_shift_to(layer: TileMapLayer) -> bool:
	if _hits_wall($Player, layer):
		return false
	for g in get_tree().get_nodes_in_group("guests"):
		if _hits_wall(g, layer):
			return false
	return true

# red screen flashing
func _flash_red() -> void:
	red_flash.modulate.a = 1.0
	create_tween().tween_property(red_flash, "modulate:a", 0.0, 0.3)

# tell ghost/demon which world this is
func _update_ghosts(is_night_now: bool) -> void:
	for gh in get_tree().get_nodes_in_group("ghosts"):
		gh.set_night(is_night_now)
	for dm in get_tree().get_nodes_in_group("demons"):
		dm.set_night(is_night_now)
