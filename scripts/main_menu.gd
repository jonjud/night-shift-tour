extends Control

const MAIN_SCENE := "res://scenes/main.tscn"

@onready var start_button: Button = $Center/VBox/StartButton
@onready var quit_button: Button = $Center/VBox/QuitButton

func _ready() -> void:
	for b in [start_button, quit_button]:
		_style_button(b)
	# บนเว็บ Quit ใช้ไม่ได้ ซ่อนไปเลย
	if OS.has_feature("web"):
		quit_button.hide()
	start_button.pressed.connect(_on_start)
	quit_button.pressed.connect(get_tree().quit)
	start_button.grab_focus()  # กด Enter/Space เริ่มได้

func _on_start() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE)

# ใส่สไตล์ปุ่มจาก PNG 9-slice
func _style_button(b: Button) -> void:
	b.custom_minimum_size = Vector2(120, 28)
	b.add_theme_font_size_override("font_size", 16)
	b.add_theme_stylebox_override("normal", _box("res://assets/ui/btn_normal.png"))
	b.add_theme_stylebox_override("hover", _box("res://assets/ui/btn_hover.png"))
	b.add_theme_stylebox_override("pressed", _box("res://assets/ui/btn_pressed.png"))
	b.add_theme_stylebox_override("focus", _box("res://assets/ui/btn_hover.png"))

func _box(path: String) -> StyleBoxTexture:
	var sb := StyleBoxTexture.new()
	sb.texture = load(path)
	sb.texture_margin_left = 4
	sb.texture_margin_right = 4
	sb.texture_margin_top = 4
	sb.texture_margin_bottom = 4
	return sb
