extends Particles
var cloud : Spatial
func _ready():
	cloud = get_parent()
	emitting = true
	var rotation_angle = rand_range(-45, 45)
	cloud.rotation_degrees.z = rotation_angle
	cloud.rotation_degrees.y = rotation_angle
	
func _process(delta):
	cloud.translation.x += delta 
	cloud.translation.y -= delta
	if not emitting:
		get_tree().create_timer(5).connect("timeout", cloud, "queue_free")



	
