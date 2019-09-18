extends Control

func _ready():
	# Al abrir la ventana de Creditos se reejecuta el GUI.gd
	# ¿Por qué? Por la señal del botón "Regresar"
	# Así que si la ventana es Creditos, ignorar esto.
	if name == "Creditos":return false
	# Revisar si hay archivo de guardado.
	var valido = helpers.cargar(true)
	if valido == true:
		# No hay archivo de guardado
		# Hacer disabled el botón.
		$Botones/Load.disabled = true

func _on_Credits_button_up():
	get_tree().change_scene("Creditos.tscn")

func _on_Regresar_button_up():
	get_tree().change_scene("Main.tscn")

func _on_Start_button_up():
	$Create_ACC.visible = true

func _on_Load_button_up():
	helpers.cargar()
	# Ir a la escena de juego.
	get_tree().change_scene("Juego.tscn")

func _on_Start2_button_up():
	helpers.create_acc($Create_ACC/Typename.text)
	# Ir a la escena de juego.
	get_tree().change_scene("Juego.tscn")

func _on_FullScreen_button_down():
	if !$FullScreen.pressed:
		helpers.fullscreen(true)
	else:
		helpers.fullscreen(false)

func _on_Saphirus_button_down():
	OS.shell_open("https://saphirus.ml")
