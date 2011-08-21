//::///////////////////////////////////////////////
//:: Horizikaul's Boom
//:: SOZ UPDATE BTM
//:: X2_S0_HoriBoom
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You blast the target with loud and high-pitched
// sounds. The target takes 1d4 points of sonic
// damage per two caster levels (maximum 5d4) and
// must make a Will save or be deafened for 1d4
// rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 22, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_HORIZIKAULS_BOOM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = HkGetSpellTarget();
    // int iCasterLevel = HkGetSpellPower( oCaster, 10 )/2;
    
    int iSpellPower = CSLGetMax(1,HkGetSpellPower( oCaster, 10 ) / 2 );
    
    int nRounds = d4(1);
    
	//SONIC
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC );
	int iImpactEffect = HkGetShapeEffect( VFX_IMP_SONIC, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_SONIC );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
    effect eVis = EffectVisualEffect( iImpactEffect );
    effect eDeaf = EffectDeaf();
    //Minimum caster level of 1, maximum of 15.

    if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        if(!HkResistSpell(OBJECT_SELF, oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId ));
            //Roll damage
            
            int iDamage = HkApplyMetamagicVariableMods(d4(iSpellPower), 4 * iSpellPower);

            //Set damage effect
            effect eDamage = HkEffectDamage(iDamage, iDamageType );
            
            //Apply the MIRV and damage effect
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
            {
                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(nRounds));
            }
        }
    }
    
    HkPostCast(oCaster);
}