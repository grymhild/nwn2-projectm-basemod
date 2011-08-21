//::///////////////////////////////////////////////
//:: Purifying Flames
//:: SG_S0_PurifyFl.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	The target of this spell bursts into flames.
	Each round it takes 3d6 dmg, fort save for half
	each round. Creatures within 5 ft take 1d6 dmg,
	no save.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 17, 2003
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
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//location lTarget 		= GetLocation(oTarget);
	//int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	//int iShapeEffect = HkGetShapeEffect( VFX_NONE, SC_SHAPE_NONE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iProxVisualType = HkGetHitEffect(VFX_COM_HIT_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );

	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	int 	iDieType 		= 6;
	int 	iNumDice 		= 3;
	int 	iBonus 		= 0;
	int 	iDamage 		= 0;

	int 	iProxDmg;
	//int 	iVisualType 	= HkGetHitEffect(VFX_IMP_FLAME_M, iDamageType);
	//int 	iBeamType 		= SGGetElementalBeamType(iDamageType);
	
	//int 	iSaveType 		= HkGetSaveType(iDamageType);
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	//if(SGCheckMetamagic(iMetamagic,METAMAGIC_EXTEND)) fDuration *= 2;
	//iDamage = SGMaximizeOrEmpower(iDieType,iNumDice,iMetamagic,iBonus);
	iDamage = HkApplyMetamagicVariableMods(CSLDieX( iDieType, 1), iDieType * 1)+iBonus;

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	//effect eBeam 	= EffectBeam(iBeamType, oCaster, BODY_NODE_HAND);
	//effect eImp 	= EffectVisualEffect(iVisualType);
	effect eProxImp = EffectVisualEffect(iProxVisualType);
	//effect eAOE 	= EffectAreaOfEffect(AOE_MOB_PURIFY_FLAMES);
	effect eDam;
	effect eLink;

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_PURIFY_FLAMES));
	if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		eDam = EffectDamage(iProxDmg,iDamageType);
		eLink = EffectLinkEffects(eDam,eProxImp);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
	}
}
