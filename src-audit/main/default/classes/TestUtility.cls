@isTest
public class TestUtility
{
    static Integer idCounter = 1;

    public static String getFakeId(Schema.SObjectType sot)
    {
        String result = String.valueOf(idCounter++);
        return sot.getDescribe().getKeyPrefix() + 
            '0'.repeat(12-result.length()) + result;
    }
}