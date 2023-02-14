extends Area

export var Uid : String
onready var node_parent = get_parent()
#onready var curr_weapon = 1

	
func _on_Area_body_entered(body):
	
	if body.name == "Player":
		WeaponInteract.entered_flag = true
		WeaponInteract.set_uid(Uid)
		WeaponInteract.set_remove_node(node_parent)
		if Weaponlist.get_primary() == null:
			Weaponlist.add_primary(Uid)
			get_parent().queue_free()
#			print(Weaponlist.get_weapons())
		elif Weaponlist.get_secondary() == null:
			Weaponlist.add_secondary(Uid)
			get_parent().queue_free()
#			print(Weaponlist.get_weapons())
#
			


func _on_WeaponPickup_body_exited(body):
	
	WeaponInteract.entered_flag = false


#
#func set_weapon(gun):
#	curr_weapon = gun
#func get_weapon():
#	return curr_weapon

#func _input(event):
#
#	if (Input.is_action_just_pressed("Interact") and entered and get_weapon()==1):
#		Weaponlist.primary_changed = true
#		Weaponlist.add_primary(Uid)
#		yield(get_tree().create_timer(0.1), "timeout")
#		get_parent().queue_free()
#	else:
#		Weaponlist.primary_changed= false
#
#	if (Input.is_action_just_pressed("Interact") and entered and get_weapon()==2):
#		Weaponlist.secondary_changed = true
#		Weaponlist.add_secondary(Uid)
#		yield(get_tree().create_timer(0.1), "timeout")
#		get_parent().queue_free()
#
#	else:
#		Weaponlist.secondary_changed= false

#func on_recieved(wep):
#	set_weapon(wep)
#
