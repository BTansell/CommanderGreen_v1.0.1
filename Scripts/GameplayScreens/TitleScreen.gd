extends Control


func _ready():
	FadeIn.get_node("FadeInAnimation").play("MenuFadeIn")
	$Menu/Logo/TitleBob.play("TitleBob")
	if Global.musicMuted == false:
		$TitleMusic.play()
