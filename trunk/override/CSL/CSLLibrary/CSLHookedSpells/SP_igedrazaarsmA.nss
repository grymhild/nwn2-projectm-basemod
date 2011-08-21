//::///////////////////////////////////////////////
//:: Igedrazaar's Miasma (A) - On Enter
//:: sg_s0_igmiasmaA.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Spell Description
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 3, 2004
//:://////////////////////////////////////////////


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	//float 	fDuration; 		//= HkGetSpellDuration(iCasterLevel);
		

	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	int 	iDieType 		= 4;
	int 	iNumDice 		= iCasterLevel;
	int 	iBonus 		= 0;
	int 	iDamage 		= 0;

	if(iNumDice>5) iNumDice=5;
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	//if(SGCheckMetamagic(iMetamagic,METAMAGIC_EXTEND)) fDuration *= 2;
	iDamage = HkApplyMetamagicVariableMods(CSLDieX( iDieType, iNumDice), iDieType * iNumDice)+iBonus;

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eDamage = EffectDamage(iDamage);
	effect eImpVis = EffectVisualEffect(VFX_COM_HIT_FROST);
	effect eLink 	= EffectLinkEffects(eDamage, eImpVis);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if ( !CSLGetIsImmuneToClouds(oTarget) )
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_IGEDRAZAARS_MIASMA));
		if(!HkResistSpell(oCaster, oTarget))
		{
			if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC))
				{
					DelayCommand(2.0f,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
				}
			}
		}
	}
}
