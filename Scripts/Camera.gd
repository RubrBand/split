extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shakeamount = 0.0
var shakeduration = 0
var shakedelay = 0.0
var shaketimer = 0
var origin :Vector3
var offset = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	origin = translation

func shake(amount, duration, delay):
	shakeamount = amount
	shakedelay = delay
	shakeduration = duration
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(shakeduration>0):
		shakeduration -=delta
		shaketimer += delta
		if(shaketimer>shakedelay):
			shaketimer = 0
			offset = Vector3(rand_range(-shakeamount,shakeamount),rand_range(-shakeamount,shakeamount),rand_range(-shakeamount,shakeamount))
	else: offset = Vector3(0,0,0)
	translation = offset + origin
