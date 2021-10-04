extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var solidcells = 1; #the amount of solid cells in the cell library
export(Array, PackedScene) var levels
export var startScene : PackedScene
export var endscene : PackedScene
var progress = -1

var textboxlocation = Vector2(317,1200)

var terminal_visible = false

var text_buffer = ""
var text_speed = 0.1
var text_countdown = 0
var input_lock = false
onready var material = $ViewportContainer.material

var col1 = Color(0.92,0.0,0.85,0.5)
var col2 = Color(0.6,0.9,0.31,0.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$ViewportContainer/Viewport.add_child(startScene.instance())
	material.set_shader_param("col1", col1)
	material.set_shader_param("col2", col2)
	material.set_shader_param("dissonance", 0.0)



func next_scene():
	var child = $ViewportContainer/Viewport.get_child(0)
	remove_child(child)
	child.queue_free()
	if progress < levels.size():
		$ViewportContainer/Viewport.add_child(levels[progress].instance())
	else:
		$ViewportContainer/Viewport.add_child(endscene.instance())

func _input(event):
	if event.is_action_pressed("game_split"):
		$GUI/Label.texture = preload("res://sprites/spacebutton0.png")
		if terminal_visible:
			if text_buffer == "":
				terminal_visible = false
			else:
				$GUI/Terminal/MarginContainer/TextEdit.text += text_buffer
				text_buffer = ""
	elif event.is_action_released("game_split"):
		$GUI/Label.texture = preload("res://sprites/spacebutton1.png")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input_lock = true
	if terminal_visible:
		if $GUI/Terminal.rect_position.y > textboxlocation.x:
			$GUI/Terminal.rect_position.y -= 800*delta
		else:
			if text_buffer != "":
				text_countdown+=delta
				if text_countdown>text_speed:
					text_countdown = 0
					$GUI/Terminal/MarginContainer/TextEdit.text += text_buffer.left(1)
					text_buffer = text_buffer.right(1)

			
	else:
		if $GUI/Terminal.rect_position.y < textboxlocation.y:
			$GUI/Terminal.rect_position.y += 800*delta
		else:
			input_lock = false
	
	


func write_in_terminal(text:String):
	text_buffer += text
	
func clear_terminal():
	$GUI/Terminal/MarginContainer/TextEdit.text = ""
