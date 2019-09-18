extends Control

# ... Pude haber creado esta función en helpers.gd y me ahorraba crear otro archivo.gd
# Lo dejaré para que vean lo funcional que son los singletons.
# Ahorran crear archivos semivacios como estos.

# Botón de salir del juego.
func _on_Salir_button_down():
	# Cerramos el juego.
	get_tree().quit()