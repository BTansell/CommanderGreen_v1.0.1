extends KinematicBody2D

var timer = null
var velocity = Vector2(Global.enemySpeed/2,0)

const enemy_bullet_scene = preload("res://Scenes/Enemy/EnemyBullet.tscn")

signal enemy_event(change)

func _ready():
	$BulletCooldown.start()

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
	$BulletCooldown.stop()
	emit_signal("enemy_event",1)
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()


func _on_BulletCooldown_timeout():
	var enemy_bullet = enemy_bullet_scene.instance()
	get_parent().add_child(enemy_bullet)
	enemy_bullet.global_position = $ProjectileEmitter.global_position
	$Laser.play()
