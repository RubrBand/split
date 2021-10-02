extends Sprite3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var goto : Vector2
var movedist = 1
var speed = 3
var grid : GridMap
var gameManager : Node

func _input(event):
	if event.is_action_pressed("game_up"):
		if (goto == Vector2(translation.x,translation.z)):
			if grid.get_cell_item(grid.world_to_map(translation).x,-1,grid.world_to_map(translation).z-1)==0:
				goto += Vector2(0,-1)
	if event.is_action_pressed("game_down"):
		if (goto == Vector2(translation.x,translation.z)):
			if grid.get_cell_item(grid.world_to_map(translation).x,-1,grid.world_to_map(translation).z+1)==0:
				goto += Vector2(0,1)
	if event.is_action_pressed("game_left"):
		if (goto == Vector2(translation.x,translation.z)):
			if grid.get_cell_item(grid.world_to_map(translation).x-1,-1,grid.world_to_map(translation).z)==0:
				goto += Vector2(-1,0)
	if event.is_action_pressed("game_right"):
		if (goto == Vector2(translation.x,translation.z)):
			if grid.get_cell_item(grid.world_to_map(translation).x+1,-1,grid.world_to_map(translation).z)==0:
				goto += Vector2(1,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = get_node("/root/GameManager/GridMap")
	goto = Vector2(translation.x,translation.z)
	gameManager = get_node("/root/GameManager")

func _process(delta):
	if (goto!=Vector2(translation.x,translation.z)):
		if(abs(goto.x-translation.x)<speed*delta&&abs(goto.y-translation.z)<speed*delta): translation = Vector3(goto.x,translation.y,goto.y)
		else: translate(Vector3(sign(goto.x-translation.x),0,sign(goto.y-translation.z))*speed*delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
