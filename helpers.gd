extends Node

var datos
var b_fullscreen = false

func guardar_datos(valores):
	# Alteramos la variable datos a la de valores recibidos.
	datos = valores

func obtener_datos():
	# Entregar los datos de guardado.
	return datos

func create_acc(nombre_elegido):
	# Creamos archivo.
	var save_game = File.new()
	# Creamos o reescribimos el archivo.
	save_game.open("./save.save", File.WRITE)
	# Valores por defecto.
	var node_data = {
		"pos_x": 384,
		"pos_y": 320,
		"nombre": nombre_elegido,
		"dir": "SOUTH"
	}
	# Guardar json en la primera línea del archivo.
	save_game.store_line(to_json(node_data))
	# Cerrar archivo.
	save_game.close()
	# Guardar los datos en helpers.
	helpers.guardar_datos(node_data)

func guardar(datos):
	var save_game = File.new()
	# Abrimos para reescribir el archivo de guardado.
	save_game.open("./save.save", File.WRITE)
	# Se escriben los datos en la primera línea.
	save_game.store_line(to_json(datos))
	# Se cierra el archivo.
	save_game.close()
	# Se muestra en consola los datos guardados.
	print("Guardado: ", datos)

func cargar(recop=false):
	var save_game = File.new()
	# Si el archivo de guardado no existe.
	if not save_game.file_exists("./save.save"):
		# Avisarle a la consola.
		print("No hay archivo de guardado")
		return true
	# Si se viene a recopilar información no hace más nada.
	# La recopilacón de información viene al inicio del juego.
	# Para hacer disabled al botón de Cargar partida.
	# Si recibe true le hace disabled.
	# Si llega hasta aquí será false, y lo mostrará activo.
	if recop:return false
	# Abrimos el archivo en solo lectura.
	save_game.open("./save.save", File.READ)
	# Almacenamos los datos en la primera linea.
	var current_line = parse_json(save_game.get_line())
	# Guardamos los datos en el helpers.
	helpers.guardar_datos(current_line)
	# Se cierra el archivo.
	save_game.close()

static func tipo_emoji(dir):
	# Se entrega el tipo de emoji según la dirección.
	# Por defecto lover, en caso de que no haya ninguna dir (imposible pero soy a prueba de tontos xd)
	var send = "lover"
	if dir == "SOUTH":
		send = "lover"
	elif dir == "NORTH":
		send = "lll"
	elif dir == "EAST":
		send = "angry"
	elif dir == "WEST":
		send = "calor"
	# Se regresa el nombre del emoji, utilizado en la función emoji()
	return send

# Se almacena la decisión del fullscreen en el checkbox de inicio.
func fullscreen(booleano):
	b_fullscreen = booleano