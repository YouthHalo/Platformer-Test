extends CharacterBody2D


const SPEED = 100.0


var flip = -1	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	velocity.y += -1
	if is_on_ceiling():
		print("smth is on me")
		velocity.y = -300
		queue_free()
	if is_on_wall():
		print("mmh drywall")
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = flip * SPEED
	if is_on_wall():
		flip = flip * (-1)
		position.x -= velocity.x*0.05
	


	move_and_slide()
