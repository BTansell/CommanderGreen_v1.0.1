extends Control

func _ready():
	FadeIn.get_node("FadeInAnimation").play("MenuFadeIn")
	if Global.musicMuted == false:
		$DifficultyMusic.play()
