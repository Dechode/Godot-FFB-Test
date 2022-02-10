extends Control


export (Curve) var ffb_signal_wave = null

var is_ffb: bool = false
var is_running: bool = false
var effect_id = -1

var amplitude: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ffbplugin.init_ffb(0) 
	is_ffb = $ffbplugin.force_feedback
#	if $ffbplugin.init_constant_force_effect() != 0:
#		print("Error initialising constant force effect")
##		$ffbplugin.init_constant_force_effect()
#	else:
#		print("Constant force effect initialised")
		
	print("Has constant force effect = ",is_ffb)
	
	$AmplitudeSlider.value = amplitude



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	var ffb_signal = $AmplitudeSlider.value
	
#	if is_running and is_ffb:
	if is_running:
		print(ffb_signal)
#		print($ffbplugin.cf_id)
		if $ffbplugin.update_constant_ffb_effect(ffb_signal, 0) != 0:
			print("Updating constant force effect failed!")
#		$ffbplugin.update_constant_ffb_effect(ffb_signal)
	else:
		$ffbplugin.destroy_ffb_effect(0)
#		if is_ffb:
#			if $ffbplugin.update_constant_ffb_effect(0.0) != 0:
##			$ffbplugin.update_constant_ffb_effect(0.0)
#				print("Updating constant force effect failed!")
#		else:
#			print("No force feedback device found")


func _on_AmplitudeSlider_value_changed(value: float) -> void:
	amplitude = value


func _on_StartBtn_pressed() -> void:
	if $ffbplugin.init_constant_force_effect() != 0:
		print("Error initialising constant force effect")
	if $ffbplugin.play_constant_ffb_effect(-1, 0) != 0:
		print("Starting ffb effect failed")
	is_running = true


func _on_StopBtn_pressed() -> void:
	is_running = false
	$ffbplugin.destroy_ffb_effect(-1)
	

