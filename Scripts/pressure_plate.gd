extends "res://Scripts/levelnode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var memindex = 0;


# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()

func update():
	if (level.world_to_map(level.player1).x==gridpos.x)&&(level.world_to_map(level.player1).y==gridpos.y)||(level.world_to_map(level.player2).x==gridpos.x)&&(level.world_to_map(level.player2).y==gridpos.y):
		level.set_logic(memindex,1)
	else: 
		level.set_logic(memindex,0)



func undo():
	level.setLogic(memindex, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
