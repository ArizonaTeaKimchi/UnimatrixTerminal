extends Node

signal command_logger

var commands: Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func try_command(command: String, keywords: PackedStringArray = PackedStringArray([])):
	"""try_command: attempts to activate a given command with optional keyword arguments
	params:
		command (String): the name of the command (case sensitive)
		keywords (OPTIONAL, PackedStringArray): the keyword arguments for the given command, if any
	
	(UnimatrixCommand names are registered to the processor via the register_command())
	"""
	
	command_logging('[color=#FF00FF][b]' + '>>' + command + ' ' + ' '.join(keywords) + '[/b][/color]')
	
	if not commands.has(command):
		var error_str = "ERROR: No command found matching \"%s\"" % command
		push_error(error_str)
		command_logging(error_str)
		return
	
	var command_node: UnimatrixCommand = self.get_command(command)
	command_node.activate(keywords, command_logging)
	
func get_command(command: String) -> UnimatrixCommand:
	return self.commands.get(command)

func register_command(command_name: String, command: UnimatrixCommand):
	if not self.commands.has(command_name):
		self.commands[command_name] = command
	else:
		push_error("ERROR: Terminal Processor already has command \"%s\" registerd" % command_name)

func command_logging(value: String):
	self.command_logger.emit(value + '\n')
