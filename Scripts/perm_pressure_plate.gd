extends "res://Scripts/levelnode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var memindex = 0
var player1 = false
var player2 = false
var locked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update():
	if level.state == 0:
		if on_player(0):
			player1 = true
		if on_player(1):
			player2 = true
		output()



func undo():
	
	if !locked:
		if level.player1.state == 2:
			player1 = false
		else:
			player2 = false
		if player1 or player2:
			locked = true
	output()

func output():
	print("-----------------")
	print(locked)
	print(player1)
	print(player2)
	level.set_logic(memindex,int(player1||player2||locked))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
