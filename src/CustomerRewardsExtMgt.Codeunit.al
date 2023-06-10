codeunit 50101 "Customer Rewards Ext. Mgt."
{
    var
        DummySuccessResponseTxt: Label '{"ActivationResponse": "Success"}', Locked = true;
        NoRewardlevelTxt: Label 'NONE';

    procedure IsCustomerRewardsActivated(): Boolean;
    var
        ActivationCodeInfo: Record "Activation Code Information";
    begin
        if not ActivationCodeInfo.FindFirst then
            exit(false);

        if (ActivationCodeInfo."Date Activated" <= Today) and (Today <= ActivationCodeInfo."Expiration Date") then
            exit(true);
        exit(false);
    end;

    procedure OpenCustomerRewardsWizard();
    var
        CustomerRewardsWizard: Page "Customer Rewards Wizard";
    begin
        CustomerRewardsWizard.RunModal;
    end;

    procedure OpenRewardsLevelPage();
    var
        RewardsLevelPage: Page "Rewards Level List";
    begin
        RewardsLevelPage.Run;
    end;

    procedure GetRewardLevel(RewardPoints: Integer) RewardLevelTxt: Text;
    var
        RewardLevelRec: Record "Reward Level";
        MinRewardLevelPoints: Integer;
    begin
        RewardLevelTxt := NoRewardlevelTxt;

        if RewardLevelRec.IsEmpty then
            exit;
        RewardLevelRec.SetRange("Minimum Reward Points", 0, RewardPoints);
        RewardLevelRec.SetCurrentKey("Minimum Reward Points");

        if not RewardLevelRec.FindFirst then
            exit;
        MinRewardLevelPoints := RewardLevelRec."Minimum Reward Points";

        if RewardPoints >= MinRewardLevelPoints then begin
            RewardLevelRec.Reset;
            RewardLevelRec.SetRange("Minimum Reward Points", MinRewardLevelPoints, RewardPoints);
            RewardLevelRec.SetCurrentKey("Minimum Reward Points");
            RewardLevelRec.FindLast;
            RewardLevelTxt := RewardLevelRec.Level;
        end;
    end;

    procedure ActivateCustomerRewards(ActivationCode: Text): Boolean;
    var
        ActivationCodeInfo: Record "Activation Code Information";
    begin
        OnGetActivationCodeStatusFromServer(ActivationCode);
        exit(ActivationCodeInfo.Get(ActivationCode));
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetActivationCodeStatusFromServer(ActivationCode: Text);
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Customer Rewards Ext. Mgt.", 'OnGetActivationCodeStatusFromServer', '', false, false)]
    local procedure OnGetActivationCodeStatusFromServerSubscriber(ActivationCode: Text);
    var
        ActivationCodeInfo: Record "Activation Code Information";
        ResponseText: Text;
        Result: JsonToken;
        JsonRepsonse: JsonToken;
    begin
        if not CanHandle then
            exit;

        if (GetHttpResponse(ActivationCode, ResponseText)) then begin
            JsonRepsonse.ReadFrom(ResponseText);

            if (JsonRepsonse.SelectToken('ActivationResponse', Result)) then begin

                if (Result.AsValue().AsText() = 'Success') then begin

                    if (ActivationCodeInfo.FindFirst()) then
                        ActivationCodeInfo.Delete;

                    ActivationCodeInfo.Init;
                    ActivationCodeInfo.ActivationCode := ActivationCode;
                    ActivationCodeInfo."Date Activated" := Today;
                    ActivationCodeInfo."Expiration Date" := CALCDATE('<1Y>', Today);
                    ActivationCodeInfo.Insert;

                end;
            end;
        end;
    end;

    local procedure GetHttpResponse(ActivationCode: Text; var ResponseText: Text): Boolean;
    begin
        if ActivationCode = '' then
            exit(false);

        ResponseText := DummySuccessResponseTxt;
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnAfterReleaseSalesDocSubscriber(VAR SalesHeader: Record "Sales Header"; PreviewMode: Boolean; LinesWereModified: Boolean);
    var
        Customer: Record Customer;
        FeatureMgt: Codeunit "FeatureMgt_FF_TSL";
    begin
        if not FeatureMgt.IsEnabled('CustomerRewards') then
            exit;

        if SalesHeader.Status <> SalesHeader.Status::Released then
            exit;

        Customer.Get(SalesHeader."Sell-to Customer No.");
        Customer.RewardPoints += 1;
        Customer.Modify;
    end;

    local procedure CanHandle(): Boolean;
    var
        CustomerRewardsExtMgtSetup: Record "Customer Rewards Mgt. Setup";
    begin
        if CustomerRewardsExtMgtSetup.Get then
            exit(CustomerRewardsExtMgtSetup."Cust. Rew. Ext. Mgt. Code. ID" = CODEUNIT::"Customer Rewards Ext. Mgt.");
        exit(false);
    end;
}