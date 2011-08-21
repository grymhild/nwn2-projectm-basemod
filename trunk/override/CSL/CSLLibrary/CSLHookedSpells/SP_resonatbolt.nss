//::///////////////////////////////////////////////
//:: Resonating Bolt
//:: cmi_s0_resonbolt
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: October 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_SP_resonatbolt();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Resonating_Bolt;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
    int iSpellPower = HkGetSpellPower(OBJECT_SELF, 10);
	
    object oTarget = HkGetSpellTarget();
    location lTarget = GetLocation(oTarget);
	location lTarget2 = HkGetSpellTargetLocation();
	
	//SONIC
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_SONIC );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
    effect eDamage;	
    effect eLightning = EffectBeam(VFX_BEAM_RESONBOLT, OBJECT_SELF, BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(iHitEffect); // This is used for both the hit effect AND the impact effect
    object oNextTarget, oTarget2;
    float fDelay;
    int nCnt = 1;
	
	// If you target a location, this will spawn in an invisible creature to act as the endpoint on the beam, then delete itself
	object oPoint = CreateObject(OBJECT_TYPE_CREATURE, "c_attachspellnode" , lTarget2);
	SetScriptHidden(oPoint, TRUE);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oPoint, 1.0);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPoint);
	DestroyObject(oPoint, 2.0);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	//
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lImpactLoc);


    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 60.0)
    {
        //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 60.0, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
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
                   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                   //Make an SR check
                   if (!HkResistSpell(OBJECT_SELF, oTarget))
        	       {
				   
					    int iDamage;    
						iDamage = d4(iSpellPower);        
						iDamage = HkApplyMetamagicVariableMods( iDamage, iSpellPower*4 );
						
						if (GetHasSpellEffect(FEAT_LYRIC_THAUM_SONIC_MIGHT,OBJECT_SELF))
						{
							iDamage += d6(4);		
						}	
						
						iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType);

                        //Set damage effect
                        eDamage = HkEffectDamage(iDamage, iDamageType);
                        if(iDamage > 0)
                        {
                            fDelay = CSLGetSpellEffectDelay(GetLocation(oTarget), oTarget);
                            //Apply VFX impcat, damage effect and lightning effect
                            DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget ) );
                            DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget ) );
                        }
                    }
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,1.0);
                    //Set the currect target as the holder of the lightning effect
                    oNextTarget = oTarget;
                    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oNextTarget, BODY_NODE_CHEST);
                }
           }
           //Get the next object in the lightning cylinder
           oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 60.0, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
        }
        nCnt++;
        oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    }	
	
	HkPostCast(oCaster);	
}

