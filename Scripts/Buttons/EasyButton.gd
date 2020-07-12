extends "res://Templates/MenuButton.gd"

func _ready():
	scene_path = "MainScreen.tscn"

func _extra_button_function():
	Global.lives = 3
	Global.enemySpeed = -400
	Global.enemySpawnCap = 0.04
	Global.difficultyMult = 0.5
