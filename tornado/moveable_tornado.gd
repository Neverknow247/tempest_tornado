extends CharacterBody3D

var sounds = Sounds

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var enter_area = $enter_area
@onready var attraction_point = $enter_area/attraction_point
@onready var camera_controller = $Camera_Controller
@onready var camera_target = $Camera_Controller/Camera_Target
@onready var gpu_particles_3d = $GPUParticles3D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var speed = SPEED
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var tornado_level = 1
var pull_force = 500
var pulled_objects = []
	#var level_up_mofiier = 17.5
	#var level_up_percentage = 1.1309
func check_size():
	var level_up_percentage = 1.1309
	var level_up_mofiier = 17.5
	if pulled_objects.size() > level_up_mofiier*level_up_percentage**tornado_level:
		level_up()
	elif pulled_objects.size() < level_up_mofiier*level_up_percentage**(tornado_level-1):
		level_down()
	apply_modifiers()
	
func level_up():
	tornado_level+=1
	print(tornado_level)

func level_down():
	if tornado_level<=1:
		return
	tornado_level-=1
	print(tornado_level)

func apply_modifiers():
	gpu_particles_3d.process_material.initial_velocity_min = 10+tornado_level
	gpu_particles_3d.process_material.initial_velocity_max = 15+tornado_level
	gpu_particles_3d.process_material.tangential_accel_min = 15+tornado_level
	gpu_particles_3d.process_material.tangential_accel_max = 30+tornado_level
	camera_target.position.y = lerp(camera_target.position.y,15.0+tornado_level,.01)
	camera_target.position.z = lerp(camera_target.position.z,15.0+tornado_level,.01)
	speed = SPEED+(tornado_level*.1)
	sounds["sfx_players"][0].volume_db = -15+int(tornado_level/2)
	$enter_area/CollisionShape3D.shape.radius = 10+(tornado_level/2)
	pull_force = 50+(tornado_level*10)
	

func _physics_process(delta):
	rotate_cyclone()
	check_size()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	#var cam_dir = Input.get_axis("ui_left","ui_right")
	#if cam_dir == 1:
		#self.rotation_degrees += Vector3(0,.5,0)
	#elif cam_dir == -1:
		#self.rotation_degrees += Vector3(0,-.5,0)
	move_and_slide()
	update_camera()
	for obj in pulled_objects:
		pull_object(obj,true)


func rotate_cyclone():
	enter_area.rotation_degrees += Vector3(0,5,0)

func update_camera():
	camera_controller.position = lerp(camera_controller.position,position,0.10)
	#camera_controller.rotation_degrees = lerp(camera_controller.rotation_degrees,self.rotation_degrees,0.10)


func pull_object(obj,should_pull):
	if should_pull:
		var force_direction = attraction_point.global_position - obj.global_position
		obj.apply_central_force(force_direction.normalized()*pull_force)

func _on_enter_area_body_entered(body):
	if body.mass <= tornado_level:
		pulled_objects.append(body)
	#if body.is_in_group("obj"):
		#pulled_objects.append(body)

func _on_enter_area_body_exited(body):
	var obj = pulled_objects.find(body)
	if obj != -1:
		pulled_objects.remove_at(obj)