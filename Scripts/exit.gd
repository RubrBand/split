extends "res://Scripts/levelnode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


export var memindex = 0
var hasplayer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update():
	if on_player():
		if hasplayer == 0:
			hasplayer = 1
#			print(level.get_logic(memindex))
			if (level.get_logic(memindex)==0):
				level.set_logic(memindex,1)
			else:
				#End level here
				get_node("/root/GameManager").progress += 1
				get_node("/root/GameManager").end_scene()
	else: 
		if hasplayer != 0:
			hasplayer = 0
			level.set_logic(memindex,0)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
