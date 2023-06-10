codeunit 50100 "Customer Rewards Install Logic"
{
    // Customer Rewards Install Logic
    Subtype = Install;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Role Center Notification Mgt.", OnBeforeShowNotifications, '', false, false)]
    procedure OnBeforeShowNotifications();
    var
        CustomerRewardsExtMgtSetup: Record "Customer Rewards Mgt. Setup";
        FeatureMgt: Codeunit "FeatureMgt_FF_TSL";  // OpenFeature Management codeunit
    begin
        if FeatureMgt.IsEnabled('CustomerRewards') then // Check if the feature is enabled
            CustomerRewardsExtMgtSetup.SetDefault();
    end;

    trigger OnInstallAppPerDatabase()
    var
        ConditionProvider: Codeunit ConditionProvider_FF_TSL;
        Company: Record Company;
        CustomerRewardsFeatureID: Code[50];
        EvaluationCompConditionCode: Code[50];
    begin
        // Define the feature
        CustomerRewardsFeatureID := 'CustomerRewards';
        ConditionProvider.AddFeature(CustomerRewardsFeatureID, '[Customer Rewards is Advanced Sample Extension](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-extension-advanced-example)');

        // Define the feature conditions [Optional]
        EvaluationCompConditionCode := 'EvaluationComp';
        Company.SetRange("Evaluation Company", true);
        ConditionProvider.AddCondition(EvaluationCompConditionCode, ConditionFunction_FF_TSL::CompanyFilter, Company.GetView());
        ConditionProvider.AddFeatureCondition(CustomerRewardsFeatureID, EvaluationCompConditionCode);
    end;
}