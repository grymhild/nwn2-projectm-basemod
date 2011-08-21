//::///////////////////////////////////////////////
//:: Searing Light (Master of Radiance)
//:: cmi_s2_searlght
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:://////////////////////////////////////////////
//:: Based on Searing Light by OEI

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "NW_I0_SPELLS"    
//#include "x2_inc_spellhook" 
//#include "nwn2_inc_spells"
//#include "_SCInclude_sneakattack"

void main()
{	
	//scSpellMetaData = SCMeta_FT_searlight();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	if (!GetHasSpellEffect(SPELLABILITY_MASTER_RADIANCE_RADIANT_AURA))
	{
        SpeakString("This ability can only be used while Radiant Aura is active.");
	}
	else
	{
	    //Declare major variables
	    
	    object oTarget = HkGetSpellTarget();
	
	    int iSpellPower = HkGetSpellPower(oCaster, 8) + 2;
		
	    
		//int nHasRSS = GetHasFeat(2991);	
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SEARING_LIGHT));
			
			int iTouch = CSLTouchAttackRanged(oTarget);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS)
		    {    //Make an SR Check
		        if (!HkResistSpell(oCaster, oTarget))
		        {
				    int iDamage;
				    int nMax;
		            //Check for racial type undead
		            if ( CSLGetIsUndead( oTarget, TRUE ) )
		            {
						iDamage = d6(iSpellPower);
		                //nMax = 8;
						iDamage = HkApplyMetamagicVariableMods(iDamage, iSpellPower*6);
		            }
		            //Check for racial type construct
		            else if ( CSLGetIsConstruct( oTarget ) )
		            {
		                iSpellPower /= 2;
		                iDamage = d6(iSpellPower);
		                //nMax = 6;
						iDamage = HkApplyMetamagicVariableMods(iDamage, iSpellPower*6);
					}
					else
					{
		                iSpellPower = iSpellPower/2;
		                iDamage = d8(iSpellPower);
		                //nMax = 8;
						iDamage = HkApplyMetamagicVariableMods(iDamage, iSpellPower*8);
					}
					
					iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, OBJECT_SELF );	
					
					
					//Set the damage effect
					effect eDam = EffectDamage(iDamage, DAMAGE_TYPE_DIVINE);
					effect eVis = EffectVisualEffect( VFX_HIT_SPELL_SEARING_LIGHT );
					
					//Apply the damage effect and VFX impact
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					DelayCommand(0.5, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		        }
			}
	    }
	    effect eRay = EffectBeam(VFX_BEAM_HOLY, OBJECT_SELF, BODY_NODE_HAND);
	    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
	}
	HkPostCast(oCaster);
}