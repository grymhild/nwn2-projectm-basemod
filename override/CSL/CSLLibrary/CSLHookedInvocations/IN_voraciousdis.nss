//:://///////////////////////////////////////////////
//:: Warlock Lesser Invocation: Voracious Dispelling
//:: nw_s0_ivoradisp.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
			5.7.2.10  Voracious Dispelling
			Complete Arcane, pg. 136
			Spell Level: 4
			Class:          Misc

			This is the equivalent of the dispel magic spell (3rd level wizard)
			except if any spells on a target are dispelled the target takes 1
			point of damage per two spell levels of the caster (no save, but magic
			resistance applies).

			[Rules Note] In the rules the damage the target takes depends on the
			spell level of what's removed, but the way the engine works the spell
			level data isn't stored on an effect.


*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"

void main()
{
	//scSpellMetaData = SCMeta_IN_voraciousdis();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_I_VORACIOUS_DISPELLING;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ELDRITCH;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	object oTarget = HkGetSpellTarget();
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	if (  GetIsObjectValid(oTarget)  )
	{
		DelayCommand( 0.1f, SCDispelTarget(oTarget, oCaster, SCGetDispellCount(iSpellId, TRUE), SPELL_I_VORACIOUS_DISPELLING ) );
	}
	else
	{
		location lLocal = HkGetSpellTargetLocation();
		int nStripCnt = SCGetDispellCount(iSpellId, FALSE);
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
		while (GetIsObjectValid(oTarget) && nStripCnt > 0)
		{
			if (GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT)
			{
				SCDispelAoE(oTarget, oCaster);
			}
			else
			{
				DelayCommand( 0.1f, SCDispelTarget(oTarget, oCaster, nStripCnt, SPELL_I_VORACIOUS_DISPELLING) );
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
		}
	}

	HkPostCast(oCaster);	
}

