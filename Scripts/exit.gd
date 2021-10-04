extends "res://Scripts/levelnode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


export var memindex = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update():
	print(level.get_logic(memindex))
	if level.get_logic(memindex)!=-1:
		if on_player():
	#			print(level.get_logic(memindex))
			if (level.get_logic(memindex)==0):
				level.set_logic(memindex,1, false)
			else:
				#End level here
				level.exit = true
				level.set_logic(memindex,-1, false)

		else: 
			level.set_logic(memindex,0, false)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
