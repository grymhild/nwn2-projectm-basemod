//::///////////////////////////////////////////////
//:: Teamwork (Nightsong Infiltrator)
//:: cmi_s2_niteamworka
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "cmi_includes"
//#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_FT_auradcteamin(); //SPELLABILITY_AURA_DC_TEAMINIT;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	
	if (oTarget != oCaster)
	{
	    if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
	    {
			if (!GetHasSpellEffect(SPELLABILITY_AURA_DC_TEAMINIT, oTarget))
			{
				int nClassLevel = GetLevelByClass(CLASS_DREAD_COMMANDO, oCaster);
								
				float fDuration = HkApplyDurationCategory(12, SC_DURCATEGORY_HOURS);
				
				itemproperty iBonusFeat, iBonusFeat2;
				if (nClassLevel > 4)
				{
					iBonusFeat = ItemPropertyBonusFeat(84); // Imp Init
					iBonusFeat2 = ItemPropertyBonusFeat(IPRP_FEAT_EPIC_SUPERIOR_INITIATIVE);
				}	
				else
				{
					iBonusFeat = ItemPropertyBonusFeat(84); // Imp Init
				}
						
				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);				
				eVis = SupernaturalEffect(eVis);
				eVis = SetEffectSpellId (eVis, SPELLABILITY_AURA_DC_TEAMINIT);
				
				SignalEvent (oTarget, EventSpellCastAt(oCaster, SPELLABILITY_AURA_DC_TEAMINIT, FALSE));		

	
			    DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration ));
				if (oTarget != oCaster)
				{
					object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTarget);
					if ( !GetIsObjectValid( oArmorNew ) )
					{
						oArmorNew = CreateItemOnObject("x2_it_emptyskin", oTarget, 1, "", FALSE);
						AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oArmorNew,fDuration);
						if (nClassLevel > 4)
						{
							AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat2,oArmorNew,fDuration);
						}
						DelayCommand(fDuration, DestroyObject(oArmorNew,0.0f,FALSE));
						AssignCommand( oTarget, ActionEquipItem(oArmorNew,INVENTORY_SLOT_CARMOUR) );		
					}
					else
					{
				        CSLSafeAddItemProperty(oArmorNew, iBonusFeat, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE,FALSE );
						if (nClassLevel > 4)
							CSLSafeAddItemProperty(oArmorNew, iBonusFeat2, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE,FALSE );	
					}
				}						
			}
			
		}
		
	}	
	
}