extends "res://Templates/MenuButton.gd"

func _ready():
	scene_path = "MainScreen.tscn"

func _extra_button_function():
	Global.lives = 2
	Global.enemySpeed = -600
	Global.enemySpawnCap = 0.02
	Global.difficultyMult = 1
