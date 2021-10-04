extends "res://Scripts/levelnode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var memindex = 0
export var var1 = 0
export var var2 = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update():
	level.set_logic(memindex, min(level.get_logic(var1)+level.get_logic(var2),1))

