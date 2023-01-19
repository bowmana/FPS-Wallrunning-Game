extends Node


onready var entered_flag = false
var uid
var node
func set_uid(id):
	uid = id
	
func get_uid():
	return uid


func set_remove_node(remove_node):
	node = remove_node
	
func get_remove_node():
	return node
