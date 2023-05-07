extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_command_entered(input: String):
	var line: PackedStringArray = input.split(' ')
	if len(line) == 0:
		return
	var command = line[0]
	var keywords: PackedStringArray = line.slice(1)
	
	UnimatrixProcessor.try_command(command, keywords)
	pass
