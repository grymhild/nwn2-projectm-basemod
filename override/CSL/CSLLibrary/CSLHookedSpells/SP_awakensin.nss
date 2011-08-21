//::///////////////////////////////////////////////
//:: Awaken Sin
//:: cmi_s0_awakensin
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On:  July 5, 2007
//:://////////////////////////////////////////////
//:: Awaken Sin
//:: Caster Level(s): Paladin 2, Cleric 3
//:: Innate Level: 3
//:: School: Enchantment
//:: Descriptor(s): Fear, Good, Mind-Affecting
//:: Component(s): Verbal, Somatic
//:: Range: Touch.
//:: Area of Effect / Target: One evil creature with Intelligence 3+
//:: Duration: Instantaneous
//:: Save: Will negates
//:: Spell Resistance: Yes
//:: The subject immediately takes 1d6 points of blunt damage per caster level
//:: (maximum 10d6) and is stunned for 1 round.
//:: 
//:: A command for repentance issues from your mouth, carrying with it the
//:: power of the spell. The crushing feeling of guilt that grew within you
//:: while you cast the spell lifts as you project the feeling at your
//:: target.
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_awakensin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Awaken_Sin;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_AOE_HOLY;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FEAR | SCMETA_DESCRIPTOR_GOOD | SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	object oTarget = HkGetSpellTarget();
	
	if (GetAlignmentGoodEvil(oTarget) != ALIGNMENT_EVIL)
	{
		SpeakString("Awaken Sin only affects evil targets.  Spell failed.");
		return;
	}
	
	int iNumDice = HkGetSpellPower( OBJECT_SELF, 10 );
	
	int iDamage = HkApplyMetamagicVariableMods(d6(iNumDice), 6 * iNumDice);
	effect eDamage = HkEffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING);
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);	
    effect eStun = EffectStunned();		
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if(HkResistSpell(OBJECT_SELF, oTarget) == 0)
    {	
	
        if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
	    {
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));	
	    	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1));
             	
	    }	
	}
	HkPostCast(oCaster);
}

