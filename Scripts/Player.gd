extends Sprite3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var goto : Vector2
var movedist = 1
var speed = 1

func _input(event):
	if event.is_action_pressed("game_up"):
		if (goto == Vector2(translation.x,translation.z)):
			goto += Vector2(0,1)
	if event.is_action_pressed("game_down"):
		if (goto == Vector2(translation.x,translation.z)):
			goto += Vector2(0,-1)
	if event.is_action_pressed("game_left"):
		if (goto == Vector2(translation.x,translation.z)):
			goto += Vector2(-1,0)
	if event.is_action_pressed("game_right"):
		if (goto == Vector2(translation.x,translation.z)):
			goto += Vector2(1,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if (goto!=Vector2(translation.x,translation.z)):
		translate(Vector3(sign(translation.x-goto.x),0,sign(translation.z-goto.y))*speed*delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
