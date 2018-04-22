extends RigidBody2D

var motion = Vector2();
var new_impulse = Vector2();
var gravity = Vector2(0, 10);
var jumpStrength = -500;
var speed = 1000;
var jumping = Vector2(0,0);
var canJump = false;

onready var anim = get_node("player_anim");
var cur_anim = "Idle"
var new_anim = "Idle"

func animate(animation):
	var a_sprite = find_node(animation);
	print(a_sprite)
	if not anim.is_playing():
		anim.play(animation)
	elif animation == cur_anim:
		return
	else:
		for n in get_node("Sprites").get_children():
			n.hide();
		a_sprite.show();
		anim.play(animation);
		cur_anim = animation

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
	
	#	Set default animation to idle in direction currently facing	
	if cur_anim in ["RunRight", "Idle"]:
		new_anim = "Idle";
	else:
		new_anim = "IdleLeft"
		
	#	
	if motion.x > 0:
		new_anim = "RunRight";
	elif motion.x < 0:
		new_anim = "RunLeft";
	
	animate(new_anim);

	apply_impulse(Vector2(), new_impulse)
	

	
func _ready():
	anim.play("Idle");
	
	set_contact_monitor(true);
	set_max_contacts_reported(5);

func _on_Floor_collided():
	canJump = true;
