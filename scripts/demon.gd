extends Node2D

@export var zone_radius := 40.0  # equal to Radius of CircleShape2D

var active := false  # true on;y at night

func set_night(is_night: bool) -> void:
	active = is_night
	visible = is_night  # hide in daylight

func _physics_process(_delta: float) -> void:
	if not active:
		return  # day is safe zone
	for g in get_tree().get_nodes_in_group("guests"):
		if global_position.distance_to(g.global_position) <= zone_radius:
			g.vanish()  # the guest in the zone = being captive :)
