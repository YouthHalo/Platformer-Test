extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -491.7 #perfect height compared to mario bros :)

#Jump heights are 491.7, 551, 606 for standing, running and special run
##these are with a not so accurate hitbox, might fix later

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var speedMulti = 1

func on_ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		if velocity.x == 0:
			$AnimatedSprite2D.play("default")

		
	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimatedSprite2D.stop()
	
	if is_on_ceiling_only():
		$AnimatedSprite2D.modulate = Color(1,0,0)
		print("Real: " + str(get_real_velocity()))
		print("Normal: " + str(velocity))
	else:
		$AnimatedSprite2D.modulate = Color(1,1,1)
		
	if is_on_wall():
		$AnimatedSprite2D.modulate = Color(0,1,0)

	if Input.is_action_pressed("right") and is_on_floor():
		$AnimatedSprite2D.flip_h = false
	elif Input.is_action_pressed("left") and is_on_floor():
		$AnimatedSprite2D.flip_h = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY - abs(velocity.x*0.25)
		$AnimatedSprite2D.play("jump")
		
		
	if Input.is_action_just_released("jump") and is_on_floor() == false:
		if velocity.y < -250:
			velocity.y = -250
		if velocity.y < -125:
			velocity.y = -125
		elif velocity.y < 0:
			velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")

	
	if Input.is_action_pressed("run") and is_on_floor():
		$AnimatedSprite2D.speed_scale = 2
		if speedMulti < 2:
			speedMulti += 0.05
		
	elif Input.is_action_just_released("run"):
		$AnimatedSprite2D.speed_scale = 1
		if speedMulti > 1:
			speedMulti -= 0.05
	if velocity.x == 0:
		speedMulti = 1
		
	if direction:
		velocity.x = direction * SPEED * speedMulti
		if not $AnimatedSprite2D.is_playing() and is_on_floor():
			$AnimatedSprite2D.play("move")

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * speedMulti)

	move_and_slide()
