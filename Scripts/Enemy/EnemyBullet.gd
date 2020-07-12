extends KinematicBody2D

var velocity = Vector2(Global.enemySpeed*1.5,0)
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	position += velocity * delta

func _on_Notifier_screen_exited():
	queue_free()

func _on_CollisionArea_area_entered(area):
	area.get_parent()._hit()
	queue_free()
