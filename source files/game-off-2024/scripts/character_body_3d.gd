extends CharacterBody3D

@onready var camera = get_node("Camera3D")


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5

var cameraRotation = Vector2(0,0)
var mouseSensitivity = 0.001

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion:
		var mouseEvent = event.relative * mouseSensitivity
		CameraLook(mouseEvent)

func CameraLook(movement: Vector2):
	cameraRotation += movement
	#cameraRotation.y = clamp(cameraRotation.y, -1.5, -1.2) # makes the camera only move in a certain area
	
	transform.basis = Basis()
	camera.transform.basis = Basis()
	
	rotate_object_local(Vector3(0,1,0), -cameraRotation.x) # first rotate y
	camera.rotate_object_local(Vector3(1,0,0), -cameraRotation.y) # then rotate x

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
