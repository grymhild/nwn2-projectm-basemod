//::///////////////////////////////////////////////
//:: Umbral Shroud
//:: cmi_s2_umbralshroud
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: December 23, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 
#include "_SCInclude_Class"
#include "_SCInclude_Reserve"


void main()
{	
	//scSpellMetaData = SCMeta_FT_umbralshroud();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int nDarkLevel = 0;
	nDarkLevel = GetDarkReserveLevel();
		 
	if (nDarkLevel == 0)
	{
		SendMessageToPC(OBJECT_SELF,"You do not have any valid spells left that can trigger this ability.");	
	}
	else
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{		
			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
			effect eConcealVision = EffectMissChance(nDarkLevel*5);

				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId));				

				//Apply the effects
				if (!(GetHasFeat(408, oTarget, TRUE)))  // Doesn't work if they have blind-fight
				{
					int iDC = GetReserveSpellSaveDC(nDarkLevel,OBJECT_SELF);
	                if  (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_EVIL))
					{	
						CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget,iSpellId);
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConcealVision, oTarget, 6.0f);
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);				
					}
				}
		}	
	}			


	HkPostCast(oCaster);
}