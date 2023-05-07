class_name UnimatrixCommand extends Node

@export var command_name: String = ''
@export_multiline var command_help: String = ''
# Called when the node enters the scene tree for the first time.
func _ready():
	self._register_command()
	
func _register_command():
	UnimatrixProcessor.register_command(command_name, self)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate(args: PackedStringArray, logger_callback: Callable):
	pass

func help():
	return self.command_help + '\n'
