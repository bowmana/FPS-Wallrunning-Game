extends "res://Scenes/Weapon.gd"


export var spread =8 #controls the random range of the additional raycasts
onready var ads_spread = spread/1.5
onready var no_ads_spread = spread

func fire(delta):
	can_fire = false
	current_ammo -=1
	set_ammo_count(current_ammo)
	anim_player.play("fire")
	recoil(delta)
	emit_smoke($smoke_spawn_point)
	emit_smoke($smoke_spawn_point2)
	play_shotsound()
	
	for i in range(10): # Fire 6 rays
		
		var new_raycast = raycast.duplicate()# Duplicate the raycast
		add_child(new_raycast)
		new_raycast.enabled = true
		new_raycast.cast_to += Vector3(rand_range(-spread, spread), rand_range(-spread, spread), rand_range(-spread, spread)) # Add random offset to the cast_to
		yield(get_tree().create_timer(.01), "timeout")
		check_collision(new_raycast)
		remove_child(new_raycast)
	yield(get_tree().create_timer(fire_rate), "timeout")
	can_fire = true
		

func _input(event):
	if Input.is_action_pressed("ads"):
		spread = ads_spread
	if Input.is_action_just_released("ads"):
		spread = no_ads_spread
		
		
