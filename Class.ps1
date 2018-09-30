class Base64q
{
    [string]$ItemName

    Base64q([string]$String)
    {
        $this.ItemName = $String
    }

    [string]ToString()
    {
        return $this.ItemName
    }
}