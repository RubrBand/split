extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var solidcells = 1; #the amount of solid cells in the cell library
export(Array, PackedScene) var levels
export var startScene : PackedScene
export var endscene : PackedScene
var progress = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	add_child(startScene.instance())

func next_scene():
	get_child(1).queue_free()
	if progress < levels.size():
		add_child(levels[progress].instance())
	else:
		add_child(endscene.instance())

func _input(event):
	if event.is_action_pressed("game_split"):
		$Label.texture = preload("res://sprites/spacebutton0.png")
	elif event.is_action_released("game_split"):
		$Label.texture = preload("res://sprites/spacebutton1.png")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
