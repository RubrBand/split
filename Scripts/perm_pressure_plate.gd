extends "res://Scripts/levelnode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var memindex = 0
var player1 = false
var player2 = false
var locked = false
var mesh

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh = self

func update():
	if level.state == 0:
		if on_player(0):
			player1 = true
		if on_player(1):
			player2 = true
	elif level.state == 4&&(player1||player2):
		locked = true
	output()

func set_material(mat):
#	mesh.set_surface_material(0, mat)
	for i in get_children():
		i.set_surface_material(0, mat)

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
	if player1&&!player2&&!locked:
		set_material(preload("res://Materials/light_green.tres"))
	elif !player1&&player2&&!locked:
		set_material(preload("res://Materials/pink.tres"))
	elif (player1 && player2) || locked:
		set_material(preload("res://Materials/blue.tres"))
	else:
		set_material(preload("res://Materials/black.tres"))
	level.set_logic(memindex,int(player1||player2||locked))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
