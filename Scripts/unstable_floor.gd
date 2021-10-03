extends "res://Scripts/levelnode.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export var memindex = 0
var broken = false
var stepped_on = false
var gravity = 9.81
var velocity = 0
var normal

# Called when the node enters the scene tree for the first time.
func _ready():
	normal = translation

func update():
	if level.state == 0:
		if on_player():
			stepped_on = true
		else: 
			if stepped_on:
				stepped_on = false
				broken = true
				velocity = 0
				level.set_cell_item(gridpos.x,-1,gridpos.y,-1)



func undo():
	stepped_on = false
	if broken:
		broken = false
		level.set_cell_item(gridpos.x,-1,gridpos.y,1)
		velocity = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if stepped_on:
		translation.x = normal.x + (randf()-0.5)*0.1
		translation.y = normal.y + (randf()-0.5)*0.1
	else:
		translation.x = normal.x
		translation.z = normal.z
	if broken:
		if translation.y+10 > normal.y:
			velocity+=gravity*delta
			translation.y -= velocity*delta
	else:
		if translation.y<normal.y:
			translation.y += sqrt(abs(normal.y-translation.y))*delta*5
		else:
			translation.y = normal.y
