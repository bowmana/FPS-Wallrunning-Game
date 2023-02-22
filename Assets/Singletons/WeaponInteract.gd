extends Node


onready var entered_flag = false
var uid
var node
var zoomed = true
func set_uid(id):
	uid = id
	
func get_uid():
	return uid


func set_remove_node(remove_node):
	node = remove_node
	
func get_remove_node():
	return node

func set_zoom(val):
	zoomed = val
	
func get_zoom():
	return zoomed
	
func _input(event):
	if event.is_action_pressed("ads"):
		set_zoom(false)
	if event.is_action_released("ads"):
		set_zoom(true)
