//::///////////////////////////////////////////////
//:: Cloak of Bravery
//:: cmi_s0_cloakbravery
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 5, 2007
//:://////////////////////////////////////////////
//:: Cloak of Bravery
//:: Caster Level(s): Paladin 2, Cleric 3, Courage 3
//:: Innate Level: 3
//:: School: Abjuration
//:: Descriptor(s): Mind-Affecting
//:: Component(s): Verbal, Somatic
//:: Range: 60 ft.
//:: Area of Effect / Target: 60-ft.-radius burst centered on you
//:: Duration: 10 minutes/level
//:: Save: No
//:: Spell Resistance: No
//:: All allies within the emanation (including you) gain a morale bonus on
//:: saves against fear effects equal to your caster level (to a maximum of +10
//:: at caster level 10th).
//:: 
//:: Summoning up your courage, you throw out your arm and sweet it over the
//:: area, cloaking all your allies in a glittering mantle of magic that
//:: bolsters their bravery.
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_cloakbravery();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Cloak_Bravery;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	int nFearBonus = HkGetSpellPower( OBJECT_SELF, 10 );
	float fDuration = TurnsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	float fRadius = HkApplySizeMods(RADIUS_SIZE_VAST);
	
	
	effect eBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL, nFearBonus, SAVING_THROW_TYPE_FEAR);	
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_HEROISM);
	effect eLink = EffectLinkEffects(eVis, eBonus);	
	
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
        {
		    //effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, oTarget, GetSpellId() ) );
			//eLink = EffectLinkEffects(eLink, eOnDispell);
			
    		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId() );								
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
            HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
    }	
	
	HkPostCast(oCaster);
}      

