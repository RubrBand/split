extends "res://Scripts/levelnode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export var memindex = 0
var broken = false
var stepped_on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update():
	if level.state == 0:
		if on_player():
			stepped_on = true
		else: 
			if stepped_on:
				stepped_on = false
				broken = true
				level.set_cell_item(gridpos.x,-1,gridpos.y,-1)



func undo():
	stepped_on = false
	if broken:
		broken = false
		level.set_cell_item(gridpos.x,-1,gridpos.y,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
