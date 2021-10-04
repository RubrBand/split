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
var material : Material
var splitscene = false
var fadeout = false

var col1 = Color(0.92,0.0,0.85,0.5)
var col2 = Color(0.6,0.9,0.31,0.5)



# Called when the node enters the scene tree for the first time.
func _ready():
	material = $ViewportContainer.material
	randomize()
	$ViewportContainer/Viewport.add_child(startScene.instance())
	material.set_shader_param("col1", col1)
	material.set_shader_param("col2", col2)
	material.set_shader_param("dissonance", 0.0)
	



func end_scene():
	if progress == 0:
		fadeout = true
	$ViewportContainer/Viewport.render_target_clear_mode = Viewport.CLEAR_MODE_NEVER
	$ViewportContainer/Viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
	var child = $ViewportContainer/Viewport.get_child(0)
	$ViewportContainer/Viewport.remove_child(child)
	child.queue_free()
	splitscene = true

func next_scene():
	$ViewportContainer/Viewport.render_target_clear_mode = Viewport.CLEAR_MODE_ALWAYS
	$ViewportContainer/Viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	if progress < levels.size():
		$ViewportContainer/Viewport.add_child(levels[progress].instance())
	else:
		$ViewportContainer/Viewport.add_child(endscene.instance())
	splitscene = false

func _input(event):
	if event.is_action_pressed("game_split"):
		$GUI/Label.texture = preload("res://sprites/spacebutton0.png")
		if terminal_visible:
			if text_buffer == "":
				terminal_visible = false
			else:
				$GUI/Terminal/MarginContainer/TextEdit.text += text_buffer
				text_buffer = ""
				$GUI/Terminal/MarginContainer/TextEdit.scroll_vertical = 1000
	elif event.is_action_released("game_split"):
		$GUI/Label.texture = preload("res://sprites/spacebutton1.png")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if fadeout: 
		if $AudioStreamPlayer.volume_db>-80:
			$AudioStreamPlayer.volume_db -= 40*delta
		else: fadeout = false
	
	
	if terminal_visible:
		input_lock = true
		if $GUI/Terminal.rect_position.y > textboxlocation.x:
			$GUI/Terminal.rect_position.y -= 800*delta
		else:
			if text_buffer != "":
				text_countdown+=delta
				if text_countdown>text_speed:
					text_countdown = 0
					$GUI/Terminal/MarginContainer/TextEdit.text += text_buffer.left(1)
					text_buffer = text_buffer.right(1)
				$GUI/Terminal/MarginContainer/TextEdit.scroll_vertical = 1000
			
	else:
		if $GUI/Terminal.rect_position.y < textboxlocation.y:
			$GUI/Terminal.rect_position.y += 800*delta
			if $GUI/Terminal.rect_position.y >= textboxlocation.y:
				input_lock = false

	var diss = material.get_shader_param("dissonance")
	if splitscene:
		if diss > 1:
			next_scene()
		else:
			material.set_shader_param("dissonance",diss+delta)
	else:
		if diss>0.0001:
			material.set_shader_param("dissonance",diss/(1+delta*2))
		else:
			material.set_shader_param("dissonance",0.0)


func write_in_terminal(text:String):
	text_buffer += text
	
func clear_terminal():
	$GUI/Terminal/MarginContainer/TextEdit.text = ""


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.stream = preload("res://music/split_loop.ogg")
	$AudioStreamPlayer.playing = true
