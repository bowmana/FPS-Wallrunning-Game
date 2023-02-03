extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.playback_speed = 2
	$AnimationPlayer.play("melon")
	$Label/Tween.interpolate_property(
		$Label, "percent_visible",
		0.0,1.0,1.0,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Label/Tween.start()
	yield(get_tree().create_timer(3), "timeout")
	get_tree().change_scene("res://Scenes/UI/Login_Register.tscn")
