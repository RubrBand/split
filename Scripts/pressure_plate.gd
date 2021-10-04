extends "res://Scripts/levelnode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var memindex = 0
var mesh
var stepped = false # used to indentify when player steps on and off of a pressure plate

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh = self

func update():
	if level.state == 0:
		if on_player():
			level.set_logic(memindex,1)
			if on_player(0):
				mesh.set_surface_material(0, preload("res://Materials/light_green.tres"))
			elif on_player(1):
				mesh.set_surface_material(0, preload("res://Materials/pink.tres"))
			if !stepped:
				stepped = true
				level.GameManager.get_node("AudioStreamPlayerButtons").stream = preload("res://sounds/button2.wav")
				level.GameManager.get_node("AudioStreamPlayerButtons").play()
		else: 
			level.set_logic(memindex,0)
			mesh.set_surface_material(0, preload("res://Materials/red.tres"))
			if stepped:
				stepped = false
				level.GameManager.get_node("AudioStreamPlayerButtons").stream = preload("res://sounds/button2reverse.wav")
				level.GameManager.get_node("AudioStreamPlayerButtons").play()



func undo():
	level.set_logic(memindex, 0)
	mesh.set_surface_material(0, preload("res://Materials/red.tres"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
