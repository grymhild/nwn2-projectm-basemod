//#include "spinc_common"
//#include "spinc_bolt"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FORCEBLAST; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	

	// Get the number of damage dice.
	int nCasterLevel = HkGetCasterLevel(OBJECT_SELF);
	int nDice = nCasterLevel > 10 ? 10 : nCasterLevel;

	DoBolt (nCasterLevel,4, 0, nDice, VFX_BEAM_MIND, VFX_IMP_MAGBLUE,
		DAMAGE_TYPE_MAGICAL, SAVING_THROW_TYPE_SPELL,
		SPELL_SCHOOL_EVOCATION, TRUE, HkGetSpellId());
}

