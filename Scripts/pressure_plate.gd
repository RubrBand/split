extends "res://Scripts/levelnode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var memindex = 0
var mesh

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh = self

func update():
	if level.state == 0:
		if on_player():
			level.set_logic(memindex,1)
			mesh.set_surface_material(0, preload("res://Materials/green.tres"))
		else: 
			level.set_logic(memindex,0)
			mesh.set_surface_material(0, preload("res://Materials/red.tres"))



func undo():
	level.set_logic(memindex, 0)
	mesh.set_surface_material(0, preload("res://Materials/red.tres"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
