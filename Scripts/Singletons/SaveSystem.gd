extends Node

var highScore

var save_path = "user://HighScore.cfg"
var config = ConfigFile.new()

func saveScore(section, key):
	config.set_value(section, key, highScore)
	config.save(save_path)

func loadScore(section, key):
	config.load(save_path)
	highScore = config.get_value(section, key)
