/* 
	//:: SOZ UPDATE BTM
	
    Reeron created this spell on 2-18-08

    Enchantment (Compulsion) [Mind-Affecting]
    Level: Sor/Wiz 8, Madness 8
    Components: V
    Casting Time: One action
    Range: Touch
    Target: Living creature touched
    Duration: 1d4+1 rounds
    Saving Throw: None
    Spell Resistance: Yes
    The subject cannot keep him or herself from behaving as though completely mad. 
    This spell makes it impossible for the victim to do anything other than race 
    about caterwauling. The effect worsens the Armor Class of the creature by 4, 
    makes Reflex saving throws impossible except on a roll of 20, and makes it 
    impossible to use a shield.

*/
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MADDENING_SCREAM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	

	
    object oTarget = HkGetSpellTarget();
    int iDuration = d4(1) + 1;
    int i = 0;
    int nmodifyattack = 0;
    //nmodifyattack=FINESSE(oTarget);
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );


    if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId ) );//Maddening Scream
 
        // Ray spells require a ranged touch attack
        int iTouch = CSLTouchAttackMelee(oTarget,TRUE,nmodifyattack);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
            
            if( GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD )
            {//Make SR check
				if (!HkResistSpell(OBJECT_SELF, oTarget))
				{
					float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
					int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
					
					effect eAC=EffectACDecrease(4, AC_DODGE_BONUS);
					effect eSave=EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 50);
					effect eMove=EffectMovementSpeedIncrease(99);
					effect eDaze=EffectDazed();
					effect eLink = EffectLinkEffects(eAC, eSave);
					eLink = EffectLinkEffects(eMove, eLink);
					eLink = EffectLinkEffects(eDaze, eLink);
					eLink = EffectLinkEffects(eVis, eLink);
					if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
					{
						HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
						ExecuteScript("n2_s0_RanWalk", oTarget);
					}
					else
					{
						FloatingTextStringOnCreature("Target is immune to Mind-Affecting Spells!", GetFirstPC());
					}
				}
			}
			else
			{
				FloatingTextStringOnCreature("Target must be a living creature to have any effect!", GetFirstPC());
			}
        }
	
 	    effect eRay = EffectBeam(VFX_BEAM_ENCHANTMENT, OBJECT_SELF, BODY_NODE_HAND);
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
	}
    
    HkPostCast(oCaster);
}

