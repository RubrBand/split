extends "res://Scripts/levelnode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var memindex = 0
export var open = false
export var invert = false

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()

func update():
	var to = level.get_logic(memindex)
	if (open!=(to!=invert)):
		if (to!=invert): open()
		else: close()

#add sum animation shit
func open():
	open = true
	level.set_cell_item(gridpos.x,-1,gridpos.y,0)

func close():
	if !(level.world_to_map(level.player1).x==gridpos.x)&&(level.world_to_map(level.player1).y==gridpos.y)||(level.world_to_map(level.player2).x==gridpos.x)&&(level.world_to_map(level.player2).y==gridpos.y):
		open = false
		level.set_cell_item(gridpos.x,-1,gridpos.y,2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
