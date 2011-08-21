//::///////////////////////////////////////////////
//:: Gust of Wind
//:: [x0_s0_gustwind.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This spell creates a gust of wind in all directions
	around the target. All targets in a medium area will be
	affected:
	- Target must make a For save vs. spell DC or be
		knocked down for 3 rounds
	- plays a wind sound
	- if an area of effect object is within the area
	it is dispelled
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Evocation"

void main()
{
	//scSpellMetaData = SCMeta_SP_gustwind();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GUST_OF_WIND;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_EVOCATION;
	
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_AIR, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iDamage;
	float fDelay;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
	// effect eDam;
	//Get the spell target location as opposed to the spell target.
	location lTarget = HkGetSpellTargetLocation();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpacLocation = HkGetSpellTargetLocation(); //GetLocation(oCaster);
	
	// void CSLEnviroWindGustEffect( location lStartLocation, location lEndLocation, int iShape = SHAPE_CONE, float fRadius = RADIUS_SIZE_HUGE, int bResistable = FALSE, object oCaster = OBJECT_SELF )

	//CSLEnviroWindGustEffect( lStartLocation, lImpactLoc, SHAPE_CONE, fRadius, TRUE, HkGetSpellSaveDC(), oCaster );
	
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpacLocation);
	
	
	int iObjectType;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lImpacLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
		
		iObjectType = GetObjectType(oTarget);
		if ( iObjectType == OBJECT_TYPE_AREA_OF_EFFECT || iObjectType == OBJECT_TYPE_DOOR || iObjectType == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			CSLEnviroWindGustEffect( lImpacLocation, oTarget );
		}
		else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			if( HkResistSpell(oCaster, oTarget) || HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC()-CSLGetSizeModifierGrapple(oTarget) ) )
			{
				// spell resisted
				CSLTorchExtinguishObject( oTarget );
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_GLITTERDUST, SPELL_DECK_BUTTERFLYSPRAY );
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE ));
			}
			else
			{
				CSLEnviroWindGustEffect( lImpacLocation, oTarget );
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE ));
			}
		}
		else
		{
			CSLTorchExtinguishObject( oTarget );
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_GLITTERDUST, SPELL_DECK_BUTTERFLYSPRAY );

		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lImpacLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE |OBJECT_TYPE_AREA_OF_EFFECT);
	}
	
	HkPostCast(oCaster);
}
