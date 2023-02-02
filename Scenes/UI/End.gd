extends Control



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Quit_pressed():
	Global.main_menu()
	



func _on_RestartLevel_pressed():
	Global.new_game()


func _on_LeaderBoards_pressed():
	var leaderboards = 'res://addons/silent_wolf/Scores/Leaderboard.tscn'
	get_tree().change_scene(leaderboards)


