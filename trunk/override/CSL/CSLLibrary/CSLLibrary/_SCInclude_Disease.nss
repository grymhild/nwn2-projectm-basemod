/** @file
* @brief Include File for DMFI
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/


/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////




/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////
#include "_CSLCore_Nwnx"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////



/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

/** Internal function.
 * Implements the decrementing of the overdose counters.
 *
 * @param oDrugUser     A creature using a drug.
 * @param sODIdentifier The name of the drug's overdose identifier.
 */
void _prc_inc_drugfunc_DecrementOverdoseTracker(object oDrugUser, string sODIdentifier)
{
    // Delete the variable if decrementing would it would make it 0
    if(GetLocalInt(oDrugUser, sODIdentifier) <= 1)
        DeleteLocalInt(oDrugUser, sODIdentifier);
    else
        SetLocalInt(oDrugUser, sODIdentifier, GetLocalInt(oDrugUser, sODIdentifier) - 1);
}


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

void IncrementOverdoseTracker(object oDrugUser, string sODIdentifier, float fODPeriod)
{
    SetLocalInt(oDrugUser, sODIdentifier, GetLocalInt(oDrugUser, sODIdentifier) + 1);
    DelayCommand(fODPeriod, _prc_inc_drugfunc_DecrementOverdoseTracker(oDrugUser, sODIdentifier));
}


int GetOverdoseCounter(object oDrugUser, string sODIdentifier)
{
    return GetLocalInt(oDrugUser, sODIdentifier);
}
