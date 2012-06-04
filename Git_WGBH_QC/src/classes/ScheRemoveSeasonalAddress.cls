global class ScheRemoveSeasonalAddress implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        BatchRemoveSeasonalAddress.BatchRemoveSeasonalAddress(); 
       
    }
}