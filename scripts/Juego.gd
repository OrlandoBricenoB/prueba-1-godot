extends Node2D

# Variable que almacena los tiles del tilemap Ciclo.
var tiles
var tiempo = 6

func _ready():
	# Se le entregan todos los tiles que $Ciclo utiliza.
	tiles = $Ciclo.get_used_cells()

# Al termnar el Ciclo Timer.
func _on_Ciclo_Timer_timeout():
	# Si tiempo es #6, es porque está en la última fase.
	if tiempo == 6:
		# Regresar a la primera.
		tiempo = 1
	else:
		# Sino, aumentar 1.
		tiempo+=1
	# Por cada tile en tiles, guardar cada uno en i
	for i in tiles:
		# Reemplazar el tile actual por el del tiempo actual.
		$Ciclo.set_cell(i.x, i.y, tiempo)
	# HUD
	var texto_tiempo
	# Cambiar los textos según el tiempo.
	if tiempo == 6:
		texto_tiempo = "Dia"
	elif tiempo == 1:
		texto_tiempo = "Noche 1"
	elif tiempo == 2:
		texto_tiempo = "Noche 2"
	elif tiempo == 3:
		texto_tiempo = "Noche 3"
	elif tiempo == 4:
		texto_tiempo = "Noche"
	elif tiempo == 5:
		texto_tiempo = "Compra una linterna xd"
	# Cambiar el texto.
	$HUD/CL/Tiempo.text = texto_tiempo

# Si proyectil choca con el Area2D favorito de todos xd.
func _on_col_body_entered(body):
	# Si está en grupo proyectil.
	if body.is_in_group("proyectil"):
		# Ejecutar la función explotar de proyectil.gd
		body.explotar()