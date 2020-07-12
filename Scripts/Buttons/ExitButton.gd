extends "res://Templates/MenuButton.gd"

func _ready():
	scene_path = "TitleScreen.tscn"

func _extra_button_function():
	get_tree().quit()
