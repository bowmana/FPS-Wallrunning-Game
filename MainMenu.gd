extends Control

onready var mainsoundtrack = $main

func _ready():
	mainsoundtrack.play()


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
