extends "res://Templates/MenuButton.gd"

func _ready():
	scene_path = "MainScreen.tscn"

func _extra_button_function():
	Global.lives = 1
	Global.enemySpeed = -800
	Global.enemySpawnCap = 0.01
	Global.difficultyMult = 2
