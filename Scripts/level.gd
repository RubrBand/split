extends GridMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var logic = []
var agents = []
var player1
var player2
var state = 0 #0 - players can move, 1 - waiting to select player, 2 - PLAYER REVERSING (beeping noises), 3 - waiting to select direction, 4 - players being pushed
var markers = []

var floorcount = 2 #how many floor types there are, they should be the first ones

# Called when the node enters the scene tree for the first time.
func _ready():
	player1 = get_node("player1")
	player2 = get_node("player2")
	player1.textures.resize(4)
	player2.textures.resize(4)
	player1.textures[0] = preload("res://Textures/greenidle.tres")
	player2.textures[0] = preload("res://Textures/pinkidle.tres")
	player1.textures[1] = preload("res://Sprites/player/greenpush.png")
	player2.textures[1] = preload("res://Sprites/player/pinkpush.png")
	player1.textures[2] = preload("res://Sprites/player/greenpull.png")
	player2.textures[2] = preload("res://Sprites/player/pinkpull.png")
	player1.textures[3] = preload("res://Sprites/player/greenhop.png")
	player2.textures[3] = preload("res://Sprites/player/pinkhop.png")


func _input(event):
	if event.is_action_pressed("game_split")&&player1.state==0&&player2.state==0:
		if state == 0:
			state = 1
		elif state == 1:
			state = 0
	elif event.is_action_pressed("game_select_p1")&&state == 1:
		collapse(true)
	elif event.is_action_pressed("game_select_p2")&&state == 1:
		collapse(false)
	if (event.is_action_pressed("game_down")||event.is_action_pressed("game_up"))&&state == 3:
		split(false)
	elif (event.is_action_pressed("game_left")||event.is_action_pressed("game_right"))&&state == 3:
		split(true)
	
	if state == 0:
		var dir = Vector2(0,0)
		if event.is_action_pressed("game_up"):
			dir = Vector2(0,-1)
		if event.is_action_pressed("game_down"):
			dir = Vector2(0,1)
		if event.is_action_pressed("game_left"):
			dir = Vector2(-1,0)
		if event.is_action_pressed("game_right"):
			dir = Vector2(1,0)
		if dir != Vector2(0,0)&&player1.state==0&&player2.state==0:
			if get_cell_item(world_to_map(player1.translation).x+dir.x,-1,world_to_map(player1.translation).z+dir.y) <= floorcount-1:
				player1.memories_of_a_better_time.append(Vector2(player1.translation.x,player1.translation.z))
				player1.goto += dir
				player1.state = 1
			if get_cell_item(world_to_map(player2.translation).x+dir.x,-1,world_to_map(player2.translation).z+dir.y) <= floorcount-1:
				player2.memories_of_a_better_time.append(Vector2(player2.translation.x,player2.translation.z))
				player2.goto += dir
				player2.state = 1
	if event.is_action_pressed("game_restart"):
		get_parent().next_scene()

func update_all():
	for agent in agents:
		agent.update()
	if state == 0 && player1.state == -1:
		if player2.state == -1:
			get_parent().next_scene()
		elif player2.state == 0:
			collapse(false)
	elif state == 0 && player2.state == -1:
		if player1.state == 0:
			collapse(true)
	if state == 4 && player1.state<=0 && player2.state<=0:
		state = 0
		update_all()
	if player1.translation == player2.translation && player1.state==0 && player2.state==0&&state!=3:
		merge(true)

func set_logic(var cell, var value):
	
	if logic.size()<=cell:
		for _i in range(logic.size(),cell+1):
			logic.append(0)
	var changed = logic[cell]!=value
	logic[cell] = value
	if changed:
		update_all()

func get_logic(var cell):
	if logic.size()>cell:
		return logic[cell]
	else: return 0

func collapse(tofirst:bool):
	state = 2
	if tofirst:
		player2.state = 2
	else:
		player1.state = 2

func merge(tofirst:bool):
	player1.state = 1
	player2.state = 1
	player1.flip_h = false
	player2.flip_h = false
	player1.textures[0] = preload("res://Textures/playertexture.tres")
	player2.textures[0] = preload("res://Textures/playertexture.tres")
	player1.memories_of_a_better_time = []
	player2.memories_of_a_better_time = []
	if tofirst:
		player2.translation = player1.translation
	else:
		player1.translation = player2.translation
	player1.goto = Vector2(player1.translation.x,player1.translation.z)
	player2.goto = Vector2(player2.translation.x,player2.translation.z)
	state = 3
	var dir = Vector2(1,0)
	for i in range(0,4):
		var _len = raycast(Vector2(world_to_map(player1.translation).x,world_to_map(player1.translation).z), dir)
		markers.append(preload("res://Scenes/splittarget.tscn").instance())
		markers[i].translation = player1.translation + Vector3(dir.x,0,dir.y)*_len
		add_child(markers[i])
		dir = Vector2(dir.y, -dir.x)

func split(horizontal:bool):
	var dir = Vector2(int(horizontal),int(!horizontal))
	dir *= (randi()%2)*2-1
	var move1 = raycast(Vector2(world_to_map(player1.translation).x,world_to_map(player1.translation).z), dir)
	var move2 = raycast(Vector2(world_to_map(player2.translation).x,world_to_map(player2.translation).z), -1*dir)
	player1.goto += dir*move1
	player2.goto += -1*dir*move2
	player1.state = 1
	player2.state = 1
	player1.textures[0] = preload("res://Textures/greenidle.tres")
	player2.textures[0] = preload("res://Textures/pinkidle.tres")
	state = 4
	for marker in markers:
		marker.queue_free()
	markers = []
	
	update_all()

func undo(_x : int, _y : int):
	for agent in agents:
		if agent.gridpos == Vector2(_x,_y):
			agent.undo()

func raycast(from:Vector2, dir : Vector2, limit = 50):
	if get_cell_item(from.x,-1,from.y)>floorcount-1:
		return -1
	else:
		if limit>0:
			var ans = raycast(from+dir, dir, limit-1)
			if ans == -2:
				if get_cell_item(from.x,-1,from.y)!=-1:
					return 1
				else:
					return -2
			else:
				return ans + 1
		else:
			return -2

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
