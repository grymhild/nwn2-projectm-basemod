//#include "inc_pw"
//#include "inc_pw_teleport"
#include "x2_inc_spellhook"


void main()
{
    object oPC = OBJECT_SELF;
    int nClass = GetLastSpellCastClass();
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode())
        return;
    LogObjectMessage(oPC, "Attempting to create a Teleport portal", LOGLEVEL_DEBUG);

    // Check to make sure that they have a target memorized
    /// @todo This check should already exist in inc_pw_teleport
    CSLNWNX_SQLExecDirect("SELECT count(*) FROM pc_teleport WHERE pcid = " + getPCID(oPC) + "");
    CSLNWNX_SQLFetch();
    if (StringToInt(CSLNWNX_SQLGetData(1)) == 0) {
        SendMessageToPC(oPC, "You must first <MEM> at least one location before using this spell!");
        return;
    }

    location lTarget = HkGetSpellTargetLocation();
    int nDuration = GetCasterLevel(oPC);

    // Make sure duration does no equal 0
    if (nDuration < 1) nDuration = 1;

    // Check Extend metamagic feat.
    if (GetMetaMagicFeat() == METAMAGIC_EXTEND)
       nDuration *= 2;    //Duration is +100%

    if (GetIsDM(oPC)) nDuration = 40;

    DelayCommand(0.2, teleport_createPortal(oPC, RoundsToSeconds(nDuration), nClass, lTarget, FALSE, FALSE));
}