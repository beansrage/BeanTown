extends RigidBody3D

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

var is_mouse_visible := false

@onready var twist_piviot := $TwistPivot
@onready var pitch_pivot  := $TwistPivot/PitchPivot

func _ready() -> void:

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_mouse_visibility()

func toggle_mouse_visibility():
	is_mouse_visible = !is_mouse_visible
	if is_mouse_visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# movement
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	apply_central_force(twist_piviot.basis * input * 1200.0 * delta)
	

		
	
		
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
