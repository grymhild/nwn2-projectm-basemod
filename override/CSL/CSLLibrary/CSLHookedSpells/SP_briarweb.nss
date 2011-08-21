//::///////////////////////////////////////////////
//:: Briar Web
//:: cmi_s0_briarweb
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
//:://////////////////////////////////////////////
//:: Briar Web
//:: Transmutation
//:: Caster Level(s): Druid 2, Ranger 2
//:: Component(s): Verbal, Somatic
//:: Range: Medium
//:: Area of Effect / Target: 40-ft.-radius spread
//:: Duration: 3 minutes.
//:: Save: None
//:: Spell Resistance: No
//:: This spell causes grasses, weeds, bushes, and even trees to grow thorns and
//:: wrap and twist around creatures in or entering the area. The spell's area
//:: becomes difficult terrain and creatures move at half speed within the
//:: affected area. Any creature moving through the area or that stays within it
//:: takes 6 points of piercing damage.
//:: 
//:: A creature with Freedom of Movement or the woodland stride ability
//:: is unaffected by this spell.
//:: 
//:: With a sound like a thousand knives being unsheathed, the plants in the
//:: area grow sharp thorns and warp into a thick briar patch.
//:://////////////////////////////////////////////



#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BRIAR_WEB;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(3, SC_DURCATEGORY_MINUTES) );
	int iSpellPower = HkGetSpellPower( oCaster );
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	effect eAOE = EffectAreaOfEffect(VFX_PER_BRIAR_WEB, "", "", "", sAOETag);

	location lTarget = HkGetSpellTargetLocation();

	//Create an instance of the AOE Object using the Apply Effect function
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration );
	
	HkPostCast(oCaster);
}