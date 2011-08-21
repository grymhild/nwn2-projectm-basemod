// Random Walking
// Place on Spawn_In event of the animal
#include "_SCInclude_AI"
void main()
{
    SCSetSpawnInCondition(CSL_FLAG_AMBIENT_ANIMATIONS);
    SCSetSpawnInCondition(CSL_FLAG_HEARTBEAT_EVENT);
    SCSetListeningPatterns();
    SCWalkWayPoints();
}