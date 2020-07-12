extends Button

var scene_path = "TitleScreen"

func _ready():
	self.connect("pressed", self, "_on_MenuButton_pressed")
	self.connect("mouse_entered", self, "_on_MenuButton_mouse_entered")
	self.connect("mouse_exited", self, "_on_MenuButton_mouse_exited")

func _on_MenuButton_pressed():
	$MenuSelect.play()
	FadeIn.get_node("FadeInAnimation").play_backwards("MenuFadeIn")
	yield(get_tree().create_timer(2), "timeout")
	_extra_button_function()
	get_tree().change_scene("res://Scenes/GameplayScreens/" + scene_path)
	get_tree().paused = false

func _on_MenuButton_mouse_entered():
	$ButtonBob.play("ButtonBob")
	$Label.modulate = Color(1.5,1.5,1.5,1)
	$MenuHover.play()

func _on_MenuButton_mouse_exited():
	$ButtonBob.stop()
	$Label.modulate = Color(1,1,1,1)

func _extra_button_function():
	return
