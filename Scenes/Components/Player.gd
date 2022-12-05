extends KinematicBody2D

export var snap := false
export var move_speed := 250
export var jump_force := 500
export var gravity := 900
export var slope_slide_threshold := 50.0
onready var _animated_sprite = $AnimatedSprite

var velocity := Vector2()

func _physics_process(delta):
	var direction_x := Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.x = direction_x * move_speed
	
	if Input.is_action_just_pressed("jump") and snap:
		velocity.y = -jump_force
		snap = false
		
	velocity.y += gravity * delta
	
	var snap_vector = Vector2(0, 32) if snap else Vector2()
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, slope_slide_threshold, 4, deg2rad(46))
		
	if is_on_floor() and (Input.is_action_just_released("right") or Input.is_action_just_released("left")):
		velocity.y = 0
	
	var just_landed := is_on_floor() and not snap
	if just_landed:
		snap = true	
	
	if Input.is_action_pressed("jump") and direction_x <0:
		_animated_sprite.animation = "Jump"
		_animated_sprite.flip_h = false
	elif Input.is_action_pressed("jump")and direction_x >0:
		_animated_sprite.animation = "Jump"
		_animated_sprite.flip_h = true
	elif Input.is_action_just_released("jump") and direction_x >0:
		_animated_sprite.animation = "Fall"
		_animated_sprite.flip_h = true
	elif Input.is_action_just_released("jump") and direction_x <0:
		_animated_sprite.animation = "Fall"
		_animated_sprite.flip_h = false
	elif direction_x > 0:
		_animated_sprite.animation = "Run"
		_animated_sprite.flip_h = true
	elif direction_x <0:
		_animated_sprite.animation = "Run"
		_animated_sprite.flip_h = false
	else:
		_animated_sprite.animation = "Idle"
		
