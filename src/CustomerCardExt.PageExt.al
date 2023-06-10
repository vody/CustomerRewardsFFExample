pageextension 50100 "Customer Card Ext." extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field(RewardLevel; RewardLevel)
            {
                ApplicationArea = CustomerRewards;
                Caption = 'Reward Level';
                Description = 'Reward level of the customer.';
                ToolTip = 'Specifies the level of reward that the customer has at this point.';
                Editable = false;
            }

            field(RewardPoints; RewardPoints)
            {
                ApplicationArea = CustomerRewards;
                Caption = 'Reward Points';
                Description = 'Reward points accrued by customer';
                ToolTip = 'Specifies the total number of points that the customer has at this point.';
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord();
    var
        FeatureMgt: Codeunit "FeatureMgt_FF_TSL";
        CustomerRewardsMgtExt: Codeunit "Customer Rewards Ext. Mgt.";
    begin
        if FeatureMgt.IsEnabled('CustomerRewards') then
            RewardLevel := CustomerRewardsMgtExt.GetRewardLevel(RewardPoints);
    end;

    var
        RewardLevel: Text;
}