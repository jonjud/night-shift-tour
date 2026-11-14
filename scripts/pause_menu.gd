extends CanvasLayer

const MENU_SCENE := "res://scenes/main_menu.tscn"

@onready var root: Control = $Root
@onready var resume_button: Button = $Root/Center/VBox/ResumeButton
@onready var slider: HSlider = $Root/Center/VBox/VolumeSlider
@onready var menu_button: Button = $Root/Center/VBox/MenuButton

func _ready() -> void:
	root.hide()
	# Start slider ref to present volume
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	slider.value_changed.connect(_on_volume)
	resume_button.pressed.connect(_resume)
	menu_button.pressed.connect(_to_menu)

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("pause"):
		return
	if root.visible:
		_resume()
	elif not get_tree().paused:  # if tree were pausing , ending screen can't turn on
		root.show()
		get_tree().paused = true
		resume_button.grab_focus()
	get_viewport().set_input_as_handled()

func _resume() -> void:
	root.hide()
	get_tree().paused = false

func _on_volume(v: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(v))  # 0 = Master

func _to_menu() -> void:
	get_tree().paused = false  # un-pause before change scene
	get_tree().change_scene_to_file(MENU_SCENE)
