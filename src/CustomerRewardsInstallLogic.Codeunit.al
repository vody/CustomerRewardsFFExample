codeunit 50100 "Customer Rewards Install Logic"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany();
    var
        CustomerRewardsExtMgtSetup: Record "Customer Rewards Mgt. Setup";
    begin
        CustomerRewardsExtMgtSetup.SetDefault();
    end;
}