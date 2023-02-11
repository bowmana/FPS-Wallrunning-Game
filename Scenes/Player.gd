extends KinematicBody

export var speed = 10
onready var SPEED = speed
export var SPRINT_SPEED = 15
export var crouch_speed = 2
export var acceleration = 5
export var gravity = .98
export var jump = 30
var jump_num = 0
export var world_node : NodePath
var world
var target_speed = 0


var sliding = false
var slide_multiplier = 1.5
var slide_cooldown = false
export var mouse_sens = 0.3
var multiplier =  1
export var dec_mouse_sens = .2
onready var head = $Head
onready var boost_bar = $"/root/World/UI/BoostBar"
onready var console_label = $"/root/World/UI/Label2"
onready var camera = $Head/Camera
onready var particles = $Head/Camera/Particles
onready var anim = $AnimationPlayer
onready var weapon_cam = $ViewportContainer/Viewport/Camera
onready var walkingsound = $walking
onready var jetsound = $jet
onready var headray = $Head/headray


var gun1
var gun2

onready var weaponholder = $Head/Camera/Weapons
onready var testingdropnode = $Head/Camera/Weapons2

onready var curr_weapon = 1

signal send_curr_weapon
var velocity = Vector3()

var camera_x_rotation = 0
onready var wall_normal = Vector3()

var direction = Vector3()
var wallrunning = false

export(float) var wallrun_angle = 15
var wallrun_current_angle = 0
var side = ""

var is_wallrun_jumping = false

export var walljumpforce = 170
export var walljumpheight = 150

var space_button_held_time = 0
var max_jetpack_velocity = 50
onready var can_jetpack = false
var jet_counter = 0
var jet_timer_on = false
var crouch = false
var head_bonked = false
var last_step_sound = floor(rand_range(0,3))
#var slide_counter = 0 
#var slide_timer_on = false
#var is_crouch = false




func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	world = get_node(world_node)
	


func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * (GlobalGameSettings.get_sensitivity() * GlobalGameSettings.get_dec_sensitivity())))
		
		var x_delta = event.relative.y * (GlobalGameSettings.get_sensitivity() * GlobalGameSettings.get_dec_sensitivity()) 
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta
			
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if curr_weapon < 2:
					curr_weapon +=1
				else:
					curr_weapon =1
			elif event.button_index == BUTTON_WHEEL_DOWN:
				if curr_weapon > 1:
					curr_weapon -=1
				else:
					curr_weapon =2
			
		
	if (Input.is_action_just_pressed("Interact") and WeaponInteract.entered_flag == true and curr_weapon==1):
		Weaponlist.add_primary(WeaponInteract.get_uid())
		if Weaponlist.weapons["primary"] != null:
			weaponholder.remove_child(gun1)
			var weapon_pickup = Weaponlist.get_weapon_pickup(gun1.name)
			
			weapon_pickup.set_global_transform(get_global_transform())

#	
			world.add_child(weapon_pickup)
			WeaponInteract.get_remove_node().queue_free()
			gun1 = Weaponlist.get_primary()
		
		
	if (Input.is_action_just_pressed("Interact") and WeaponInteract.entered_flag == true and curr_weapon==2):
		Weaponlist.add_secondary(WeaponInteract.get_uid())
		if Weaponlist.weapons["primary"] != null:
			weaponholder.remove_child(gun2)
			var weapon_pickup = Weaponlist.get_weapon_pickup(gun2.name)
			weapon_pickup.set_global_transform(get_global_transform())
			world.add_child(weapon_pickup)
			WeaponInteract.get_remove_node().queue_free()
			gun2 = Weaponlist.get_secondary()
			



func wall_run():
	
	if !is_on_floor() and Input.is_action_pressed("move_forward") and is_on_wall():
		if not Input.is_action_just_pressed("jump"):
			velocity.y = 0


		wall_normal = get_slide_collision(0)
#		yield(get_tree().create_timer(0.1), "timeout")
		var wallrun_direction = Vector3.UP.cross(wall_normal.normal)
		var player_view_dir = -head.global_transform.basis.z
		var dot = wallrun_direction.dot(player_view_dir)
		if dot < 0:
			wallrun_direction = - wallrun_direction
			
		var wallrun_axis_2d = Vector2(wallrun_direction.x, wallrun_direction.z)
		var view_dir_2d = Vector2(player_view_dir.x, player_view_dir.z)
		var angle = wallrun_axis_2d.angle_to(view_dir_2d)
		
		angle = rad2deg(angle)
		if dot < 0:
			angle =-angle
			
		if angle > 85:
			
			wallrunning = false
			return
		
		wallrun_direction += -wall_normal.normal *.1
		wallrunning = true
		side = get_side(wall_normal.position)
		jump_num = 0
		direction = wallrun_direction * speed

func process_wallrun_rotation(delta):
	if wallrunning:
		if side == "RIGHT":
			wallrun_current_angle += delta * 60
			wallrun_current_angle = clamp(wallrun_current_angle, -wallrun_angle, wallrun_angle)
		elif side == "LEFT":
			wallrun_current_angle -= delta * 60
			wallrun_current_angle = clamp(wallrun_current_angle, -wallrun_angle, wallrun_angle)
	else:
		if wallrun_current_angle > 0:
			wallrun_current_angle -= delta * 40
			wallrun_current_angle = max(0,wallrun_current_angle)
		elif wallrun_current_angle < 0:
			wallrun_current_angle += delta * 40
			wallrun_current_angle = min(wallrun_current_angle,0)
			
	#set rotation_degrees to Vector3(0,0,1) * wallrun_current_angle
	rotation_degrees = Vector3(0,0,1) * wallrun_current_angle

func get_side(point):
	point = to_local(point)
	
	if point.x > 0:
		return "RIGHT"
	elif point.x < 0:
		return "LEFT"
	else:
		return "CENTER"
		
func wall_jump():
	if Input.is_action_just_pressed("jump") and wallrunning:
			velocity += wall_normal.normal * walljumpforce + Vector3(0,walljumpheight,0)
			wallrunning = false
			
			
func sliding(delta, head_basis):

		
	if Input.is_action_pressed("slide") and is_on_floor() and not slide_cooldown and Input.is_action_pressed("move_forward") and speed > 20 :
		sliding = true
		slide_cooldown = true
		yield(get_tree().create_timer(1.0), "timeout")
		sliding = false
		yield(get_tree().create_timer(.10), "timeout")
		slide_cooldown = false

			
			
	if Input.is_action_just_released("slide"):
		sliding = false
		print("notsliding")

	if sliding:
		velocity -= head_basis.z * slide_multiplier * speed * delta
		particles.emitting = true
		if not anim.is_playing():
			anim.play("sliding")
	

	
	if !sliding and anim.is_playing() and anim.get_current_animation() == "sliding":
		if !head_bonked:
			anim.play("sliding", -1,10)
		else:
			
			anim.play("crouch")
			crouch = true
			

	particles.emitting = false
	
func crouching():
	
	if crouch:
		speed = crouch_speed

	if Input.is_action_just_pressed("slide") and is_on_floor() and !sliding and !crouch and speed <=20.01 :

		anim.play("crouch")
		print(crouch, "here1")
		crouch = true



	elif crouch and head_bonked == false:
		if Input.is_action_just_pressed("slide") and is_on_floor() and !sliding:

#			if anim.is_playing() and anim.get_current_animation() == "crouch":
			crouch = false
			anim.play("sliding", -1,1)
#
#

		



func play_footstepL():
	var rand_footstep = floor(rand_range(0,4))
	while rand_footstep == last_step_sound:
		rand_footstep = floor(rand_range(0,4))
	match str(rand_footstep):
		"0":
			walkingsound.stream = preload("res://walkingL1.wav")
		"1":
			walkingsound.stream = preload("res://walkingL2.wav")
		"2":
			walkingsound.stream = preload("res://walkingL3.wav")
		"3":
			walkingsound.stream = preload("res://walkingL4.wav")
	
	walkingsound.play()
#	walkingsound.pitch_scale = rand_range(1,2)
	last_step_sound = rand_footstep
	
func play_footstepR():
	var rand_footstep = floor(rand_range(0,4))
	while rand_footstep == last_step_sound:
		rand_footstep = floor(rand_range(0,4))
	match str(rand_footstep):
		"0":
			walkingsound.stream = preload("res://walkingR1.wav")
		"1":
			walkingsound.stream = preload("res://walkingR2.wav")
		"2":
			walkingsound.stream = preload("res://walkingR3.wav")
		"3":
			walkingsound.stream = preload("res://walkingR4.wav")
#	walkingsound.pitch_scale = rand_range(1,2) 
	walkingsound.play()
	
	last_step_sound = rand_footstep
			


func _process(_delta):
	head_bonked = false
	if headray.is_colliding():
		head_bonked = true
		print("bonked")

	console_label.set_text(str(speed))

	boost_bar.value = space_button_held_time*10
	if boost_bar.value == 0:
		boost_bar.visible = false
	else:
		boost_bar.visible = true
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if !gun1:
		if Weaponlist.weapons["primary"] != null:
			gun1 = Weaponlist.get_primary()

	if !gun2:
		if Weaponlist.weapons["secondary"] != null:
			gun2 = Weaponlist.get_secondary()
	
	weapon_select()
	if curr_weapon == 1:
		if gun2:
			if gun2.get_parent() == weaponholder:
#				anim.play("change_weapon")
				weaponholder.remove_child(gun2)
				
				
		if gun1 != null and gun1.get_parent() == null:
			
			weaponholder.add_child(gun1)
			
#			anim.play_backwards("change_weapon")
		
			
	if curr_weapon == 2 :
		if gun1:
			if gun1.get_parent() == weaponholder:
#				anim.play("change_weapon")
				weaponholder.remove_child(gun1)
				
		if gun2 != null and gun2.get_parent() == null:
			
			weaponholder.add_child(gun2)
#			anim.play_backwards("change_weapon")
	



func weapon_select():
	if Input.is_action_just_pressed("weapon1"):
		
		curr_weapon = 1

	elif Input.is_action_just_pressed("weapon2"):
		curr_weapon = 2
		
		
		
func jet_pack(delta):
	
	if jump_num == 0 and !is_on_floor():
		jet_timer_on = true
	if is_on_floor():
		jet_timer_on = false
		jet_counter = 0
		space_button_held_time = 0
		jump_num = 0
		
	if wallrunning:
		jet_timer_on = false
		space_button_held_time = 0
		jet_counter = 0
	
	if (Input.is_action_pressed("jump") and not wallrunning and not is_on_floor()) or (jump_num == 0 and !is_on_floor() and Input.is_action_pressed("jump")):
		
		if jet_counter >= .33:
			if space_button_held_time >= 10:
				
				return
			
			
			space_button_held_time += delta*12
			jetsound.pitch_scale = -space_button_held_time
			if !jetsound.is_playing():
				jetsound.play()
			
#			print(space_button_held_time)
			var jetpack_velocity = min(space_button_held_time * acceleration, max_jetpack_velocity)
			velocity.y = jetpack_velocity
		else:
			
			space_button_held_time = 0




func _physics_process(delta):

	
	velocity = move_and_slide(velocity, Vector3.UP)
	var head_basis = head.get_global_transform().basis
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	
	var gravity_resistance = get_floor_normal() if is_on_floor() else Vector3.UP

	
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if jump_num == 0:
			print("jumped")
			velocity.y += jump
			jump_num = 1
			yield(get_tree().create_timer(.01), "timeout")
			jet_counter = 0
			jet_timer_on = true
		
		

	jet_pack(delta)
	
	
	if jet_timer_on:
		jet_counter += delta
	
	direction = Vector3()

	wall_run()
	
	process_wallrun_rotation(delta)
	crouching()
	sliding(delta, head_basis)
	
	
	
	
	if !is_on_wall():
		wallrunning = false
	if Input.is_action_pressed("move_forward"):
		direction -= head_basis.z
		
	elif Input.is_action_pressed("move_backward"):
		direction += head_basis.z
		
	if Input.is_action_pressed("move_left"):
		direction -= head_basis.x
		
	elif Input.is_action_pressed("move_right"):
		direction += head_basis.x
		
	direction = direction.normalized()
	if velocity.length() < 3.0 and !sliding and is_on_floor():
		anim.play("HeadBob", 0.1, 0.2)
		


	elif velocity.length() <= SPEED and !sliding and (is_on_floor() or wallrunning):
		anim.play("Walking", 0.1, 1.0)
		
		
	else:
		
		if !sliding and (is_on_floor() or wallrunning):
		
			anim.play("Sprinting", 0.1, 1.5)
			
	if speed >= 21 and velocity.length() > 3.0:
		weapon_cam.fov = lerp(weapon_cam.fov, 90, 10 * delta)
	else:
		weapon_cam.fov = lerp(weapon_cam.fov, 70, 10 * delta)
		
	if Input.is_action_pressed("sprint") and Input.is_action_pressed("ads") == false:
		target_speed = SPRINT_SPEED
		if crouch and !head_bonked:
			anim.play("sliding", -1, 10)
			crouch = false
	else:
		target_speed = SPEED
		
	var interp_factor = 0
	if direction.length()> 0:
		interp_factor = 2
	else:
		interp_factor = 100
	speed = lerp(speed, target_speed, interp_factor*delta)
		

	

	wall_jump()
	
	velocity -= gravity_resistance * gravity









