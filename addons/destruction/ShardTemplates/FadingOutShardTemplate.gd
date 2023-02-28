extends RigidBody

func _ready():
	apply_impulse(Vector3(randf(), .1, randf()) - Vector3.ONE * 25, -translation.normalized() / 10 + Vector3.UP * 6)
	var material : SpatialMaterial = load('res://Assets/Models/Materials/glass.tres')
	if not material:
		return
	material = material.duplicate()
	$MeshInstance.material_override = material
	material.flags_transparent = true
	
	$Tween.interpolate_property(material, "albedo_color", material, Color(1,1,1,0), 2, Tween.TRANS_EXPO, Tween.EASE_OUT, 4)
	$Tween.start()
