extends Control

var _ip_regex = RegEx.new()
var _port_regex = RegEx.new()

onready var _name_edit = $NameEdit
onready var _ip_edit = $IpEdit
onready var _port_edit = $PortEdit
onready var _connect_button = $ConnectButton

onready var _client = $Client

func _ready():
	_ip_regex.compile("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$")
	_port_regex.compile("^[0-9]{1,5}$")

	_name_edit.text = ""
	_ip_edit.text = "127.0.0.1"
	_ip_edit.caret_position = _ip_edit.text.length()
	_update_connect_enabled()

	_name_edit.grab_focus()

func _on_NameEdit_text_changed(new_text):
	_update_connect_enabled()

func _on_IpEdit_text_changed(new_text):
	_update_connect_enabled()

func _on_PortEdit_text_changed(new_text):
	_update_connect_enabled()

func _update_connect_enabled():
	_connect_button.disabled = true
	if _name_edit.text != "" \
	&& _ip_regex.search(_ip_edit.text) != null \
	&& _port_regex.search(_port_edit.text) != null:
		_connect_button.disabled = false

func _on_ConnectButton_pressed():
	_client.connect_to_server(_ip_edit.text, _port_edit.text.to_int())
