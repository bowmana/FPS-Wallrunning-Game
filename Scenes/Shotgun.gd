extends "res://Scenes/Weapon.gd"


export var spread =8 #controls the random range of the additional raycasts

func fire(delta):
	can_fire = false
	current_ammo -= 1
	anim_player.play(weapon_fire_anim)
	var side_recoil = rand_range(-4,4)
	var recoil = rand_range(1,1.5)
	up_recoil += recoil * delta
	head.rotation.x = lerp(head.rotation.x, deg2rad(head.rotation_degrees.x + up_recoil), delta)
	head.rotation.y = lerp(head.rotation.y, deg2rad(side_recoil), 2*delta)
	
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
		


