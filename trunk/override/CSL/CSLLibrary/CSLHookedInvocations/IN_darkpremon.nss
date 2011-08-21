//:://///////////////////////////////////////////////
//:: Warlock Dark Invocation: Dark Foresight
//:: nw_s0_idarkfors.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 12/08/05
//::////////////////////////////////////////////////
/*
		Dark Foresight  Complete Arcane, pg. 133
		Spell Level: 9
		Class:        Misc

		This is identical to the premonition spell (8th level wizard).

		Gives the gives the creature touched 30/+5
		damage reduction.  This lasts for 1 hour per
		caster level or until 10 * Caster Level
		is dealt to the person.


		[Rules Note] This is supposed to use the foresight spell,
		which doesn't exist in NWN2. So it is mapped to an excellent spell
		with the same sort of theme. High level wizards tend to have this
		spell up all the time, any way, so it shouldn't unbalance the game.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"




void main()
{
	//scSpellMetaData = SCMeta_IN_darkforesigh();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster, 30, CLASS_TYPE_WARLOCK ); // OldGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30, CLASS_TYPE_WARLOCK );
	float fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS);
	
	int nLimit = iSpellPower * 10;
	int nReduce = 10;
	if (iSpellPower>=15) nReduce += 5;
	if (iSpellPower>=20) nReduce += 5;
	if (iSpellPower>=25) nReduce += 5;
	if (iSpellPower>=30) nReduce += 5;
	
	CSLUnstackSpellEffects(oCaster, iSpellId );
	//CSLUnstackSpellEffects(oCaster, SPELL_PREMONITION, "Premonition");
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	eLink = EffectLinkEffects(eLink, EffectDamageReduction(nReduce, GMATERIAL_METAL_ALCHEMICAL_SILVER, nLimit, DR_TYPE_GMATERIAL));
	SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration );
	
	HkPostCast(oCaster);
}

