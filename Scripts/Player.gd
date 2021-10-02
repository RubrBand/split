extends Sprite3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var goto : Vector2
var movedist = 1
var speed = 3
var grid : GridMap
var gameManager : Node
var fallspeed = 6
var undospeed = 6
var memories_of_a_better_time = []

var state = 0 #0 - can move, 1 - can't move, 2 - backwards



# Called when the node enters the scene tree for the first time.
func _ready():
	grid = get_parent()
	goto = Vector2(translation.x,translation.z)
	gameManager = get_node("/root/GameManager")

func _process(delta):
	if state == 0:
		if (goto!=Vector2(translation.x,translation.z)):
			if(abs(goto.x-translation.x)<speed*delta&&abs(goto.y-translation.z)<=speed*delta): 
				translation = Vector3(goto.x,translation.y,goto.y)
				grid.update_all()
			else: translate(Vector3(sign(goto.x-translation.x),0,sign(goto.y-translation.z))*speed*delta)
	elif state == 1:
		if (goto!=Vector2(translation.x,translation.z)):
			if(abs(goto.x-translation.x)<fallspeed*delta&&abs(goto.y-translation.z)<=fallspeed*delta): 
				translation = Vector3(goto.x,translation.y,goto.y)
				if (grid.state == 4 || grid.state == 5): grid.state+=1
				grid.update_all()
			else: translate(Vector3(sign(goto.x-translation.x),0,sign(goto.y-translation.z))*fallspeed*delta)
	elif state == 2:
		if(abs(goto.x-translation.x)<undospeed*delta&&abs(goto.y-translation.z)<=undospeed*delta):
			translation = Vector3(goto.x,translation.y,goto.y)
			grid.undo(goto.x, goto.y)
			if(memories_of_a_better_time.size()>0):
				goto = memories_of_a_better_time.pop_back()
			else:
				grid.merge(grid.player1!=self)
		else: translate(Vector3(sign(goto.x-translation.x),0,sign(goto.y-translation.z))*undospeed*delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
