extends RigidBody3D

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_piviot := $TwistPivot
@onready var pitch_pivot  := $TwistPivot/PitchPivot


# for this to work.. Player must be converted/recreated in characterbody3d this node features is_on_floor.. rigidbody3d does not!
## How fast the player moves in meters per second.
#@export var speed = 14
## Vertical impulse applied to the character upon jumping in meters per second.
#@export var jump_impulse = 20
## Vertical impulse applied to the character upon bouncing over a mob in meters per second.
#@export var bounce_impulse = 16
## The downward acceleration when in the air, in meters per second per second.
#@export var fall_acceleration = 75
#
#var velocity = Vector3.ZERO
#
#
#func _physics_process(delta):
	#var direction = Vector3.ZERO
	#if Input.is_action_pressed("move_right"):
		#direction.x += 1
	#if Input.is_action_pressed("move_left"):
		#direction.x -= 1
	#if Input.is_action_pressed("move_back"):
		#direction.z += 1
	#if Input.is_action_pressed("move_forward"):
		#direction.z -= 1
#
	#if direction != Vector3.ZERO:
		## In the lines below, we turn the character when moving and make the animation play faster.
		#direction = direction.normalized()
		#$Pivot.look_at(position + direction, Vector3.UP)
		#$AnimationPlayer.playback_speed = 4
	#else:
		#$AnimationPlayer.playback_speed = 1
#
	#velocity.x = direction.x * speed
	#velocity.z = direction.z * speed
#
	## Jumping.
	#if is_on_floor() and Input.is_action_just_pressed("jump"):
		#velocity.y += jump_impulse
#
	## We apply gravity every frame so the character always collides with the ground when moving.
	## This is necessary for the is_on_floor() function to work as a body can always detect
	## the floor, walls, etc. when a collision happens the same frame.
	#velocity.y -= fall_acceleration * delta
	#set_velocity(velocity)
	#set_up_direction(Vector3.UP)
	#move_and_slide()
	#velocity = velocity
	#

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# movement
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	apply_central_force(twist_piviot.basis * input * 1200.0 * delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	twist_piviot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp ( pitch_pivot.rotation.x,
		deg_to_rad(-90),
		deg_to_rad(90)
	)		
	
	twist_input = 0.0
	pitch_input = 0.0
	
# Jump requires only two lines of code

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
