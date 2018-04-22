extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const standable = false
onready var anim = find_node("anim_player")

func _ready():
	set_collision_mask_bit(0, false);
	set_collision_mask_bit(0, false);
	set_collision_mask_bit(3, true);
	set_collision_layer_bit(3, true);
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	var v = linear_velocity
	var angle = atan2(v[1], v[0])
	
	var sprite = find_node("CollisionShape2D");
	sprite.rotation = angle + PI/2
	
	if not anim.is_playing():
		anim.play("Fly");
	
	
	

func _integrate_forces(state):
	for i in range(0, state.get_contact_count()):
		if (state.get_contact_collider_object(i).get_collision_layer_bit(2)):
			queue_free()