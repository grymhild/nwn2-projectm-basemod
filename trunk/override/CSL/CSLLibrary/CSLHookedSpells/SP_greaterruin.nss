//::///////////////////////////////////////////////
//:: Greater Ruin
//:: X2_S2_Ruin
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
// The caster deals 35d6 damage to a single target
	fort save for half damage
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 18, 2002
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_greaterruin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_RUIN;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	// End of Spell Cast Hook

	//Declare major variables
	object oTarget = HkGetSpellTarget();


	float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
	float fDelay = fDist/(3.0 * log(fDist) + 2.0);

	//int nSpellDC = SCGetEpicSpellSaveDC(OBJECT_SELF);
	int nSpellDC = HkGetSpellSaveDC(oCaster, oTarget);
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
	//Roll damage
	int nDam = d6(35);
	//Set damage effect

	if ( HkSavingThrow(SAVING_THROW_FORT,oTarget,nSpellDC,SAVING_THROW_TYPE_SPELL,OBJECT_SELF)  )
	{
			nDam /=2;
	}

	effect eDam = EffectDamage(nDam, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_PLUS_TWENTY);
	HkApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), GetLocation(oTarget));
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(487), oTarget);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oTarget);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM), oTarget);
	DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	
	HkPostCast(oCaster);
}

