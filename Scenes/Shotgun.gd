extends "res://Scenes/Weapon.gd"


export var spread =8 #controls the random range of the additional raycasts

func fire(delta):
	can_fire = false
	current_ammo -= 1
	anim_player.play("fire")
	recoil(delta)
	emit_smoke()
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
		


