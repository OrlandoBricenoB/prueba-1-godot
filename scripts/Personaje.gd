extends KinematicBody2D

# Velocidad para moverse
export (int) var SPEED = 140
# Dirección
var dir = "SOUTH"
# Ubicación de teleport
var teleport
# ¿Puede teletransportarse?
var can_teleport = false
# Nombre del usuario
var nombre
# Estado de vuelo, false por defecto.
var volando = false
# Movimiento del personaje
var velocidad = Vector2()

func _init():
	# ¿Seleccionó el fullscreen? Activarlo.
	if helpers.b_fullscreen:
		OS.set_window_fullscreen(true)

func _ready():
	# Hacer invisible el personaje. La animación de inicio le devuelve el valor original.
	$spr.modulate.a = 0
	# Función de creación del personaje.
	create()
	set_physics_process(true)

func create():
	# Obteniendo datos .save
	var datos = helpers.obtener_datos()
	# Asignando nombre cargado.
	nombre = datos.nombre
	# Colocando la dirección cargada.
	dir = datos.dir
	# Moviendo a la localización cargada.
	position = Vector2(datos.pos_x, datos.pos_y)
	# Cambiando el texto nombre del HUD.
	get_parent().get_node("HUD/CL/Name").text = nombre

func _input(event):
	# Crear emojis. Según la dirección del personaje
	if event.is_action_pressed("emoji"):
		# Revisar qué tipo de emoji asignar.
		emoji(helpers.tipo_emoji(dir))
	# Disparo.
	elif event.is_action_pressed("disparo"):
		disparar("kunai")
		get_parent().get_node("Dash").play()
	# Explosión.
	elif event.is_action_pressed("explosion"):
		explotar()
	# LevelUp
	elif event.is_action_pressed("ui_select"):
		# Sonido de LevelUP, lo usaré en la Prueba #2
		get_parent().get_node("LevelUp").play()
	# Reset Game
	elif event.is_action_pressed("reiniciar"):
		print(get_tree().reload_current_scene())
	# Clic
	elif event.is_action_pressed("clic"):
		# Almacenando la ubicación del mouse.
		var target = get_global_mouse_position()
		# Doble Clic
		if event.doubleclick:
			# Teletransportarse a la ubicación del mouse.
			teletransportar(target)
	elif event.is_action_pressed("guardar"):
		var data_send = {}
		# Enviamos el nombre.
		data_send.nombre = nombre
		# Creamos una nueva posición en base a 32.
		var new_position = base32(position)
		# Enviamos las nuevas coordenadas en base a 32.
		data_send.pos_x = new_position.x
		data_send.pos_y = new_position.y
		# Enviamos la dirección.
		data_send.dir = dir
		# Llamamos la función de guardado y enviamos datos.
		helpers.guardar(data_send)
		# Mensajito de guardado.
		get_parent().get_node("HUD/CL/Guardado/anim").play("in")
	# Animación de vuelo.
	elif event.is_action_pressed("volar"):
		if volando:
			# Detener animación
			animar("stop")
			# Flag volando.
			volando = false
			# Dirección del personaje
			direccion()
			# Volviendo velocidad a la normal.
			SPEED = 140
			# Cancelar ejecución de lo de abajo.
			return false
		# Animación de vuelo stand.
		animar("fly_"+dir.to_lower())
		# Flag volando.
		volando = true
		# Aumento de la velocidad de movimiento.
		SPEED = 300

func emoji(name):
	# Instanciar la escena del emoji y ubicarlo en el emoji_pos
	var emoji_node = load("res://escenas/Emoji.tscn").instance()
	var emoji = load("res://assets/emoji/"+name+".png")
	# Cambiar la imagen del sprite.
	emoji_node.get_node("spr").set_texture(emoji)
	add_child(emoji_node)

func caminar():
	# Si presiona la tecla de vuelo, no hacer nada.
	# Esto evita problemas porque se vuela con el SHIFT (16777237) y la flecha de arriba.
	if Input.is_key_pressed(16777237):return false
	# Si está teletransportandose, no hacer nada.
	if !can():return false
	velocidad = Vector2()
	if Input.is_action_pressed("ui_right"):
		dir = "EAST"
		velocidad.x += 1
		velocidad.y = 0
	if Input.is_action_pressed("ui_left"):
		dir = "WEST"
		velocidad.x -= 1
		velocidad.y = 0
	if Input.is_action_pressed("ui_up"):
		dir = "NORTH"
		velocidad.y -= 1
		velocidad.x = 0
	if Input.is_action_pressed("ui_down"):
		dir = "SOUTH"
		velocidad.y += 1
		velocidad.x = 0
	if velocidad.x != 0 or velocidad.y != 0:
		if volando:
			is_in_anim("volando")
		else:
			is_in_anim("walk")
	# Asignar velocidad final.
	velocidad = velocidad.normalized()*SPEED

func _physics_process(delta):
	# Ejecutar el caminar.
	caminar()
	# Si no se está presionando ninguna tecla y can() es true.
	if velocidad.x == 0 and velocidad.y == 0 and can():
		# Si no está volando
		if !volando:
			# Y hay una animación en play.
			if $anim.is_playing():
				# Detener animación.
				animar("stop")
		# Asignar dirección, esto para si vuela o no vuela.
		direccion()
	else:
		# Si tiene un botón de movimiento presionado, mover.
		velocidad = move_and_slide(velocidad)

func can():
	# Si no puede teletransportarse es porque lo está haciendo.
	if !can_teleport:return false
	# Si puede.
	return true

func base32(vector):
	# Convertirmos el Vector2 recibido como vector.
	# En base a 32, esto para obtener coordenadas en base a tiles.
	vector.x = floor(vector.x/32)*32
	vector.y = floor(vector.y/32)*32
	return vector

func direccion(type=true):
	# Para cuando regresa de la teletransportación.
	if $anim.is_playing() && !type:
		# Si se está ejecutando una animación, no hacer nada.
		return false

	# Comprobamos si está volando
	if volando and can():
		# Ejecutar animación de vuelo estático.
		# Si la animación no es de vuelo, ejecutarla.
		if is_in_anim("fly"):
			return false
	elif dir == "SOUTH":
		# Sprite mirando hacia abajo
		$spr.set_region_rect(Rect2(Vector2(0,0), Vector2(32,32)))
	elif dir == "NORTH":
		# Sprite mirando hacia arriba
		$spr.set_region_rect(Rect2(Vector2(32,0), Vector2(32,32)))
	elif dir == "EAST":
		# Sprite mirando hacia la derecha
		$spr.set_region_rect(Rect2(Vector2(64,0), Vector2(32,32))) 
	elif dir == "WEST":
		# Sprite mirando hacia la izquierda
		$spr.set_region_rect(Rect2(Vector2(96,0), Vector2(32,32)))
		# Se quita el flip horizontal porque la única animación que no necesita flip es la de caminar.
		$spr.flip_h = false

# Esta función comprueba si una animación está siendo
# ejecutada y comprueba si la dirección de la animación es correcta.
func is_in_anim(anim):
	# Variable init para saber si ejecutar o no la animación.
	var init = false
	# ¿Tiene la animación actual el mismo nombre que se quiere revisar?
	if $anim.current_animation.find(anim) > -1:
		# Tiene la animación deseada
		if $anim.current_animation.find(dir.to_lower()) > -1:
			# Tiene la misma dir.
			return true
		else:
			# No tiene la misma dirección.
			init = true
	else:
		# No tiene la animación deseada.
		init = true
	# Si init es true, iniciar la animación en la dirección del personaje
	if init:
		animar(anim+"_"+dir.to_lower())

func animar(name):
	# Si la animación enviada es "stop"
	if name == "stop":
		# Detener animación.
		$anim.stop()
		return false
	# Si se está reproduciendo una animación.
	if $anim.is_playing():
		# Detenerla
		$anim.stop()
	# Y reproducir la siguiente.
	$anim.play(name)
	return true

func disparar(tipo):
	var proyectil_node = load("res://escenas/"+tipo+".tscn").instance()
	get_parent().add_child(proyectil_node)
	# Se asigna la dirección del personaje al proyectil.
	proyectil_node.direccion(dir)
	# La posición del personaje será la misma del personaje.
	proyectil_node.position = position
	# Según la dirección colocar 1 tile de separación del personaje.
	if dir == "SOUTH":
		proyectil_node.position.y+=32
	elif dir == "NORTH":
		proyectil_node.position.y-=32
	elif dir == "EAST":
		proyectil_node.position.x+=32
	elif dir == "WEST":
		proyectil_node.position.x-=32

func explotar():
	var exp_node = load("res://escenas/explosion.tscn").instance()
	add_child(exp_node)
	# Inicia el timer Explotar.
	$Explotar.start()

func teletransportar(loc):
	if !can():return false
	# Asignar localización en base a 32 (tiles)
	loc.x = floor(loc.x/32)*32
	loc.y = floor(loc.y/32)*32
	# Asignar la localización recibida al teleport var.
	teleport = loc
	# No permitir transportarse
	can_teleport = false
	# Animación de teletransportación.
	animar("it_"+dir.to_lower())
	# Sonido de teletransportación.
	get_parent().get_node("It").play()

func _on_anim_animation_finished(anim_name):
	# Si la animación finalizada es la de it normal.
	# Resulta que la animación it_return también contiene it_ así que cuando regresaba también
	# Se ejecutaba en este primer if, solo coloqué and no sea la de regreso.
	if anim_name.find("it_") > -1 and anim_name.find("it_return_") == -1:
		# Ajustar posición a la variable teleport.
		position = teleport
		# Animación de teletransportación de regreso.
		animar("it_return_"+dir.to_lower())
	# Si es la de it de regreso.
	elif anim_name.find("it_return_") > -1:
		# Permitir que se vuelva a teletransportar.
		can_teleport = true
		# Hacemos que tome el sprite de la dirección deseada,
		# enviamos el parámetro 1 para que compruebe si está
		# ejecutando una animación, no hacer nada.
		# se supone que si está ejecutando esto es porque
		# ya terminó la animación de it_return pero yo soy
		# MUY a prueba de tontos.
		direccion(1)

func _on_start_timeout():
	# Se cumple el tiempo para aparecer personaje
	# Se devuelve la transparencia al sprite.
	$spr.modulate.a = 255
	# Inicia la animación de teletransportación de regreso.
	animar("it_return_"+dir.to_lower())
	# Ejecuta sonido de It.
	get_parent().get_node("It").play()

func _on_Explotar_timeout():
	# Al acabar el timer Explotar, ejecutar sonido de explosión.
	# Pude hacer este timer y agregar el nodo sonido en la escena
	# de Explosión, pero me dió flojera y basicamente creé un 
	# pequeño código spaguetti al escribir este mismo código en
	# Personaje.gd y proyectil.gd
	get_parent().get_node("Explode").play()