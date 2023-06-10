codeunit 50100 "Customer Rewards Install Logic"
{
    // Customer Rewards Install Logic
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Role Center Notification Mgt.", OnBeforeShowNotifications, '', false, false)]
    procedure OnBeforeShowNotifications();
    var
        CustomerRewardsExtMgtSetup: Record "Customer Rewards Mgt. Setup";
        FeatureMgt: Codeunit "FeatureMgt_FF_TSL";  // OpenFeature Management codeunit
    begin
        if FeatureMgt.IsEnabled('CustomerRewards') then // Check if the feature is enabled
            CustomerRewardsExtMgtSetup.SetDefault();
    end;
}