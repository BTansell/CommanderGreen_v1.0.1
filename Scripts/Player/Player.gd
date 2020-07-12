extends KinematicBody2D

var speed = standard_speed
var bullet_delay = standard_bullet_delay
var can_shoot = true
var screen_size
var missed_bullets = 0
var shot_bullets = 0
var is_white = false

const standard_speed = 500
const standard_bullet_delay = 0.75
const player_bullet_scene = preload("res://Scenes/Player/PlayerBullet.tscn")

signal life_update(change)
signal final_accuracy(accuracy)

func _ready():
	screen_size = get_viewport_rect().size
	yield(get_tree().create_timer(0.01), "timeout")
	emit_signal("life_update")

func _process(delta):

	var velocity = Vector2()

	if Input.is_action_pressed("ui_left"):
		$Rocket.play("Backward")
		velocity.x -= 1

	if Input.is_action_pressed("ui_right"):
		$Rocket.play("Forward")
		velocity.x += 1

	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if Input.is_action_pressed("ui_down"):
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	if Input.is_action_pressed("ui_attack") && can_shoot:
		var player_bullet = player_bullet_scene.instance()
		get_parent().add_child(player_bullet)
		player_bullet.connect("missed_bullet", self, "_on_missed_bullet")
		player_bullet.global_position = $ProjectileEmitter.global_position
		shot_bullets += 1
		can_shoot = false
		$Laser.play()
		$BulletCooldown.wait_time = bullet_delay
		$BulletCooldown.start()

	if velocity.x == 0:
		$Rocket.play("Idle")

	position += velocity * delta
	position.x = clamp(position.x, 90, screen_size.x-56)
	position.y = clamp(position.y, 32, screen_size.y-46)

func _hit():
	Global.lives -= 1
	emit_signal("life_update")
	$CollisionArea.set_collision_mask(0)
	$CollisionArea.set_collision_layer(0)
	$ExplosionParticles.set_emitting(true)
	$Explosion.play()
	$PlayerDeath.play()
	if Global.lives == 0:
		if shot_bullets == 0:
			shot_bullets = 1
		
		emit_signal("final_accuracy",2.0-(float(missed_bullets)/shot_bullets))
		set_process(false)
		$Ship.hide()
		$Rocket.hide()
		$RocketParticles.hide()
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()
		
	else:
		_on_PowerUpCooldown_timeout()
		$Rocket.modulate = Color(1,1,1,0.25)
		$Ship.modulate = Color(1,1,1,0.25)
		$RocketParticles.modulate = Color(1,1,1,0.25)
		$DeathCooldown.start()

func _on_BulletCooldown_timeout():
	can_shoot = true

func _speed_power_up():
	$PowerUpCooldown.start()
	$PowerUpFlash.start()
	speed = 1000

func _gun_power_up():
	$PowerUpCooldown.start()
	$PowerUpFlash.start()
	bullet_delay = 0.25

func _life_power_up():
	Global.lives += 1
	emit_signal("life_update")

func _on_PowerUpCooldown_timeout():
	speed = standard_speed
	bullet_delay = standard_bullet_delay
	$PowerUpFlash.stop()
	is_white = false
	$Rocket.modulate = Color(1,1,1,1)
	$Ship.modulate = Color(1,1,1,1)
	$RocketParticles.modulate = Color(1,1,1,1)

func _on_PowerUpFlash_timeout():
	is_white = !is_white
	var rgb = pow(10,int(is_white))
	$Rocket.modulate = Color(rgb,rgb,rgb,1)
	$Ship.modulate = Color(rgb,rgb,rgb,1)
	$RocketParticles.modulate = Color(rgb,rgb,rgb,1)
	$PowerUpFlash.start()


func _on_DeathCooldown_timeout():
	can_shoot = true
	$Rocket.modulate = Color(1,1,1,1)
	$Ship.modulate = Color(1,1,1,1)
	$RocketParticles.modulate = Color(1,1,1,1)
	$CollisionArea.set_collision_layer(1)
	$CollisionArea.set_collision_mask(28)

func _on_missed_bullet():
	missed_bullets += 1
