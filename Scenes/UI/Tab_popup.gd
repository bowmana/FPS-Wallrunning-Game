extends Control
var mastersound
var fxsound
var musicsound
func _ready():
	mastersound = AudioServer.get_bus_volume_db(0)
	fxsound = AudioServer.get_bus_volume_db(1)
	musicsound = AudioServer.get_bus_volume_db(2)
	$Options/MasterSlider.value = mastersound
	$Options/FXSlider.value = fxsound
	$Options/MusicSlider.value = musicsound
	

var tabbed = false
func _input(event):
	if Input.is_action_just_pressed("tab"):
		tabbed = !tabbed
		if tabbed:
			show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
	
	
func _on_RestartLevel_pressed():
	Global.new_game()


func _on_Quit_pressed():
	Global.main_menu()


func _on_Settings_pressed():
	$OptionsMenu.hide()
	$Options.show()


func _on_Button_pressed():
	$OptionsMenu.show()
	$Options.hide()
	
	
func _on_MasterSlider_value_changed(value):
	if value == -45:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		AudioServer.set_bus_volume_db(0,value)
	
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


