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
export var weapon_name: String
export var fully_auto :bool
export var bolt :bool
export var playbackspeed = 1

onready var ammo_label = $"/root/World/UI/Label"
onready var b_decal = preload("res://Scenes/Player/Decals/BulletDecal.tscn")
onready var crosshair_decal = preload("res://Scenes/Player/Decals/CrossHair.tscn")
onready var laser_decal_path = preload("res://Scenes/Player/Decals/LaserDecal.tscn")
onready var laser_decal = laser_decal_path.instance()
onready var smoke_path = preload("res://Scenes/Player/Weapons/smoke.tscn")
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

var heat_values

var aiming = false
var current_x_rot = 0
var lerp_speed = 10


func _ready():
	heat_values = Weaponlist.get_spray(weapon_name)

#	if weapon_name in Weaponlist.weapons_recoil:
#		heat_values = Weaponlist.weapons_recoil[weapon_name]
#		print(heat_values)
#	else:
#		print("Key not found:", weapon_name)
	
	current_ammo = clip_size
	laser = $Laser
	raycast = get_node("/root/World/Player/Head/Camera/RayCast")
#	add_child(laser_decal)
	camera = get_node("/root/World/Player/Head/Camera")
	head = get_node("/root/World/Player/Head")

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

	SoundManager.play_sfx(shootsound.stream, self)
	last_shot_sound = rand_shot

func _process(delta):

	if reloading:
		ammo_label.set_text("reloading")
		decrease_recoil(delta)
		head.rotation.x = lerp(head.rotation.x, 0, delta)
	else:
		ammo_label.set_text("%d / %d" % [current_ammo, clip_size])
	if fully_auto:
		if Input.is_action_pressed("primary_fire") and can_fire:
			#fire weapon
			if current_ammo >0 and not reloading:
				
				fire(delta)

			elif not reloading: 
				reload(delta)
				
		if ! Input.is_action_pressed("primary_fire") and can_fire:
			if head.rotation.x != 0:
				decrease_recoil(delta)
				head.rotation.x = lerp(head.rotation.x, 0, delta)
				
				
	else:
		if Input.is_action_just_pressed("primary_fire") and can_fire:
			#fire weapon
			if current_ammo >0 and not reloading:
			
				fire(delta)
				if bolt:
					anim_player.play("bolt", 1, playbackspeed)
#

			elif not reloading: 
				reload(delta)
				
			
				
		if ! Input.is_action_just_pressed("primary_fire") and can_fire:
			if head.rotation.x != 0:
				
#				decrease_recoil(delta)
				head.rotation.x = lerp(head.rotation.x, 0, delta)
				
			
				

			
		

	if Input.is_action_just_pressed("reload") and not reloading:
		reload(delta)
		print(head.rotation)
		
	if Input.is_action_pressed("ads") and not reloading:
		aiming = true
		
		transform.origin = transform.origin.linear_interpolate(ads_position, ads_acceleration)
		

		var distance = raycast.get_collision_point().distance_to(raycast.global_transform.origin)
		var scalingfactor = lerp(.3, 4, (distance) / 100)
		laser_decal.scale = Vector3(scalingfactor,scalingfactor,scalingfactor)
#		stamp_decal_to_normal(laser_decal, raycast)
#		laser.visible = false
		raycast.visible = true
		camera.fov = lerp(camera.fov, ads_fov, ads_acceleration)
		GlobalGameSettings.set_dec_sensitivity(.2)
	else:
		aiming = false
		transform.origin = transform.origin.linear_interpolate(default_position, ads_acceleration)

	
		raycast.visible = true

		laser.cast_to = raycast.cast_to
#		stamp_decal_to_normal(laser_decal, laser)
#		laser.visible = true
		

		var distance = laser.get_collision_point().distance_to(laser.global_transform.origin)
		var scalingfactor = lerp(.3, 4, (distance) / 100)
		laser_decal.scale = Vector3(scalingfactor,scalingfactor,scalingfactor)
		camera.fov = lerp(camera.fov, default_fov, ads_acceleration)
		GlobalGameSettings.set_dec_sensitivity(1)
		
		
		
func check_collision(_raycast):

	if _raycast.is_colliding():
		var collider = _raycast.get_collider()
	
		print(collider.name)
		var b = b_decal.instance()
		
		if collider.is_in_group("Enemies"):
			collider.queue_free()
			print("killed " + collider.name)
		elif collider.is_in_group("Target"):
			collider.queue_free()
		
		get_tree().get_root().add_child(b)
	
		stamp_decal_to_normal(b, _raycast)



var heat_index = 0

#heat_values = [[0,0],[0.1,0.2],[0.2,0.3],[0.3,0.4],[0.4,0.5],[0.5,0.6],[0.6,0.7],[0.7,0.8],[0.8,0.9],[0.9,1.0],[1.0,1.1],[1.1,1.2],[1.2,1.3],[1.3,1.4],[1.4,1.5],[1.5,1.6],[1.6,1.7],[1.7,1.8],[1.8,1.9],[1.9,2.0],[2.0,2.1],[2.1,2.2],[2.2,2.3],[2.3,2.4],[2.4,2.5],[2.5,2.6],[2.6,2.7],[2.7,2.8],[2.8,2.9],[2.9,3.0]]

var heat : Array

func recoil(delta):
	heat_index +=1
	if heat_index >= heat_values.size():
		heat_index = heat_values.size()-1
	heat = heat_values[heat_index]
	print(heat)
	head.rotation.x += heat[0] * delta
	if head.rotation.x >= .5:
		head.rotation.x = .5
	head.rotation.y += heat[1] * delta


func decrease_recoil(delta):

	heat_index -= 1
	if heat_index < 0:
		heat_index = 0
	heat = heat_values[heat_index]
	head.rotation.x -= heat[0] * delta
	head.rotation.y -= heat[1] * delta
	if heat_index == 0:
		head.rotation.x = lerp(head.rotation.x, 0, .01)
		


func fire(delta): 

	heat_values = Weaponlist.get_spray(weapon_name)

	can_fire = false
	current_ammo -=1
	recoil(delta)
#	if !fully_auto:
#		if bolt:
#			get_tree().create_timer(1.2).connect("timeout", self, "decrease_recoil", [delta])
#		else:
#			get_tree().create_timer(.6).connect("timeout", self, "decrease_recoil", [delta])
	anim_player.play("fire", -1, playbackspeed)
	emit_smoke()
	play_shotsound()
	check_collision(raycast)
	yield(get_tree().create_timer(fire_rate), "timeout")
	can_fire = true
	
	

	

func reload(delta):
	
	print("reloading")

	print(head.rotation.x)
	anim_player.play("reload")
	reloading = true
	yield(get_tree().create_timer(reload_speed), "timeout")
	current_ammo = clip_size
	reloading = false
	print("reload complete")

func emit_smoke():
	var new_smoke = smoke_path.instance()
	new_smoke.transform = $smoke_spawn_point.global_transform
	add_child(new_smoke)
	get_tree().create_timer(3.0).connect("timeout", self, "_remove_smoke", [new_smoke])

func _remove_smoke(smoke):
	# remove the smoke node from the scene tree and free its memory
	smoke.queue_free()
	
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





