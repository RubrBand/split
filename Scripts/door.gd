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

func open():
	pass

func close():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
