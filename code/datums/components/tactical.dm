/datum/component/tactical
	var/allowed_slot

/datum/component/tactical/Initialize(allowed_slot)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.allowed_slot = allowed_slot

/datum/component/tactical/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, .proc/modify)
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, .proc/unmodify)

/datum/component/tactical/UnregisterFromParent()
	unmodify()

/datum/component/fantasy/Destroy()
	unmodify()
	return ..()

/datum/component/tactical/proc/modify(obj/item/source, mob/user, slot)
	if(allowed_slot && slot != allowed_slot)
		unmodify()
		return

	var/obj/item/master = parent
	var/image/I = image(icon = master.icon, icon_state = master.icon_state, loc = user)
	I.copy_overlays(master)
	I.override = TRUE
	source.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/everyone, "sneaking_mission", I)
	I.layer = ABOVE_MOB_LAYER

/datum/component/tactical/proc/unmodify(obj/item/source, mob/user)
	user.remove_alt_appearance("sneaking_mission")