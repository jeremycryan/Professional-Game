extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var velocity = Vector2()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	var speed = 24
	var drag = 0.08
	
	if Input.is_action_pressed('ui_up'):
		velocity.y -= speed
	if Input.is_action_pressed('ui_down'):
		velocity.y += speed
	if Input.is_action_pressed('ui_left'):
		velocity.x -= speed
	if Input.is_action_pressed('ui_right'):
		velocity.x += speed
		
	velocity = velocity*(1-drag)
	velocity = move_and_slide(velocity, Vector2(0, -1))
		
	
	
	#position += velocity*delta