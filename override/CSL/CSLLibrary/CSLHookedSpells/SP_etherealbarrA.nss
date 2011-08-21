//::///////////////////////////////////////////////
//:: Ethereal Barrier (OnEnter)
//:: sg_s0_etherbarA.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Abjuration
	Level: Clr 2
	Components: V, S
	Casting Time: 1 action
	Range: Medium
	Area: 10 meter wide x 2 meter thick wall
	Duration: 1 turn/level
	Saving Throw: None
	Spell Resistance: Yes

	The Ethereal Barrier is a defense against the
	passage of extradimensional creatures, including
	characters or monsters, that are phased or ethereal.
	The cleric creates an imperceptible barrier 10 meters
	wide and 2 meters thick. Note that some monsters
	may be capable of abandoning their ethereal approach
	and simply entered the barred area on their own feet -
	the ethereal barrier only bars their passage as long as
	they are traveling in the Border Ethereal.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: September 30, 2004
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
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//location lTarget 		= CSLGetBehindLocation(oTarget, SC_DISTANCE_TINY);
	//int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();

	//--------------------------------------------------------------------------
	// Effects // CSL_ENVIRO_ANCHORED
	//--------------------------------------------------------------------------
	effect eImpVis = EffectVisualEffect(VFX_COM_HIT_FROST);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if( CSLGetIsIncorporeal( oTarget ) || (CSLGetHasEffectType( oTarget, EFFECT_TYPE_SANCTUARY ) &&
		!GetHasSpellEffect( SPELL_SANCTUARY, oTarget ))  ) {

		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ETHEREAL_BARRIER, FALSE));
		if(!HkResistSpell(oCaster, oTarget))
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
			AssignCommand(oTarget,ClearAllActions());
			AssignCommand(oTarget, SetFacingPoint( GetPosition(OBJECT_SELF))); // fix the walking sideways issue
			DelayCommand(0.5f,AssignCommand(oTarget, JumpToLocation( CSLGetBehindLocation(oTarget, SC_DISTANCE_TINY) )));
			FloatingTextStringOnCreature("** Some type of barrier is impeding your travels. **", oTarget, FALSE);
		}
	}
}