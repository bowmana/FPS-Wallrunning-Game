extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var levels = ['res://Scenes/World.tscn', 'res://Scenes/World2.tscn']
var end_screen = 'res://Scenes/UI/EndScreen.tscn'
var main_menu = 'res://Scenes/UI/MainMenu.tscn'
var tutorial = 'res://Scenes/Tutorial.tscn'
var level_select = 'res://Scenes/UI/LevelSelectMain.tscn'
var settings = 'res://Scenes/UI/Settings.tscn'
var current_level = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
		get_tree().change_scene(levels[current_level])
		
func new_game():


	current_level = -1
	next_level()
	
func prev_level():
	current_level -=1
	if current_level < 0:
		current_level = 0
	get_tree().change_scene(levels[current_level])
	
func get_level():
	return levels[current_level].split("/")[-1].split(".")[0]
	
func pick_level(level):
	current_level =level
	get_tree().change_scene(levels[current_level])


func _on_Button_pressed():
	main_menu()
