//::///////////////////////////////////////////////
//:: Storm Bolt
//:: cmi_s2_stormbolt
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: December 14, 2007
//:://////////////////////////////////////////////


/*----  Kaedrin PRC Content ---------*/



#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 
#include "_SCInclude_Class"
#include "_SCInclude_Reserve"

void main()
{	
	//scSpellMetaData = SCMeta_FT_stormbolt();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	int nStormSinger = GetLevelByClass(CLASS_STORMSINGER, OBJECT_SELF);

	//Declare major variables
	int nDamageDice = CSLGetHighestLevelByDescriptor( SCMETA_DESCRIPTOR_ELECTRICAL, oCaster );
	if ( nDamageDice == -1)
	{
		SendMessageToPC(OBJECT_SELF,"You do not have any valid spells left that can trigger this ability.");	
		return;
	}
	nDamageDice += nStormSinger;
	
    object oTarget = HkGetSpellTarget();
    location lTarget = GetLocation(oTarget);
	location lTarget2 = HkGetSpellTargetLocation();
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	int iBeamEffect = HkGetShapeEffect( VFX_BEAM_LIGHTNING, SC_SHAPE_BEAM ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

    effect eDamage;
    effect eLightning = EffectBeam(iBeamEffect, OBJECT_SELF, BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(iHitEffect);
    object oNextTarget, oTarget2;
    float fDelay;
    int nCnt = 1;
	int iDC = GetReserveSpellSaveDC(nDamageDice,OBJECT_SELF);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	effect eImpactVis = EffectVisualEffect( iHitEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lTarget2);

	// If you target a location, this will spawn in an invisible creature to act as the endpoint on the beam, then delete itself
	object oPoint = CreateObject(OBJECT_TYPE_CREATURE, "c_attachspellnode" , lTarget2);
	SetScriptHidden(oPoint, TRUE);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oPoint, 1.0);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPoint);
	DestroyObject(oPoint, 2.0);
	
    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= fRadius)
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
                	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
 					
 					int iDamage = SCGetReserveFeatDamage( nDamageDice, 6);
                    iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, iSaveType);

                    //Set damage effect
                    eDamage = EffectDamage(iDamage, iDamageType);
                    fDelay = CSLGetSpellEffectDelay(GetLocation(oTarget), oTarget);
                    //Apply VFX impcat, damage effect and lightning effect
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,1.0);
                    //Set the currect target as the holder of the lightning effect
                    oNextTarget = oTarget;
                    eLightning = EffectBeam(iBeamEffect, oNextTarget, BODY_NODE_CHEST);
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

