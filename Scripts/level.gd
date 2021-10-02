extends GridMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var logic = []
var agents = []
var player1
var player2
var state = 0 #0 - players can move, 1 - waiting to select player, 2 - PLAYER REVERSING (beeping noises), 3 - waiting to select direction, 4,5 - players being pushed

# Called when the node enters the scene tree for the first time.
func _ready():
	player1 = get_node("player1")
	player2 = get_node("player2")


func _input(event):
	if event.is_action_pressed("game_split"):
		if state == 0:
			state = 1
			player1.state = 1
			player2.state = 1
		elif state == 1:
			state = 0
			player1.state = 0
			player2.state = 0
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
		if dir != Vector2(0,0)&&(player1.goto == Vector2(player1.translation.x,player1.translation.z))&&(player2.goto == Vector2(player2.translation.x,player2.translation.z)):
			if get_cell_item(world_to_map(player1.translation).x+dir.x,-1,world_to_map(player1.translation).z+dir.y) == 0:
				player1.memories_of_a_better_time.append(Vector2(player1.translation.x,player1.translation.z))
				player1.goto += dir
			if get_cell_item(world_to_map(player2.translation).x+dir.x,-1,world_to_map(player2.translation).z+dir.y) == 0:
				player2.memories_of_a_better_time.append(Vector2(player2.translation.x,player2.translation.z))
				player2.goto += dir

func update_all():
	for agent in agents:
		agent.update()
	if state == 6:
		state = 0
		player1.state = 0
		player2.state = 0
	if player1.translation == player2.translation && state == 0:
		merge(true)

func set_logic(var cell, var value):
	
	if logic.size()<=cell:
		logic.resize(cell+1)
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
		player1.state = 1
	else:
		player1.state = 2
		player2.state = 1

func merge(tofirst:bool):
	player1.state = 1
	player2.state = 1
	if tofirst:
		player2.translation = player1.translation
	else:
		player1.translation = player2.translation
	player1.goto = Vector2(player1.translation.x,player1.translation.z)
	player2.goto = Vector2(player2.translation.x,player2.translation.z)
	state = 3
	#change sprite to blue

func split(horizontal:bool):
	var dir = Vector2(int(horizontal),int(!horizontal))
	dir *= (randi()%2)*2-1
	var move1 = raycast(Vector2(world_to_map(player1.translation).x,world_to_map(player1.translation).z), dir)
	var move2 = raycast(Vector2(world_to_map(player2.translation).x,world_to_map(player2.translation).z), -1*dir)
	player1.goto += dir*move1
	player2.goto += -1*dir*move2
	state = 4 + int(move1 == 0)+int(move2 == 0)
	update_all()

func undo(x : int, y : int):
	for agent in agents:
		if agent.gridpos == Vector2(x,y):
			agent.undo()

func raycast(from:Vector2, dir : Vector2):
	if get_cell_item(from.x,-1,from.y)!=0:
		return -1
	else:
		return raycast(from+dir, dir)+1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
