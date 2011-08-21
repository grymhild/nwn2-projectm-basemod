//::///////////////////////////////////////////////
//:: Acid Fog: Heartbeat
//:: NW_S0_AcidFogC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All creatures within the AoE take 2d6 acid damage
	per round and upon entering if they fail a Fort Save
	their movement is halved.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_SP_acidfog(); //SPELL_ACID_FOG;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_ACID, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//int nIgnoreSR = FALSE;
    //if ( iSpellId == 745 )
    //{
    //    nIgnoreSR = TRUE;
    //}
    	//ACID
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ACID );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ACID );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ACID );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

	object oTarget = GetFirstInPersistentObject(OBJECT_SELF);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			if (!CSLGetIsImmuneToClouds(oTarget) )
			{
				int iDamage = HkApplyMetamagicVariableMods(d6(2), 12);
				effect eDam = EffectDamage(iDamage, iDamageType);
				eDam = EffectLinkEffects(eDam, EffectVisualEffect(iHitEffect));
				
				SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ACID_FOG, TRUE ));
				float fDelay = CSLRandomBetweenFloat(0.4, 1.2);
				//if( nIgnoreSR || !HkResistSpell(oCaster, oTarget, fDelay))
				//{
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				//}
			}
		}
		oTarget = GetNextInPersistentObject(OBJECT_SELF);
	}
}