extends Node

onready var hitmark_sound = $hitmarker
export var health = 100

func decrease_health(val):
	print(val, "damage value")
	
	play_hitmark_sound()
	print("decrease health")
	if health > 0:
		health -= val
	if health <= 0:
		print("health gone")
		queue_free()
	print(health)
		

func play_hitmark_sound():
	SoundManager.play_sfx(hitmark_sound.stream, get_tree().current_scene)
