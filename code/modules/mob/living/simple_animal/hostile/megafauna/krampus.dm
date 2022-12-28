/mob/living/simple_animal/hostile/megafauna/krampus
	name = "Krampus"
	desc = "A mythological man-eating legendary creature, you probably aren't going to survive this."
	health = 400
	maxHealth = 400
	icon_state = "krampus"
	icon_living = "krampus"
	icon_dead = "wendigo_dead"
	icon = 'icons/mob/simple/icemoon/64x64megafauna.dmi'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/magic/demon_attack1.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	weather_immunities = list(TRAIT_SNOWSTORM_IMMUNE)
	speak_emote = list("roars")
	armour_penetration = 40
	melee_damage_lower = 40
	melee_damage_upper = 40
	vision_range = 9
	speed = 1
	move_to_delay = 6
	ranged = FALSE
	pixel_x = -16
	base_pixel_x = -16
	maptext_height = 64
	maptext_width = 64
	mob_size = MOB_SIZE_LARGE
	robust_searching = FALSE
	move_resist = MOVE_RESIST_DEFAULT
	small_sprite_type = /datum/action/small_sprite/megafauna/bubblegum
	death_message = "falls, shaking the ground around it"
	death_sound = 'sound/effects/gravhit.ogg'

	var/datum/action/cooldown/mob_cooldown/projectile_attack/shotgun_blast/krampus/shotgun_blast


/mob/living/simple_animal/hostile/megafauna/krampus/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
	add_filter("scary_outline",9,list("type"="outline","color"="#FF0000"))
	AddElement(/datum/element/content_barfer)
	shotgun_blast = new /datum/action/cooldown/mob_cooldown/projectile_attack/shotgun_blast/krampus()
	shotgun_blast.Grant(src)

/mob/living/simple_animal/hostile/megafauna/krampus/Destroy()
	QDEL_NULL(shotgun_blast)
	return ..()

/obj/projectile/krampus/coal
	name = "coal"
	icon = 'icons/obj/ore.dmi'
	icon_state = "slag"
	damage = 10
	armour_penetration = 50
	speed = 2
	eyeblur = 0
	damage_type = BRUTE
	pass_flags = PASSTABLE
	plane = GAME_PLANE

/obj/projectile/krampus/coal/can_hit_target(atom/target, direct_target = FALSE, ignore_loc = FALSE, cross_failed = FALSE)
	if(isliving(target))
		direct_target = TRUE
	return ..(target, direct_target, ignore_loc, cross_failed)

/mob/living/simple_animal/hostile/megafauna/krampus/devour(mob/living/victim)
	// if(victim && victim.loc != src)
	// 	if(!is_station_level(z) || client) //NPC monsters won't heal while on station
	// 		adjustBruteLoss(-victim.maxHealth/2)
	// 	playsound(src, SFX_RUSTLE, 200, TRUE)
	// 	visible_message(span_warning("[src] puts [victim] in his magic bag!"))
	// 	victim.forceMove(src)
	// 	return TRUE
	return FALSE

/mob/living/simple_animal/hostile/megafauna/krampus/AttackingTarget()
	if(target == src)
		to_chat(src, span_warning("You almost claw yourself, but then decide against it."))
		return
	if(isliving(target)) //Swallows corpses like a snake to regain health.
		var/mob/living/L = target
		if(L.stat == DEAD)
			to_chat(src, span_warning("You begin to put [L] into your magic bag..."))
			if(do_after(src, 30, target = L))
				playsound(src, 'sound/magic/demon_attack1.ogg', 100, TRUE)
				playsound(src, SFX_RUSTLE, 100, TRUE)
				visible_message(span_warning("[src] puts [L] in his magic bag!"))
				L.forceMove(src)
				adjustHealth(-L.maxHealth * 0.5)
			return
	. = ..()

/obj/projectile/krampus/coal/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		new /obj/item/stack/sheet/mineral/coal(target.loc, 1)
