extends KinematicBody2D

var velocity = Vector2(-200,0)

func _ready():
	$CollisionArea.connect("area_entered", self, "_on_CollisionArea_area_entered")
	$Notifier.connect("screen_exited", self, "_on_Notifier_screen_exited")

func _process(delta):
	position += velocity * delta

func _on_Notifier_screen_exited():
	queue_free()

func _on_CollisionArea_area_entered(area):
	$CollisionArea.set_collision_mask(0)
	$CollisionArea.set_collision_layer(0)
	set_process(false)
	$PowerUp.hide()
	$PowerUpSound.play()
	_power_up_type(area)
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()

func _power_up_type(area):
	return
