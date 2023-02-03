extends Control

onready var mainsoundtrack = $main

func _ready():
	yield(SilentWolf.Scores.get_high_scores(0, "Exodus"), "sw_scores_received")
	yield(SilentWolf.Scores.get_high_scores(0, "NightFall"), "sw_scores_received")
	mainsoundtrack.play()
	
	$Options.hide()


func _on_LevelSelect_pressed():
	Global.load_level_select()


func _on_Tutorial_pressed():
	Global.load_tutorial()


func _on_Settings_pressed():
	$Options.show()
	$OptionsMenu.hide()


func _on_MasterSlider_value_changed(value):
	if value == -45:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		AudioServer.set_bus_volume_db(0,value)


func _on_Button_pressed():
	$Options.hide()
	$OptionsMenu.show()


func _on_FXSlider_value_changed(value):
	if value == -45:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
		AudioServer.set_bus_volume_db(1,value)


func _on_MusicSlider_value_changed(value):
	if value == -45:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
		AudioServer.set_bus_volume_db(2,value)

	


func _on_Leaderboards_pressed():
	var scene = "res://addons/silent_wolf/Scores/Leaderboard.tscn"
	get_tree().change_scene(scene)
