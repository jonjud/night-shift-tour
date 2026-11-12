extends Node2D

@export var trail_offset := 12  # ยิ่งมาก ยิ่งตามห่างผู้เล่น

# ดึง Player ซึ่งต้องเป็นพี่น้องกัน (อยู่ใต้ Main เหมือนกัน)
@onready var player: CharacterBody2D = get_node("../Player")

func _physics_process(_delta: float) -> void:
	# ไปยืนที่ตำแหน่งย้อนหลังของผู้เล่น
	global_position = player.trail[trail_offset]
