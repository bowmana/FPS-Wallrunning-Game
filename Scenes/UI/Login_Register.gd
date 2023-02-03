extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Login_pressed():
	var login_scene = "res://addons/silent_wolf/Auth/Login.tscn"
	get_tree().change_scene(login_scene)


func _on_Register_pressed():
	var register_scene = "res://addons/silent_wolf/Auth/Register.tscn"
	get_tree().change_scene(register_scene)
