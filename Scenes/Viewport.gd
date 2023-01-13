extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	print("                 [Screen Metrics]")
#	print("            Display size: ", OS.get_screen_size())
#	print("   Decorated Window size: ", OS.get_real_window_size())
#	print("             Window size: ", OS.get_window_size())
#	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
#	print(OS.get_window_size().x)
#	print(OS.get_window_size().y)
	self.size = OS.get_window_size()
	print(self.size.x)
	print(self.size.y)
