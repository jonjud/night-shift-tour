extends Node2D

const SPEED := 30.0  # slower than player
const TOUCH_DIST := 8.0 #the distance that count as "touching" *feeling weird saying that*

var active := false  # true only at night (nightLayer)

func set_night(is_night: bool) -> void:
	active = is_night
	visible = is_night  # Hide in daylight

func _physics_process(delta: float) -> void:
	if not active:
		return
	var target := _nearest_guest()
	if target == null:
		return
	global_position = global_position.move_toward(target.global_position, SPEED * delta)
	# touched = vanish
	if global_position.distance_to(target.global_position) <= TOUCH_DIST:
		target.vanish()

# find the nearest guest
func _nearest_guest() -> Node2D:
	var best: Node2D = null
	var best_dist := INF
	for g in get_tree().get_nodes_in_group("guests"):
		var d := global_position.distance_to(g.global_position)
		if d < best_dist:
			best_dist = d
			best = g
	return best
