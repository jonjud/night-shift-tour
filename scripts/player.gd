extends CharacterBody2D

const SPEED := 120.0
const TRAIL_MAX := 200  # จำนวนตำแหน่งที่จดไว้ย้อนหลัง

var trail: Array[Vector2] = []

func _ready() -> void:
	# เติม trail ด้วยตำแหน่งเริ่มต้น แขกจะได้เกิดซ้อนกับผู้เล่น
	trail.resize(TRAIL_MAX)
	trail.fill(global_position)

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * SPEED
	move_and_slide()
	# จดตำแหน่งใหม่เฉพาะตอนขยับ (ใส่หน้าสุด ทิ้งอันเก่าสุดท้ายสุด)
	if velocity != Vector2.ZERO:
		trail.push_front(global_position)
		trail.pop_back()
