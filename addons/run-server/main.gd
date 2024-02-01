@tool
extends EditorPlugin

var run_server_button : Button

func _enter_tree() -> void:
	if !ProjectSettings.has_setting("run_server/args"):
		ProjectSettings.set_setting("run_server/args", PackedStringArray(["--headless"]))
	var nodes = EditorInterface.get_base_control().get_children();
	var run_bar : HBoxContainer = find(nodes[0].get_child(0).get_children(), "@EditorRunBar").get_child(0).get_child(0);
	run_server_button = run_bar.get_child(0).duplicate()
	run_server_button.icon = preload("res://addons/run-server/run_server.svg")
	run_server_button.tooltip_text = "Run server"
	run_bar.add_child(run_server_button)
	run_bar.move_child(run_server_button, 6)
	run_server_button.toggled.connect(run_server_toggled)

func find(array : Array, what : String):
	for element in array:
		if element.name.begins_with(what): return element;

func run_server_toggled(value : bool):
	if value == false: return;
	run_server_button.button_pressed = false
	var args = ["/c" if OS.get_name() == "Windows" else "-c", OS.get_executable_path()];
	args.append_array(ProjectSettings.get_setting("run_server/args", []))
	OS.create_process("cmd" if OS.get_name() == "Windows" else "bash", args, true)

func _exit_tree() -> void:
	run_server_button.queue_free();
