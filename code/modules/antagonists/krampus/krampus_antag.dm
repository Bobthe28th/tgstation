/datum/antagonist/krampus
	name = "\improper Krampus"
	show_in_antagpanel = TRUE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	job_rank = ROLE_TRAITOR

/datum/antagonist/krampus/proc/forge_objectives()
	var/datum/objective/kill_naughty/kill = new()
	objectives += kill

/datum/objective/kill_naughty
	explanation_text = "Kill and eat all those who are naughty."

/datum/antagonist/krampus/greet()
	. = ..()
	var/mob/living/old_body = owner.current
	var/k = new /mob/living/simple_animal/hostile/megafauna/krampus(owner.current.loc)
	owner.current.mind.transfer_to(k)
	owner.announce_objectives()
	if (old_body)
		old_body.gib()

/datum/antagonist/krampus/on_gain()
	forge_objectives()
	. = ..()
