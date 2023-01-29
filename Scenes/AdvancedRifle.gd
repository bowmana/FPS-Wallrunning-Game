

extends "res://Scenes/Weapon.gd"
onready var crosshair = crosshair_decal.instance()
var crosshair_raycast : RayCast
func _ready():
	crosshair_raycast = $MeshInstance/Laser
	get_tree().get_root().add_child(crosshair)

func _process(delta):
	if Input.is_action_pressed("ads"):

		crosshair.visible = true
		crosshair_raycast.cast_to = crosshair_raycast.cast_to.linear_interpolate(initial_cast_to + ads_cast_to_offset, ads_acceleration)
		var distance = raycast.get_collision_point().distance_to(raycast.global_transform.origin)
		var scalingfactor = lerp(0.05, 4, (distance) / 100)
		crosshair.scale = Vector3(scalingfactor,scalingfactor,scalingfactor)

		stamp_decal_to_normal(crosshair, crosshair_raycast)
	
	else:
		crosshair.visible = false
		
