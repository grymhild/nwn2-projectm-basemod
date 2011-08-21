//::///////////////////////////////////////////////
//:: Blessed Aim
//:: cmi_s0_blessedaim
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: June 28, 2007
//:://////////////////////////////////////////////
//:: Blessed Aim
//:: Caster Level(s): Paladin 1, Cleric 1, Blackguard 1
//:: Innate Level: 1
//:: School: Divination
//:: Descriptor(s):
//:: Component(s): Verbal, Somatic
//:: Range: 50 ft.
//:: Area of Effect / Target: 50-ft.-radius spread centered on you
//:: Duration: 1 minute/level
//:: Save: None
//:: Spell Resistance: No
//:: This spell grants your allies within the spread a +2 morale bonus on ranged
//:: attack rolls.
//:: 
//:: With the blessing of your deity, you bolster your allies' aim with an
//:: exhortation.
//:://////////////////////////////////////////////


/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_blessedaim();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Blessed_Aim;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_DIVINATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	float fRadius = HkApplySizeMods(RADIUS_SIZE_GINORMOUS);

    	
	effect eBonus = EffectAttackIncrease(2);	
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_HEROISM);
	effect eLink = EffectLinkEffects(eVis, eBonus);	
	
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF );
	float fDuration = TurnsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	float fDelay;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
        {
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
			if (GetIsObjectValid(oWeapon) && GetWeaponRanged(oWeapon))
			{
				///effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId() ) );
				//eLink = EffectLinkEffects(eLink, eOnDispell);
				fDelay = CSLRandomBetweenFloat(0.4, 1.1);
				
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId() );			
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
				DelayCommand(fDelay, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() ) );
			}
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
    }	
	
	HkPostCast(oCaster);
}

