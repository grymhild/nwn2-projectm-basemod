//::///////////////////////////////////////////////
//:: Lightning Bolt
//:: NW_S0_LightnBolt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Does 1d6 per level in a 5ft tube for 30m
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On:  March 8, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 2, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



//#include "ginc_debug"

void main()
{
	//scSpellMetaData = SCMeta_SP_lightningbol();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LIGHTNING_BOLT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ELECTRICAL, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( OBJECT_SELF, 10 );
	int iDamage;
	
	object oTarget = HkGetSpellTarget();
	location lTarget = GetLocation(oTarget);
	location lTarget2 = HkGetSpellTargetLocation();
	
	//string sTarget2 = "wp_lbolttrgt2";
	object oNextTarget, oTarget2;
	float fDelay;
	int nCnt = 1;

	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
	int iShapeEffect = HkGetShapeEffect( VFX_BEAM_LIGHTNING, SC_SHAPE_BEAM ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
	float fRadius = HkApplySizeMods(30.0f);
	//int iShape = HkApplyShapeMods( SHAPE_SPELLCYLINDER );
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	//Set the lightning stream to start at the caster's hands
	effect eLightning = EffectBeam(iShapeEffect, OBJECT_SELF, BODY_NODE_HAND);
	effect eVis  = EffectVisualEffect(iHitEffect); // used for both hit and impact visual
	effect eDamage;
	
	// If you target a location, this will spawn in an invisible creature to act as the endpoint on the beam, then delete itself
	object oPoint = CreateObject(OBJECT_TYPE_CREATURE, "c_attachspellnode" , lTarget2);
	SetScriptHidden(oPoint, TRUE);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oPoint, 1.0);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPoint);
	DestroyObject(oPoint, 2.0);
	
	//CreateObject(OBJECT_TYPE_WAYPOINT, sTarget2, lTarget2);
	//object oPoint = GetObjectByTag(sTarget2);
	//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oPoint, 1.0);
	//PrettyDebug("Lightning bolt!  Woo Hoo!");
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lImpactLoc);


	oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
	while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 30.0)
	{
			//Get first target in the lightning area by passing in the location of first target and the casters vector (position)
			oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, fRadius, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
		//PrettyDebug("investigating target " + GetName(oTarget));
			while (GetIsObjectValid(oTarget))
			{
				//Exclude the caster from the damage effects
				if (oTarget != OBJECT_SELF && oTarget2 == oTarget)
				{
					if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
					{
						//Fire cast spell at event for the specified target
					//PrettyDebug("Signaling Lightning Bolt on " + GetName(oTarget));
						SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LIGHTNING_BOLT, TRUE ));
						//Make an SR check
						if (!HkResistSpell(OBJECT_SELF, oTarget))
						{
							//Roll damage
							iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
							//Adjust damage based on Reflex Save, Evasion and Improved Evasion
							iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(),iSaveType);
							//Set damage effect
							eDamage = HkEffectDamage(iDamage, iDamageType);
							if(iDamage > 0)
							{
								fDelay = CSLGetSpellEffectDelay(GetLocation(oTarget), oTarget);
								//Apply VFX impcat, damage effect and lightning effect
								DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
								DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
							}
						}
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,1.0);
						//Set the currect target as the holder of the lightning effect
						oNextTarget = oTarget;
						eLightning = EffectBeam(iShapeEffect, oNextTarget, BODY_NODE_CHEST);
					}
				}
				//Get the next object in the lightning cylinder
				oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, fRadius, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
			}
			nCnt++;
			oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
	}
	
	HkPostCast(oCaster);
}

