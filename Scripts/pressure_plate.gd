extends "res://Scripts/levelnode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var memindex = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update():
	if level.state == 0:
		if on_player():
			level.set_logic(memindex,1)
		else: 
			level.set_logic(memindex,0)



func undo():
	level.set_logic(memindex, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
