@isTest
public class ExampleClassTest {
    @testSetup private static void createTestData() {
        Account acc = new Account(Name='Account Test');
        insert acc;
    }
    @isTest private static void testExampleMethod() {
        ExampleClass.exampleMethod();
    }
    @isTest private static void testExampleMethod2() {
        ExampleClass.exampleMethod();
    }
}