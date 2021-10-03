extends Sprite3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var goto : Vector2
var movedist = 1
var speed = 3
var grid : GridMap
var gameManager : Node
#var fallspeed = 6
var undospeed = 6
var memories_of_a_better_time = []
var y_normal : float
var y_velocity = 0.0
var gravity = 20
var textures = [] #0 - idle, 1 - push, 2 - pull, 3 - jump


var state = 0 #-1 - dead, 0 - not moving, 1 - moving, 2 - moving backwards, 3 - falling



# Called when the node enters the scene tree for the first time.
func _ready():
	y_normal = translation.y
	grid = get_parent()
	goto = Vector2(translation.x,translation.z)
	gameManager = get_node("/root/GameManager")

func _process(delta):
	if state == 1:
		if(abs(goto.x-translation.x)<undospeed*delta):
			translation.x=goto.x
		else: translation.x += sign(goto.x-translation.x)*speed*delta
		if(abs(goto.y-translation.z)<undospeed*delta):
			translation.z=goto.y
		else: translation.z += sign(goto.y-translation.z)*speed*delta
		if(abs(y_normal-translation.y)<undospeed*delta*3):
			translation.y=y_normal
		else: translation.y += sign(y_normal-translation.y)*speed*delta*3
		
		if(translation==Vector3(goto.x,y_normal,goto.y)): 
			if (grid.state == 4 || grid.state == 5): grid.state+=1
			if(grid.get_cell_item(grid.world_to_map(translation).x,-1,grid.world_to_map(translation).z)==-1):
				state = 3
			else: 
				grid.update_all()
				state = 0
		
	elif state == 2:
		if(abs(goto.x-translation.x)<undospeed*delta):
			translation.x=goto.x
		if(abs(goto.y-translation.z)<undospeed*delta):
			translation.z=goto.y
		if(abs(y_normal-translation.y)<undospeed*delta*3):
			translation.y=y_normal
		
		if(abs(goto.x-translation.x)<undospeed*delta&&abs(goto.y-translation.z)<=undospeed*delta&&abs(y_normal-translation.y)<undospeed*delta*3):
			translation = Vector3(goto.x,y_normal,goto.y)
			grid.undo(grid.world_to_map(translation).x, grid.world_to_map(translation).z)
			if(memories_of_a_better_time.size()>0):
				goto = memories_of_a_better_time.pop_back()
			else:
				grid.merge(grid.player1!=self)
		else: translate(Vector3(sign(goto.x-translation.x),sign(y_normal-translation.y)*3,sign(goto.y-translation.z))*undospeed*delta)
	elif state == 3:
		y_velocity += gravity*delta
		translation.y -= y_velocity*delta
		if (translation.y+10<y_normal):
			y_velocity = 0
			translation.y = y_normal-10
			die()
	
	
	
	#animation
	if state == 0:
		texture = textures[0]
	elif state == 3:
		texture == textures[2]
	elif grid.state == 0:
		texture = textures[3]
	elif grid.state>3 || state == 2:
#		print(String(goto.x)+" "+String(translation.x))
		if(goto.x>=translation.x&&goto.y<=translation.z&&y_normal>=translation.y):
			texture = textures[1]
		elif(goto.x<=translation.x&&goto.y>=translation.z&&y_normal<=translation.y):
			texture = textures[2]

func die():
	state = -1
	grid.update_all()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
