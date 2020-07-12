extends Node2D

var score
var rand
var screen_size
var enemy_cooldown
var accuracy_mult
var enemy_array = [en_one,en_one,en_two]
var power_up_array = [pu_gun,pu_gun,pu_speed,pu_speed,pu_life]

const en_one = preload("res://Scenes/Enemy/EnemyOne.tscn")
const en_two = preload("res://Scenes/Enemy/EnemyTwo.tscn")
const pu_speed = preload("res://Scenes/PowerUps/SpeedPowerUp.tscn")
const pu_gun = preload("res://Scenes/PowerUps/GunPowerUp.tscn")
const pu_life = preload("res://Scenes/PowerUps/LifePowerUp.tscn")

func _ready():
	FadeIn.get_node("FadeInAnimation").play("MenuFadeIn")
	rand = RandomNumberGenerator.new()
	screen_size = get_viewport_rect().size
	score = 0
	enemy_cooldown = 5
	$SpawnTimer.set_wait_time(enemy_cooldown)
	$ScoreLabel.set_text("SCORE: " + str(score))
	$Player.connect("life_update", self, "_on_life_event")
	$Player.connect("final_accuracy", self, "_on_final_accuracy")
	$SpawnTimer.connect("timeout", self, "_on_spawn_timeout_complete")
	$PowerUpTimer.connect("timeout", self, "_on_power_up_spawn_timeout_complete")
	$SpawnTimer.start()
	$PowerUpTimer.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Global.musicMuted == false:
		$MainMusic.play()

func _on_spawn_timeout_complete():
	rand.randomize()
	var new_enemy = enemy_array[rand.randi_range(0,2)].instance()
	rand.randomize()
	new_enemy.position.x = screen_size.x + 100
	new_enemy.position.y = rand.randf_range(40,screen_size.y-40)
	add_child(new_enemy)
	new_enemy.connect("enemy_event", self, "_on_enemy_event")
	enemy_cooldown *= 0.95
	enemy_cooldown += Global.enemySpawnCap
	$SpawnTimer.set_wait_time(enemy_cooldown)

func _on_power_up_spawn_timeout_complete():
	rand.randomize()
	var new_power_up = power_up_array[rand.randi_range(0,4)].instance()
	rand.randomize()
	new_power_up.position.x = screen_size.x + 100
	new_power_up.position.y = rand.randf_range(40,screen_size.y-40)
	add_child(new_power_up)

func _on_enemy_event(change):
	score += change
	$ScoreLabel.set_text("SCORE: " + str(score))

func _on_life_event():
	$LivesLabel.set_text("LIVES: " + str(Global.lives))
	
	if Global.lives == 0:
		$ScoreLabel.hide()
		$LivesLabel.hide()
		yield(get_tree().create_timer(1), "timeout")
		get_tree().paused = true
		var finalScore = int(score * accuracy_mult * Global.difficultyMult)
		$EndScore/ScoreMenu/ScoreSection/ScoreCalcLabel.set_text("Base Score: " \
		+ str(score) + "\nAccuracy Multiplier: x" + str(stepify(accuracy_mult,0.01)) \
		+ "\nDifficulty Multiplier: x" + str(Global.difficultyMult))
		$EndScore/ScoreMenu/ScoreSection/ScoreFinalLabel.set_text("Total Score: " \
		+ str(finalScore))
		$EndScore.show()
		SaveSystem.loadScore("Score","HighScore")
		
		if SaveSystem.highScore < finalScore or SaveSystem.highScore == null:
			SaveSystem.highScore = finalScore
			SaveSystem.saveScore("Score","HighScore")
		
		$EndScore/ScoreMenu/ScoreSection/HighScoreLabel.set_text("High Score: " \
		+ str(SaveSystem.highScore))
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_final_accuracy(accuracy):
	accuracy_mult = accuracy
