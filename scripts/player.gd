extends CharacterBody2D

const SPEED : float = 120.0

func _physics_process(delta: float) -> void:
	#read direction from wasd and move
	var dir : Vector2 = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = dir * SPEED
	move_and_slide()
	
