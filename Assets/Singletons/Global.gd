extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var levels = [{'scene':'res://Scenes/World.tscn', 'map': 'Exodus'}, {'scene':'res://Scenes/World2.tscn', 'map': 'NightFall'}]
var end_screen = 'res://Scenes/UI/EndScreen.tscn'
var main_menu = 'res://Scenes/UI/MainMenu.tscn'
var tutorial = 'res://Scenes/Tutorial.tscn'
var level_select = 'res://Scenes/UI/LevelSelectMain.tscn'
var settings = 'res://Scenes/UI/Settings.tscn'
var ui_time_label = preload("res://Scenes/UI/UI.tscn").instance()
#onready var time_label_instance = ui_time_label_path.instance()
onready var time_label = ui_time_label.get_node("TimeLabel")
var current_level = 0
# Called when the node enters the scene tree for the first time.



func game_over(): #has player beaten prev high score
	get_tree().change_scene(end_screen)
	print("here fam")
	


func main_menu():
	get_tree().change_scene(main_menu)
	
func load_tutorial():
	get_tree().change_scene(tutorial)
	
func load_level_select():
	get_tree().change_scene(level_select)

func load_settings():
	get_tree().change_scene(settings)
func next_level():
	current_level +=1
	if current_level >= Global.levels.size():
		# no more levels to load
		game_over()
	else:
		get_tree().change_scene(levels[current_level]["scene"])
		
func new_game():


	current_level = -1
	next_level()
	
func prev_level():
	current_level -=1
	if current_level < 0:
		current_level = 0
	get_tree().change_scene(levels[current_level]["scene"])
	
func get_level():
	return levels[current_level]["scene"].split("/")[-1].split(".")[0]
	
func pick_level(level):
	current_level =level
	get_tree().change_scene(levels[current_level]["scene"])


func get_map():
	print(levels[current_level]["map"])

func _on_Button_pressed():
	main_menu()



var time = 0
var timer_on = false
var score = 0
func _process(delta):
	if(timer_on):
		time += delta
	var mils = fmod(time,1)*1000
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60)/60
	var hr = fmod(fmod(time,3600 * 60)/3600, 24)
	if time > 0:
		var time_passed = "%02d : %02d : %02d : %03d" % [hr,mins,secs,mils]
		if time_passed != null:
			time_label.text = time_passed
			set_score(time_passed)


func timer_start():
	timer_on = true
	
func timer_stop():
	timer_on = false
	
func timer_reset():
	pass

func set_score(value):
	score = value
	
func get_score():
	return score
	
var player_name = ""
func set_player_name(value):
	player_name = value
func get_player_name():
	return player_name
	
