extends Spatial

class_name Weapon

export var fire_rate = 0.5
export var damage : float = 10.0
export var clip_size = 5
export var reload_speed : float = 1.0
export var weapon_range = 100
export var default_position : Vector3
export var ads_position : Vector3
export var ads_rotation : Vector3
export var default_rotation : Vector3
export var ads_acceleration : float = 0.7
export var default_fov : float = 70 #default camera view for all games in godot
export var ads_fov : float = 55
export var ads_cast_from : Vector3 = Vector3(0,.1,0)
export var weapon_name: String
export var fully_auto :bool
export var bolt : bool
export var playbackspeed = 1
export var emit_smoke_time = .15
export var lasersound : AudioStream


#onready var ammo_label = $"/root/World/UI/Label"
onready var b_decal = preload("res://Scenes/Player/Decals/BulletDecal.tscn")

onready var laser_decal_path = preload("res://Scenes/Player/Decals/LaserDecal.tscn")
onready var laser_decal = laser_decal_path.instance()
onready var smoke_path = preload("res://Assets/Models/weapons/smoke.tscn")
onready var weaponPickup = preload("res://Scenes/UI/WeaponPickup.tscn")

onready var right_ch = $CanvasLayer/Scope/Right_CH
onready var left_ch = $CanvasLayer/Scope/Left_CH
onready var up_ch = $CanvasLayer/Scope/Up_CH
onready var down_ch = $CanvasLayer/Scope/Down_CH
var CH_recoil_pos = 50

var weapon : Spatial
var raycast : RayCast
var original_cast_to = 0
export var initial_shot_spread = 0
onready var original_spread = initial_shot_spread
export var max_shot_spread = 30
export var spread_area = 300
var laser : RayCast
export var has_laser = false

var camera : Camera
var head: Spatial
var anim_player : AnimationPlayer

var current_ammo = 0
var can_fire = true
var reloading = false
var up_recoil = 0

var turn_laser_on = false
export var stream_sounds: Array
export var reload_stream_sounds: Array
export var bolt_stream_sounds: Array
var last_shot_sound = floor(rand_range(0,3))


onready var shootsound = $shoot
onready var reloadsound = $reload

var heat_values

var aiming = false
var current_x_rot = 0


var heat_index = 0
var heat : Array



func _ready():
	heat_values = Weaponlist.get_spray(weapon_name)
	print(original_spread, "original_spread")
	current_ammo = clip_size
	set_ammo_count(current_ammo)
	
	laser = $Laser
	raycast = get_node("/root/World/Player/Head/CamRoot/HeadBob/Camera/RayCast")
	raycast.cast_to = Vector3(0,0,-weapon_range)
	original_cast_to = raycast.cast_to

	if has_laser:
		add_child(laser_decal)
	camera = get_node("/root/World/Player/Head/CamRoot/HeadBob/Camera")
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

	SoundManager.play_sfx(shootsound.stream, get_tree().current_scene)
	last_shot_sound = rand_shot


func play_reload_sound(start_or_finish_sound):
	if start_or_finish_sound == "start":
		reloadsound.stream = reload_stream_sounds[0]
	elif start_or_finish_sound == "end":
		reloadsound.stream = reload_stream_sounds[1]
	else:
		print("error, include a start/finsih sound")
	SoundManager.play_sfx(reloadsound.stream, get_tree().current_scene)
	
func play_bolt_sound(start_or_finish_sound):
	if start_or_finish_sound == "start":
		reloadsound.stream = bolt_stream_sounds[0]
	elif start_or_finish_sound == "end":
		reloadsound.stream = bolt_stream_sounds[1]
	else:
		print("error, include a start/finsih sound")
	SoundManager.play_sfx(reloadsound.stream, get_tree().current_scene)
func _input(event):
	if event.is_action_pressed("laser"):
		turn_laser_on = !turn_laser_on
		shootsound.stream = lasersound
		SoundManager.play_sfx(shootsound.stream, get_tree().current_scene)

func initial_shot():
	if heat_index == 0 and !Input.is_action_pressed("ads"):
		raycast.cast_to = original_cast_to + Vector3(rand_range(-initial_shot_spread, initial_shot_spread), rand_range(-initial_shot_spread, initial_shot_spread), 0) 
		
	elif heat_index != 0 and !Input.is_action_pressed("ads"):
		raycast.cast_to = original_cast_to + Vector3(rand_range(-initial_shot_spread/2, initial_shot_spread/2), rand_range(-initial_shot_spread/2, initial_shot_spread/2), 0) 

	elif Input.is_action_pressed("ads"): 
		raycast.cast_to = original_cast_to
func _process(delta):
	
	raycast.cast_to.z = -weapon_range
	initial_shot()

	
	if reloading:
		set_ammo_count("í ½í´ƒí ½í´--")
#		ammo_label.set_text("reloading")
#		set_ammo_count(current_ammo)
		decrease_recoil(delta)
		head.rotation.x = lerp(head.rotation.x, 0, delta)
	

	
#		set_ammo_count(current_ammo)
#		ammo_label.set_text("%d / %d" % [current_ammo, clip_size])
##		$Ammo_count_viewport.render_target_update_mode = Viewport.UPDATE_ONCE
#		ammo_label.text = str(current_ammo)

	if fully_auto:
		
		if Input.is_action_pressed("primary_fire") and can_fire:
			#fire weapon
			if current_ammo >0 and not reloading:
				
				fire(delta)
			
			elif not reloading: 
				reload(delta)
				
		if ! Input.is_action_pressed("primary_fire") and can_fire:

			decrease_recoil(delta)
			head.rotation.x = lerp(head.rotation.x, 0, delta)
			adjust_crosshair_back(delta)
				
				
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
		
				
#				decrease_recoil(delta)
			head.rotation.x = lerp(head.rotation.x, 0, delta)
			adjust_crosshair_back(delta)
			

	if Input.is_action_just_pressed("reload") and not reloading:
		reload(delta)
		print(head.rotation)
		
	if Input.is_action_pressed("ads") and not reloading:
		aiming = true
		crosshair_modulate(delta)
		transform.origin = transform.origin.linear_interpolate(ads_position, ads_acceleration)
		
		rotation_degrees= rotation_degrees.linear_interpolate(ads_rotation, ads_acceleration)
		if has_laser:
			hide_laser()
#		raycast.visible = true
		camera.fov = lerp(camera.fov, ads_fov, ads_acceleration)
		GlobalGameSettings.set_dec_sensitivity(.2)
	else:
		aiming = false
		crosshair_modulate_back()
		transform.origin = transform.origin.linear_interpolate(default_position, ads_acceleration)
		if !reloading:
			rotation_degrees = rotation_degrees.linear_interpolate(default_rotation, ads_acceleration)
		if has_laser:
			show_laser()
			
	

		
		
		camera.fov = lerp(camera.fov, default_fov, ads_acceleration)
		GlobalGameSettings.set_dec_sensitivity(1)
		
func show_laser():
	if turn_laser_on:
		laser.cast_to.z = raycast.cast_to.z
		if reloading:
			$Laser_visual.visible = false
			laser_decal.visible = false
		if laser.is_colliding() and not reloading:
			laser_decal.visible = true
			$Laser_visual.visible = true
		elif !laser.is_colliding() and not reloading:
			$Laser_visual.visible = true
			laser_decal.visible = false
		
		var distance = raycast.get_collision_point().distance_to(raycast.global_transform.origin)
		var scalingfactor = lerp(.3, 4, (distance) / 100)
#		laser.cast_to = raycast.cast_to
		laser_decal.scale = Vector3(scalingfactor,scalingfactor,scalingfactor)
		stamp_decal_to_normal(laser_decal, laser)
#		$Laser_visual.visible = true
	else:
		hide_laser()
	
	
	
	
func hide_laser():
	$Laser_visual.visible = false
	laser_decal.visible = false
		
func check_collision(_raycast):

	if _raycast.is_colliding():
		var collider = _raycast.get_collider()
	
		print(collider.name)
		var b = b_decal.instance()
		
		if collider.is_in_group("Enemies"):
			collider.queue_free()
			print("killed " + collider.name)
		elif collider.is_in_group("Target"):
			var distance = _raycast.get_collision_point().distance_to(_raycast.global_transform.origin)
			var new_damage = damage -(distance * .01)
			if new_damage <= damage/1.5:
				collider.decrease_health(damage/1.5)
			else:
				collider.decrease_health(new_damage)
			print(distance, "distance")
			
			
		
		get_tree().get_root().add_child(b)
	
		stamp_decal_to_normal(b, _raycast)





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
		


func set_ammo_count(val):

	
	$Ammo_count_viewport/Ammo_count.text = str(val)
	$Ammo_count_viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS

func fire(delta): 
		

	
	heat_values = Weaponlist.get_spray(weapon_name)

	can_fire = false
	current_ammo -=1
	set_ammo_count(current_ammo)
	recoil(delta)
	if !fully_auto:
		if bolt:
			get_tree().create_timer(.2).connect("timeout", self, "decrease_recoil", [delta])
		else:
			get_tree().create_timer(.6).connect("timeout", self, "decrease_recoil", [delta])
	anim_player.play("fire", -1, playbackspeed)
	emit_smoke($smoke_spawn_point)
	play_shotsound()
	adjust_crosshair(delta)
	CH_recoil_pos +=4
	check_collision(raycast)
	yield(get_tree().create_timer(fire_rate), "timeout")
	can_fire = true
#	print(raycast.cast_to.z, "castto")
	

	
func adjust_crosshair(delta):
	up_ch.position = lerp(up_ch.position, Vector2(0, -CH_recoil_pos), 3*delta)
	left_ch.position = lerp(left_ch.position, Vector2(-CH_recoil_pos,0), 3*delta)
	right_ch.position = lerp(right_ch.position, Vector2(CH_recoil_pos,0), 3*delta)
	down_ch.position = lerp(down_ch.position, Vector2(0, CH_recoil_pos), 3*delta)
	initial_shot_spread += spread_area*delta
	if down_ch.position > Vector2(0,30):
		print(initial_shot_spread)
		initial_shot_spread = max_shot_spread
		CH_recoil_pos = 30
	
func adjust_crosshair_back(delta):
	initial_shot_spread = original_spread
	for ch in $CanvasLayer/Scope.get_children():
		ch.position = lerp(ch.position, Vector2(0,0), 3* delta)
		CH_recoil_pos -= ch.position.x
		
func crosshair_modulate(delta):
	$CanvasLayer/Scope.set_modulate(lerp($CanvasLayer/Scope.modulate, Color(1,1,1,0),.03))
	adjust_crosshair_back(delta)
	print(delta)
func crosshair_modulate_back():
	$CanvasLayer/Scope.set_modulate(lerp($CanvasLayer/Scope.modulate, Color(1,1,1,1),.03))
	

func reload(delta):
	
	print("reloading")

	print(head.rotation.x)
	anim_player.play("reload")
	reloading = true
	yield(get_tree().create_timer(reload_speed), "timeout")
	current_ammo = clip_size
	set_ammo_count(current_ammo)
	reloading = false
	print("reload complete")

func emit_smoke(spawn_point):
	var new_smoke = smoke_path.instance()
	new_smoke.transform = spawn_point.transform
	add_child(new_smoke)
	get_tree().create_timer(emit_smoke_time).connect("timeout", self, "_remove_smoke", [new_smoke])

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





