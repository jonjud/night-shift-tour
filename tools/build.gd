@tool
extends EditorScript

# # = both world wall | . = both world passage
# n = open only at night | d = open only at day
const MAP: Array[String] = [
	"###############################",
	"#....#......#..........###....#",
	"#....#..#...n..........nnn....#",
	"#....n..n...n..........nnn....#",
	"#....#..#...n..........nnn....#",
	"#.......#...#..........###....#",
	"###############################",
]
const ORIGIN := Vector2i(-15, -3)  # ช่องซ้ายบนของ MAP อยู่ที่ tile นี้

func _run() -> void:
	var root := get_scene()
	var day: TileMapLayer = root.get_node("DayLayer")
	var night: TileMapLayer = root.get_node("NightLayer")
	day.clear()
	night.clear()
	for r in MAP.size():
		for c in MAP[r].length():
			var ch := MAP[r][c]
			var cell := ORIGIN + Vector2i(c, r)
			var day_wall := ch == "#" or ch == "n"
			var night_wall := ch == "#" or ch == "d"
			# day: 0=floor 1=wall 4=moon gate | night: 2=floor 3=wall 5=sun gate
			day.set_cell(cell, 0, Vector2i(4 if ch == "n" else (1 if day_wall else 0), 0))
			night.set_cell(cell, 0, Vector2i(5 if ch == "d" else (3 if night_wall else 2), 0))
	EditorInterface.save_scene()
	print("Map built")
