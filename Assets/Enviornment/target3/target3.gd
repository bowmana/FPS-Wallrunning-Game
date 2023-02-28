extends "res://Scenes/Health.gd"
export var _floor : NodePath
var floor_node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target_hit = false
func _ready():
	floor_node = get_node(_floor)
	
	

# Called when the node enters the scene tree for the first time.
func destruction():
	$CollisionShape.queue_free()
	$window_round.queue_free()
	$window_round2.queue_free()
	$window_round3.queue_free()
	$glasssound.play()

	get_node("Destruction").destroy()
	target_hit = true
		
	


func _process(delta):
	if !target_hit:
		floor_node.rotation += Vector3(0,.5,0) *delta

	
	
	

	
#	var mat1 : SpatialMaterial= _mesh.mesh.surface_get_material(1)
##	mat1.albedo_color = Color.red
##	_mesh.set_surface_material(0,mat1)
#	var matOverride :SpatialMaterial  = mat1.set_ma
	
	
#	var mat2 : SpatialMaterial= _mesh.mesh.surface_get_material(2)
#	mat1.albedo_color = Color(1,0,0)
	
	
	
