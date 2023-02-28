extends "res://Scenes/Health.gd"
export var _floor : NodePath
var floor_node
export var mesh_instance_str : String

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	node_delete = get_parent()
	floor_node = get_node(_floor)

	

# Called when the node enters the scene tree for the first time.
func destruction():
	$CollisionShape.queue_free()
	$window_round.queue_free()
	$window_round2.queue_free()
	$window_round3.queue_free()
	

	get_node("Destruction").destroy()
	get_parent().get_node("glasssound").play()
	modulation()
		
	


func modulation():
	var _mesh : MeshInstance = (floor_node.get_node(mesh_instance_str))
	_mesh.set_material_override(null)

	
	
	

	
#	var mat1 : SpatialMaterial= _mesh.mesh.surface_get_material(1)
##	mat1.albedo_color = Color.red
##	_mesh.set_surface_material(0,mat1)
#	var matOverride :SpatialMaterial  = mat1.set_ma
	
	
#	var mat2 : SpatialMaterial= _mesh.mesh.surface_get_material(2)
#	mat1.albedo_color = Color(1,0,0)
	
	
	
