//::///////////////////////////////////////////////
//:: Grease: On Enter
//:: NW_S0_GreaseA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creatures entering the zone of grease must make
	a reflex save or fall down.  Those that make
	their save have their movement reduced by 1/2.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_grease(); //SPELL_GREASE;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_GREASE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oCaster = GetAreaOfEffectCreator();
	object oTarget = GetEnteringObject();
	float fDelay = CSLRandomBetweenFloat(1.0, 2.2);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		if ( !CSLGetIsIncorporeal( oTarget ) )
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_GREASE, TRUE ));
			effect eLink = EffectVisualEffect(VFX_IMP_SLOW);
			eLink = EffectLinkEffects(eLink, EffectMovementSpeedDecrease(50));
			eLink = SetEffectSpellId(eLink, SPELL_GREASE);
			effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
		//SendMessageToPC( oTarget , "Adding Grease");
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
			if ( CSLGetIsFireBased( oTarget ) )
			{
				ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_FIRE), GetLocation(oTarget) );
			}
		}
	}
	else if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE )
    {
    	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_GREASE, TRUE ));
    }
}