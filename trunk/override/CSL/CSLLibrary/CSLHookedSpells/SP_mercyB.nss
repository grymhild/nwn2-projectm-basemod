//::///////////////////////////////////////////////
//:: SP_mercyB.nss - Changed to OnHit
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	
	
	int iSpellId = SPELL_MERCY; // put spell constant here
	object  oTarget = CSLGetOriginalDamageTarget(OBJECT_SELF);
	
	if ( GetTotalDamageDealt() <= 1 && GetDamageDealtByType(DAMAGE_TYPE_NEGATIVE) <= 1 )
	{
		return;
	}
	
	if( !GetIsObjectValid(oTarget) )
    {
		return;
	}
	
	object  oCaster = GetLocalObject(oTarget, "CSL_MERCYCASTER");
	object  oAttacker = GetLastDamager(OBJECT_SELF);
	
	
	
	if ( oCaster == oAttacker )
	{
		// same code as in heart beat
		SetImmortal(oTarget, FALSE);
		DeleteLocalInt(oTarget, "MERCY");
		DeleteLocalObject(oTarget, "CSL_MERCYCASTER");
		CSLSetOnDamagedScript( oTarget, "" );
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
		//DelayCommand(0.1, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
	}
}
