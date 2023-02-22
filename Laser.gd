extends Spatial

export var ray_node : NodePath
var ray
var distance
func _ready():
	ray = get_node(ray_node)
	
func _process(delta):
	if ray.get_collider():
		distance = transform.origin.distance_to(ray.get_collision_point())
		$MeshInstance.rotation = ray.rotation
		$MeshInstance.scale = Vector3($MeshInstance.scale.x, $MeshInstance.scale.y, distance)
		$MeshInstance.translation = Vector3(0, 0, -1* (distance / 2))
		transform.origin = ray.transform.origin
	else:
		$MeshInstance.rotation = ray.rotation
		$MeshInstance.scale = Vector3($MeshInstance.scale.x, $MeshInstance.scale.y, ray.cast_to.z)
		$MeshInstance.translation = Vector3(0, 0, ray.cast_to.z / 2)
		transform.origin = ray.transform.origin
		
