extends RigidBody2D

var motion = Vector2();
var new_impulse = Vector2();
var gravity = Vector2(0, 10);
var jumpStrength = -500;
var speed = 1000;
var jumping = Vector2(0,0);
var canJump = false;

func _process(delta):
	motion = Vector2(0,0);
	jumping = Vector2(0,0);
	
	if (Input.is_action_pressed("mv_right")):
		motion.x += 1;
	if (Input.is_action_pressed("mv_left")):
		motion.x -= 1;
	if (Input.is_action_pressed("mv_up")):
		if canJump:
			jumping = Vector2(0,jumpStrength);
			canJump = false;
	if (Input.is_action_pressed("mv_down")):
		motion.y += 1;
	motion = motion.normalized();
	
	new_impulse = motion * delta * speed;
	new_impulse += gravity;
	new_impulse += jumping;

	apply_impulse(Vector2(), new_impulse)
	
func _ready():
	set_contact_monitor(true);
	set_max_contacts_reported(5);

func _on_Floor_collided():
	canJump = true;
