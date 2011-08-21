//::///////////////////////////////////////////////
//:: Lesser Aura of Cold - OnHeartbeat
//:: cmi_s0_lauracoldc
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
//:://////////////////////////////////////////////
//:: Lesser Aura of Cold
//:: Caster Level(s): Cleric 3, Druid 3, Paladin 4, Ranger 4
//:: Innate Level: 3
//:: School: Transmutation
//:: Descriptor(s): Cold
//:: Component(s): Verbal, Somatic
//:: Range: Personal
//:: Area of Effect / Target: 5-ft.-radius sphere centered on you
//:: Duration: 1 round/level
//:: You are covered in a thin layer of white frost and frigid cold emanates
//:: from your body, dealing 1d6 points of cold damage at the start of your
//:: round to each creature within 5 feet.
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_LESSER_AURA_COLD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_COLD, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------		

	
	object oTarget;
	object oCreator = GetAreaOfEffectCreator();
	int nDamValue;
	effect eColdDamage;
	effect eColdHit = EffectVisualEffect(VFX_COM_HIT_FROST);

	//Find our first target
	oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);

	//This loop validates target, makes it save, burns it, then finds the next target and repeats
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCreator) && (oTarget != oCreator) )
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE));

			if (!HkResistSpell(oCreator, oTarget))
			{
				//Determine damage
				nDamValue =	HkApplyMetamagicVariableMods(d6(), 6);

				eColdDamage	= EffectDamage(nDamValue, DAMAGE_TYPE_COLD);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eColdDamage, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eColdHit, oTarget);
			}
		}
		oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
	}
}

