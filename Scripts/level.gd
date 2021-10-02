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
	pass # Replace with function body.

func set_logic(var cell, var value):
	var changed = logic[cell]!=value
	logic[cell] = value
	if changed:
		for agent in agents:
			agent.update()

func get_logic(var cell):
	return logic[cell]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
