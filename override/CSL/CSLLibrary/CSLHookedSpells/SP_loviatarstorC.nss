//::///////////////////////////////////////////////
//:: Loviatar's Torments (b) - heartbeat
//:: sg_s0_lovtormb.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Originally used only by priests of Loviatar,
	this spell has been seen being used by priests
	of other evil gods.

	School: Evocation [Evil]
	Level: Clr 3, Evil 3
	Target: One creature
	Duration: 1 rnd/lvl
	Save: Fortitude negates
	SR: Yes

	Causes d6 dmg per round (max 10 rounds without
	metamagic). Also applies a -2 morale penalty
	to attacks, saves, and skill checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 25, 2003
//:://////////////////////////////////////////////
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
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	object oTarget 		= HkGetAOEOwner();
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();



	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	int iDieType = 6;
	int iNumDice = 1;
	int iBonus = 0;
	int iDamage = 0;

	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	iDamage = HkApplyMetamagicVariableMods(CSLDieX( iDieType, iNumDice), iDieType * iNumDice)+iBonus;

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eDamage = EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
	effect eImp 	= EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
	effect eLink 	= EffectLinkEffects(eDamage,eImp);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if(!GetIsObjectValid(oTarget)) {
		DestroyObject(OBJECT_SELF);
	} else {
		SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_LOV_TORMENTS));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
	}
}