//::///////////////////////////////////////////////
//:: Aura of Hellfire on Heartbeat
//:: NW_S1_AuraElecC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Prolonged exposure to the aura of the creature
    causes fire damage to all within the aura.
*/

#include "_HkSpell"


void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_EVOCATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = 9;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower(oCaster, 20); // AOE's ignore caps since the cap is set when it's cast
	int iSpellSaveDC = HkGetSpellSaveDC();
	int nDamage;
    int nDamSave;
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iDescriptor = HkGetDescriptor(); // This is stored in the AOE tag of the AOE, and after that it's stored in a var on the AOE
	int iSaveType = SAVING_THROW_TYPE_FIRE;
	//int iHitEffect = VFX_HIT_SPELL_FIRE;
	int iImpactEffect = VFX_IMP_FLAME_M;

	int iDamageType = CSLGetDamageTypeModifiedByDescriptor( DAMAGE_TYPE_FIRE, iDescriptor );
	if ( iDamageType != DAMAGE_TYPE_FIRE )
	{
		//iHitEffect = CSLGetHitEffectByDamageType( iDamageType );
		iSaveType = CSLGetSaveTypeByDamageType( iDamageType );
		iImpactEffect = CSLGetImpactEffectByDamageType( iDamageType );
	}
	/////////////////////////////////////////////////////////////////////////////////
 
    effect eDam;
    effect eVis = EffectVisualEffect( iImpactEffect );
    //Get first target in spell area
    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), 761));
            //Roll damage
            nDamage = d6(6);
            //Make a saving throw check
            //if(HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), iSaveType))
            //{
            //    nDamage = nDamage / 2;
            //}
            nDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, nDamage, oTarget, HkGetSpellSaveDC(), iSaveType, oCaster, SAVING_THROW_RESULT_ROLL );
							
            //Set the damage effect
            eDam = EffectDamage(nDamage, iDamageType);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
}