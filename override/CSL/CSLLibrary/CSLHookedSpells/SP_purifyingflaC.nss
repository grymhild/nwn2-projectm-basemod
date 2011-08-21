//::///////////////////////////////////////////////
//:: Purifying Flames (b) - Heartbeat
//:: SG_S0_PurifyFlB.nss
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
//#include "sg_i0_spconst"
//#include "sg_inc_elements"
//#include "sg_inc_spinfo"
//#include "sg_inc_wrappers"
//#include "sg_inc_utils"
//#include "x2_i0_spells"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	object oTarget 		= HkGetAOEOwner();
	location lTarget 		= GetLocation(oTarget);
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	//float 	fDuration 		= HkGetSpellDuration(iCasterLevel, SC_DURCATEGORY_ROUNDS );
	
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
	
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	iDamage = HkApplyMetamagicVariableMods(CSLDieX( iDieType, iNumDice), iDieType * iNumDice)+iBonus;

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eImp 	= EffectVisualEffect(iHitEffect);
	effect eProxImp = EffectVisualEffect(iProxVisualType);
	effect eDam;
	effect eLink;

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_PURIFY_FLAMES));
	//if(HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, iSaveType))
	//{
	//	iDamage /= 2;
	//}
	iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, iSaveType, oCaster );
				
	eDam=EffectDamage(iDamage,iDamageType);
	eLink=EffectLinkEffects(eImp,eDam);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
	lTarget=GetLocation(oTarget);

	oTarget=GetFirstObjectInShape(SHAPE_SPHERE,FeetToMeters(5.0),lTarget, TRUE);
	while(GetIsObjectValid(oTarget))
	{
		iProxDmg = HkApplyMetamagicVariableMods(CSLDieX( iDieType, 1), iDieType * 1)+iBonus;
		eDam=EffectDamage(iProxDmg,iDamageType);
		eLink=EffectLinkEffects(eDam,eProxImp);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
		oTarget=GetNextObjectInShape(SHAPE_SPHERE,FeetToMeters(5.0),lTarget, TRUE);
	}
}
