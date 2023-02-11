extends "res://Scenes/Weapon.gd"
var player_anim_player : AnimationPlayer
var zoomed: bool = false

func _ready():
	player_anim_player = get_node("/root/World/Player/AnimationPlayer")
func zoom():
	if !zoomed:
		player_anim_player.play("zoom")
	else:
		player_anim_player.play_backwards("zoom")
		
	zoomed = !zoomed


func _input(event):
	if event.is_action_pressed("ads"):
		zoom()
	if event.is_action_released("ads"):
		zoom()
		
		
