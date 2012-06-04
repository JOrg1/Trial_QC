global class SchePopulateSeasonalAddress implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        BatchPopulateSeasonalAddress.BatchPopulateSeasonalAddress(); 
        
    }
}