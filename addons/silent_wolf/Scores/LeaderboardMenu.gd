extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var drop_down = $OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	drop_down.add_item("Exodus")
	drop_down.add_item("NightFall")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OptionButton_item_selected(index):
	var curr_selected = index
	
	if curr_selected == 0:
		$NightFall.hide()
		$Exodus.show()
	elif curr_selected == 1:
		$NightFall.hide()
		$Exodus.hide()
