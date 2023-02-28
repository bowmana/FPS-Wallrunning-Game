extends Node
class_name Health
onready var hitmark_sound = $hitmarker
export var health = 100
var node_delete = self
func decrease_health(val):
	print(val, "damage value")
	
	play_hitmark_sound()
	print("decrease health")
	if health > 0:
		health -= val
	if health <= 0:
		destruction()
		get_tree().create_timer(5.5).connect("timeout", node_delete, "queue_free")
		
	print(health)
		
func destruction():
	print("health gone")
	get_node("cube/Destruction").destroy()
	$Explosion.emitting = true
	$explosionsound.play()
	$glasssound.play()
	$CollisionShape.queue_free()
	$mesh.queue_free()
	

	
func play_hitmark_sound():
	SoundManager.play_sfx(hitmark_sound.stream, get_tree().current_scene)
