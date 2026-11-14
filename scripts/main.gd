extends Node2D

const SHIFT_COOLDOWN : float = 1.5
const GOAL_RADIUS := 20.0
const GUEST_REWARD := 100
const SHIFT_TIME := 60.0 # 3 mins

@onready var day_layer : TileMapLayer = $DayLayer
@onready var night_layer : TileMapLayer = $NightLayer
@onready var red_flash: ColorRect = $FlashLayer/RedFlash
@onready var shift_flash: ColorRect = $FlashLayer/ShiftFlash
@onready var money_label: Label = $HUD/MoneyLabel
@onready var goal: Node2D = $FerrisWheel
@onready var time_label: Label = $HUD/TimeLabel
@onready var end_screen: CanvasLayer = $EndLayer

var is_night : bool = false
var cooldown_left : float = 0.0
var money := 0
var saved := 0
var time_left := SHIFT_TIME
var shift_over := false

func _ready() -> void:
	#always starting in day , no matter the inspector says
	_apply_world()

func _process(delta: float) -> void:
	if cooldown_left > 0.0:
		cooldown_left -= delta
	if shift_over:
		return
	time_left = maxf(time_left - delta, 0.0)
	var t := ceili(time_left)  # rounded up
	time_label.text = "%d:%02d" % [t / 60, t % 60]
	if time_left <= 0.0:
		end_shift()

func _physics_process(_delta: float) -> void:
	if shift_over:
		return
	_check_goal()
	# จบกะถ้าไม่มีแขกเหลือ (vanish() ออกจาก group ทันที)
	if get_tree().get_nodes_in_group("guests").is_empty():
		end_shift()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shift_world"):
		if cooldown_left > 0.0:
			print("Shift blocked, cooldown left ", snappedf(cooldown_left,0.1))
			return
		var target := night_layer if not is_night else day_layer  # NEW
		if not _can_shift_to(target):                              # NEW
			_flash_red()                                           # NEW
			return  
		is_night = not is_night
		cooldown_left = SHIFT_COOLDOWN
		_apply_world()
		_shift_flash(is_night)
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

# screen pulse on world shift: purple -> night, warm yellow -> day
func _shift_flash(to_night: bool) -> void:
	shift_flash.color = Color(0.35, 0.2, 0.6) if to_night else Color(1.0, 0.95, 0.7)
	shift_flash.modulate.a = 0.6
	create_tween().tween_property(shift_flash, "modulate:a", 0.0, 0.25)

# tell ghost/demon which world this is
func _update_ghosts(is_night_now: bool) -> void:
	for gh in get_tree().get_nodes_in_group("ghosts"):
		gh.set_night(is_night_now)
	for dm in get_tree().get_nodes_in_group("demons"):
		dm.set_night(is_night_now)

# guest that get in the goal's redius = we get the money guest get outta train
func _check_goal() -> void:
	for g in get_tree().get_nodes_in_group("guests"):
		if g.global_position.distance_to(goal.global_position) <= GOAL_RADIUS:
			g.suck_into(goal.global_position) #change from vanish to sucking... (nah it's so weird) 
			money += GUEST_REWARD
			money_label.text = "$%d" % money

func end_shift() -> void:
	shift_over = true
	time_label.text = "0:00 SHIFT OVER"
	end_screen.show_result(saved, money)
	get_tree().paused = true 
