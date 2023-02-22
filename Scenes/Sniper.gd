extends "res://Scenes/Weapon.gd"
var zoomed: bool = false
var player_anim_player : AnimationPlayer
func _ready():
	player_anim_player = get_node("/root/World/Player/AnimationPlayer2")
func zoom():
	if !zoomed:
#		WeaponInteract.set_zoom(zoomed)
		player_anim_player.play("zoom")
	else:
#		WeaponInteract.set_zoom(zoomed)
		player_anim_player.play_backwards("zoom")
		
	zoomed = !zoomed

func _input(event):
	if event.is_action_pressed("ads"):
		
		zoom()
	if event.is_action_released("ads"):
		zoom()




