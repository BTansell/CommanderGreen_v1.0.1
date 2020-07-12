extends KinematicBody2D

var velocity = Vector2(1100,0)
var screen_size

signal missed_bullet

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	position += velocity * delta

func _on_Notifier_screen_exited():
	if self.global_position.x > screen_size.x:
		emit_signal("missed_bullet")
	queue_free()

func _hit():
	queue_free()
