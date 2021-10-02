extends GridMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var logic = []
var agents = []
var player1
var player2

# Called when the node enters the scene tree for the first time.
func _ready():
	player1 = get_node("player1")
	player2 = get_node("player2")
	

func update_all():
	for agent in agents:
		agent.update()

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
