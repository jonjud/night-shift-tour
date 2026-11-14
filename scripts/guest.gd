extends Node2D

const LOST_SFX := preload("res://assets/audio/guest_lost.wav")

@export var trail_offset := 12  # ยิ่งมาก ยิ่งตามห่างผู้เล่น

# ดึง Player ซึ่งต้องเป็นพี่น้องกัน (อยู่ใต้ Main เหมือนกัน)
@onready var player: CharacterBody2D = get_node("../Player")

func _physics_process(_delta: float) -> void:
	# ไปยืนที่ตำแหน่งย้อนหลังของผู้เล่น
	global_position = player.trail[trail_offset]

func vanish() -> void:
	remove_from_group("guests")
	var tw : Tween = create_tween()
	tw.tween_property(self , "modulate:a", 0.0, 0.25)
	tw.tween_callback(queue_free)
	# play on the scene root: this node is freed after the fade
	var p := AudioStreamPlayer.new()
	p.stream = LOST_SFX
	p.volume_db = -10.0  # quieter; 0 = original, -6 ≈ half, -12 ≈ quarter
	get_tree().current_scene.add_child(p)
	p.finished.connect(p.queue_free)
	p.play()

# pulled into the Ferris wheel: fly to the hub, shrink, fade
func suck_into(target: Vector2) -> void:
	remove_from_group("guests")
	set_physics_process(false)  # stop following the player's trail
	var tw := create_tween().set_parallel(true)
	tw.tween_property(self, "global_position", target, 0.35)
	tw.tween_property(self, "scale", Vector2(0.2, 0.2), 0.35)
	tw.tween_property(self, "modulate:a", 0.0, 0.35)
	tw.chain().tween_callback(queue_free)
