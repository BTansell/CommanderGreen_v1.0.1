extends "res://Templates/MenuButton.gd"

func _ready():
	if Global.musicMuted == true:
		$AnimatedSprite.play("NoMusic")

func _on_MenuButton_pressed():
	if Global.musicMuted == true:
		Global.musicMuted = false
		$AnimatedSprite.play("Music")
		get_tree().get_root().get_node("/root/TitleScreen/TitleMusic").play()
	else:
		Global.musicMuted = true
		$AnimatedSprite.play("NoMusic")
		get_tree().get_root().get_node("/root/TitleScreen/TitleMusic").stop()
