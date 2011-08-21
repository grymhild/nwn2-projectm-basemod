/** @file spell_planepock.nss Casts the spell Planar Pocket.
 * @ingroup CustomSpells
 * This spell will create a portal that leads to a small, safe place in an extraplanar dimension.
 *
 * It is dangerous to attempt to create another planar pocket while already within one. In addition, carrying
 * extradimensional space into a planar pocket can be hazardous.
 *
 * Generally only those of the caster's choosing can pass through a portal (i.e. party members).
 * It is safe to rest and recover within a planar pocket. However, certain more powerful entities
 * may have the ability to force their way into the planar pocket as well.
 *
 * When the spell expires, if the outside portal is closed by the caster, or if the portal is successfully
 * dispelled from the outside, the occupants of the planar pocket are immediately ejected.
 *
 * There is a slight chance that the Pocket will be occupied upon arrival.   Lasts for
 * one hour per caster level.
 */

 // spell_planepock
// Script for the spell Pocket Plane
// Copyright(C) 2006 dragonwell.org, Grinning Fool (Marc A. Paradise)
// All rights reserved.
/*
Caster Level(s): Wiz/Sorc 3
Innate Level: 3
School: Transmutation
Component(s): Verbal, Somatic
Range: Medium
Area of Effect / Target: Special
Duration: 1 hour/level
Additional Counter Spells: None
Save: None
Spell Resistance:None

*/
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_planar_pock"


void main()
{
    if (!X2PreSpellCastCode())
        return;
    LogObjectMessage(OBJECT_SELF, "spell_mordhome: begin post-spellhook.");
//    planpock_create(OBJECT_SELF, HkGetSpellTargetLocation(), HoursToSeconds(GetCasterLevel(OBJECT_SELF)));
    planpock_create(OBJECT_SELF, HkGetSpellTargetLocation(), RoundsToSeconds(GetCasterLevel(OBJECT_SELF)));

 /// @todo chance of occupation upon arrival
 /// @todo need to modify rest system so if PC rests for "8" hours... we check against
 ///       the portla lifespan.
 ///
}
