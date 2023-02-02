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
export var weapon_fire_anim: String
export var fully_auto :bool

onready var ammo_label = $"/root/World/UI/Label"
onready var b_decal = preload("res://Scenes/Player/Decals/BulletDecal.tscn")
onready var crosshair_decal = preload("res://Scenes/Player/Decals/CrossHair.tscn")
onready var laser_decal_path = preload("res://Scenes/Player/Decals/LaserDecal.tscn")
onready var laser_decal = laser_decal_path.instance()
onready var weaponPickup = preload("res://Scenes/UI/WeaponPickup.tscn")




var weapon : Spatial
var raycast : RayCast
var laser : RayCast

var camera : Camera
var head: Spatial
var anim_player : AnimationPlayer

var current_ammo = 0
var can_fire = true
var reloading = false
var up_recoil = 0

export var ads_cast_to_offset : Vector3 = Vector3(0,8.33,0)
export var stream_sounds: Array
var last_shot_sound = floor(rand_range(0,3))
var initial_cast_to : Vector3 =  Vector3(0,0,0)
var rayPos : Vector3 =  Vector3(0,0,0)
onready var shootsound = $shoot

func _ready():
	
	current_ammo = clip_size

#	raycast = $RayCast
	laser = $Laser
	raycast = get_node("/root/World/Player/Head/Camera/RayCast")
	add_child(laser_decal)
	camera = get_node("/root/World/Player/Head/Camera")
	head = get_node("/root/World/Player/Head")
#	rayPos = raycast.transform.origin
#	initial_cast_to = raycast.cast_to
#	anim_player = get_node("/root/World/Player/AnimationPlayer")
	anim_player = $AnimationPlayer
func play_shotsound():
	var rand_shot = floor(rand_range(0,4))
	while rand_shot == last_shot_sound:
		rand_shot = floor(rand_range(0,4))
	match str(rand_shot):
		"0":
			shootsound.stream = stream_sounds[0]
		"1":
			shootsound.stream = stream_sounds[1]
		"2":
			shootsound.stream = stream_sounds[2]
		"3":
			shootsound.stream = stream_sounds[3]
	shootsound.pitch_scale = rand_range(-20,-14)

	shootsound.play()
	last_shot_sound = rand_shot

func _process(delta):

	if reloading:
		ammo_label.set_text("reloading")
	else:
		ammo_label.set_text("%d / %d" % [current_ammo, clip_size])
	if fully_auto:
		if Input.is_action_pressed("primary_fire") and can_fire:
			#fire weapon
			if current_ammo >0 and not reloading:
				
				fire(delta)

			elif not reloading: 
				reload()
				
		if ! Input.is_action_pressed("primary_fire") and can_fire:
			up_recoil = 0
	else:
		if Input.is_action_just_pressed("primary_fire") and can_fire:
			#fire weapon
			if current_ammo >0 and not reloading:
				
				fire(delta)

			elif not reloading: 
				reload()
				
		if ! Input.is_action_just_pressed("primary_fire") and can_fire:
			up_recoil = 0
		
		
		

	if Input.is_action_just_pressed("reload") and not reloading:
		reload()
		
	if Input.is_action_pressed("ads"):
		transform.origin = transform.origin.linear_interpolate(ads_position, ads_acceleration)


#		raycast.transform.origin = (rayPos + ads_cast_from)
#
#		raycast.cast_to = raycast.cast_to.linear_interpolate(initial_cast_to + ads_cast_to_offset, ads_acceleration)

		var distance = raycast.get_collision_point().distance_to(raycast.global_transform.origin)
		var scalingfactor = lerp(.3, 4, (distance) / 100)
		laser_decal.scale = Vector3(scalingfactor,scalingfactor,scalingfactor)
		stamp_decal_to_normal(laser_decal, raycast)
		laser.visible = false
		raycast.visible = true
		camera.fov = lerp(camera.fov, ads_fov, ads_acceleration)
		GlobalGameSettings.set_dec_sensitivity(.2)
	else:
		transform.origin = transform.origin.linear_interpolate(default_position, ads_acceleration)
#		raycast.transform.origin = rayPos
	
		raycast.visible = true
#		raycast.cast_to = raycast.cast_to.linear_interpolate(initial_cast_to,ads_acceleration)
		laser.cast_to = raycast.cast_to
		stamp_decal_to_normal(laser_decal, laser)
		laser.visible = true
#		raycast.visible = false
		

		var distance = laser.get_collision_point().distance_to(laser.global_transform.origin)
		var scalingfactor = lerp(.3, 4, (distance) / 100)
		laser_decal.scale = Vector3(scalingfactor,scalingfactor,scalingfactor)
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


func fire(delta): 
	print("fired weapon")
	
	can_fire = false
	current_ammo -=1

#	anim_player.play(weapon_fire_anim)
	anim_player.play("fire")
	play_shotsound()
	var side_recoil = rand_range(-1,2)
	var recoil = rand_range(1,1.5)
	up_recoil += recoil * delta
	head.rotation.x = lerp(head.rotation.x, deg2rad(head.rotation_degrees.x + up_recoil), delta)
	head.rotation.y = lerp(head.rotation.y, deg2rad(side_recoil), 2*delta)
	
	if up_recoil >= 35:
		up_recoil = 35
		
	check_collision(raycast)

	yield(get_tree().create_timer(fire_rate), "timeout")
	
	can_fire = true

	
func reload():
	print("reloading")
	anim_player.play("reload")
	reloading = true
	yield(get_tree().create_timer(reload_speed), "timeout")
	current_ammo = clip_size
	reloading = false
	print("reload complete")


func stamp_decal_to_normal(decal, _raycast):
	decal.global_transform.origin = _raycast.get_collision_point()
	
	var surface_dir_up = Vector3(0,1,0)
	var surface_dir_down = Vector3(0,-1,0)
	
	if _raycast.get_collision_normal() == surface_dir_up:
		decal.look_at(_raycast.get_collision_point() + _raycast.get_collision_normal(), Vector3.RIGHT)
	elif _raycast.get_collision_normal() == surface_dir_down:
		decal.look_at(_raycast.get_collision_point() + _raycast.get_collision_normal(), Vector3.RIGHT)
	else:
		decal.look_at(_raycast.get_collision_point() + _raycast.get_collision_normal(), Vector3.DOWN)




