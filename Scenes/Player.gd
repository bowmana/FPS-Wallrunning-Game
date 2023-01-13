extends KinematicBody

export var speed = 10
export var acceleration = 5
export var gravity = .98
export var jump = 30
export var walljumpforce = 170
export var walljumpheight = 150
export var mouse_sens = 0.3
var multiplier =  1
export var dec_mouse_sens = .2
onready var head = $Head
onready var camera = $Head/Camera


var velocity = Vector3()
var camera_x_rotation = 0
onready var wall_normal = Vector3()

var direction = Vector3()
var wallrunning = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	
	
func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * (GlobalGameSettings.get_sensitivity() * GlobalGameSettings.get_dec_sensitivity())))
		
		var x_delta = event.relative.y * (GlobalGameSettings.get_sensitivity() * GlobalGameSettings.get_dec_sensitivity()) 
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta
		
func wall_run():
	
	if !is_on_floor() and Input.is_action_pressed("move_forward") and is_on_wall():
		if not Input.is_action_just_pressed("jump"):
			velocity.y = 0
		wall_normal = get_slide_collision(0)
		yield(get_tree().create_timer(0.1), "timeout")
		direction = -wall_normal.normal * speed
		wallrunning = true
		

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _physics_process(delta):
	
	var head_basis = head.get_global_transform().basis

	direction = Vector3()
	
	wall_run()
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
	
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	
	var gravity_resistance = get_floor_normal() if is_on_floor() else Vector3.UP

	velocity -= gravity_resistance * gravity
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump
#		
	if Input.is_action_just_pressed("jump") and wallrunning:
		velocity += wall_normal.normal * walljumpforce + Vector3(0,walljumpheight,0)
		wallrunning = false
	velocity = move_and_slide(velocity, Vector3.UP)
	
	






