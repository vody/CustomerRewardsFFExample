pageextension 50101 "Customer List Ext." extends "Customer List"
{
    actions
    {
        addfirst("&Customer")
        {
            action("Reward Levels")
            {
                ApplicationArea = CustomerRewards; // Set ApplicationArea to your feature identifier;
                Image = CustomerRating;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open the list of reward levels.';


                trigger OnAction();
                begin
                    if CustomerRewardsExtMgt.IsCustomerRewardsActivated then
                        CustomerRewardsExtMgt.OpenRewardsLevelPage
                    else
                        CustomerRewardsExtMgt.OpenCustomerRewardsWizard;
                end;
            }
        }
    }

    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt.";
}