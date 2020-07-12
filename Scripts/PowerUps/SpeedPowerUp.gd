extends "res://Templates/PowerUp.gd"

func _power_up_type(area):
	area.get_parent()._speed_power_up()
