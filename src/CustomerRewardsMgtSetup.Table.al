table 50102 "Customer Rewards Mgt. Setup"
{
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }

        field(2; "Cust. Rew. Ext. Mgt. Code. ID"; Integer)
        {
            TableRelation = "CodeUnit Metadata".ID;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    internal procedure SetDefault();
    begin
        if not Get() then begin
            "Cust. Rew. Ext. Mgt. Code. ID" := Codeunit::"Customer Rewards Ext. Mgt.";
            Insert();
        end
    end;
}