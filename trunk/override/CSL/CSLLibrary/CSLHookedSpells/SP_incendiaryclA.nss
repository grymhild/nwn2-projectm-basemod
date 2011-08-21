//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Person within the AoE take 4d6 fire damage
	per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: March 2003: Removed movement speed penalty

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_incendiarycl(); //SPELL_INCENDIARY_CLOUD;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_INCENDIARY_CLOUD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION|SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//Declare major variables
	int iDamage;
	effect eDam;
	object oTarget;
	//Declare and assign personal impact visual effect.
	
	
	//FIRE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	//int iDamageType = HkGetDamageType( DAMAGE_TYPE_NONE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	



	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	float fDelay;
	//Capture the first target object in the shape.
	oTarget = GetEnteringObject();
	//Declare the spell shape, size and the location.
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INCENDIARY_CLOUD, TRUE));
			//Make SR check, and appropriate saving throw(s).
		// if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
		//  {
				fDelay = CSLRandomBetweenFloat(0.5, 2.0);
				//Roll damage.
				iDamage = HkApplyMetamagicVariableMods(d6(4), 6 * 4);
				
				//Adjust damage for Reflex Save, Evasion and Improved Evasion
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, GetAreaOfEffectCreator());
				// Apply effects to the currently selected target.
				eDam = EffectDamage(iDamage, DAMAGE_TYPE_FIRE);
				if(iDamage > 0)
				{
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
		// }
	}
}