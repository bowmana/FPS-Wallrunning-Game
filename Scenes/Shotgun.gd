extends "res://Scenes/Weapon.gd"


export var spread =1 #controls the random range of the additional raycasts

func fire():
	print("fired weapon")
	current_ammo -= 1
	can_fire = false
	for i in range(6): # Fire 6 rays
		var new_raycast = raycast.duplicate()# Duplicate the raycast
		add_child(new_raycast)
		new_raycast.enabled = true
		new_raycast.cast_to += Vector3(rand_range(-spread, spread), rand_range(-spread, spread), rand_range(-spread, spread)) # Add random offset to the cast_to

		check_collision(new_raycast)
		yield(get_tree().create_timer(.1), "timeout")
		remove_child(new_raycast)
		
	
	
	yield(get_tree().create_timer(.1), "timeout")
	can_fire = true

