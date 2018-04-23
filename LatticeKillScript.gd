extends Node2D

func kill():
	for child in get_children(): #Delete the enemy and its children if it has been dashed through
		child.queue_free();
	get_parent().queue_free();