Add-Type -Language CSharp -TypeDefinition @"
public class Base64
{
    public string ItemName;

    public Base64(string Str)
    {
        ItemName = Str;
    }

    public override string ToString()
    {
        return ItemName;
    }
}
"@

$Base64qV = [Base64q]'Text'

function Test-Q
{
    'Q'
}