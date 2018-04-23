extends StaticBody2D

export var door_type = 0
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var currentBody

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func button_body_entered(body):
	if(currentBody == null):
		if(door_type == 0):  # door disappears only while button is pressed
			currentBody = body
			set_collision_layer_bit(0,false)
			get_child(1).hide()
		elif(door_type == 1): # door disappears and reappears after 1 second
			set_collision_layer_bit(0,false)
			get_child(1).hide()
			
			var t = Timer.new()
			t.set_wait_time(1)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			
			set_collision_layer_bit(0,true)
			get_child(1).show()
		elif(door_type == 2): # door disappears permenantly 
			set_collision_layer_bit(0,false)
			get_child(1).hide()
	
func button_body_exited(body):	
	if(currentBody == body):
		if(door_type == 0):
			set_collision_layer_bit(0,true)
			get_child(1).show()
			currentBody = null