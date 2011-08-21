//::///////////////////////////////////////////////
//:: Glyph of Warding
//:: x2_s0_glphwarda.nss
//:: Copyright (c) 2006 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////
/*
	The caster creates a trapped area which detects
	the entrance of enemy creatures into 3 m area
	around the spell location.  When tripped it
	causes an explosion that does 1d8 per
	two caster levels up to a max of 5d8 damage.
	Damage type is dependent on caster alignment.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_glyphwarding(); //SPELL_GLYPH_OF_WARDING;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_GLYPH_OF_WARDING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iDescriptor = SCMETA_DESCRIPTOR_NONE;
	
	int nAlign = GetAlignmentGoodEvil( oCaster );
	if (nAlign==ALIGNMENT_GOOD)
	{
		iDescriptor = SCMETA_DESCRIPTOR_DIVINE|SCMETA_DESCRIPTOR_GOOD;		
	}
	else if (nAlign==ALIGNMENT_EVIL)
	{
		iDescriptor = SCMETA_DESCRIPTOR_NEGATIVE|SCMETA_DESCRIPTOR_EVIL;
	}
	else
	{
		iDescriptor = SCMETA_DESCRIPTOR_SONIC;
	}
	
	HkPreCast( OBJECT_INVALID, iSpellId, iDescriptor, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	
	
	
	//NEGATIVE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_NECROMANCY );
	//int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	if (CSLSpellsIsTarget( oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		if ( !HkResistSpell(oCaster, oTarget ) )
		{
			int iDice = HkGetSpellPower(oCaster, 10);
			int nDam = HkApplyMetamagicVariableMods(d8( iDice /2 ), 40);
			nDam = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,nDam, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, oCaster);
			
			//int nAlign = GetAlignmentGoodEvil( oCaster );
			if (nAlign==ALIGNMENT_GOOD)
			{
				effect eGoodVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY );
				effect eGoodDam = EffectDamage(nDam, DAMAGE_TYPE_DIVINE );
				effect eGoodLink = EffectLinkEffects(eGoodVis, eGoodDam);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eGoodLink, oTarget);
			}
			else if (nAlign==ALIGNMENT_EVIL)
			{
				effect eEvilVis = EffectVisualEffect(VFX_HIT_SPELL_EVIL );
				effect eEvilDam = EffectDamage(nDam, DAMAGE_TYPE_NEGATIVE);
				effect eEvilLink = EffectLinkEffects(eEvilVis, eEvilDam);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eEvilLink, oTarget);
			}
			else
			{
				effect eNeutVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC );
				effect eNeutDam = EffectDamage(nDam, DAMAGE_TYPE_SONIC );
				effect eNeutLink = EffectLinkEffects(eNeutVis, eNeutDam);
				HkApplyEffectToObject( DURATION_TYPE_INSTANT, eNeutLink, oTarget );
			}
		}
		DestroyObject(OBJECT_SELF, 0.3);
	}
	
	HkPostCast(oCaster);
}