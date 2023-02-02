extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
	
		Global.timer_stop()
		print(Global.get_score())
		Global.get_map()
#		Global.get_score()
		
		var score_id = SilentWolf.Scores.persist_score(SilentWolf.Auth.logged_in_player, 5)
		print("Score persisted successfully: " + str(score_id))
		yield(SilentWolf.Scores.get_high_scores(), "sw_scores_received")
		print("Scores: " + str(SilentWolf.Scores.scores))
		yield(get_tree().create_timer(3), "timeout")
		var endscene = 'res://Scenes/UI/End.tscn'
		get_tree().change_scene(endscene)
