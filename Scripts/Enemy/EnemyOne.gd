extends KinematicBody2D

var velocity = Vector2(Global.enemySpeed,0)

signal enemy_event(change)

func _process(delta):
	position += velocity * delta

func _on_Notifier_screen_exited():
	if global_position.x < 0:
		emit_signal("enemy_event",-1)
	queue_free()


func _on_CollisionArea_area_entered(area):
	area.get_parent()._hit()
	$CollisionArea.set_collision_mask(0)
	$CollisionArea.set_collision_layer(0)
	set_process(false)
	$Ship.hide()
	$Rocket.hide()
	$RocketParticles.hide()
	$ExplosionParticles.set_emitting(true)
	$Explosion.play()
	emit_signal("enemy_event",1)
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
