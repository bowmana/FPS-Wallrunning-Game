extends Spatial

class_name Weapon

export var fire_rate = 0.5
export var clip_size = 5
export var reload_speed = 1
export var default_position : Vector3
export var ads_position : Vector3
export var ads_acceleration : float = 0.7
export var default_fov : float = 70 #default camera view for all games in godot
export var ads_fov : float = 55
export var ads_cast_from : Vector3 = Vector3(0,.1,0)

onready var ammo_label = $"/root/World/UI/Label"
onready var b_decal = preload("res://Scenes/Player/Decals/BulletDecal.tscn")
onready var crosshair_decal = preload("res://Scenes/Player/Decals/CrossHair.tscn")
onready var weaponPickup = preload("res://Scenes/UI/WeaponPickup.tscn")


var weapon : Spatial
var raycast : RayCast

var camera : Camera

var anim_player : AnimationPlayer

var current_ammo = 0
var can_fire = true
var reloading = false

export var ads_cast_to_offset : Vector3 = Vector3(0,8.33,0)
var initial_cast_to : Vector3 =  Vector3(0,0,0)
var rayPos : Vector3 =  Vector3(0,0,0)
func _ready():
	current_ammo = clip_size

	raycast = $RayCast

	camera = get_node("/root/World/Player/Head/Camera")

	rayPos = raycast.transform.origin
	initial_cast_to = raycast.cast_to
	anim_player = $AnimationPlayer
	


func _process(delta):

	if reloading:
		ammo_label.set_text("reloading")
	else:
		ammo_label.set_text("%d / %d" % [current_ammo, clip_size])
	
	if Input.is_action_pressed("primary_fire") and can_fire:
		#fire weapon
		if current_ammo >0 and not reloading:
			
			fire()

		elif not reloading: 
			reload()

	if Input.is_action_just_pressed("reload") and not reloading:
		reload()
		
	if Input.is_action_pressed("ads"):
		transform.origin = transform.origin.linear_interpolate(ads_position, ads_acceleration)


		raycast.transform.origin = (rayPos + ads_cast_from)

		raycast.cast_to = raycast.cast_to.linear_interpolate(initial_cast_to + ads_cast_to_offset, ads_acceleration)



		camera.fov = lerp(camera.fov, ads_fov, ads_acceleration)
		GlobalGameSettings.set_dec_sensitivity(.2)
	else:
		transform.origin = transform.origin.linear_interpolate(default_position, ads_acceleration)
		raycast.transform.origin = rayPos

		raycast.cast_to = raycast.cast_to.linear_interpolate(initial_cast_to,ads_acceleration)

		camera.fov = lerp(camera.fov, default_fov, ads_acceleration)
		GlobalGameSettings.set_dec_sensitivity(1)
		
		
		
func check_collision(_raycast):
	print(_raycast.cast_to)
	if _raycast.is_colliding():
		var collider = _raycast.get_collider()
		print(collider)
		print("herre???")
		var b = b_decal.instance()
		
		if collider.is_in_group("Enemies"):
			collider.queue_free()
			print("killed " + collider.name)
		if collider.is_in_group("Target"):
			pass
		
		get_tree().get_root().add_child(b)
	
		stamp_decal_to_normal(b, _raycast)


func fire(): 
	print("fired weapon")
	
	can_fire = false
	current_ammo -=1
	anim_player.play("fire")
	check_collision(raycast)
	yield(get_tree().create_timer(fire_rate), "timeout")
	can_fire = true

	
func reload():
	print("reloading")
	anim_player.play("reloadsmg")
	reloading = true
	yield(get_tree().create_timer(reload_speed), "timeout")
	current_ammo = clip_size
	reloading = false
	print("reload complete")


func stamp_decal_to_normal(decal, _raycast):
	decal.global_transform.origin = _raycast.get_collision_point()
	print(decal)
	var surface_dir_up = Vector3(0,1,0)
	var surface_dir_down = Vector3(0,-1,0)
	
	if _raycast.get_collision_normal() == surface_dir_up:
		decal.look_at(_raycast.get_collision_point() + _raycast.get_collision_normal(), Vector3.RIGHT)
	elif _raycast.get_collision_normal() == surface_dir_down:
		decal.look_at(_raycast.get_collision_point() + _raycast.get_collision_normal(), Vector3.RIGHT)
	else:
		decal.look_at(_raycast.get_collision_point() + _raycast.get_collision_normal(), Vector3.DOWN)




