//::///////////////////////////////////////////////
//:: Animal Shapes - Master Script
//:: sg_s0_anishapes.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Transmutation
     Level: Animal 7, Druid 8
     Casting Time: 1 action
     Range: Close (25 ft + 5ft/lvl)
     Targets: One willing creature (changed from text)
     Duration: 1 hour/level
     Saving Throw: None (see text)
     Spell Resistance: Yes (harmless)

     As polymorph other, except you polymorph one
     willing creature into an animal of your choice,
     the spell has no effect on unwilling creatures.
     Recipients remain in the animal form until the
     spell expires or you dismiss the spell for all
     recipients.  In addition, an individual subject
     may choose to resume her normal form (as a full-
     round action), doing so ends the spell for her
     and her alone.
*/

#include "_HkSpell"
#include "_SCInclude_Polymorph"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ANISHAPE_NORMAL; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_MAGICAL;
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
	// int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
    
	PolyMerge(oTarget, iSpellId, fDuration, FALSE, FALSE, FALSE);

    HkPostCast(oCaster);
}

