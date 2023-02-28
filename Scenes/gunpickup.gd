
extends Interactable
export var Uid : String
onready var node_parent = get_parent()
func _ready():
	WeaponInteract.interact_flag = false

func interact():
	WeaponInteract.set_remove_node(node_parent)
	WeaponInteract.set_uid(Uid)
	WeaponInteract.interact_flag = true
	


	if Weaponlist.get_primary() == null:
		Weaponlist.add_primary(Uid)
		get_parent().queue_free()
	elif Weaponlist.get_secondary() == null:
		Weaponlist.add_secondary(Uid)
		get_parent().queue_free()
