//::///////////////////////////////////////////////
//:: Electric Jolt
//:: SOZ UPDATE BTM
//:: [x0_s0_ElecJolt.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
1d3 points of electrical damage to one target.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_ELECTRIC_JOLT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ELECTRICAL, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
    object oTarget = HkGetSpellTarget();
    int iCasterLevel = GetCasterLevel(OBJECT_SELF);

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
	int iShapeEffect = HkGetShapeEffect( VFX_IMP_LIGHTNING_S, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
    effect eVis = EffectVisualEffect(iShapeEffect);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt( OBJECT_SELF, iSpellId ));
        //Make SR Check
        if(!HkResistSpell(OBJECT_SELF, oTarget))
        {
            //Set damage effect
            effect eBad = HkEffectDamage( HkApplyMetamagicVariableMods(d3(),3), iDamageType);
            //Apply the VFX impact and damage effect
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBad, oTarget);
        }
    }
    
    HkPostCast(oCaster);
}