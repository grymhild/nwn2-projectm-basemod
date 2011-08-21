/*
	sp_createtatoo

	<Didn't find a description>

	By: ???
	Created: ???
	Modified: Jul 1, 2006

	fixed spelling of tattoo
*/
//#include "prc_sp_func"
#include "_HkSpell"

int GetTattooCount(object oTarget, int nSpellID)
{
	// Loop through all of the effects on the target, counting
	// the number of them that have this spell ID.
	int nTattoos = 0;
	effect eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect))
	{
		if (nSpellID == GetEffectSpellId(eEffect)) nTattoos++;
		eEffect = GetNextEffect(oTarget);
	}

	return nTattoos;
}

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
	

	return TRUE; 	//return TRUE if spell charges should be decremented
}




void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CREATE_MAGIC_TATOO; // put spell constant here
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

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 

	object oTarget = HkGetSpellTarget();
	//--------------------------------------------------------------------------
	//do spell
	//--------------------------------------------------------------------------
	int nTattooSpellID = HkGetSpellId() + 1;

	if (GetIsPC(oCaster))
	{
		// A creature is only allowed 3 tattoos, check the number they have to make
		// sure we have room to add another.
		int nTattoo = GetTattooCount(oTarget, nTattooSpellID);
		if (nTattoo >= 3)
		{
			// Let the caster know they cannot add another tattoo to the target.
			SendMessageToPC(OBJECT_SELF, GetName(oTarget) + " already has 3 tattoos.");
		}
		else
		{
			// SCRaise the spell cast event.
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, FALSE);

			// Save the ID of the tattoo spell (so the conversation scripts can cast it),
			// and save the metamagic and target. Then invoke the conversation to
			// let the caster pick what tattoo to scribe.
			SetLocalInt(OBJECT_SELF, "SP_CREATETATOO_LEVEL", nCasterLevel);
			SetLocalInt(OBJECT_SELF, "SP_CREATETATOO_SPELLID", nTattooSpellID);
			SetLocalInt(OBJECT_SELF, "SP_CREATETATOO_METAMAGIC", HkGetMetaMagicFeat());
			SetLocalObject(OBJECT_SELF, "SP_CREATETATOO_TARGET", oTarget);
			ActionStartConversation(OBJECT_SELF, "sp_createtatoo", FALSE, FALSE);
		}
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}