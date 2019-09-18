extends Label

func _ready():
	set_process(true)

# Llevar siempre el emoji en la posición del personaje.
func _process(delta):
	# Si el padre es el Personaje
	if get_parent().get_name() == "Personaje":
		# Asignar posición en la del emoji_pos del padre.
		rect_position = get_parent().get_node("emoji_pos").rect_position

# Al pasar 5 segundos, desaparecer emoji.
func _on_Timer_timeout():
	$AnimationPlayer.play("fadeOut")

# Eliminar el nodo del emoji instanciado.
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fadeOut":
		queue_free()
