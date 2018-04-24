extends Area2D

export (String) var NextScene = "Level_1"

func _ready():
	connect("body_entered", self, "next_scene");

func next_scene(body):
	if body.get_name() == "Player":
		get_tree().change_scene("res://" + NextScene + ".tscn");