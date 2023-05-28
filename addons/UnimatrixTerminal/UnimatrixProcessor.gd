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

func parse_vec3(val: PackedStringArray):
	var indices = val[0].split(',') 
	if len(indices) == 3:
		return Vector3(parse_float(indices[0]), parse_float(indices[1]), parse_float(indices[2]))
	else:
		push_error("ERROR: Failed to parse coordinates from input vector: \"%s\"" % val)

func parse_vec2(val: PackedStringArray):
	var indices = val[0].split(',') 
	if  len(indices) == 2:
		return Vector2(parse_float(indices[0]), parse_float(indices[1]))
	else:
		push_error("ERROR: Failed to parse coordinates from input vector: \"%s\"" % val)

func parse_float(val: String):
	if val.is_valid_float():
		return val.to_float()
	
	push_error("ERROR: Failed to parse float from value: \"%s\"" % val)

func parse_int(val: String, floor: bool = false):
	if val.is_valid_int() || (floor and val.is_valid_float()):
		return val.to_int()
	
	push_error("ERROR: Failed to parse float from value: \"%s\"" % val)

func parse_list(input: String, delimiter: String = ',', parser_method: String = '', parser=self):
	var values: Array[String] = input.split(delimiter)
	
	return values.map(func(val): return parser.call(parser_method, val))

func parse_file_path(path: String):
	if FileAccess.file_exists(path):
		return FileAccess.open(path, FileAccess.READ)

	push_error("ERROR: Failed to open file from path: \"%s\"" % path)
	
func parse_dir(path: String):
	if DirAccess.dir_exists_absolute(path):
		return DirAccess.open(path)
	
func parse_json(path: String):
	var file: FileAccess = parse_file_path(path)
	
	var json = JSON.parse_string(file.get_as_text())
	
	if json != null:
		return json
	
	push_error("PARSE ERROR: Failed to parse json from file")

func parse_csv(path: String):
	var file: FileAccess = parse_file_path(path)
	
	var csv_headers: PackedStringArray = []
	var data: Array[PackedStringArray] = []
	
	if file != null:
		if not file.eof_reached():
			csv_headers = file.get_csv_line()
		while not file.eof_reached():
			data.append(file.get_csv_line())
		
		return {'headers': csv_headers, 'data': data}
