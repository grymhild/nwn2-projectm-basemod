//::///////////////////////////////////////////////
//:: Blessed Aim
//:: cmi_s0_blessedaim
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: June 28, 2007
//:://////////////////////////////////////////////
//:: Linked Perception
//:: Divination
//:: Level: Druid 2, Ranger 1
//:: Components: VS
//:: Area: 20-ft.-radius centered on you
//:: Duration: 1 minute/level
//:: This spell imparts to all allies in its area a shared awareness of their
//:: surroundings. Each ally in the area (including yourself) gains a +2 bonus
//:: on Spot and Listen checks per each ally in the area. For example, if you
//:: and three allies are in the area, each of you gains a +6 bonus.
//:: 
//:: Your senses are muddied for a moment, but when they clear, your sight
//:: and hearing are improved.
//:://////////////////////////////////////////////


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LINKED_PERCEPTION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);

	int nBonus;

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
				nBonus++;
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
	}
	nBonus = nBonus * 2;
	if (nBonus > 20) //Sanity check
		nBonus = 20;

	effect eSkill1 = EffectSkillIncrease(SKILL_SPOT, nBonus);
	effect eSkill2 = EffectSkillIncrease(SKILL_LISTEN, nBonus);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_HEROISM);
	effect eLink = EffectLinkEffects(eSkill1, eSkill2);
	eLink = EffectLinkEffects(eLink, eVis);
	
	
	float fDelay;

	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			fDelay = CSLRandomBetweenFloat(0.4, 1.1);

			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
			SignalEvent(oTarget, EventSpellCastAt(oCaster,iSpellId, FALSE));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));

		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
	}
	
	HkPostCast(oCaster);
}